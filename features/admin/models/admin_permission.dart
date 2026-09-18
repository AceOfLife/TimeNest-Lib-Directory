enum AdminPermission {
  // Dashboard
  viewDashboard,
  viewAnalytics,

  // Users
  viewUsers,
  editUsers,
  deleteUsers,
  blockUsers,
  unblockUsers,

  // KYC
  approveKyc,
  rejectKyc,

  // Reports
  viewReports,
  resolveReports,

  // Requests
  manageRequests,
  deleteRequests,
  hideRequests,

  // Announcements
  createAnnouncements,
  editAnnouncements,
  deleteAnnouncements,
  publishAnnouncements,

  // Audit Logs
  viewAuditLogs,

  // Admin Management
  manageAdmins,
  assignRoles,

  // Settings
  manageSettings,
}