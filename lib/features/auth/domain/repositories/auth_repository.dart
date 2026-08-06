import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  // شيلنا الـ phone من هنا
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<User?> signInWithGoogle();
  Future<User?> signInWithApple();

  Future<void> signOut();
}