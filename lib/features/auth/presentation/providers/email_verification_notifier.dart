import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'email_verification_providers.dart';

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

  // التحقق الصارم الحقيقي (يقارن الكود المدخل بالكود المخزّن في الـ state.code بدقة)
  Future<void> verifyCode(String email, String code) async {
    state = state.copyWith(status: EmailVerificationStatus.loading);
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    // التأكد من تطابق الكود المدخل مع الكود الحقيقي الذي تم توليده
    if (state.code != null && code.trim() == state.code!.trim()) {
      state = state.copyWith(
        status: EmailVerificationStatus.success,
        errorMessage: null,
      );
    } else {
      state = state.copyWith(
        status: EmailVerificationStatus.error,
        errorMessage: "Invalid verification code",
      );
    }
  }

  // توليد كود عشوائي جديد وتخزينه في الـ State
  Future<void> resendCode(String email) async {
    state = state.copyWith(status: EmailVerificationStatus.loading);

    await Future.delayed(const Duration(milliseconds: 500));
    
    // توليد رقم عشوائي من 4 خانات بين 1000 و 9999
    final randomCode = (1000 + Random().nextInt(9000)).toString();
    
    print("========================================");
    print("🎲 NEW RANDOM OTP CODE: $randomCode");
    print("========================================");

    state = state.copyWith(
      status: EmailVerificationStatus.resendSuccess,
      code: randomCode, // تخزين الكود الحقيقي في الـ State للمقارنة لاحقاً
      errorMessage: null,
    );
  }
}

final emailVerificationProvider =
    NotifierProvider<EmailVerificationNotifier, EmailVerificationState>(() {
  return EmailVerificationNotifier();
});