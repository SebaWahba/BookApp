import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import 'profile_providers.dart';

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
                const UserEntity(
                  id: 'user_123',
                  name: '',
                  email: '',
                  phone: '',
                ))
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
}

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, UserEntity>(ProfileController.new);
