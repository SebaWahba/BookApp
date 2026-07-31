import '../models/verification_contact_type.dart';

enum ForgetPasswordStatus { initial, loading, success, error }

class ForgetPasswordState {
  final ForgetPasswordStatus status;
  final String? errorMessage;
  final VerificationContactType? selectedContactType;
  final String? contactInput;
  final int countdownSeconds;
  final bool isTimerRunning;

  const ForgetPasswordState({
    this.status = ForgetPasswordStatus.initial,
    this.errorMessage,
    this.selectedContactType,
    this.contactInput,
    this.countdownSeconds = 30,
    this.isTimerRunning = false,
  });

  ForgetPasswordState copyWith({
    ForgetPasswordStatus? status,
    String? errorMessage,
    VerificationContactType? selectedContactType,
    String? contactInput,
    int? countdownSeconds,
    bool? isTimerRunning,
  }) {
    return ForgetPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      selectedContactType: selectedContactType ?? this.selectedContactType,
      contactInput: contactInput ?? this.contactInput,
      countdownSeconds: countdownSeconds ?? this.countdownSeconds,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
    );
  }
}
