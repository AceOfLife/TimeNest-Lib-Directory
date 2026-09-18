import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ReportRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  Future<void> submitReport({
    required String reportedUserId,
    required String reason,
  }) async {
    await _firestore
        .collection('reports')
        .add({
      'reportedUserId':
          reportedUserId,
      'reportedBy':
          _auth.currentUser!.uid,
      'reason': reason,
      'status': 'pending',
      'createdAt':
          FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>
      getPendingReports() {
    return _firestore
        .collection('reports')
        .where(
          'status',
          isEqualTo: 'pending',
        )
        .snapshots();
  }
}