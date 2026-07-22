import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../data/datasources/books_remote_data_source.dart';
import '../../data/repositories/books_repository_impl.dart';
import '../../domain/repositories/books_repository.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
});

final booksRemoteDataSourceProvider = Provider<BooksRemoteDataSource>((ref) {
  return BooksRemoteDataSourceImpl(ref.watch(dioProvider));
});

final booksRepositoryProvider = Provider<BooksRepository>((ref) {
  return BooksRepositoryImpl(ref.watch(booksRemoteDataSourceProvider));
});
