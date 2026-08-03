import '../../../../../core/enums/verification_status.dart';

class PhoneVerificationState {
  final PhoneVerificationStatus status;
  final String? verificationId;
  final String? errorMessage;

  const PhoneVerificationState({
    this.status = PhoneVerificationStatus.initial,
    this.verificationId,
    this.errorMessage,
  });

  PhoneVerificationState copyWith({
    PhoneVerificationStatus? status,
    String? verificationId,
    String? errorMessage,
  }) {
    return PhoneVerificationState(
      status: status ?? this.status,
      verificationId: verificationId ?? this.verificationId,
      errorMessage: errorMessage,
    );
  }
}
