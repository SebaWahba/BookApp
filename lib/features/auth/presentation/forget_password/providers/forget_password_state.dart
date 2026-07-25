import '../models/verification_contact_type.dart';

enum ForgetPasswordStatus { initial, loading, success, error }

class ForgetPasswordState {
  final ForgetPasswordStatus status;
  final String? errorMessage;
  final VerificationContactType? selectedContactType;

  const ForgetPasswordState({
    this.status = ForgetPasswordStatus.initial,
    this.errorMessage,
    this.selectedContactType,
  });

  ForgetPasswordState copyWith({
    ForgetPasswordStatus? status,
    String? errorMessage,
    VerificationContactType? selectedContactType,
  }) {
    return ForgetPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      selectedContactType: selectedContactType ?? this.selectedContactType,
    );
  }
}
