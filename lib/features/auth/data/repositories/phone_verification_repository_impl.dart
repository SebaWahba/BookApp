import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repositories/phone_verification_repository.dart';
import '../datasources/phone_verification_remote_datasource.dart';

class PhoneVerificationRepositoryImpl implements PhoneVerificationRepository {
  final PhoneVerificationRemoteDataSource remoteDataSource;
  PhoneVerificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> sendCode(String phone) async {
    try {
      final verificationId = await remoteDataSource.sendCode(phone);
      return Right(verificationId);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to send code'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyCode(String phone, String code) async {
    try {
      await remoteDataSource.verifyCode(phone, code);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to verify code'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}