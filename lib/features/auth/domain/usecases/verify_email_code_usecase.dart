import 'package:bookapp/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:bookapp/core/error/failure.dart';
import 'package:bookapp/features/auth/domain/repositories/email_verification_repository.dart';

class VerifyCodeParams {
  final String email;
  final String code;
  VerifyCodeParams(this.email , this.code );

}

class VerifyEmailCodeUsecase implements UseCase < void , VerifyCodeParams> {
  final EmailVerificationRepository repository;
  VerifyEmailCodeUsecase(this.repository);


  @override
  Future<Either<Failure, void>> call( VerifyCodeParams params) {
    return repository.verifyCode( params.email , params.code);
  }

}