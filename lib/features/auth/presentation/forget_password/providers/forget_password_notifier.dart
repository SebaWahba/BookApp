import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/email_otp_remote_datasource.dart';
import '../../../data/datasources/forget_password_remote_datasource.dart';
import '../../../data/repositories/email_verification_repository_impl.dart';
import '../../../data/repositories/forget_password_repository.dart';
import '../../../domain/repositories/email_verification_repository.dart';
import '../../../domain/usecases/resend_email_code_usecase.dart';
import '../../../domain/usecases/verify_email_code_usecase.dart';
import '../models/verification_contact_type.dart';
import 'forget_password_state.dart';

export 'forget_password_state.dart';

final emailVerificationRepositoryProvider =
    Provider<EmailVerificationRepository>((ref) {
  return EmailVerificationRepositoryImpl(
    remoteDataSource: EmailOtpRemoteDataSourceImpl(),
  );
});

final resendEmailCodeUsecaseProvider = Provider<ResendEmailCodeUsecase>((ref) {
  return ResendEmailCodeUsecase(ref.watch(emailVerificationRepositoryProvider));
});

final verifyEmailCodeUsecaseProvider = Provider<VerifyEmailCodeUsecase>((ref) {
  return VerifyEmailCodeUsecase(ref.watch(emailVerificationRepositoryProvider));
});

final forgetPasswordRepositoryProvider =
    Provider<ForgetPasswordRepository>((ref) {
  return ForgetPasswordRepositoryImpl(
    remoteDataSource: ForgetPasswordRemoteDataSourceImpl(),
  );
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

  Future<void> sendOtpToEmail(String email) async {
    state = state.copyWith(
      status: ForgetPasswordStatus.loading,
      contactInput: email,
    );

    final useCase = ref.read(resendEmailCodeUsecaseProvider);
    final result = await useCase(email);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ForgetPasswordStatus.error,
          errorMessage: failure.message,
        );
      },
      (_) {
        startResendTimer();
        state = state.copyWith(
          status: ForgetPasswordStatus.success,
          contactInput: email,
        );
      },
    );
  }

  Future<void> verifyOtpCode(String enteredCode) async {
    final email = state.contactInput;
    if (email == null) {
      state = state.copyWith(
        status: ForgetPasswordStatus.error,
        errorMessage: 'Email context missing. Please restart reset request.',
      );
      return;
    }

    state = state.copyWith(status: ForgetPasswordStatus.loading);
    final useCase = ref.read(verifyEmailCodeUsecaseProvider);
    final result = await useCase(VerifyCodeParams(email, enteredCode));

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ForgetPasswordStatus.error,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(status: ForgetPasswordStatus.success);
      },
    );
  }

  Future<void> sendVerificationCode({
    required VerificationContactType type,
    required String input,
  }) async {
    if (type == VerificationContactType.email) {
      await sendOtpToEmail(input);
    } else {
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
}

final forgetPasswordProvider =
    NotifierProvider<ForgetPasswordNotifier, ForgetPasswordState>(
  ForgetPasswordNotifier.new,
);
