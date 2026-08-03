import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repositories/email_verification_repository.dart';
import '../datasources/email_otp_remote_datasource.dart';

class EmailVerificationRepositoryImpl implements EmailVerificationRepository {
  final EmailOtpRemoteDataSource remoteDataSource;
  String? _lastGeneratedOtp;

  EmailVerificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> resendCode(String email) async {
    try {
      final otpCode = remoteDataSource.generate4DigitOtp();
      _lastGeneratedOtp = otpCode;

      await remoteDataSource.sendOtpEmail(email: email, otpCode: otpCode);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> verifyCode(String email, String code) async {
    if (_lastGeneratedOtp == null) {
      return Left(ServerFailure('OTP code has expired. Please request a new one.'));
    }

    if (code.trim() == _lastGeneratedOtp) {
      return const Right(null);
    } else {
      return Left(ServerFailure('Invalid 4-digit OTP code entered.'));
    }
  }
}
