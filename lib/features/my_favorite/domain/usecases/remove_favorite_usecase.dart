import 'package:bookapp/core/error/failure.dart';
import 'package:bookapp/features/my_favorite/domain/repositories/favorites_repository.dart';
import 'package:dartz/dartz.dart';

class RemoveFavoriteUseCase {
  const RemoveFavoriteUseCase(this.repository);

  final FavoritesRepository repository;

  Future<Either<Failure, void>> call(String bookId) {
    return repository.removeFavorite(bookId);
  }
}
