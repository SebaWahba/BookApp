import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/verification_contact_type.dart';
import 'forget_password_state.dart';

export 'forget_password_state.dart';

class ForgetPasswordNotifier extends Notifier<ForgetPasswordState> {
  @override
  ForgetPasswordState build() => const ForgetPasswordState();

  void selectContactType(VerificationContactType type) {
    state = state.copyWith(selectedContactType: type);
  }

  Future<void> sendVerificationCode({required VerificationContactType type, required String input}) async {
    state = state.copyWith(status: ForgetPasswordStatus.loading);
    try {
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(status: ForgetPasswordStatus.success);
    } catch (e) {
      state = state.copyWith(status: ForgetPasswordStatus.error, errorMessage: e.toString());
    }
  }
}

final forgetPasswordProvider = NotifierProvider<ForgetPasswordNotifier, ForgetPasswordState>(
  ForgetPasswordNotifier.new,
);
