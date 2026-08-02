import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:bookapp/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return remoteDataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) {
    return remoteDataSource.signUpWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
  }

  @override
  Future<User?> signInWithGoogle() => remoteDataSource.signInWithGoogle();

  @override
  Future<User?> signInWithApple() => remoteDataSource.signInWithApple();
}