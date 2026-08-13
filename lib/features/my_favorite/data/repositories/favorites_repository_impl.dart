import 'package:bookapp/core/error/failure.dart';
import 'package:bookapp/features/books/data/models/book_model.dart';
import 'package:bookapp/features/my_favorite/data/datasources/favorites_remote_data_source.dart';
import 'package:bookapp/features/my_favorite/domain/repositories/favorites_repository.dart';
import 'package:dartz/dartz.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this.remoteDataSource);

  final FavoritesRemoteDataSource remoteDataSource;

  @override
  Stream<List<BookModel>> watchFavorites() {
    return remoteDataSource.watchFavorites();
  }

  @override
  Stream<bool> watchIsFavorite(String bookId) {
    return remoteDataSource.watchIsFavorite(bookId);
  }

  @override
  Future<Either<Failure, void>> addFavorite(BookModel book) async {
    try {
      await remoteDataSource.addFavorite(book);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String bookId) async {
    try {
      await remoteDataSource.removeFavorite(bookId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(BookModel book) async {
    try {
      await remoteDataSource.toggleFavorite(book);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
