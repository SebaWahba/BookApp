import '../../../../core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class PhoneVerificationRepository {
  Future<Either<Failure, Unit>> sendCode(String phone);
  Future<Either<Failure, Unit>> verifyCode(String phone, String code);
}
