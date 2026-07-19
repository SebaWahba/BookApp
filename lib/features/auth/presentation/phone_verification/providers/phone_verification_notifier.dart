import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/enums/verification_status.dart';
import 'phone_verification_state.dart';

export 'phone_verification_state.dart';

class PhoneVerificationNotifier extends Notifier<PhoneVerificationState> {
  @override
  PhoneVerificationState build() => const PhoneVerificationState();

  // TODO: swap for the real sendPhoneCodeUseCaseProvider once the backend
  // base URL (see ApiClient.baseUrl) is available.
  Future<void> sendCode(String phone) async {
    state = state.copyWith(status: PhoneVerificationStatus.loading);
    try {
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(status: PhoneVerificationStatus.success);
    } catch (e) {
      state = state.copyWith(status: PhoneVerificationStatus.error, errorMessage: e.toString());
    }
  }
}

final phoneVerificationProvider = NotifierProvider<PhoneVerificationNotifier, PhoneVerificationState>(
  PhoneVerificationNotifier.new,
);
