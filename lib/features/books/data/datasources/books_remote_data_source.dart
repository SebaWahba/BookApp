import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/book_model.dart';

abstract class BooksRemoteDataSource {
  Future<List<BookModel>> getBooks(String query);
  Future<BookModel> getBookDetails(String volumeId);
}

class BooksRemoteDataSourceImpl implements BooksRemoteDataSource {
  final Dio _dio;

  BooksRemoteDataSourceImpl(this._dio);

  @override
  Future<List<BookModel>> getBooks(String query) async {
    final response = await _dio.get(
      '/volumes',
      queryParameters: {
        'q': query,
        'key': ApiConstants.apiKey,
      },
    );

    if (response.data != null && response.data['items'] != null) {
      final List<dynamic> items = response.data['items'];
      return items
          .map((json) => BookModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<BookModel> getBookDetails(String volumeId) async {
    final response = await _dio.get(
      '/volumes/$volumeId',
      queryParameters: {
        'key': ApiConstants.apiKey,
      },
    );

    return BookModel.fromJson(response.data as Map<String, dynamic>);
  }
}

final booksRemoteDataSourceProvider = Provider<BooksRemoteDataSource>((ref) {
  return BooksRemoteDataSourceImpl(ref.watch(dioProvider));
});
