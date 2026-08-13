import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/password_reset_challenge.dart';
import '../repositories/forget_password_repository.dart';

class SendResetCodeParams {
  const SendResetCodeParams({required this.contact, required this.isPhone});

  final String contact;
  final bool isPhone;
}

class SendResetCodeUseCase
    implements UseCase<PasswordResetChallenge, SendResetCodeParams> {
  SendResetCodeUseCase(this.repository);

  final ForgetPasswordRepository repository;

  @override
  Future<Either<Failure, PasswordResetChallenge>> call(
    SendResetCodeParams params,
  ) {
    return repository.sendResetCode(
      contact: params.contact,
      isPhone: params.isPhone,
    );
  }
}
