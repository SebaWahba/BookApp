import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/enums/verification_status.dart';
import '../../../data/datasources/phone_verification_remote_datasource.dart';
import '../../forget_password/providers/forget_password_notifier.dart';
import 'phone_verification_state.dart';

export 'phone_verification_state.dart';

final phoneVerificationRemoteDataSourceProvider =
    Provider<PhoneVerificationRemoteDataSource>((ref) {
  return PhoneVerificationRemoteDataSourceImpl();
});

class PhoneVerificationNotifier extends Notifier<PhoneVerificationState> {
  @override
  PhoneVerificationState build() => const PhoneVerificationState();

  void resetState() {
    state = const PhoneVerificationState();
  }

  Future<void> sendCode(String phone) async {
    state = state.copyWith(
      status: PhoneVerificationStatus.loading,
      contactInput: phone,
    );

    final forgetRemoteSource = ref.read(forgetPasswordRemoteDataSourceProvider);
    final userExists = await forgetRemoteSource.checkUserExists(
      phone,
      isPhone: true,
    );

    if (!userExists) {
      state = state.copyWith(
        status: PhoneVerificationStatus.error,
        errorMessage: 'No account found with this information',
      );
      return;
    }

    final dataSource = ref.read(phoneVerificationRemoteDataSourceProvider);
    final code = dataSource.generate4DigitOtp();

    state = state.copyWith(
      status: PhoneVerificationStatus.success,
      generatedOtp: code,
      contactInput: phone,
    );
  }

  Future<bool> verifyCode(String enteredCode) async {
    final expectedCode = state.generatedOtp;

    state = state.copyWith(status: PhoneVerificationStatus.loading);
    await Future.delayed(const Duration(milliseconds: 300));

    if (expectedCode != null && enteredCode.trim() == expectedCode) {
      state = state.copyWith(status: PhoneVerificationStatus.success);
      return true;
    } else {
      state = state.copyWith(
        status: PhoneVerificationStatus.error,
        errorMessage: 'Invalid verification code. Please check and try again.',
      );
      return false;
    }
  }
}

final phoneVerificationProvider =
    NotifierProvider<PhoneVerificationNotifier, PhoneVerificationState>(
  PhoneVerificationNotifier.new,
);
