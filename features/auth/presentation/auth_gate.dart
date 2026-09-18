import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth_state_provider.dart';
import '../../../providers/auth_repository_provider.dart';

import '../../navigation/presentation/main_shell.dart';
import '../../admin/presentation/admin_main_shell.dart';

import 'login_screen.dart';
import 'blocked_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final authState =
        ref.watch(
      authStateProvider,
    );

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }

        return FutureBuilder(
          future: ref
              .read(
                authRepositoryProvider,
              )
              .getCurrentUserData(),
          builder: (
            context,
            snapshot,
          ) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(
                  child:
                      CircularProgressIndicator(),
                ),
              );
            }

            final userData =
                snapshot.data;

            if (userData == null) {
              return const LoginScreen();
            }

            if (userData.isBlocked) {
              return const BlockedScreen();
            }

            if (userData.role ==
                'admin') {
              return const AdminMainShell();
            }

            return const MainShell();
          },
        );
      },
      loading: () =>
          const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      ),
      error: (_, __) =>
          const Scaffold(
        body: Center(
          child: Text(
            'Authentication Error',
          ),
        ),
      ),
    );
  }
}