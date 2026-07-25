import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/phone_verification_repository.dart';

class SendPhoneCodeUseCase implements UseCase<Unit, String> {
  final PhoneVerificationRepository repository;
  SendPhoneCodeUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String phone) {
    return repository.sendCode(phone);
  }
}
