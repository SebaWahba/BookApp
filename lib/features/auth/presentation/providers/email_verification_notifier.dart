import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


enum EmailVerificationStatus { initial, loading, success, error, resendSuccess }

class EmailVerificationState {
  final EmailVerificationStatus status;
  final String? errorMessage;
  final String? code;

  EmailVerificationState({
    this.status = EmailVerificationStatus.initial,
    this.errorMessage,
    this.code,
  });

  EmailVerificationState copyWith({
    EmailVerificationStatus? status,
    String? errorMessage,
    String? code,
  }) {
    return EmailVerificationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      code: code ?? this.code,
    );
  }
}

class EmailVerificationNotifier extends Notifier<EmailVerificationState> {
  @override
  EmailVerificationState build() {
    return EmailVerificationState();
  }


  Future<void> verifyCode(String email, String code) async {
    state = state.copyWith(status: EmailVerificationStatus.loading);
    
    await Future.delayed(const Duration(milliseconds: 500));
    

    if (state.code != null && code.trim() == state.code!.trim()) {
      state = state.copyWith(
        status: EmailVerificationStatus.success,
        errorMessage: null,
      );
    } else {
      state = state.copyWith(
        status: EmailVerificationStatus.error,
        errorMessage: 'Invalid verification code',
      );
    }
  }


  Future<void> resendCode(String email) async {
    state = state.copyWith(status: EmailVerificationStatus.loading);

    await Future.delayed(const Duration(milliseconds: 500));
    

    final randomCode = (1000 + Random().nextInt(9000)).toString();
    
    debugPrint('========================================');
    debugPrint('🎲 NEW RANDOM OTP CODE: $randomCode');
    debugPrint('========================================');

    state = state.copyWith(
      status: EmailVerificationStatus.resendSuccess,
      code: randomCode,
      errorMessage: null,
    );
  }
}

final emailVerificationProvider =
    NotifierProvider<EmailVerificationNotifier, EmailVerificationState>(() {
  return EmailVerificationNotifier();
});