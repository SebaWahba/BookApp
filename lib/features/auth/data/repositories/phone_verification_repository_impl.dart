import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repositories/phone_verification_repository.dart';
import '../datasources/phone_verification_remote_datasource.dart';

class PhoneVerificationRepositoryImpl implements PhoneVerificationRepository {
  final PhoneVerificationRemoteDataSource remoteDataSource;
  PhoneVerificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Unit>> sendCode(String phone) async {
    try {
      return const Right(unit);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyCode(String phone, String code) async {
    try {
      return const Right(unit);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
