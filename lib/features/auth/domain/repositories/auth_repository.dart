import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<User?> signInWithGoogle();
  Future<User?> signInWithApple();
}