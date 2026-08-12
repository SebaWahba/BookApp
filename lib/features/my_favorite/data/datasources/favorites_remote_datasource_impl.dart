import 'package:bookapp/features/books/data/models/book_model.dart';
import 'package:bookapp/features/my_favorite/data/datasources/favorites_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  FavoritesRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> _favoritesCollection() {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No authenticated user found',
      );
    }

    return _firestore.collection('users').doc(user.uid).collection('favorites');
  }

  Map<String, dynamic> _favoritePayload(BookModel book) {
    if (book.id.isEmpty) {
      throw ArgumentError('Favorite book id cannot be empty');
    }

    return {
      ...book.toFavoriteJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  @override
  Stream<List<BookModel>> watchFavorites() {
    return _favoritesCollection()
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BookModel.fromFavoriteJson(doc.data()))
              .where((book) => book.id.isNotEmpty)
              .toList(),
        );
  }

  @override
  Stream<bool> watchIsFavorite(String bookId) {
    if (bookId.isEmpty) {
      return Stream.value(false);
    }

    return _favoritesCollection()
        .doc(bookId)
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }

  @override
  Future<void> addFavorite(BookModel book) async {
    await _favoritesCollection()
        .doc(book.id)
        .set(_favoritePayload(book), SetOptions(merge: true));
  }

  @override
  Future<void> removeFavorite(String bookId) async {
    if (bookId.isEmpty) return;

    await _favoritesCollection().doc(bookId).delete();
  }

  @override
  Future<void> toggleFavorite(BookModel book) async {
    final favoriteRef = _favoritesCollection().doc(book.id);
    final snapshot = await favoriteRef.get();

    if (snapshot.exists) {
      await favoriteRef.delete();
      return;
    }

    await favoriteRef.set(_favoritePayload(book));
  }
}
