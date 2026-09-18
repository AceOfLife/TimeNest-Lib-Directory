import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/current_user_provider.dart';
import '../models/admin_role.dart';
import '../services/permission_engine.dart';
import 'permission_provider.dart';

final permissionEngineProvider =
    Provider<PermissionEngine?>((ref) {
  final userAsync = ref.watch(
    currentUserProvider,
  );

  return userAsync.maybeWhen(
    data: (user) {
      if (user == null) {
        return null;
      }

      final permissionService =
          ref.watch(
        permissionServiceProvider,
      );

      final role =
          AdminRole.values.firstWhere(
        (e) => e.name == user.role,
        orElse: () => AdminRole.support,
      );

      return PermissionEngine(
        role: role,
        customPermissions:
            user.permissions,
        permissionService:
            permissionService,
      );
    },
    orElse: () => null,
  );
});