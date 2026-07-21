import 'package:bookapp/core/error/failure.dart';
import 'package:bookapp/core/usecases/usecase.dart';
import 'package:bookapp/features/auth/domain/repositories/email_verification_repository.dart';
import 'package:dartz/dartz.dart';

class ResendEmailCodeUsecase implements UseCase<void, String> {
  final EmailVerificationRepository repository;
  ResendEmailCodeUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(String email) {
    return repository.resendCode(email);
  }
}
