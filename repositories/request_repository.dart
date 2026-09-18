import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timenest/models/review_model.dart';

import '../../../models/help_request_model.dart';
import 'chat_repository.dart';
import '../models/report_model.dart';
import 'notification_repository.dart';

class RequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? get currentUserId => _auth.currentUser?.uid;

  final NotificationRepository _notificationRepository =
      NotificationRepository();

  Future<void> createRequest({
    required String category,
    required String title,
    required String description,
    required int creditsReward,
    required DateTime taskDate,
    required TimeOfDay taskTime,
  }) async {
    final userDoc = await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();

    if (userDoc['isBlocked'] == true) {
      throw Exception('Blocked users cannot create requests.');
    }
    await _firestore.collection('help_requests').add({
      'category': category,
      'title': title,
      'description': description,
      'createdBy': _auth.currentUser!.uid,
      'assignedTo': '',
      'status': 'open',
      'visibility': 'active',
      'creditsReward': creditsReward,
      'rewardPaid': false,
      'createdAt': FieldValue.serverTimestamp(),
      'taskDate': Timestamp.fromDate(taskDate),
      'taskTime':
          '${taskTime.hour.toString().padLeft(2, '0')}:${taskTime.minute.toString().padLeft(2, '0')}',
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRequests() {
    return _firestore
        .collection('help_requests')
        .where('visibility', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<List<HelpRequestModel>> getHelpRequests() {
    return _firestore
        .collection('help_requests')
        .where('visibility', isEqualTo: 'active')
        .where('status', whereIn: ['open', 'accepted', 'in_progress'])
        .where('status', whereIn: ['open', 'accepted', 'in_progress'])
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => HelpRequestModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> acceptRequest(String requestId) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return;
    }

    final userDoc = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (userDoc['isBlocked'] == true) {
      throw Exception('Blocked users cannot accept requests.');
    }

    final requestRef = _firestore.collection('help_requests').doc(requestId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(requestRef);

      if (!snapshot.exists) {
        throw Exception('Request no longer exists.');
      }

      final data = snapshot.data()!;

      final createdBy = data['createdBy'];

      final status = data['status'];

      if (createdBy == currentUser.uid) {
        throw Exception('You cannot accept your own request.');
      }

      if (status != 'open') {
        throw Exception('This request has already been accepted.');
      }

      transaction.update(requestRef, {
        'assignedTo': currentUser.uid,
        'status': 'accepted',
      });
    });

    final requestDoc = await requestRef.get();

    final data = requestDoc.data()!;

    await ChatRepository().createChatRoom(
      requestId: requestId,
      requestTitle: data['title'] ?? '',
      requesterId: data['createdBy'],
      helperId: currentUser.uid,
    );
    await _notificationRepository.createNotification(
      userId: data['createdBy'],
      title: 'Request Accepted',
      body: 'Someone accepted your request "${data['title']}".',
    );
  }

  Stream<List<HelpRequestModel>> getMyRequests() {
    final currentUser = _auth.currentUser;

    return _firestore
        .collection('help_requests')
        .where('createdBy', isEqualTo: currentUser!.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => HelpRequestModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<HelpRequestModel>> getMyTasks() {
    final currentUser = _auth.currentUser;

    return _firestore
        .collection('help_requests')
        .where('assignedTo', isEqualTo: currentUser!.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => HelpRequestModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> updateRequestStatus({
    required String requestId,
    required String status,
  }) async {
    final requestDoc = await _firestore
        .collection('help_requests')
        .doc(requestId)
        .get();

    final request = requestDoc.data();

    await _firestore.collection('help_requests').doc(requestId).update({
      'status': status,
      if (status == 'completed') 'completedAt': FieldValue.serverTimestamp(),
    });

    if (request == null) {
      return;
    }

    if (status == 'in_progress') {
      await _notificationRepository.createNotification(
        userId: request['assignedTo'],
        title: 'Task Started',
        body: 'You started "${request['title']}".',
      );
    }

    if (status == 'completion_requested') {
      await _notificationRepository.createNotification(
        userId: request['createdBy'],
        title: 'Completion Requested',
        body: 'A helper requested completion approval.',
      );
    }
  }

  Future<void> awardPoints({
    required String userId,
    required int points,
  }) async {
    final userRef = _firestore.collection('users').doc(userId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);

      final currentPoints = snapshot.data()?['points'] ?? 0;

      transaction.update(userRef, {'points': currentPoints + points});
    });
  }

  Future<void> completeRequest(HelpRequestModel request) async {
    final requestSnapshot = await _firestore
        .collection('help_requests')
        .doc(request.id)
        .get();

    final latestRequest = requestSnapshot.data();

    if (latestRequest == null) {
      return;
    }

    if (latestRequest['rewardPaid'] == true) {
      return;
    }

    final requestRef = _firestore.collection('help_requests').doc(request.id);

    final requesterRef = _firestore.collection('users').doc(request.createdBy);

    final helperRef = _firestore.collection('users').doc(request.assignedTo);

    await _firestore.runTransaction((transaction) async {
      final requesterSnapshot = await transaction.get(requesterRef);

      final helperSnapshot = await transaction.get(helperRef);

      final requesterPoints = requesterSnapshot.data()?['points'] ?? 0;

      final helperPoints = helperSnapshot.data()?['points'] ?? 0;

      transaction.update(requesterRef, {
        'points': requesterPoints - request.creditsReward,
      });

      transaction.update(helperRef, {
        'points': helperPoints + request.creditsReward,
      });

      transaction.update(requestRef, {
        'status': 'completed',
        'rewardPaid': true,
        'rewardPaidAt': FieldValue.serverTimestamp(),
        'completedAt': FieldValue.serverTimestamp(),
      });
    });
    await _notificationRepository.createNotification(
      userId: request.assignedTo,
      title: 'Task Completed',
      body:
          'You earned ${request.creditsReward} credit${request.creditsReward > 1 ? "s" : ""}.',
    );
  }

  Future<void> markTaskFinished(String requestId) async {
    await _firestore.collection('help_requests').doc(requestId).update({
      'status': 'awaiting_confirmation',
    });
  }

  Future<void> submitReview({
    required String requestId,
    required String reviewedUserId,
    required int rating,
    required String comment,
  }) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return;
    }

    final existingReview = await _firestore
        .collection('reviews')
        .where('requestId', isEqualTo: requestId)
        .where('reviewerId', isEqualTo: currentUser.uid)
        .limit(1)
        .get();

    if (existingReview.docs.isNotEmpty) {
      throw Exception('You already reviewed this task.');
    }

    await _firestore.collection('reviews').add({
      'requestId': requestId,
      'reviewerId': currentUser.uid,
      'reviewedUserId': reviewedUserId,
      'rating': rating,
      'comment': comment,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await recalculateRating(reviewedUserId);

    await _notificationRepository.createNotification(
      userId: reviewedUserId,
      title: 'New Review',
      body: 'You received a new rating of $rating stars.',
    );
  }

  Future<void> recalculateRating(String userId) async {
    final reviews = await _firestore
        .collection('reviews')
        .where('reviewedUserId', isEqualTo: userId)
        .get();

    if (reviews.docs.isEmpty) {
      return;
    }

    double total = 0;

    for (final doc in reviews.docs) {
      total += (doc['rating'] as num).toDouble();
    }

    final average = total / reviews.docs.length;

    await _firestore.collection('users').doc(userId).update({
      'averageRating': average,
    });
  }

  Future<bool> hasReviewed(String requestId) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return false;
    }

    final review = await _firestore
        .collection('reviews')
        .where('requestId', isEqualTo: requestId)
        .where('reviewedId', isEqualTo: currentUser.uid)
        .limit(1)
        .get();

    return review.docs.isNotEmpty;
  }

  Stream<List<ReviewModel>> getMyReviews() {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('reviews')
        .where('reviewedUserId', isEqualTo: currentUser.uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReviewModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> reportUser({
    required String reportedUserId,
    required String reason,
  }) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return;
    }

    await _firestore.collection('reports').add({
      'reportedUserId': reportedUserId,
      'reportedBy': currentUser.uid,
      'reason': reason,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _notificationRepository.createNotification(
      userId: reportedUserId,
      title: 'Account Report',
      body: 'A report has been submitted involving your account.',
    );
  }

  Stream<List<ReportModel>> getReports() {
    return _firestore
        .collection('reports')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReportModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> resolveReport(String reportId) async {
    await _firestore.collection('reports').doc(reportId).update({
      'status': 'resolved',
    });
  }

  Future<void> issueStrike(String userId) async {
    final userRef = _firestore.collection('users').doc(userId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);

      final currentStrikes = snapshot.data()?['strikeCount'] ?? 0;

      final newStrikeCount = currentStrikes + 1;

      transaction.update(userRef, {
        'strikeCount': newStrikeCount,
        'isBlocked': newStrikeCount >= 3,
      });
    });
  }

  Future<void> unblockUser(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'isBlocked': false,
      'strikeCount': 0,
    });
  }
}
