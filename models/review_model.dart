import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String requestId;
  final String reviewerId;
  final String revieweeId;
  final double rating;
  final String comment;
  final DateTime? createdAt;

  ReviewModel({
    required this.id,
    required this.requestId,
    required this.reviewerId,
    required this.revieweeId,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  factory ReviewModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return ReviewModel(
      id: id,
      requestId: map['requestId'] ?? '',
      reviewerId: map['reviewerId'] ?? '',
      revieweeId: map['revieweeId'] ?? '',
      rating:
          (map['rating'] ?? 0)
              .toDouble(),
      comment: map['comment'] ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'reviewerId': reviewerId,
      'revieweeId': revieweeId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}