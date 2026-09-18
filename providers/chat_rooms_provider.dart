import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat_room_model.dart';
import 'chat_repository_provider.dart';

final chatRoomsProvider =
    StreamProvider<
        List<ChatRoomModel>>(
  (ref) {
    return ref
        .read(chatRepositoryProvider)
        .getMyChatRooms();
  },
);