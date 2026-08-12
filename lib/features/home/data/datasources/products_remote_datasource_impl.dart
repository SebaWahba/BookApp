import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import 'products_remote_datasource.dart';

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final FirebaseFirestore firestore;

  ProductsRemoteDataSourceImpl(this.firestore);

  @override
  Stream<List<ProductModel>> getProductsStream({String? category}) {
    if (category == null || category.isEmpty || category.toLowerCase() == 'all') {
      return firestore.collection('products').snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList();
      });
    }

    return firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    });
  }

  @override
  Stream<List<ProductModel>> getProductsByAuthorIdStream(String authorId) {
    return firestore
        .collection('products')
        .where('authorId', isEqualTo: authorId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    });
  }
}
