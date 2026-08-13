import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repositories/books_repository.dart';
import '../datasources/books_remote_data_source.dart';
import '../models/book_model.dart';

class BooksRepositoryImpl implements BooksRepository {
  final BooksRemoteDataSource remoteDataSource;

  BooksRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<BookModel>>> getBooks({
    required String query,
    int startIndex = 0,
    int maxResults = 10,
  }) async {
    try {
      final books = await remoteDataSource.getBooks(
        query,
        startIndex: startIndex,
        maxResults: maxResults,
      );
      return Right(books);
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error']?['message'] as String? ??
          e.message ??
          'A server error occurred';
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookModel>> getBookDetails({
    required String volumeId,
  }) async {
    try {
      final bookDetails = await remoteDataSource.getBookDetails(volumeId);
      return Right(bookDetails);
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error']?['message'] as String? ??
          e.message ??
          'A server error occurred';
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

final booksRepositoryProvider = Provider<BooksRepository>((ref) {
  return BooksRepositoryImpl(ref.watch(booksRemoteDataSourceProvider));
});
