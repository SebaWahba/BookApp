import 'package:bookapp/core/network/dio_provider.dart';
import 'package:bookapp/core/network/firebase_auth_provider.dart';
import 'package:bookapp/core/services/cloudinary_service.dart';
import 'package:bookapp/core/services/image_picker_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookapp/core/network/firestore_provider.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_profile_image_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';

// Services
final imagePickerServiceProvider = Provider<ImagePickerService>((ref) {
  return ImagePickerServiceImpl();
});

final cloudinaryServiceProvider = Provider<CloudinaryService>((ref) {
  final dio = ref.watch(dioProvider);
  return CloudinaryServiceImpl(dio: dio);
});

// Data Source
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  return ProfileRemoteDataSourceImpl(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
});

// Repository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDataSource = ref.watch(profileRemoteDataSourceProvider);
  final cloudinaryService = ref.watch(cloudinaryServiceProvider);
  return ProfileRepositoryImpl(remoteDataSource, cloudinaryService);
});

// Use Cases
final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return GetUserProfileUseCase(repository);
});

final updateUserProfileUseCaseProvider = Provider<UpdateUserProfileUseCase>((
  ref,
) {
  final repository = ref.watch(profileRepositoryProvider);
  return UpdateUserProfileUseCase(repository);
});

final updateProfileImageUseCaseProvider = Provider<UpdateProfileImageUseCase>((
  ref,
) {
  final repository = ref.watch(profileRepositoryProvider);
  return UpdateProfileImageUseCase(repository);
});
