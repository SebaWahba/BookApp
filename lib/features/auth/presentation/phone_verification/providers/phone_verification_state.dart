import '../../../../../core/enums/verification_status.dart';

class PhoneVerificationState {
  final PhoneVerificationStatus status;
  final String? verificationId;
  final String? errorMessage;
  final String? generatedOtp;
  final String? contactInput;

  const PhoneVerificationState({
    this.status = PhoneVerificationStatus.initial,
    this.verificationId,
    this.errorMessage,
    this.generatedOtp,
    this.contactInput,
  });

  PhoneVerificationState copyWith({
    PhoneVerificationStatus? status,
    String? verificationId,
    String? errorMessage,
    String? generatedOtp,
    String? contactInput,
  }) {
    return PhoneVerificationState(
      status: status ?? this.status,
      verificationId: verificationId ?? this.verificationId,
      errorMessage: errorMessage,
      generatedOtp: generatedOtp ?? this.generatedOtp,
      contactInput: contactInput ?? this.contactInput,
    );
  }
}
