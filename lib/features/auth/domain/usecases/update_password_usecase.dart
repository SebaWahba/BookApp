import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/forget_password_repository.dart';

class UpdatePasswordParams {
  const UpdatePasswordParams({required this.email, required this.newPassword});

  final String email;
  final String newPassword;
}

class UpdatePasswordUseCase implements UseCase<Unit, UpdatePasswordParams> {
  UpdatePasswordUseCase(this.repository);

  final ForgetPasswordRepository repository;

  @override
  Future<Either<Failure, Unit>> call(UpdatePasswordParams params) {
    return repository.updatePassword(
      email: params.email,
      newPassword: params.newPassword,
    );
  }
}
