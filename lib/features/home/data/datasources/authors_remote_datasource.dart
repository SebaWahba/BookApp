import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/author_model.dart';
import '../models/product_model.dart';

abstract class AuthorsRemoteDataSource {
  Future<List<AuthorModel>> getAuthors();
  Stream<List<AuthorModel>> getAuthorsStream();
  Stream<List<ProductModel>> getProductsByAuthorIdStream(String authorId);
}

class AuthorsRemoteDataSourceImpl implements AuthorsRemoteDataSource {
  final FirebaseFirestore firestore;

  AuthorsRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<AuthorModel>> getAuthors() async {
    final snapshot = await firestore.collection('authors').get();
    return snapshot.docs
        .map((doc) => AuthorModel.fromJson(doc.id, doc.data()))
        .toList();
  }

  @override
  Stream<List<AuthorModel>> getAuthorsStream() {
    return firestore.collection('authors').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AuthorModel.fromFirestore(doc))
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
