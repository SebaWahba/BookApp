import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/password_reset_challenge.dart';

abstract class ForgetPasswordRepository {
  /// Resolves [contact] (an email address, or a phone number when [isPhone])
  /// to an account and issues a verification code for it.
  Future<Either<Failure, PasswordResetChallenge>> sendResetCode({
    required String contact,
    required bool isPhone,
  });

  /// Checks [code] against the code most recently issued by [sendResetCode].
  Future<Either<Failure, Unit>> verifyResetCode(String code);

  /// Sets [newPassword] on the account identified by [email].
  Future<Either<Failure, Unit>> updatePassword({
    required String email,
    required String newPassword,
  });
}
