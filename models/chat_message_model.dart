class ChatMessageModel {
  final String id;
  final String senderId;
  final String message;
  final bool isRead;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.message,
    required this.isRead,
  });

  factory ChatMessageModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return ChatMessageModel(
      id: id,
      senderId:
          map['senderId'] ?? '',
      message:
          map['message'] ?? '',
      isRead:
          map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'isRead': isRead,
    };
  }
}