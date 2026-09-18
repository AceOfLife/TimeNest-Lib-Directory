import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  Future<void> submitReview({
    required String requestId,
    required String revieweeId,
    required int rating,
    required String comment,
  }) async {
    await _firestore
        .collection('reviews')
        .add({
      'requestId': requestId,
      'reviewerId':
          _auth.currentUser!.uid,
      'revieweeId': revieweeId,
      'rating': rating,
      'comment': comment,
      'createdAt':
          FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>
      getUserReviews(
    String userId,
  ) {
    return _firestore
        .collection('reviews')
        .where(
          'revieweeId',
          isEqualTo: userId,
        )
        .snapshots();
  }

  Future<double> getAverageRating(
    String userId,
  ) async {
    final snapshot =
        await _firestore
            .collection('reviews')
            .where(
              'revieweeId',
              isEqualTo: userId,
            )
            .get();

    if (snapshot.docs.isEmpty) {
      return 0;
    }

    double total = 0;

    for (final doc in snapshot.docs) {
      total +=
          (doc['rating'] as num)
              .toDouble();
    }

    return total /
        snapshot.docs.length;
  }
}