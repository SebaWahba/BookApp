import '../models/forget_password_error.dart';
import '../models/verification_contact_type.dart';

enum ForgetPasswordStatus { initial, loading, success, error }

/// Which async step [ForgetPasswordState.status] refers to. Three screens share
/// one notifier, so each has to tell its own result apart from the others'.
enum ForgetPasswordStep {
  none,
  sendCode,
  resendCode,
  verifyCode,
  updatePassword,
}

class ForgetPasswordState {
  const ForgetPasswordState({
    this.status = ForgetPasswordStatus.initial,
    this.step = ForgetPasswordStep.none,
    this.error,
    this.selectedContactType,
    this.contactInput,
    this.accountEmail,
    this.otpCode,
    this.countdownSeconds = 0,
    this.isTimerRunning = false,
  });

  final ForgetPasswordStatus status;
  final ForgetPasswordStep step;
  final ForgetPasswordError? error;

  final VerificationContactType? selectedContactType;

  /// What the user typed to identify themselves — shown back to them on the
  /// verification screen.
  final String? contactInput;

  /// The account's email, resolved from [contactInput]. The reset always
  /// targets the email account, even when the user identified by phone.
  final String? accountEmail;

  /// The simulated verification code, surfaced in the dev bottom sheet. Drop
  /// this once codes are delivered by a real mail/SMS provider.
  final String? otpCode;

  final int countdownSeconds;
  final bool isTimerRunning;

  bool get isLoading => status == ForgetPasswordStatus.loading;

  bool succeeded(ForgetPasswordStep forStep) =>
      status == ForgetPasswordStatus.success && step == forStep;

  bool failed(ForgetPasswordStep forStep) =>
      status == ForgetPasswordStatus.error && step == forStep;

  ForgetPasswordState copyWith({
    ForgetPasswordStatus? status,
    ForgetPasswordStep? step,
    ForgetPasswordError? error,
    bool clearError = false,
    VerificationContactType? selectedContactType,
    String? contactInput,
    String? accountEmail,
    String? otpCode,
    int? countdownSeconds,
    bool? isTimerRunning,
  }) {
    return ForgetPasswordState(
      status: status ?? this.status,
      step: step ?? this.step,
      error: clearError ? null : (error ?? this.error),
      selectedContactType: selectedContactType ?? this.selectedContactType,
      contactInput: contactInput ?? this.contactInput,
      accountEmail: accountEmail ?? this.accountEmail,
      otpCode: otpCode ?? this.otpCode,
      countdownSeconds: countdownSeconds ?? this.countdownSeconds,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
    );
  }
}