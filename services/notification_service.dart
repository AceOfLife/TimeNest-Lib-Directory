import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging
      _messaging =
          FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin
      _localNotifications =
          FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await _messaging
        .requestPermission();

    const androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings =
        InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications
        .initialize(settings);

    FirebaseMessaging.onMessage
        .listen(
      (message) async {
        final notification =
            message.notification;

        if (notification == null) {
          return;
        }

        await _localNotifications
            .show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android:
                AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance',
              importance:
                  Importance.max,
              priority:
                  Priority.high,
            ),
          ),
        );
      },
    );
  }

  static Future<String?> getToken()
      async {
    return _messaging.getToken();
  }
}