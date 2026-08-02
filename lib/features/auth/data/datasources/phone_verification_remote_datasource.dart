import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class PhoneVerificationRemoteDataSource {
  Future<String> sendCode(String phone);
  Future<void> verifyCode(String phone, String code);
}

class PhoneVerificationRemoteDataSourceFirebase implements PhoneVerificationRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  @override
  Future<String> sendCode(String phone) async {
    final completer = Completer<String>();

    // الطريقة الصحيحة في الإصدارات الحديثة لتعطيل التحقق أثناء الاختبار
    _auth.setSettings(appVerificationDisabledForTesting: true);

    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        if (!completer.isCompleted) completer.complete(_verificationId ?? '');
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!completer.isCompleted) {
          completer.completeError(Exception(e.message));
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        
        debugPrint("========================================");
        debugPrint("🔐 VERIFICATION ID FOR $phone: $verificationId");
        debugPrint("========================================");

        if (!completer.isCompleted) completer.complete(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );

    return completer.future;
  }

  @override
  Future<void> verifyCode(String phone, String code) async {
    if (_verificationId == null) throw Exception('Verification ID is null');
    
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: code,
    );

    await _auth.signInWithCredential(credential);
  }
}