import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../datasources/forget_password_remote_datasource.dart';

abstract class ForgetPasswordRepository {
  Future<Either<Failure, String>> sendOtpEmail(String email);
}

class ForgetPasswordRepositoryImpl implements ForgetPasswordRepository {
  final ForgetPasswordRemoteDataSource remoteDataSource;

  ForgetPasswordRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> sendOtpEmail(String email) async {
    try {
      final exists = await remoteDataSource.checkUserExists(email);
      if (!exists) {
        return Left(ServerFailure('No account found with this email address.'));
      }

      final otpCode = remoteDataSource.generate4DigitOtp();
      await remoteDataSource.sendOtpEmail(email: email, otpCode: otpCode);

      return Right(otpCode);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
