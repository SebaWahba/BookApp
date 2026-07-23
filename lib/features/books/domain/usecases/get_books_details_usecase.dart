import 'package:bookapp/core/error/failure.dart';
import 'package:bookapp/features/books/data/models/book_model.dart';
import 'package:bookapp/features/books/domain/repositories/books_repository.dart';
import 'package:dartz/dartz.dart';

class GetBooksDetailsUsecase {
  final BooksRepository repository;
  const GetBooksDetailsUsecase(this.repository);

  Future<Either<Failure, BookModel>> call({required String volumeId}) {
    return repository.getBookDetails(volumeId: volumeId);
  }
}
