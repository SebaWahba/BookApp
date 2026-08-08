import 'package:bookapp/core/error/failure.dart';
import 'package:bookapp/features/books/data/models/book_model.dart';
import 'package:bookapp/features/my_favorite/domain/repositories/favorites_repository.dart';
import 'package:dartz/dartz.dart';

class ToggleFavoriteUseCase {
  const ToggleFavoriteUseCase(this.repository);

  final FavoritesRepository repository;

  Future<Either<Failure, void>> call(BookModel book) {
    return repository.toggleFavorite(book);
  }
}
