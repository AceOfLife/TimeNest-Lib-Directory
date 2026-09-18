import '../models/admin_permission.dart';
import '../models/admin_role.dart';
import 'permission_service.dart';

class PermissionEngine {
  PermissionEngine({
    required this.role,
    required this.customPermissions,
    required PermissionService permissionService,
  }) : _permissionService = permissionService;

  final AdminRole role;

  /// Additional permissions assigned directly to the admin.
  ///
  /// Stored in Firestore as:
  ///
  /// permissions: [
  ///   "manageUsers",
  ///   "publishAnnouncements"
  /// ]
  final List<String> customPermissions;

  final PermissionService _permissionService;

  /// Checks whether the admin has a permission.
  bool can(
    AdminPermission permission,
  ) {
    // Super Admin has unrestricted access.
    if (role == AdminRole.superAdmin) {
      return true;
    }

    // User-specific permission override.
    if (customPermissions.contains(permission.name)) {
      return true;
    }

    // Default role permissions.
    return _permissionService.hasPermission(
      role: role,
      permission: permission,
    );
  }

  /// Returns true if the admin has at least one permission.
  bool canAny(
    List<AdminPermission> permissions,
  ) {
    return permissions.any(can);
  }

  /// Returns true only if the admin has every permission.
  bool canAll(
    List<AdminPermission> permissions,
  ) {
    return permissions.every(can);
  }

  // ==========================================================
  // Dashboard
  // ==========================================================

  bool get canViewDashboard =>
      can(AdminPermission.viewDashboard);

  bool get canViewAnalytics =>
      can(AdminPermission.viewAnalytics);

  // ==========================================================
  // Users
  // ==========================================================

  bool get canViewUsers =>
      can(AdminPermission.viewUsers);

  bool get canEditUsers =>
      can(AdminPermission.editUsers);

  bool get canDeleteUsers =>
      can(AdminPermission.deleteUsers);

  bool get canBlockUsers =>
      can(AdminPermission.blockUsers);

  bool get canUnblockUsers =>
      can(AdminPermission.unblockUsers);

  // ==========================================================
  // KYC
  // ==========================================================

  bool get canApproveKyc =>
      can(AdminPermission.approveKyc);

  bool get canRejectKyc =>
      can(AdminPermission.rejectKyc);

  // ==========================================================
  // Reports
  // ==========================================================

  bool get canViewReports =>
      can(AdminPermission.viewReports);

  bool get canResolveReports =>
      can(AdminPermission.resolveReports);

  // ==========================================================
  // Requests
  // ==========================================================

  bool get canManageRequests =>
      can(AdminPermission.manageRequests);

  bool get canDeleteRequests =>
      can(AdminPermission.deleteRequests);

  bool get canHideRequests =>
      can(AdminPermission.hideRequests);

  // ==========================================================
  // Announcements
  // ==========================================================

  bool get canCreateAnnouncements =>
      can(AdminPermission.createAnnouncements);

  bool get canEditAnnouncements =>
      can(AdminPermission.editAnnouncements);

  bool get canDeleteAnnouncements =>
      can(AdminPermission.deleteAnnouncements);

  bool get canPublishAnnouncements =>
      can(AdminPermission.publishAnnouncements);

  // ==========================================================
  // Audit Logs
  // ==========================================================

  bool get canViewAuditLogs =>
      can(AdminPermission.viewAuditLogs);

  // ==========================================================
  // Admin Management
  // ==========================================================

  bool get canManageAdmins =>
      can(AdminPermission.manageAdmins);

  bool get canAssignRoles =>
      can(AdminPermission.assignRoles);

  // ==========================================================
  // Settings
  // ==========================================================

  bool get canManageSettings =>
      can(AdminPermission.manageSettings);
}