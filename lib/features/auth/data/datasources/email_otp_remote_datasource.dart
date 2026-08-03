import 'dart:math';

abstract class EmailOtpRemoteDataSource {
  String generate4DigitOtp();
  Future<void> sendOtpEmail({required String email, required String otpCode});
}

class EmailOtpRemoteDataSourceImpl implements EmailOtpRemoteDataSource {
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
    // Local mock OTP generation; no external network requests needed.
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
