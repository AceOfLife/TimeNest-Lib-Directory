import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/help_request_model.dart';
import '../models/report_model.dart';
import '../models/review_model.dart';
import '../models/user_model.dart';

class AdminUserRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Stream<UserModel> getUser(
    String uid,
  ) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map(
          (doc) => UserModel.fromMap({
            ...doc.data()!,
            'uid': doc.id,
          }),
        );
  }

  Stream<List<HelpRequestModel>>
      getUserRequests(
    String uid,
  ) {
    return _firestore
        .collection('help_requests')
        .where(
          'createdBy',
          isEqualTo: uid,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    HelpRequestModel.fromMap(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  Stream<List<HelpRequestModel>>
      getCompletedTasks(
    String uid,
  ) {
    return _firestore
        .collection('help_requests')
        .where(
          'assignedTo',
          isEqualTo: uid,
        )
        .where(
          'status',
          isEqualTo: 'completed',
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    HelpRequestModel.fromMap(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  Stream<List<ReviewModel>>
      getReviews(
    String uid,
  ) {
    return _firestore
        .collection('reviews')
        .where(
          'reviewedUserId',
          isEqualTo: uid,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    ReviewModel.fromMap(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  Stream<List<ReportModel>>
      getReportsAgainstUser(
    String uid,
  ) {
    return _firestore
        .collection('reports')
        .where(
          'reportedUserId',
          isEqualTo: uid,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    ReportModel.fromMap(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  Future<void> blockUser(
    String uid,
  ) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .update({
      'isBlocked': true,
    });
  }

  Future<void> unblockUser(
    String uid,
  ) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .update({
      'isBlocked': false,
      'strikeCount': 0,
    });
  }

  Future<void> resetStrikes(
    String uid,
  ) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .update({
      'strikeCount': 0,
    });
  }

  Future<void> deleteUser(
    String uid,
  ) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .delete();
  }
}