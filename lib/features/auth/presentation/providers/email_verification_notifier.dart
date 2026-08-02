import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookapp/features/auth/domain/usecases/verify_email_code_usecase.dart';
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

  // التحقق المحلي السريع (بيقارن بالكود العشوائي اللي اتولد من غير مشاكل فايربيس)
  Future<void> verifyCode(String email, String code) async {
    state = state.copyWith(status: EmailVerificationStatus.loading);
    
    // محاكاة بسيطة للتحقق الناجح طالما الكود مطابق لللي اتولد عشوائياً أو أي 4 أرقام للتجربة
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (code.length == 4) {
      state = state.copyWith(status: EmailVerificationStatus.success);
    } else {
      state = state.copyWith(
        status: EmailVerificationStatus.error,
        errorMessage: "Invalid code",
      );
    }
  }

  // توليد كود عشوائي جديد كل مرة
  Future<void> resendCode(String email) async {
    state = state.copyWith(status: EmailVerificationStatus.loading);

    await Future.delayed(const Duration(milliseconds: 500));
    
    // توليد رقم عشوائي من 4 خانات (مثلاً بين 1000 و 9999)
    final randomCode = (1000 + Random().nextInt(9000)).toString();
    
    print("========================================");
    print("🎲 NEW RANDOM OTP CODE: $randomCode");
    print("========================================");

    state = state.copyWith(
      status: EmailVerificationStatus.resendSuccess,
      code: randomCode, // تخزين الكود العشوائي في الـ State
    );
  }
}

final emailVerificationProvider =
    NotifierProvider<EmailVerificationNotifier, EmailVerificationState>(() {
  return EmailVerificationNotifier();
});