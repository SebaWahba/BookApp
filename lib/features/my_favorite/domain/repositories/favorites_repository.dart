import 'package:bookapp/core/error/failure.dart';
import 'package:bookapp/features/books/data/models/book_model.dart';
import 'package:dartz/dartz.dart';

abstract class FavoritesRepository {
  Stream<List<BookModel>> watchFavorites();
  Stream<bool> watchIsFavorite(String bookId);
  Future<Either<Failure, void>> addFavorite(BookModel book);
  Future<Either<Failure, void>> removeFavorite(String bookId);
  Future<Either<Failure, void>> toggleFavorite(BookModel book);
}
