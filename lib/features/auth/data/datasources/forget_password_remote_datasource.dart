import 'dart:developer' as developer;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ForgetPasswordRemoteDataSource {
  Future<bool> checkUserExists(String input, {bool isPhone = false});
  String generate4DigitOtp();
}

class ForgetPasswordRemoteDataSourceImpl implements ForgetPasswordRemoteDataSource {
  final FirebaseFirestore _firestore;

  ForgetPasswordRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<bool> checkUserExists(String input, {bool isPhone = false}) async {
    final cleanInput = input.trim();
    if (cleanInput.isEmpty) return false;

    try {
      if (isPhone) {
        final queryPhone = await _firestore
            .collection('users')
            .where('phone', isEqualTo: cleanInput)
            .limit(1)
            .get();

        if (queryPhone.docs.isNotEmpty) return true;

        final queryPhoneNumber = await _firestore
            .collection('users')
            .where('phoneNumber', isEqualTo: cleanInput)
            .limit(1)
            .get();

        return queryPhoneNumber.docs.isNotEmpty;
      } else {
        final queryEmail = await _firestore
            .collection('users')
            .where('email', isEqualTo: cleanInput.toLowerCase())
            .limit(1)
            .get();

        return queryEmail.docs.isNotEmpty;
      }
    } catch (e) {
      developer.log('Firestore checkUserExists error: $e');
      return false;
    }
  }

  @override
  String generate4DigitOtp() {
    final random = Random();
    final code = 1000 + random.nextInt(9000);
    return code.toString();
  }
}
