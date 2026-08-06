import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bookapp/core/network/firestore_provider.dart';
import '../../../data/datasources/forget_password_remote_datasource.dart';
import '../../../data/repositories/forget_password_repository_impl.dart';
import '../../../domain/repositories/forget_password_repository.dart';
import '../../../domain/usecases/send_reset_code_usecase.dart';
import '../../../domain/usecases/update_password_usecase.dart';
import '../../../domain/usecases/verify_reset_code_usecase.dart';

// Data Source
//
// The issued OTP lives on the instance, so this provider must stay alive for
// the length of the reset attempt — rebuilding it would invalidate the code the
// user is currently typing.
final forgetPasswordRemoteDataSourceProvider =
    Provider<ForgetPasswordRemoteDataSource>((ref) {
      return ForgetPasswordRemoteDataSourceImpl(
        firestore: ref.watch(firestoreProvider),
        auth: FirebaseAuth.instance,
      );
    });

// Repository
final forgetPasswordRepositoryProvider = Provider<ForgetPasswordRepository>((
  ref,
) {
  return ForgetPasswordRepositoryImpl(
    ref.watch(forgetPasswordRemoteDataSourceProvider),
  );
});

// Use Cases
final sendResetCodeUseCaseProvider = Provider<SendResetCodeUseCase>((ref) {
  return SendResetCodeUseCase(ref.watch(forgetPasswordRepositoryProvider));
});

final verifyResetCodeUseCaseProvider = Provider<VerifyResetCodeUseCase>((ref) {
  return VerifyResetCodeUseCase(ref.watch(forgetPasswordRepositoryProvider));
});

final updatePasswordUseCaseProvider = Provider<UpdatePasswordUseCase>((ref) {
  return UpdatePasswordUseCase(ref.watch(forgetPasswordRepositoryProvider));
});
