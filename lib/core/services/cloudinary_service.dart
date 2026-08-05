import 'dart:io';

import 'package:bookapp/core/constants/api_constants.dart';
import 'package:bookapp/core/error/failure.dart';
import 'package:dio/dio.dart';

abstract class CloudinaryService {
  Future<String> uploadImage(File imageFile);
}

class CloudinaryServiceImpl implements CloudinaryService {
  final Dio _dio;

  CloudinaryServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<String> uploadImage(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
        'upload_preset': ApiConstants.cloudinaryUploadPreset,
      });

      final response = await _dio.post(
        ApiConstants.cloudinaryUploadUrl,
        data: formData,
      );

      if (response.statusCode == 200 && response.data != null) {
        final secureUrl = response.data['secure_url'] as String?;
        if (secureUrl != null) {
          return secureUrl;
        }
      }

      throw ServerFailure('Failed to get image URL from Cloudinary');
    } on DioException catch (e) {
      throw ServerFailure(
        e.response?.data?['error']?['message']?.toString() ??
            'Image upload failed',
      );
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Image upload failed: ${e.toString()}');
    }
  }
}
