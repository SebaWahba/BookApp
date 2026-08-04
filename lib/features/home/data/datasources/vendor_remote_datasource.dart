import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vendor_models.dart';

abstract class VendorRemoteDataSource {
  Future<List<VendorModel>> getVendors();
}

class VendorRemoteDataSourceImpl implements VendorRemoteDataSource {
  final FirebaseFirestore firestore;

  VendorRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<VendorModel>> getVendors() async {
    final snapshot = await firestore.collection('vendors').get();
    return snapshot.docs
        .map((doc) => VendorModel.fromJson(doc.id, doc.data()))
        .toList();
  }
}
