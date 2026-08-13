import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bookapp/features/auth/data/datasources/email_verification_remote_datasource.dart'
    as ds;
import 'package:bookapp/features/auth/data/repositories/email_verification_repository_impl.dart'
    as repo_impl;
import 'package:bookapp/features/auth/domain/repositories/email_verification_repository.dart';
import 'package:bookapp/features/auth/domain/usecases/verify_email_code_usecase.dart';
import 'package:bookapp/features/auth/domain/usecases/resend_email_code_usecase.dart';

final emailVerificationRemoteDataSourceProvider =
    Provider<ds.EmailVerificationRemoteDataSource>((ref) {
      return ds.EmailVerificationRemoteDataSourceFirebase();
    });

final emailVerificationRepositoryProvider =
    Provider<EmailVerificationRepository>((ref) {
      final dataSource = ref.watch(emailVerificationRemoteDataSourceProvider);
      return repo_impl.EmailVerificationRepositoryImpl(dataSource);
    });

final verifyEmailCodeUsecaseProvider = Provider<VerifyEmailCodeUsecase>((ref) {
  return VerifyEmailCodeUsecase(ref.watch(emailVerificationRepositoryProvider));
});

final resendEmailCodeUsecaseProvider = Provider<ResendEmailCodeUsecase>((ref) {
  return ResendEmailCodeUsecase(ref.watch(emailVerificationRepositoryProvider));
});
