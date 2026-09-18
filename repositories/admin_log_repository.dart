import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/admin_log_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminLogRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;
  final FirebaseAuth _auth =
    FirebaseAuth.instance;

  Future<void> addLog({
  required String action,
  required String targetId,
  required String targetName,
  required String description,
}) async {

  final admin =
      _auth.currentUser;

  if (admin == null) {
    return;
  }

  await _firestore
      .collection('admin_logs')
      .add({
    'action': action,
    'adminId': admin.uid,
    'adminName':
        admin.displayName ??
        admin.email ??
        'Administrator',
    'targetId': targetId,
    'targetName': targetName,
    'description': description,
    'createdAt':
        FieldValue.serverTimestamp(),
  });
}

  Stream<List<AdminLogModel>>
      getLogs() {
    return _firestore
        .collection('admin_logs')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    AdminLogModel.fromMap(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
        );
  }
}