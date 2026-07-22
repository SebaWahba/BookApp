import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/book.dart';
import '../repositories/books_repository.dart';

class SearchBooksUseCase {
  final BooksRepository repository;

  const SearchBooksUseCase(this.repository);

  Future<Either<Failure, List<Book>>> call(String query) {
    return repository.searchBooks(query);
  }
}