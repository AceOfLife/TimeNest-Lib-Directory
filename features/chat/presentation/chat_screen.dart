import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/chat_rooms_provider.dart';
import '../../../core/widgets/shimmer_loading.dart';
import 'chat_conversation_screen.dart';

class ChatScreen
    extends ConsumerWidget {
  const ChatScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final rooms =
        ref.watch(
      chatRoomsProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Chats'),
      ),
      body: rooms.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text(
                'No chats yet',
              ),
            );
          }

          return ListView.builder(
            itemCount:
                items.length,
            itemBuilder:
                (
              context,
              index,
            ) {
              final room =
                  items[index];

              return ListTile(
                leading:
                    const CircleAvatar(
                  child: Icon(
                    Icons.chat,
                  ),
                ),
                title: Text(
                  room.requestTitle,
                ),
                subtitle: Text(
                  room.lastMessage
                          .isEmpty
                      ? 'No messages yet'
                      : room.lastMessage,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ChatConversationScreen(
                        roomId:
                            room.id,
                        title: room
                            .requestTitle,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () =>
            const ShimmerLoading(),
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