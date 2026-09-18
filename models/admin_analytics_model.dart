class AdminAnalyticsModel {
  final int totalUsers;
  final int verifiedUsers;
  final int pendingKyc;
  final int blockedUsers;

  final int totalRequests;
  final int openRequests;
  final int acceptedRequests;
  final int inProgressRequests;
  final int awaitingConfirmationRequests;
  final int completedRequests;

  final int pendingReports;
  final int resolvedReports;

  final int newUsersToday;
  final int newUsersThisWeek;
  final int newUsersThisMonth;

  final int completedToday;
  final int completedThisWeek;

  final double averageRating;

  const AdminAnalyticsModel({
    required this.totalUsers,
    required this.verifiedUsers,
    required this.pendingKyc,
    required this.blockedUsers,
    required this.totalRequests,
    required this.openRequests,
    required this.acceptedRequests,
    required this.inProgressRequests,
    required this.awaitingConfirmationRequests,
    required this.completedRequests,
    required this.pendingReports,
    required this.resolvedReports,
    required this.newUsersToday,
    required this.newUsersThisWeek,
    required this.newUsersThisMonth,
    required this.completedToday,
    required this.completedThisWeek,
    required this.averageRating,
  });
}