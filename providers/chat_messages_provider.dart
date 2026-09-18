import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat_message_model.dart';
import 'chat_repository_provider.dart';

final chatMessagesProvider =
    StreamProvider.family<
        List<ChatMessageModel>,
        String>(
  (ref, roomId) {
    return ref
        .read(chatRepositoryProvider)
        .getMessages(roomId);
  },
);