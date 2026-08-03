import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/enums/verification_status.dart';
import '../../../data/datasources/phone_verification_remote_datasource.dart';
import 'phone_verification_state.dart';

export 'phone_verification_state.dart';

final phoneVerificationRemoteDataSourceProvider =
    Provider<PhoneVerificationRemoteDataSource>((ref) {
  return PhoneVerificationRemoteDataSourceImpl();
});

class PhoneVerificationNotifier extends Notifier<PhoneVerificationState> {
  @override
  PhoneVerificationState build() => const PhoneVerificationState();

  Future<void> sendCode(String phone) async {
    state = state.copyWith(status: PhoneVerificationStatus.loading);
    final dataSource = ref.read(phoneVerificationRemoteDataSourceProvider);

    await dataSource.sendCode(
      phone: phone,
      onCodeSent: (verificationId) {
        state = state.copyWith(
          status: PhoneVerificationStatus.success,
          verificationId: verificationId,
        );
      },
      onError: (error) {
        state = state.copyWith(
          status: PhoneVerificationStatus.error,
          errorMessage: error,
        );
      },
    );
  }

  Future<void> verifyCode(String smsCode) async {
    final verificationId = state.verificationId;
    if (verificationId == null) {
      state = state.copyWith(
        status: PhoneVerificationStatus.error,
        errorMessage: 'Verification session expired. Please resend code.',
      );
      return;
    }

    state = state.copyWith(status: PhoneVerificationStatus.loading);
    try {
      final dataSource = ref.read(phoneVerificationRemoteDataSourceProvider);
      await dataSource.verifyCode(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      state = state.copyWith(status: PhoneVerificationStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: PhoneVerificationStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

final phoneVerificationProvider =
    NotifierProvider<PhoneVerificationNotifier, PhoneVerificationState>(
  PhoneVerificationNotifier.new,
);
