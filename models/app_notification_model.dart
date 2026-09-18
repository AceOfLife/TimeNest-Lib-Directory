class AppNotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final bool isRead;

  AppNotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.isRead,
  });

  factory AppNotificationModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return AppNotificationModel(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      isRead: map['isRead'] ?? false,
    );
  }
}