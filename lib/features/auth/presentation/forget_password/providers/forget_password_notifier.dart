import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/verification_contact_type.dart';
import 'forget_password_state.dart';

export 'forget_password_state.dart';

class ForgetPasswordNotifier extends Notifier<ForgetPasswordState> {
  Timer? _timer;

  @override
  ForgetPasswordState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return const ForgetPasswordState();
  }

  void selectContactType(VerificationContactType type) {
    state = state.copyWith(selectedContactType: type);
  }

  void startResendTimer() {
    _timer?.cancel();
    state = state.copyWith(countdownSeconds: 30, isTimerRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdownSeconds > 1) {
        state = state.copyWith(countdownSeconds: state.countdownSeconds - 1);
      } else {
        timer.cancel();
        state = state.copyWith(countdownSeconds: 0, isTimerRunning: false);
      }
    });
  }

  Future<void> sendVerificationCode({
    required VerificationContactType type,
    required String input,
  }) async {
    state = state.copyWith(
      status: ForgetPasswordStatus.loading,
      contactInput: input,
    );
    try {
      await Future.delayed(const Duration(seconds: 2));
      startResendTimer();
      state = state.copyWith(status: ForgetPasswordStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: ForgetPasswordStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

final forgetPasswordProvider =
    NotifierProvider<ForgetPasswordNotifier, ForgetPasswordState>(
  ForgetPasswordNotifier.new,
);
