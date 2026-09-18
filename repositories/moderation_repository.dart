import 'package:cloud_firestore/cloud_firestore.dart';

class ModerationRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> blockUser(
    String userId,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update({
      'isBlocked': true,
    });
  }

  Future<void> unblockUser(
    String userId,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update({
      'isBlocked': false,
    });
  }

  Future<void> addStrike(
  String userId,
) async {
  final doc =
      await _firestore
          .collection('users')
          .doc(userId)
          .get();

  final strikes =
      doc.data()?['strikeCount'] ??
          0;

  final newCount =
      strikes + 1;

  await _firestore
      .collection('users')
      .doc(userId)
      .update({
    'strikeCount':
        newCount,
    'isBlocked':
        newCount >= 3,
  });
}
}