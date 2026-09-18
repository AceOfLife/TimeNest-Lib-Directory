class AdminDashboardStatsModel {
final int totalUsers;
final int verifiedUsers;
final int pendingKyc;
final int blockedUsers;
final int totalRequests;
final int completedRequests;
final int openRequests;
final int totalReports;

AdminDashboardStatsModel({
required this.totalUsers,
required this.verifiedUsers,
required this.pendingKyc,
required this.blockedUsers,
required this.totalRequests,
required this.completedRequests,
required this.openRequests,
required this.totalReports,
});
}
