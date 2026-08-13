import 'package:bookapp/features/location/data/datasources/location_remote_datasource.dart';
import 'package:bookapp/features/location/data/models/address_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  LocationRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> _addressesCollection() {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No authenticated user found',
      );
    }

    return _firestore.collection('users').doc(user.uid).collection('addresses');
  }

  @override
  Future<List<AddressModel>> getAddresses() async {
    final snapshot = await _addressesCollection().get();
    final addresses = snapshot.docs
        .map(AddressModel.fromFirestore)
        .where((address) => address.address.isNotEmpty)
        .toList();

    addresses.sort((a, b) {
      const order = {'home': 0, 'office': 1};
      return (order[a.addressType] ?? 99).compareTo(order[b.addressType] ?? 99);
    });

    return addresses;
  }

  @override
  Future<void> saveAddress(AddressModel address) async {
    final addressType = address.addressType.toLowerCase();
    if (addressType != 'home' && addressType != 'office') {
      throw ArgumentError('Unsupported address type');
    }

    await _addressesCollection()
        .doc(addressType)
        .set(address.toFirestore(), SetOptions(merge: true));
  }
}
