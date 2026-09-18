import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/notification_provider.dart';

class NotificationsScreen
    extends ConsumerWidget {
  const NotificationsScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final notifications =
        ref.watch(
      notificationProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
        ),
      ),
      body: notifications.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text(
                'No notifications',
              ),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (
              context,
              index,
            ) {
              final notification =
                  items[index];

              return ListTile(
                leading: Icon(
                  notification.isRead
                      ? Icons
                          .notifications_none
                      : Icons
                          .notifications,
                ),
                title: Text(
                  notification.title,
                ),
                subtitle: Text(
                  notification.body,
                ),
                onTap: () async {
                  await ref
                      .read(
                        notificationRepositoryProvider,
                      )
                      .markAsRead(
                        notification.id,
                      );
                },
              );
            },
          );
        },
        loading: () =>
            const Center(
          child:
              CircularProgressIndicator(),
        ),
        error: (e, _) =>
            Center(
          child: Text(
            e.toString(),
          ),
        ),
      ),
    );
  }
}