import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bookapp/core/error/failure.dart';
import '../../../domain/usecases/send_reset_code_usecase.dart';
import '../../../domain/usecases/update_password_usecase.dart';
import '../models/forget_password_error.dart';
import '../models/verification_contact_type.dart';
import 'forget_password_providers.dart';
import 'forget_password_state.dart';

export 'forget_password_state.dart';

class ForgetPasswordNotifier extends Notifier<ForgetPasswordState> {
  static const int _resendCooldownSeconds = 30;

  Timer? _timer;

  @override
  ForgetPasswordState build() {
    ref.onDispose(() => _timer?.cancel());
    return const ForgetPasswordState();
  }

  void selectContactType(VerificationContactType type) {
    state = state.copyWith(selectedContactType: type, clearError: true);
  }

  /// Drops everything from a previous attempt so re-entering the flow doesn't
  /// inherit a stale contact, code or countdown.
  void reset() {
    _timer?.cancel();
    state = const ForgetPasswordState();
  }

  Future<void> sendCode({
    required VerificationContactType type,
    required String input,
  }) =>
      _requestCode(type: type, input: input, step: ForgetPasswordStep.sendCode);

  /// Re-issues a code for the contact already captured by [sendCode].
  Future<void> resendCode() {
    final type = state.selectedContactType;
    final input = state.contactInput;
    if (type == null || input == null || input.isEmpty) return Future.value();

    return _requestCode(
      type: type,
      input: input,
      step: ForgetPasswordStep.resendCode,
    );
  }

  Future<void> _requestCode({
    required VerificationContactType type,
    required String input,
    required ForgetPasswordStep step,
  }) async {
    state = state.copyWith(
      status: ForgetPasswordStatus.loading,
      step: step,
      selectedContactType: type,
      contactInput: input,
      clearError: true,
    );

    final result = await ref
        .read(sendResetCodeUseCaseProvider)
        .call(
          SendResetCodeParams(
            contact: input,
            isPhone: type == VerificationContactType.phone,
          ),
        );

    state = result.fold(
      (failure) => state.copyWith(
        status: ForgetPasswordStatus.error,
        step: step,
        // Only an explicit NotFoundFailure means "no such account"; anything
        // else (offline, Firestore rules) is a lookup that never completed and
        // must not be reported as bad details.
        error: _mapFailure(failure, ForgetPasswordError.lookupFailed),
      ),
      (challenge) {
        startResendTimer();
        return state.copyWith(
          status: ForgetPasswordStatus.success,
          step: step,
          accountEmail: challenge.email,
          otpCode: challenge.code,
          clearError: true,
        );
      },
    );
  }

  Future<void> verifyCode(String code) async {
    state = state.copyWith(
      status: ForgetPasswordStatus.loading,
      step: ForgetPasswordStep.verifyCode,
      clearError: true,
    );

    final result = await ref.read(verifyResetCodeUseCaseProvider).call(code);

    state = result.fold(
      (failure) => state.copyWith(
        status: ForgetPasswordStatus.error,
        step: ForgetPasswordStep.verifyCode,
        error: _mapFailure(failure, ForgetPasswordError.invalidCode),
      ),
      (_) => state.copyWith(
        status: ForgetPasswordStatus.success,
        step: ForgetPasswordStep.verifyCode,
        clearError: true,
      ),
    );
  }

  Future<void> updatePassword(String newPassword) async {
    final email = state.accountEmail;
    if (email == null || email.isEmpty) {
      state = state.copyWith(
        status: ForgetPasswordStatus.error,
        step: ForgetPasswordStep.updatePassword,
        error: ForgetPasswordError.accountNotFound,
      );
      return;
    }

    state = state.copyWith(
      status: ForgetPasswordStatus.loading,
      step: ForgetPasswordStep.updatePassword,
      clearError: true,
    );

    final result = await ref
        .read(updatePasswordUseCaseProvider)
        .call(UpdatePasswordParams(email: email, newPassword: newPassword));

    state = result.fold(
      (failure) => state.copyWith(
        status: ForgetPasswordStatus.error,
        step: ForgetPasswordStep.updatePassword,
        error: _mapFailure(failure, ForgetPasswordError.updateFailed),
      ),
      (_) => state.copyWith(
        status: ForgetPasswordStatus.success,
        step: ForgetPasswordStep.updatePassword,
        clearError: true,
      ),
    );
  }

  void startResendTimer() {
    _timer?.cancel();
    state = state.copyWith(
      countdownSeconds: _resendCooldownSeconds,
      isTimerRunning: true,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdownSeconds > 1) {
        state = state.copyWith(countdownSeconds: state.countdownSeconds - 1);
      } else {
        timer.cancel();
        state = state.copyWith(countdownSeconds: 0, isTimerRunning: false);
      }
    });
  }

  ForgetPasswordError _mapFailure(Failure failure, ForgetPasswordError orElse) {
    return switch (failure) {
      NotFoundFailure() => ForgetPasswordError.accountNotFound,
      ValidationFailure() => ForgetPasswordError.invalidCode,
      ExpiredFailure() => ForgetPasswordError.expiredCode,
      AuthSessionFailure() => ForgetPasswordError.sessionRequired,
      _ => orElse,
    };
  }
}

final forgetPasswordProvider =
    NotifierProvider<ForgetPasswordNotifier, ForgetPasswordState>(
      ForgetPasswordNotifier.new,
    );
