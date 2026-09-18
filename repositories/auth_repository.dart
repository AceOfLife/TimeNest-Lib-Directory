import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;
  final FirebaseStorage _storage =
    FirebaseStorage.instance;
      

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    final credential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    final user = UserModel(
      uid: uid,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      points: 2,
      kycStatus: 'pending',
      photoUrl: '',
      averageRating: 0,
      strikeCount: 0,
      isBlocked: false,
      role: 'user',
    );

    await _firestore
        .collection('users')
        .doc(uid)
        .set(user.toMap());
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(
    String email,
  ) async {
    await _auth.sendPasswordResetEmail(
      email: email,
    );
  }

  Future<UserModel?> getCurrentUserData() async {
  final currentUser = _auth.currentUser;

  if (currentUser == null) {
    return null;
  }

  final doc = await _firestore
      .collection('users')
      .doc(currentUser.uid)
      .get();

  if (!doc.exists) {
    return null;
  }

  return UserModel.fromMap(
    doc.data()!,
  );
}
Future<String?> uploadProfilePhoto(
  File imageFile,
) async {
  final currentUser = _auth.currentUser;

  if (currentUser == null) {
    print('No logged in user');
    return null;
  }

  try {
    final ref = _storage
        .ref()
        .child(
          'profile_photos/${currentUser.uid}.jpg',
        );

    final uploadTask =
        await ref.putFile(imageFile);

    print(
      'Upload success: ${uploadTask.state}',
    );

    final downloadUrl =
        await ref.getDownloadURL();

    print(
      'Download URL: $downloadUrl',
    );

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .update({
      'photoUrl': downloadUrl,
    });

    print(
      'Firestore updated successfully',
    );

    return downloadUrl;
  } catch (e) {
    print(
      'Profile upload error: $e',
    );
    rethrow;
  }
}

Future<void> updateProfile({
  required String fullName,
  required String phoneNumber,
}) async {
  final currentUser =
      _auth.currentUser;

  if (currentUser == null) return;

  await _firestore
      .collection('users')
      .doc(currentUser.uid)
      .update({
    'fullName': fullName,
    'phoneNumber': phoneNumber,
  });
}
Future<bool> isCurrentUserBlocked() async {
  final currentUser =
      _auth.currentUser;

  if (currentUser == null) {
    return false;
  }

  final doc = await _firestore
      .collection('users')
      .doc(currentUser.uid)
      .get();

  if (!doc.exists) {
    return false;
  }

  return doc.data()?['isBlocked'] ??
      false;
}


}