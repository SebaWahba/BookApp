import 'package:dartz/dartz.dart';
import 'package:bookapp/core/error/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfileParams {
  final UserEntity user;
  final String? newPassword;

  const UpdateUserProfileParams({required this.user, this.newPassword});
}

class UpdateUserProfileUseCase {
  final ProfileRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(
    UpdateUserProfileParams params,
  ) async {
    return await repository.updateUserProfile(
      params.user,
      newPassword: params.newPassword,
    );
  }
}
