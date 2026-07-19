import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/phone_verification_repository.dart';
import '../../../domain/usecases/send_phone_code_usecase.dart';
import '../../../data/phone_verification/datasources/phone_verification_remote_datasource.dart';
import '../../../data/phone_verification/repositories/phone_verification_repository_impl.dart';
import '../../../../../core/network/api_client_provider.dart';
import '../../../domain/usecases/verify_phone_code_usecase.dart';

final phoneVerificationRemoteDataSourceProvider = Provider<PhoneVerificationRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PhoneVerificationRemoteDataSourceImpl(apiClient);
});

final phoneVerificationRepositoryProvider = Provider<PhoneVerificationRepository>((ref) {
  final dataSource = ref.watch(phoneVerificationRemoteDataSourceProvider);
  return PhoneVerificationRepositoryImpl(dataSource);
});

final sendPhoneCodeUseCaseProvider = Provider<SendPhoneCodeUseCase>((ref) {
  return SendPhoneCodeUseCase(ref.watch(phoneVerificationRepositoryProvider));
});

final verifyPhoneCodeUseCaseProvider = Provider<VerifyPhoneCodeUseCase>((ref) {
  return VerifyPhoneCodeUseCase(ref.watch(phoneVerificationRepositoryProvider));
});