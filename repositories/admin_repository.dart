import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/admin_dashboard_stats_model.dart';
import '../models/help_request_model.dart';
import '../models/report_model.dart';
import '../models/user_model.dart';
import '../models/admin_analytics_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logAdminAction({
    required String action,
    required String targetId,
    required String targetName,
    required String description,
  }) async {
    final admin = _auth.currentUser;

    if (admin == null) {
      return;
    }

    await _firestore.collection('admin_logs').add({
      'action': action,
      'adminId': admin.uid,
      'adminName': admin.displayName ?? admin.email ?? 'Administrator',
      'targetId': targetId,
      'targetName': targetName,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ==========================================================
  // DASHBOARD
  // ==========================================================

  Stream<AdminDashboardStatsModel> getDashboardStats() {
    return _firestore.collection('users').snapshots().asyncMap((
      usersSnapshot,
    ) async {
      final requestsSnapshot = await _firestore
          .collection('help_requests')
          .get();

      final reportsSnapshot = await _firestore.collection('reports').get();

      final users = usersSnapshot.docs;
      final requests = requestsSnapshot.docs;

      int totalUsers = users.length;

      int verifiedUsers = 0;
      int pendingKyc = 0;
      int blockedUsers = 0;

      for (final userDoc in users) {
        final data = userDoc.data();

        final kycStatus = data['kycStatus'] ?? 'pending';

        if (kycStatus == 'verified') {
          verifiedUsers++;
        } else if (kycStatus == 'pending') {
          pendingKyc++;
        }

        if (data['isBlocked'] == true) {
          blockedUsers++;
        }
      }

      int totalRequests = requests.length;

      int completedRequests = 0;

      int openRequests = 0;

      for (final request in requests) {
        final data = request.data();

        final status = data['status'] ?? '';

        if (status == 'completed') {
          completedRequests++;
        } else if (status == 'open') {
          openRequests++;
        }
      }

      return AdminDashboardStatsModel(
        totalUsers: totalUsers,
        verifiedUsers: verifiedUsers,
        pendingKyc: pendingKyc,
        blockedUsers: blockedUsers,
        totalRequests: totalRequests,
        completedRequests: completedRequests,
        openRequests: openRequests,
        totalReports: reportsSnapshot.docs.length,
      );
    });
  }

  // ==========================================================
  // USERS
  // ==========================================================

  Stream<List<UserModel>> getAllUsers() {
    return _firestore
        .collection('users')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromMap({...doc.data(), 'uid': doc.id}))
              .toList(),
        );
  }

  Stream<List<UserModel>> getPendingKycUsers() {
    return _firestore
        .collection('users')
        .where('kycStatus', isEqualTo: 'pending')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromMap({...doc.data(), 'uid': doc.id}))
              .toList(),
        );
  }

  Future<void> approveKyc(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'kycStatus': 'verified',
    });
    await _logAdminAction(
      action: 'Approve KYC',
      targetId: userId,
      targetName: userId,
      description: 'Approved KYC verification.',
    );
  }

  Future<void> rejectKyc(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'kycStatus': 'rejected',
    });
    await _logAdminAction(
      action: 'Reject KYC',
      targetId: userId,
      targetName: userId,
      description: 'Rejected KYC verification.',
    );
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
    await _logAdminAction(
      action: 'Issue Strike',
      targetId: userId,
      targetName: userId,
      description: 'Issued a strike to the user.',
    );
  }

  Future<void> unblockUser(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'isBlocked': false,
      'strikeCount': 0,
    });
    await _logAdminAction(
      action: 'Unblock User',
      targetId: userId,
      targetName: userId,
      description: 'Removed all strikes and unblocked the user.',
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

    for (final review in reviews.docs) {
      total += (review['rating'] as num).toDouble();
    }

    final average = total / reviews.docs.length;

    await _firestore.collection('users').doc(userId).update({
      'averageRating': average,
    });
  }
  // ==========================================================
  // REPORTS
  // ==========================================================

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
    await _logAdminAction(
      action: 'Resolve Report',
      targetId: reportId,
      targetName: reportId,
      description: 'Resolved a user report.',
    );
  }

  // ==========================================================
  // REQUESTS
  // ==========================================================

  Stream<List<HelpRequestModel>> getAllRequests() {
    return _firestore
        .collection('help_requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => HelpRequestModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> completeRequest({required String requestId}) async {
    final requestRef = _firestore.collection('help_requests').doc(requestId);

    await _firestore.runTransaction((transaction) async {
      final requestSnapshot = await transaction.get(requestRef);

      if (!requestSnapshot.exists) {
        return;
      }

      final request = requestSnapshot.data()!;

      if (request['rewardPaid'] == true) {
        return;
      }

      final requesterRef = _firestore
          .collection('users')
          .doc(request['createdBy']);

      final helperRef = _firestore
          .collection('users')
          .doc(request['assignedTo']);

      final requesterSnapshot = await transaction.get(requesterRef);

      final helperSnapshot = await transaction.get(helperRef);

      final requesterPoints = requesterSnapshot.data()?['points'] ?? 0;

      final helperPoints = helperSnapshot.data()?['points'] ?? 0;

      final reward = request['creditsReward'];

      transaction.update(requesterRef, {'points': requesterPoints - reward});

      transaction.update(helperRef, {'points': helperPoints + reward});

      transaction.update(requestRef, {
        'status': 'completed',
        'rewardPaid': true,
        'completedAt': FieldValue.serverTimestamp(),
      });
    });
    await _logAdminAction(
      action: 'Complete Request',
      targetId: requestId,
      targetName: requestId,
      description: 'Marked request as completed and transferred reward points.',
    );
  }

  Future<void> hideRequest(String requestId) async {
    await _firestore.collection('help_requests').doc(requestId).update({
      'visibility': 'hidden',
    });
    await _logAdminAction(
      action: 'Hide Request',
      targetId: requestId,
      targetName: requestId,
      description: 'Request hidden by administrator.',
    );
  }

  Future<void> deleteRequest(String requestId) async {
    await _firestore.collection('help_requests').doc(requestId).delete();
    await _logAdminAction(
      action: 'Delete Request',
      targetId: requestId,
      targetName: requestId,
      description: 'Request permanently deleted.',
    );
  }

  Stream<AdminAnalyticsModel> getAnalytics() {
    return _firestore.collection('users').snapshots().asyncMap((
      usersSnapshot,
    ) async {
      final requestsSnapshot = await _firestore
          .collection('help_requests')
          .get();

      final reportsSnapshot = await _firestore.collection('reports').get();

      final now = DateTime.now();

      final today = DateTime(now.year, now.month, now.day);

      final weekAgo = now.subtract(const Duration(days: 7));

      final monthAgo = DateTime(now.year, now.month - 1, now.day);

      int totalUsers = usersSnapshot.docs.length;

      int verifiedUsers = 0;
      int pendingKyc = 0;
      int blockedUsers = 0;

      int newUsersToday = 0;
      int newUsersThisWeek = 0;
      int newUsersThisMonth = 0;

      double ratingTotal = 0;

      for (final doc in usersSnapshot.docs) {
        final data = doc.data();

        if (data['kycStatus'] == 'verified') {
          verifiedUsers++;
        }

        if (data['kycStatus'] == 'pending') {
          pendingKyc++;
        }

        if (data['isBlocked'] == true) {
          blockedUsers++;
        }

        ratingTotal += ((data['averageRating'] ?? 0) as num).toDouble();

        final timestamp = data['createdAt'];

        if (timestamp != null) {
          final created = timestamp as Timestamp;

          final date = created.toDate();

          if (date.isAfter(today)) {
            newUsersToday++;
          }

          if (date.isAfter(weekAgo)) {
            newUsersThisWeek++;
          }

          if (date.isAfter(monthAgo)) {
            newUsersThisMonth++;
          }
        }
      }

      int totalRequests = requestsSnapshot.docs.length;

      int openRequests = 0;
      int acceptedRequests = 0;
      int inProgressRequests = 0;
      int awaitingConfirmation = 0;
      int completedRequests = 0;

      int completedToday = 0;
      int completedThisWeek = 0;

      for (final doc in requestsSnapshot.docs) {
        final data = doc.data();

        switch (data['status']) {
          case 'open':
            openRequests++;
            break;

          case 'accepted':
            acceptedRequests++;
            break;

          case 'in_progress':
            inProgressRequests++;
            break;

          case 'awaiting_confirmation':
            awaitingConfirmation++;
            break;

          case 'completed':
            completedRequests++;

            final completedAt = data['completedAt'];

            if (completedAt != null) {
              final date = (completedAt as Timestamp).toDate();

              if (date.isAfter(today)) {
                completedToday++;
              }

              if (date.isAfter(weekAgo)) {
                completedThisWeek++;
              }
            }

            break;
        }
      }

      int pendingReports = 0;
      int resolvedReports = 0;

      for (final doc in reportsSnapshot.docs) {
        final status = doc['status'];

        if (status == 'pending') {
          pendingReports++;
        } else if (status == 'resolved') {
          resolvedReports++;
        }
      }

      return AdminAnalyticsModel(
        totalUsers: totalUsers,
        verifiedUsers: verifiedUsers,
        pendingKyc: pendingKyc,
        blockedUsers: blockedUsers,
        totalRequests: totalRequests,
        openRequests: openRequests,
        acceptedRequests: acceptedRequests,
        inProgressRequests: inProgressRequests,
        awaitingConfirmationRequests: awaitingConfirmation,
        completedRequests: completedRequests,
        pendingReports: pendingReports,
        resolvedReports: resolvedReports,
        newUsersToday: newUsersToday,
        newUsersThisWeek: newUsersThisWeek,
        newUsersThisMonth: newUsersThisMonth,
        completedToday: completedToday,
        completedThisWeek: completedThisWeek,
        averageRating: totalUsers == 0 ? 0 : ratingTotal / totalUsers,
      );
    });
  }
}
