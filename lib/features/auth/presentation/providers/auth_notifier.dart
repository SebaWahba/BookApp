import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:bookapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // أضيفي دي لو مش موجودة لحفظ الداتا
import 'package:bookapp/core/services/notification_service.dart'; // استدعاء خدمة الإشعارات

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
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
    
    if (errorStr.contains('email-already-in-use') || errorStr.contains('already in use')) {
      return 'This email is already registered. Please sign in instead.';
    }
    
    return 'An unexpected error occurred. Please try again.';
  }

  // دالة مساعدة لحفظ بيانات المستخدم في Firestore وتفعيل الإشعار الترحيبي
  Future<void> _handleSuccessfulAuth(User user, {String? name}) async {
    // تخزين أو تحديث بيانات اليوزر في الـ Firestore (بالتنسيق مع مارينا عادل)
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email ?? '',
      'name': name ?? user.displayName ?? 'User',
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // إظهار الإشعار المحلي الترحيبي
    final displayName = name ?? user.displayName ?? 'User';
    await NotificationService.showWelcomeNotification(displayName);
  }

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      final user = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (user != null) {
        await _handleSuccessfulAuth(user); // حفظ وتنبيه
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        state = state.copyWith(isLoading: false, errorMessage: "Login failed");
      }
    } catch (e) {
      final message = _mapErrorToMessage(e);
      state = state.copyWith(isLoading: false, errorMessage: message);
    }
  }

  Future<void> signUp({required String email, required String password, required String name}) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      final user = await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );

      if (user != null) {
        await user.sendEmailVerification();
        await _handleSuccessfulAuth(user, name: name); // حفظ وتنبيه بالاسم المدخل
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        state = state.copyWith(isLoading: false, errorMessage: "Sign up failed");
      }
    } catch (e) {
      final message = _mapErrorToMessage(e);
      state = state.copyWith(isLoading: false, errorMessage: message);
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        await _handleSuccessfulAuth(user); // حفظ وتنبيه
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        state = state.copyWith(isLoading: false, isSuccess: false);
      }
    } catch (e) {
      String errorStr = e.toString().toLowerCase();
      if (errorStr.contains('cancel') || errorStr.contains('aborted') || errorStr.contains('sign_in_canceled')) {
        state = state.copyWith(isLoading: false, isSuccess: false);
        return;
      }
      final message = _mapErrorToMessage(e);
      state = state.copyWith(isLoading: false, errorMessage: message);
    }
  }

  Future<void> signInWithApple() async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      final user = await _authRepository.signInWithApple();
      if (user != null) {
        await _handleSuccessfulAuth(user); // حفظ وتنبيه
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        state = state.copyWith(isLoading: false, errorMessage: "Apple sign in failed");
      }
    } catch (e) {
      String errorStr = e.toString().toLowerCase();
      if (errorStr.contains('cancel') || errorStr.contains('aborted') || errorStr.contains('sign_in_canceled')) {
        state = state.copyWith(isLoading: false, isSuccess: false);
        return;
      }
      final message = _mapErrorToMessage(e);
      state = state.copyWith(isLoading: false, errorMessage: message);
    }
  }
}

final authProvider = NotifierProvider.autoDispose<AuthNotifier, AuthState>(AuthNotifier.new);