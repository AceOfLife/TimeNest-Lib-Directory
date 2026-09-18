import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>>
      getNotifications() {
    final uid =
        _auth.currentUser?.uid;

    if (uid == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('notifications')
        .where(
          'userId',
          isEqualTo: uid,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  Future<void> markAsRead(
    String notificationId,
  ) async {
    await _firestore
        .collection('notifications')
        .doc(notificationId)
        .update({
      'isRead': true,
    });
  }

  Stream<int> getUnreadCount() {
    final uid =
        _auth.currentUser?.uid;

    if (uid == null) {
      return Stream.value(0);
    }

    return _firestore
        .collection('notifications')
        .where(
          'userId',
          isEqualTo: uid,
        )
        .where(
          'isRead',
          isEqualTo: false,
        )
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.length,
        );
  }

  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    await _firestore
        .collection('notifications')
        .add({
      'userId': userId,
      'title': title,
      'body': body,
      'isRead': false,
      'createdAt':
          FieldValue.serverTimestamp(),
    });
  }
}