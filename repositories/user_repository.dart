import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  //---------------------------------------------------------
  // Get one user
  //---------------------------------------------------------

  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    if (!doc.exists) {
      return null;
    }

    return UserModel.fromMap(doc.data()!);
  }

  //---------------------------------------------------------
  // Live stream
  //---------------------------------------------------------

  Stream<UserModel?> watchUser(
    String uid,
  ) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;

      return UserModel.fromMap(doc.data()!);
    });
  }
}