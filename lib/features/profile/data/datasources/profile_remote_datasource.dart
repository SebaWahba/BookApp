import '../models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateUserProfile(UserModel user, {String? newPassword});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  // Mock in-memory user profile (Will be replaced with Firebase Auth / Firestore calls)
  UserModel _currentUser = const UserModel(
    id: 'user_123',
    name: 'John Freeman',
    email: 'john.freeman@gmail.com',
    phone: '+20 123 456 7890',
  );

  @override
  Future<UserModel> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }

  @override
  Future<UserModel> updateUserProfile(
    UserModel user, {
    String? newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Connect with Firebase Auth & Firestore update
    _currentUser = user;
    return _currentUser;
  }
}
