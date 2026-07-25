import '../../../../../core/enums/verification_status.dart';

class PhoneVerificationState {
  final PhoneVerificationStatus status;
  final String? errorMessage;

  const PhoneVerificationState({
    this.status = PhoneVerificationStatus.initial,
    this.errorMessage,
  });

  PhoneVerificationState copyWith({
    PhoneVerificationStatus? status,
    String? errorMessage,
  }) {
    return PhoneVerificationState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
