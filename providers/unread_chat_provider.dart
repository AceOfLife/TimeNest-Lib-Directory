import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/chat_repository.dart';

final unreadChatProvider =
    StreamProvider<int>((ref) {
  return ChatRepository()
      .getUnreadChatCount();
});