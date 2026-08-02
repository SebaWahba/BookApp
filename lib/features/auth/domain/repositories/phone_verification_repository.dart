import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

abstract class PhoneVerificationRepository {
  Future<Either<Failure, String>> sendCode(String phone);
  Future<Either<Failure, Unit>> verifyCode(String phone, String code);
}