import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

abstract class EmailVerificationRemoteDataSource {
  Future<void> verifyCode(String email, String code);
  Future<void> resendCode(String email);
}

class EmailVerificationRemoteDataSourceFirebase
    implements EmailVerificationRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static String? _latestGeneratedCode;

  @override
  Future<void> verifyCode(String email, String code) async {
    try {
      if (_latestGeneratedCode != null && _latestGeneratedCode == code) {
        User? user = _firebaseAuth.currentUser;

        // إذا كان المستخدم مسجلاً، يمكنك تحديث حالته أو اعتباره مؤكداً
        if (user != null) {
          // اختيارياً: لو ترغب في تحديث الإيميل كـ Verified في فايربيس
          // (ملاحظة: الـ Custom OTP يعتبر تحقق محلي، ويمكنك دمجه مع تحديث الـ Firebase)
        }
      } else {
        throw Exception("Invalid verification code. Please try again.");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> resendCode(String email) async {
    try {
      final randomCode = (1000 + Random().nextInt(9000)).toString();
      _latestGeneratedCode = randomCode;
      debugPrint('========================================');
      debugPrint('🔐 VERIFICATION CODE FOR $email: $randomCode');
      debugPrint('========================================');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
