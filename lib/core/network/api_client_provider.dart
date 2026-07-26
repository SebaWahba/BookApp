import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = Dio(BaseOptions(baseUrl: ApiClient.baseUrl));
  dio.interceptors.add(
    LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
    ),
  );
  return ApiClient(dio);
});
