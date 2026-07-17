import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/enums/verification_status.dart';
import 'phone_verification_providers.dart';

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

class PhoneVerificationNotifier extends Notifier<PhoneVerificationState> {
  @override
  PhoneVerificationState build() => const PhoneVerificationState();

  Future<void> sendCode(String phone) async {
    state = state.copyWith(status: PhoneVerificationStatus.loading);
    final useCase = ref.read(sendPhoneCodeUseCaseProvider);
    final result = await useCase(phone);
    result.fold(
          (failure) => state = state.copyWith(
        status: PhoneVerificationStatus.error,
        errorMessage: failure.message,
      ),
          (_) => state = state.copyWith(status: PhoneVerificationStatus.success),
    );
  }
}

final phoneVerificationProvider =
NotifierProvider<PhoneVerificationNotifier, PhoneVerificationState>(
  PhoneVerificationNotifier.new,
);