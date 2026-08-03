import 'dart:developer' as developer;
import 'dart:math';
import 'package:dio/dio.dart';

abstract class EmailOtpRemoteDataSource {
  String generate4DigitOtp();
  Future<void> sendOtpEmail({required String email, required String otpCode});
}

class EmailOtpRemoteDataSourceImpl implements EmailOtpRemoteDataSource {
  final Dio _dio;

  static const String serviceId = 'service_ca7h74i';
  static const String publicKey = 'LosvAVCbrlRorEgFc';
  static const String templateId = 'template_7dfmh8y';
  static const String emailJsUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  EmailOtpRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? Dio();

  @override
  String generate4DigitOtp() {
    final random = Random();
    final code = 1000 + random.nextInt(9000);
    return code.toString();
  }

  @override
  Future<void> sendOtpEmail({
    required String email,
    required String otpCode,
  }) async {
    final payload = {
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': publicKey,
      'template_params': {
        'to_email': email.trim(),
        'otp_code': otpCode,
        'time': '15 minutes',
      },
    };

    try {
      final response = await _dio.post(
        emailJsUrl,
        data: payload,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'origin': 'http://localhost',
          },
        ),
      );

      developer.log('EmailJS Response [${response.statusCode}]: ${response.data}');

      if (response.statusCode != 200) {
        throw Exception('Failed to send email. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?.toString() ?? e.message ?? 'Network error while sending OTP email.';
      developer.log('EmailJS DioException [${e.response?.statusCode}]: $errorMsg');
      throw Exception(errorMsg);
    } catch (e) {
      developer.log('EmailJS Error: $e');
      rethrow;
    }
  }
}
