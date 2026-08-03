import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class PhoneVerificationRemoteDataSource {
  Future<void> sendCode({
    required String phone,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  });

  Future<UserCredential> verifyCode({
    required String verificationId,
    required String smsCode,
  });
}

class PhoneVerificationRemoteDataSourceImpl
    implements PhoneVerificationRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  PhoneVerificationRemoteDataSourceImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<void> sendCode({
    required String phone,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone.trim(),
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? 'Phone verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Future<UserCredential> verifyCode({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode.trim(),
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }
}
