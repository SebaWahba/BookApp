import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import 'profile_providers.dart';

class IsUploadingImageNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setUploading(bool value) => state = value;
}

final isUploadingImageProvider =
    NotifierProvider<IsUploadingImageNotifier, bool>(
      IsUploadingImageNotifier.new,
    );

class ProfileController extends AsyncNotifier<UserEntity> {
  @override
  Future<UserEntity> build() async {
    return _fetchProfile();
  }

  Future<UserEntity> _fetchProfile() async {
    final useCase = ref.read(getUserProfileUseCaseProvider);
    final result = await useCase();
    return result.fold((failure) => throw failure, (user) => user);
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? password,
  }) async {
    final currentUser = state.value;
    final updatedEntity =
        (currentUser ??
                const UserEntity(id: '', name: '', email: '', phone: ''))
            .copyWith(name: name, email: email, phone: phone);

    state = const AsyncValue.loading();

    final updateUseCase = ref.read(updateUserProfileUseCaseProvider);
    final result = await updateUseCase(
      UpdateUserProfileParams(user: updatedEntity, newPassword: password),
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (user) {
        state = AsyncValue.data(user);
        return true;
      },
    );
  }

  Future<bool> updateProfileImage(File imageFile) async {
    ref.read(isUploadingImageProvider.notifier).setUploading(true);

    final useCase = ref.read(updateProfileImageUseCaseProvider);
    final result = await useCase(imageFile);

    ref.read(isUploadingImageProvider.notifier).setUploading(false);

    return result.fold(
      (failure) {
        return false;
      },
      (user) {
        state = AsyncValue.data(user);
        return true;
      },
    );
  }
}

/// autoDispose so the profile is refetched each time these screens are opened.
///
/// As a kept-alive singleton it served whatever was loaded first for the whole
/// run of the app: data cached before sign-up wrote the phone number, and — after
/// signing out and back in — the previous account's profile.
final profileControllerProvider =
    AsyncNotifierProvider.autoDispose<ProfileController, UserEntity>(
      ProfileController.new,
    );
