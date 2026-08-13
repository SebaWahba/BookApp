import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateUserProfile(UserModel user, {String? newPassword});
  Future<UserModel> updateProfileImage(String imageUrl);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ProfileRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  @override
  Future<UserModel> getUserProfile() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user found');
    }

    final doc = await _firestore.collection('users').doc(currentUser.uid).get();

    if (!doc.exists) {
      // If Firestore document doesn't exist yet, build from Firebase Auth data
      return UserModel(
        id: currentUser.uid,
        name: currentUser.displayName ?? '',
        email: currentUser.email ?? '',
        phone: currentUser.phoneNumber ?? '',
        photoUrl: currentUser.photoURL,
      );
    }

    final data = doc.data()!;
    return UserModel(
      id: currentUser.uid,
      name: data['name'] as String? ?? currentUser.displayName ?? '',
      email: data['email'] as String? ?? currentUser.email ?? '',
      phone: data['phone'] as String? ?? currentUser.phoneNumber ?? '',
      photoUrl: data['photoUrl'] as String? ?? currentUser.photoURL,
    );
  }

  @override
  Future<UserModel> updateUserProfile(
    UserModel user, {
    String? newPassword,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user found');
    }

    // Update Firebase Auth display name if changed
    if (user.name != currentUser.displayName) {
      await currentUser.updateDisplayName(user.name);
    }

    // Update password if provided
    if (newPassword != null && newPassword.isNotEmpty) {
      await currentUser.updatePassword(newPassword);
    }

    // Update Firestore document
    await _firestore.collection('users').doc(currentUser.uid).set({
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'photoUrl': user.photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return UserModel(
      id: currentUser.uid,
      name: user.name,
      email: user.email,
      phone: user.phone,
      photoUrl: user.photoUrl,
    );
  }

  @override
  Future<UserModel> updateProfileImage(String imageUrl) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user found');
    }

    // Update Firebase Auth photoURL
    await currentUser.updatePhotoURL(imageUrl);

    // Update Firestore document
    await _firestore.collection('users').doc(currentUser.uid).set({
      'photoUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Fetch and return the full updated profile
    return getUserProfile();
  }
}
