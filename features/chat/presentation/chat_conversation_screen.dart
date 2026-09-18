import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/chat_messages_provider.dart';
import '../../../providers/chat_repository_provider.dart';

class ChatConversationScreen
    extends ConsumerStatefulWidget {
  final String roomId;
  final String title;

  const ChatConversationScreen({
    super.key,
    required this.roomId,
    required this.title,
  });

  @override
  ConsumerState<
          ChatConversationScreen>
      createState() =>
          _ChatConversationScreenState();
}

class _ChatConversationScreenState
    extends ConsumerState<
        ChatConversationScreen> {
  final TextEditingController
      _messageController =
          TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback(
      (_) {
        ref
            .read(
              chatRepositoryProvider,
            )
            .markMessagesAsRead(
              widget.roomId,
            );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final messages =
        ref.watch(
      chatMessagesProvider(
        widget.roomId,
      ),
    );

    final currentUserId =
        ref
            .read(
              chatRepositoryProvider,
            )
            .currentUserId;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet',
                    ),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.all(
                    12,
                  ),
                  itemCount:
                      items.length,
                  itemBuilder:
                      (
                    context,
                    index,
                  ) {
                    final msg =
                        items[index];

                    final isMine =
                        msg.senderId ==
                            currentUserId;

                    return Align(
                      alignment:
                          isMine
                              ? Alignment
                                  .centerRight
                              : Alignment
                                  .centerLeft,
                      child:
                          Container(
                        margin:
                            const EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        padding:
                            const EdgeInsets.all(
                          12,
                        ),
                        decoration:
                            BoxDecoration(
                          color: isMine
                              ? Colors
                                  .blue
                              : Colors
                                  .grey
                                  .shade300,
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                        child: Text(
                          msg.message,
                          style:
                              TextStyle(
                            color: isMine
                                ? Colors
                                    .white
                                : Colors
                                    .black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () =>
                  const Center(
                child:
                    CircularProgressIndicator(),
              ),
              error: (
                e,
                _,
              ) =>
                  Center(
                child:
                    Text(
                  e.toString(),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.all(
                12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller:
                          _messageController,
                      decoration:
                          const InputDecoration(
                        hintText:
                            'Type a message...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                    ),
                    onPressed:
                        () async {
                      final text =
                          _messageController
                              .text;

                      _messageController
                          .clear();

                      await ref
                          .read(
                            chatRepositoryProvider,
                          )
                          .sendMessage(
                            roomId:
                                widget.roomId,
                            message:
                                text,
                          );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}