import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
class ApiClient {
  final Dio dio;
  ApiClient(this.dio);

static const String baseUrl = ApiConstants.baseUrl;

  Future<Response> post(String path, {dynamic data}) {
    return dio.post(path, data: data);
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return dio.get(path, queryParameters: queryParameters);
  }
}