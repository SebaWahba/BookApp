enum PhoneVerificationStatus { initial, loading, success, error, resendSuccess }

class PhoneVerificationState {
  final PhoneVerificationStatus status;
  final String? errorMessage;
  final String? code;

  PhoneVerificationState({
    this.status = PhoneVerificationStatus.initial,
    this.errorMessage,
    this.code,
  });

  PhoneVerificationState copyWith({
    PhoneVerificationStatus? status,
    String? errorMessage,
    String? code,
  }) {
    return PhoneVerificationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      code: code ?? this.code,
    );
  }
}