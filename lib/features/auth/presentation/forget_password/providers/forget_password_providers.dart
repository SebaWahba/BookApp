import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/verification_contact_type.dart';

final selectedContactTypeProvider = StateProvider<VerificationContactType?>((ref) {
  return null;
});

final forgetPasswordControllerProvider = StateNotifierProvider<ForgetPasswordController, AsyncValue<void>>((ref) {
  return ForgetPasswordController();
});

class ForgetPasswordController extends StateNotifier<AsyncValue<void>> {
  ForgetPasswordController() : super(const AsyncValue.data(null));

  Future<void> sendVerificationCode({
    required VerificationContactType type,
    required String input,
  }) async {
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(seconds: 2));

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}