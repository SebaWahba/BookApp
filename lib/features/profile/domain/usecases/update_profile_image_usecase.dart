import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:bookapp/core/error/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileImageUseCase {
  final ProfileRepository repository;

  UpdateProfileImageUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(File imageFile) async {
    return await repository.updateProfileImage(imageFile);
  }
}
