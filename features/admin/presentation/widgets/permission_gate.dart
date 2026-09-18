import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/admin_permission.dart';
import '../../providers/permission_engine_provider.dart';

class PermissionGate
    extends ConsumerWidget {
  const PermissionGate({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });

  final AdminPermission permission;

  final Widget child;

  final Widget? fallback;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final engine = ref.watch(
      permissionEngineProvider,
    );

    if (engine == null) {
      return fallback ??
          const SizedBox.shrink();
    }

    if (engine.can(permission)) {
      return child;
    }

    return fallback ??
        const SizedBox.shrink();
  }
}