class ChatRoomModel {
  final String id;
  final String requestId;
  final String requestTitle;
  final String requesterId;
  final String helperId;
  final String lastMessage;

  ChatRoomModel({
    required this.id,
    required this.requestId,
    required this.requestTitle,
    required this.requesterId,
    required this.helperId,
    required this.lastMessage,
  });

  factory ChatRoomModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return ChatRoomModel(
      id: id,
      requestId: map['requestId'] ?? '',
      requestTitle:
          map['requestTitle'] ?? '',
      requesterId:
          map['requesterId'] ?? '',
      helperId: map['helperId'] ?? '',
      lastMessage:
          map['lastMessage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'requestTitle': requestTitle,
      'requesterId': requesterId,
      'helperId': helperId,
      'lastMessage': lastMessage,
    };
  }
}