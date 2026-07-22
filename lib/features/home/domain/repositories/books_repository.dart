import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/book.dart';

abstract class BooksRepository {
  Future<Either<Failure, List<Book>>> searchBooks(String query);
  Future<Either<Failure, Book>> getBookById(String id);
}