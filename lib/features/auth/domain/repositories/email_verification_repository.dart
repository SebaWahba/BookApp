import 'package:dartz/dartz.dart';
import 'package:bookapp/core/error/failure.dart';

abstract class EmailVerificationRepository {
  Future<Either<Failure, void>> resendCode(String email);
  Future<Either<Failure, void>> verifyCode(String email , String code);
}