import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/forget_password_remote_datasource.dart';
import '../models/verification_contact_type.dart';
import 'forget_password_state.dart';

export 'forget_password_state.dart';

final forgetPasswordRemoteDataSourceProvider =
    Provider<ForgetPasswordRemoteDataSource>((ref) {
  return ForgetPasswordRemoteDataSourceImpl();
});

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

  void resetState() {
    _timer?.cancel();
    state = const ForgetPasswordState();
  }

  Future<void> sendOtpToEmail(String email) async {
    await sendVerificationCode(
      type: VerificationContactType.email,
      input: email,
    );
  }

  Future<bool> verifyOtpCode(String enteredCode) async {
    final expectedCode = state.generatedOtp;

    state = state.copyWith(status: ForgetPasswordStatus.loading);
    await Future.delayed(const Duration(milliseconds: 300));

    if (expectedCode != null && enteredCode.trim() == expectedCode) {
      state = state.copyWith(status: ForgetPasswordStatus.success);
      return true;
    } else {
      state = state.copyWith(
        status: ForgetPasswordStatus.error,
        errorMessage: 'Invalid verification code. Please check and try again.',
      );
      return false;
    }
  }

  Future<void> sendVerificationCode({
    required VerificationContactType type,
    required String input,
  }) async {
    state = state.copyWith(
      status: ForgetPasswordStatus.loading,
      contactInput: input,
    );

    final remoteDataSource = ref.read(forgetPasswordRemoteDataSourceProvider);
    final userExists = await remoteDataSource.checkUserExists(
      input,
      isPhone: type == VerificationContactType.phone,
    );

    if (!userExists) {
      state = state.copyWith(
        status: ForgetPasswordStatus.error,
        errorMessage: 'No account found with this information',
      );
      return;
    }

    final otpCode = remoteDataSource.generate4DigitOtp();
    startResendTimer();

    state = state.copyWith(
      status: ForgetPasswordStatus.success,
      generatedOtp: otpCode,
      contactInput: input,
    );
  }
}

final forgetPasswordProvider =
    NotifierProvider<ForgetPasswordNotifier, ForgetPasswordState>(
  ForgetPasswordNotifier.new,
);
