import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/notification_repository.dart';
import '../models/app_notification_model.dart';

final notificationRepositoryProvider =
    Provider(
  (ref) =>
      NotificationRepository(),
);

final notificationProvider =
    StreamProvider<
        List<AppNotificationModel>>(
  (ref) {
    return ref
        .read(
          notificationRepositoryProvider,
        )
        .getNotifications()
        .map(
      (snapshot) =>
          snapshot.docs
              .map(
                (doc) =>
                    AppNotificationModel
                        .fromMap(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
    );
  },
);

final unreadNotificationProvider =
    StreamProvider<int>(
  (ref) {
    return ref
        .read(
          notificationRepositoryProvider,
        )
        .getUnreadCount();
  },
);