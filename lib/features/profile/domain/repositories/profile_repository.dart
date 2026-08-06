import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:bookapp/core/error/failure.dart';
import '../entities/user_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> getUserProfile();
  Future<Either<Failure, UserEntity>> updateUserProfile(
    UserEntity user, {
    String? newPassword,
  });
  Future<Either<Failure, UserEntity>> updateProfileImage(File imageFile);
}
