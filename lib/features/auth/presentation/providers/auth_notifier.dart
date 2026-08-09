import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:bookapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookapp/core/services/notification_service.dart';
import 'package:bookapp/core/utils/phone_number.dart';

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  AuthState copyWith({bool? isLoading, String? errorMessage, bool? isSuccess}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  @override
  AuthState build() {
    return const AuthState();
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }

  /// Applies [transform] only while this provider is still alive.
  ///
  /// [authProvider] is autoDispose, so a screen closing mid-request tears the
  /// notifier down while an await is still pending. Both reading `state` and
  /// assigning it throw after that, so the guard has to wrap the whole update
  /// rather than just the assignment.
  void _update(AuthState Function(AuthState current) transform) {
    if (!ref.mounted) return;
    state = transform(state);
  }

  String _mapErrorToMessage(Object e) {
    String errorStr = e.toString();

    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'This email is already registered. Please sign in instead.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'user-not-found':
          return 'No user found with this email.';
        case 'invalid-email':
          return 'The email address is badly formatted.';
        case 'invalid-credential':
          return 'Invalid email or password.';
        default:
          return e.message ?? 'Authentication failed. Please try again.';
      }
    }

    if (errorStr.contains('email-already-in-use') ||
        errorStr.contains('already in use')) {
      return 'This email is already registered. Please sign in instead.';
    }

    return 'An unexpected error occurred. Please try again.';
  }

  Future<void> _handleSuccessfulAuth(User user, {String? name}) async {
    // Persist session tokens and user credentials locally
    final prefs = await SharedPreferences.getInstance();
    final token = await user.getIdToken();

    await prefs.setString('auth_token', token ?? user.uid);
    await prefs.setString('user_email', user.email ?? '');
    await prefs.setString('user_uid', user.uid);
    await prefs.setBool('is_logged_in', true);

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email ?? '',
      'name': name ?? user.displayName ?? 'User',
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final displayName = name ?? user.displayName ?? 'User';
    await NotificationService.showWelcomeNotification(displayName);
  }

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );
    try {
      final user = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user != null) {
        await _handleSuccessfulAuth(user);
        _update((s) => s.copyWith(isLoading: false, isSuccess: true));
      } else {
        _update(
          (s) => s.copyWith(isLoading: false, errorMessage: "Login failed"),
        );
      }
    } catch (e) {
      final message = _mapErrorToMessage(e);
      _update((s) => s.copyWith(isLoading: false, errorMessage: message));
    }
  }

  /// Restores session for saved user after biometric authentication
  Future<bool> signInWithBiometrics() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      final savedUid = prefs.getString('user_uid');

      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        await _handleSuccessfulAuth(currentUser);
        _update((s) => s.copyWith(isLoading: false, isSuccess: true));
        return true;
      } else if (isLoggedIn && savedUid != null && savedUid.isNotEmpty) {
        _update((s) => s.copyWith(isLoading: false, isSuccess: true));
        return true;
      } else {
        _update(
          (s) => s.copyWith(
            isLoading: false,
            errorMessage:
                'No saved session found. Please log in with email & password first.',
          ),
        );
        return false;
      }
    } catch (e) {
      final message = _mapErrorToMessage(e);
      _update((s) => s.copyWith(isLoading: false, errorMessage: message));
      return false;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );
    try {
      final user = await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );

      if (user != null) {
        await user.sendEmailVerification();
        await _handleSuccessfulAuth(user, name: name);
        _update((s) => s.copyWith(isLoading: false, isSuccess: true));
      } else {
        _update(
          (s) => s.copyWith(isLoading: false, errorMessage: "Sign up failed"),
        );
      }
    } catch (e) {
      final message = _mapErrorToMessage(e);
      _update((s) => s.copyWith(isLoading: false, errorMessage: message));
    }
  }

  /// True when a *different* user document already holds [phone].
  ///
  /// Forgot-password resolves an account from its phone number, so a number
  /// shared by two accounts would make that lookup ambiguous.
  ///
  /// This is a UX guard, not enforcement: two sign-ups racing can still both
  /// pass, and nothing stops a direct write. Real uniqueness needs a
  /// `phoneNumbers/{e164} -> uid` document with a create-if-absent rule.
  Future<bool> _isPhoneTakenByAnotherAccount(String phone, String uid) async {
    // Matches the same spelling variants forgot-password looks up, so a number
    // can't be claimed twice just by typing it in a different format.
    final candidates = PhoneNumber.lookupCandidates(phone);
    if (candidates.isEmpty) return false;

    // Both fields are checked because older documents used `phoneNumber`.
    for (final field in const ['phone', 'phoneNumber']) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(field, whereIn: candidates)
          .get();

      if (snapshot.docs.any((doc) => doc.id != uid)) return true;
    }
    return false;
  }

  Future<void> saveUserPhoneNumber({required String phone}) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        if (await _isPhoneTakenByAnotherAccount(phone, user.uid)) {
          _update(
            (s) => s.copyWith(
              isLoading: false,
              errorMessage:
                  "This phone number is already linked to another account.",
            ),
          );
          return;
        }

        // Personal data — debug builds only. This is the value forgot-password
        // has to match exactly, so it's the other half of that trace.
        if (kDebugMode) {
          debugPrint(
            '[SignUp] storing phone "$phone" on ${user.email} (${user.uid})',
          );
        }

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'phone': phone,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        _update((s) => s.copyWith(isLoading: false, isSuccess: true));
      } else {
        _update(
          (s) => s.copyWith(
            isLoading: false,
            errorMessage: "No authenticated user found",
          ),
        );
      }
    } catch (e) {
      final message = _mapErrorToMessage(e);
      _update((s) => s.copyWith(isLoading: false, errorMessage: message));
    }
  }

  /// Ends the session for real. Navigating away from the profile isn't enough:
  /// Firebase persists credentials across launches, so without this the startup
  /// check would keep resolving to Home after a "logout".
  Future<void> signOut() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      await _authRepository.signOut();
      _update((_) => const AuthState());
    } catch (e) {
      _update(
        (s) =>
            s.copyWith(isLoading: false, errorMessage: _mapErrorToMessage(e)),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        await _handleSuccessfulAuth(user);
        _update((s) => s.copyWith(isLoading: false, isSuccess: true));
      } else {
        _update((s) => s.copyWith(isLoading: false, isSuccess: false));
      }
    } catch (e) {
      String errorStr = e.toString().toLowerCase();
      if (errorStr.contains('cancel') ||
          errorStr.contains('aborted') ||
          errorStr.contains('sign_in_canceled')) {
        _update((s) => s.copyWith(isLoading: false, isSuccess: false));
        return;
      }
      final message = _mapErrorToMessage(e);
      _update((s) => s.copyWith(isLoading: false, errorMessage: message));
    }
  }

  Future<void> signInWithApple() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );
    try {
      final user = await _authRepository.signInWithApple();
      if (user != null) {
        await _handleSuccessfulAuth(user);
        _update((s) => s.copyWith(isLoading: false, isSuccess: true));
      } else {
        _update(
          (s) => s.copyWith(
            isLoading: false,
            errorMessage: "Apple sign in failed",
          ),
        );
      }
    } catch (e) {
      String errorStr = e.toString().toLowerCase();
      if (errorStr.contains('cancel') ||
          errorStr.contains('aborted') ||
          errorStr.contains('sign_in_canceled')) {
        _update((s) => s.copyWith(isLoading: false, isSuccess: false));
        return;
      }
      final message = _mapErrorToMessage(e);
      _update((s) => s.copyWith(isLoading: false, errorMessage: message));
    }
  }
}

final authProvider = NotifierProvider.autoDispose<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
