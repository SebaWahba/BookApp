import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../books/data/models/book_model.dart';
import '../../../books/domain/repositories/books_repository.dart';

class GetBookDetailsUseCase {
  final BooksRepository repository;
  const GetBookDetailsUseCase(this.repository);

  Future<Either<Failure, BookModel>> call(String volumeId) {
    return repository.getBookDetails(volumeId: volumeId);
  }
}
