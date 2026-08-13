import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/password_reset_challenge.dart';
import '../../domain/repositories/forget_password_repository.dart';
import '../datasources/forget_password_remote_datasource.dart';

class ForgetPasswordRepositoryImpl implements ForgetPasswordRepository {
  ForgetPasswordRepositoryImpl(this.remoteDataSource);

  final ForgetPasswordRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, PasswordResetChallenge>> sendResetCode({
    required String contact,
    required bool isPhone,
  }) async {
    try {
      final email = await remoteDataSource.findAccountEmail(
        contact,
        isPhone: isPhone,
      );

      if (email == null) {
        // Carries no detail either way, so the screen can't be used to probe
        // which addresses or numbers are registered.
        return Left(NotFoundFailure('No account matches the given details.'));
      }

      return Right(
        PasswordResetChallenge(email: email, code: remoteDataSource.issueOtp()),
      );
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to send reset code'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyResetCode(String code) async {
    try {
      return switch (remoteDataSource.checkOtp(code)) {
        OtpCheckResult.valid => const Right(unit),
        OtpCheckResult.invalid => Left(
          ValidationFailure('Incorrect verification code.'),
        ),
        OtpCheckResult.expired => Left(
          ExpiredFailure('Verification code expired.'),
        ),
      };
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.updatePassword(
        email: email,
        newPassword: newPassword,
      );
      return const Right(unit);
    } on NoResetSessionException {
      return Left(
        AuthSessionFailure('Password change requires an authenticated user.'),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login' || e.code == 'user-token-expired') {
        return Left(
          AuthSessionFailure(e.message ?? 'Please sign in again to continue.'),
        );
      }
      if (e.code == 'weak-password') {
        return Left(ValidationFailure(e.message ?? 'Password is too weak.'));
      }
      return Left(ServerFailure(e.message ?? 'Failed to update password'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
