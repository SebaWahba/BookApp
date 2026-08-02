import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:bookapp/features/auth/presentation/providers/auth_providers.dart';

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

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      final user = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (user != null) {
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        state = state.copyWith(isLoading: false, errorMessage: "Login failed");
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
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
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        state = state.copyWith(isLoading: false, errorMessage: "Sign up failed");
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> signInWithApple() async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      final user = await _authRepository.signInWithApple();
      if (user != null) {
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);