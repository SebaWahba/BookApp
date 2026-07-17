import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/failure.dart';
import '../../../domain/repositories/phone_verification_repository.dart';
import '../datasources/phone_verification_remote_datasource.dart';

class PhoneVerificationRepositoryImpl implements PhoneVerificationRepository {
  final PhoneVerificationRemoteDataSource remoteDataSource;
  PhoneVerificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Unit>> sendCode(String phone) async {
    try {
      await remoteDataSource.sendCode(phone);
      return const Right(unit);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Left(NetworkFailure(e.message ?? 'Network error'));
      }
      return Left(ServerFailure(e.message ?? 'Failed to send code'));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyCode(String phone, String code) async {
    try {
      await remoteDataSource.verifyCode(phone, code);
      return const Right(unit);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Left(NetworkFailure(e.message ?? 'Network error'));
      }
      return Left(ServerFailure(e.message ?? 'Failed to verify code'));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}