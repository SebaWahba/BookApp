import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/book_model.dart';

abstract class BooksRepository {
  Future<Either<Failure, List<BookModel>>> getBooks({required String query});

  Future<Either<Failure, BookModel>> getBookDetails({required String volumeId});
}