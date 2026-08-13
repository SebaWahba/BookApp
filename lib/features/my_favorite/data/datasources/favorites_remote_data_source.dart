import 'package:bookapp/features/books/data/models/book_model.dart';

abstract class FavoritesRemoteDataSource {
  Stream<List<BookModel>> watchFavorites();
  Stream<bool> watchIsFavorite(String bookId);
  Future<void> addFavorite(BookModel book);
  Future<void> removeFavorite(String bookId);
  Future<void> toggleFavorite(BookModel book);
}
