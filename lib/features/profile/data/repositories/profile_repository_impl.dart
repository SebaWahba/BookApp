import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:bookapp/core/error/failure.dart';
import 'package:bookapp/core/services/cloudinary_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final CloudinaryService cloudinaryService;

  ProfileRepositoryImpl(this.remoteDataSource, this.cloudinaryService);

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      final user = await remoteDataSource.getUserProfile();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile(
    UserEntity user, {
    String? newPassword,
  }) async {
    try {
      final userModel = UserModel.fromEntity(user);
      final updatedUser = await remoteDataSource.updateUserProfile(
        userModel,
        newPassword: newPassword,
      );
      return Right(updatedUser);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfileImage(File imageFile) async {
    try {
      // 1. Upload to Cloudinary → get secure_url
      final imageUrl = await cloudinaryService.uploadImage(imageFile);
      // 2. Update Firestore + Firebase Auth → return updated user
      final updatedUser = await remoteDataSource.updateProfileImage(imageUrl);
      return Right(updatedUser);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
