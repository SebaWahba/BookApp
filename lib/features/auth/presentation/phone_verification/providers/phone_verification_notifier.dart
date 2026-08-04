import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'phone_verification_state.dart';

class PhoneVerificationNotifier extends Notifier<PhoneVerificationState> {
  // متغير حراسة داخلي يمنع توليد كود جديد نهائياً إذا كان موجوداً بالفعل
  bool _hasGenerated = false;

  @override
  PhoneVerificationState build() {
    _hasGenerated = false;
    return PhoneVerificationState();
  }

  void resetState() {
    _hasGenerated = false;
    state = PhoneVerificationState();
  }

  Future<String?> sendCode(String phoneNumber) async {
    // لو تم توليد كود مسبقاً في هذه الجلسة، ارجِع القديم فوراً ومتولدش جديد ولا تنفذ أي شيء مرتين
    if (_hasGenerated && state.code != null && state.code!.isNotEmpty) {
      return state.code;
    }

    _hasGenerated = true;
    state = state.copyWith(status: PhoneVerificationStatus.loading, errorMessage: null);

    await Future.delayed(const Duration(milliseconds: 300));
    
    final randomCode = (1000 + Random().nextInt(9000)).toString();

    print("========================================");
    print("📱 NEW PHONE OTP CODE: $randomCode");
    print("========================================");

    state = state.copyWith(
      status: PhoneVerificationStatus.success,
      code: randomCode,
    );

    return randomCode;
  }

  Future<String?> resendCode(String phoneNumber) async {
    // في حالة إعادة الإرسال، نسمح بتوليد كود جديد وتصفية الحراسة مؤقتاً
    _hasGenerated = false;
    state = state.copyWith(status: PhoneVerificationStatus.loading, errorMessage: null);

    await Future.delayed(const Duration(milliseconds: 300));
    
    final randomCode = (1000 + Random().nextInt(9000)).toString();
    _hasGenerated = true;

    print("========================================");
    print("📱 RESENT PHONE OTP CODE: $randomCode");
    print("========================================");
    
    state = state.copyWith(
      status: PhoneVerificationStatus.resendSuccess,
      code: randomCode,
    );

    return randomCode;
  }

  Future<void> verifyCode(String phoneNumber, String code) async {
    state = state.copyWith(status: PhoneVerificationStatus.loading, errorMessage: null);
    
    await Future.delayed(const Duration(milliseconds: 300));
    
    // التحقق الصارم من تطابق الكود المدخل مع الكود المخزن بدقة
    if (state.code != null && code.trim() == state.code!.trim()) {
      state = state.copyWith(status: PhoneVerificationStatus.success, errorMessage: null);
    } else {
      state = state.copyWith(
        status: PhoneVerificationStatus.error,
        errorMessage: "Invalid verification code",
      );
    }
  }
}

final phoneVerificationProvider =
    NotifierProvider<PhoneVerificationNotifier, PhoneVerificationState>(() {
  return PhoneVerificationNotifier();
});