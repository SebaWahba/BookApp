import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/book_model.dart';

abstract class BooksRepository {
  Future<Either<Failure, List<BookModel>>> getBooks({
    required String query,
    int startIndex = 0,
    int maxResults = 10,
  });

  Future<Either<Failure, BookModel>> getBookDetails({required String volumeId});
}
