import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repositories/email_verification_repository.dart';
import '../datasources/email_verification_remote_datasource.dart';

class EmailVerificationRepositoryImpl implements EmailVerificationRepository {
  final EmailVerificationRemoteDataSource remoteDataSource;

  EmailVerificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> verifyCode(String email, String code) async {
    try {
      await remoteDataSource.verifyCode(email, code);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resendCode(String email) async {
    try {
      await remoteDataSource.resendCode(email);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}