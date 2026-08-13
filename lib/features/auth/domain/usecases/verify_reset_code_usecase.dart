import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/forget_password_repository.dart';

class VerifyResetCodeUseCase implements UseCase<Unit, String> {
  VerifyResetCodeUseCase(this.repository);

  final ForgetPasswordRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String code) {
    return repository.verifyResetCode(code);
  }
}
