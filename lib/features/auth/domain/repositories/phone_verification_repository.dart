import '../../../../core/error/failure.dart';
import 'package:dartz/dartz.dart';
abstract class PhoneVerificationRepository {
  Future<Either<Failure, void>> sendCode(String phone);
  Future<Either<Failure, void>> verifyCode(String phone, String code);
}