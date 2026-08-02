import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/author_model.dart';

abstract class AuthorsRemoteDataSource {
  Future<List<AuthorModel>> getAuthors();
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
}
