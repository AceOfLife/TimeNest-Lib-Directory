import '../models/admin_permission.dart';
import '../models/admin_role.dart';

class PermissionService {
  const PermissionService();

  static final Map<AdminRole, Set<AdminPermission>> rolePermissions = {
    AdminRole.superAdmin: {
      ...AdminPermission.values,
    },

    AdminRole.admin: {
      AdminPermission.viewDashboard,
      AdminPermission.viewAnalytics,

      AdminPermission.viewUsers,
      AdminPermission.editUsers,
      AdminPermission.blockUsers,
      AdminPermission.unblockUsers,

      AdminPermission.approveKyc,
      AdminPermission.rejectKyc,

      AdminPermission.viewReports,
      AdminPermission.resolveReports,

      AdminPermission.manageRequests,
      AdminPermission.hideRequests,

      AdminPermission.createAnnouncements,
      AdminPermission.editAnnouncements,
      AdminPermission.publishAnnouncements,

      AdminPermission.viewAuditLogs,
    },

    AdminRole.moderator: {
      AdminPermission.viewDashboard,

      AdminPermission.viewUsers,

      AdminPermission.viewReports,
      AdminPermission.resolveReports,

      AdminPermission.manageRequests,
      AdminPermission.hideRequests,

      AdminPermission.viewAuditLogs,
    },

    AdminRole.support: {
      AdminPermission.viewDashboard,

      AdminPermission.viewUsers,

      AdminPermission.viewReports,
    },
  };

  bool hasPermission({
    required AdminRole role,
    required AdminPermission permission,
  }) {
    return rolePermissions[role]
            ?.contains(permission) ??
        false;
  }
}