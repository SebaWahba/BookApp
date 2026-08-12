import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

abstract class EmailVerificationRepository {
  Future<Either<Failure, void>> verifyCode(String email, String code);

  Future<Either<Failure, void>> resendCode(String email);
}
