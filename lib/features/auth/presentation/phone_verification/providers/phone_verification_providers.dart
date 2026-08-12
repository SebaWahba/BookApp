import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/phone_verification_remote_datasource.dart';
import '../../../data/repositories/phone_verification_repository_impl.dart';
import '../../../domain/repositories/phone_verification_repository.dart';
import '../../../domain/usecases/send_phone_code_usecase.dart';
import '../../../domain/usecases/verify_phone_code_usecase.dart';

final phoneVerificationRemoteDataSourceProvider =
Provider<PhoneVerificationRemoteDataSource>((ref) {
  return PhoneVerificationRemoteDataSourceFirebase();
});

final phoneVerificationRepositoryProvider =
Provider<PhoneVerificationRepository>((ref) {
  final dataSource = ref.watch(phoneVerificationRemoteDataSourceProvider);
  return PhoneVerificationRepositoryImpl(dataSource);
});

final sendPhoneCodeUseCaseProvider = Provider<SendPhoneCodeUseCase>((ref) {
  return SendPhoneCodeUseCase(ref.watch(phoneVerificationRepositoryProvider));
});

final verifyPhoneCodeUseCaseProvider = Provider<VerifyPhoneCodeUseCase>((ref) {
  return VerifyPhoneCodeUseCase(ref.watch(phoneVerificationRepositoryProvider));
});