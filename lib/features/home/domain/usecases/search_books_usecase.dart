import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../books/data/models/book_model.dart';
import '../../../books/domain/repositories/books_repository.dart';

class SearchBooksUseCase {
  final BooksRepository repository;
  const SearchBooksUseCase(this.repository);

  Future<Either<Failure, List<BookModel>>> call(String query) {
    return repository.getBooks(query: query);
  }
}