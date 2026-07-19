import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = Dio(BaseOptions(baseUrl: ApiClient.baseUrl));
  return ApiClient(dio);
});