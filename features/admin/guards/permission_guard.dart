import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/admin_permission.dart';
import '../providers/permission_engine_provider.dart';
import '../presentation/widgets/permission_denied_screen.dart';

class PermissionGuard extends ConsumerWidget {
  const PermissionGuard({
    super.key,
    required this.permission,
    required this.child,
  });

  final AdminPermission permission;

  final Widget child;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final engine = ref.watch(
      permissionEngineProvider,
    );

    if (engine == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!engine.can(permission)) {
      return const PermissionDeniedScreen();
    }

    return child;
  }
}