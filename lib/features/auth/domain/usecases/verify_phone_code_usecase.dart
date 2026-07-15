import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/phone_verification_repository.dart';

class VerifyPhoneCodeUseCase implements UseCase<void, VerifyPhoneCodeParams> {
  final PhoneVerificationRepository repository;
  VerifyPhoneCodeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(VerifyPhoneCodeParams params) {
    return repository.verifyCode(params.phone, params.code);
  }
}

class VerifyPhoneCodeParams {
  final String phone;
  final String code;
  VerifyPhoneCodeParams({required this.phone, required this.code});
}