import 'dart:math';

abstract class PhoneVerificationRemoteDataSource {
  String generate4DigitOtp();
}

class PhoneVerificationRemoteDataSourceImpl
    implements PhoneVerificationRemoteDataSource {
  @override
  String generate4DigitOtp() {
    final random = Random();
    final code = 1000 + random.nextInt(9000);
    return code.toString();
  }
}
