import '../../../../core/network/api_client.dart';

abstract class PhoneVerificationRemoteDataSource {
  Future<void> sendCode(String phone);
  Future<void> verifyCode(String phone, String code);
}

class PhoneVerificationRemoteDataSourceImpl
    implements PhoneVerificationRemoteDataSource {
  final ApiClient apiClient;
  PhoneVerificationRemoteDataSourceImpl(this.apiClient);

  @override
  Future<void> sendCode(String phone) async {
    await apiClient.post('/auth/phone/send-code', data: {'phone': phone});
  }

  @override
  Future<void> verifyCode(String phone, String code) async {
    await apiClient.post(
      '/auth/phone/verify-code',
      data: {'phone': phone, 'code': code},
    );
  }
}
