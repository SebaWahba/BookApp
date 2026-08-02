import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:bookapp/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:bookapp/features/auth/domain/repositories/auth_repository.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.read(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});