import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/address_model.dart';

abstract class LocationRemoteDataSource {
  Future<void> saveAddress(AddressModel address);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  LocationRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  @override
  Future<void> saveAddress(AddressModel address) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No authenticated user found',
      );
    }

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('addresses')
        .doc(address.addressType.toLowerCase());

    await docRef.set(address.toFirestore(), SetOptions(merge: true));
  }
}
