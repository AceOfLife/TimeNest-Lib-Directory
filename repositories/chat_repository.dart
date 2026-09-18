import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/chat_room_model.dart';
import '../models/chat_message_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  String get currentUserId =>
      _auth.currentUser?.uid ?? '';

  Future<void> createChatRoom({
    required String requestId,
    required String requestTitle,
    required String requesterId,
    required String helperId,
  }) async {
    final roomId =
        '${requestId}_$helperId';

    final roomRef = _firestore
        .collection('chat_rooms')
        .doc(roomId);

    final roomSnapshot =
        await roomRef.get();

    if (roomSnapshot.exists) {
      return;
    }

    await roomRef.set({
      'requestId': requestId,
      'requestTitle': requestTitle,
      'requesterId': requesterId,
      'helperId': helperId,
      'lastMessage': '',
      'lastMessageTime':
          FieldValue.serverTimestamp(),
      'createdAt':
          FieldValue.serverTimestamp(),
      'unreadCount_$requesterId': 0,
      'unreadCount_$helperId': 0,
    });
  }

  Stream<List<ChatRoomModel>>
      getMyChatRooms() {
    final uid = currentUserId;

    return _firestore
        .collection('chat_rooms')
        .orderBy(
          'lastMessageTime',
          descending: true,
        )
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .where(
              (doc) {
                final data =
                    doc.data();

                return data[
                            'requesterId'] ==
                        uid ||
                    data['helperId'] ==
                        uid;
              },
            )
            .map(
              (doc) =>
                  ChatRoomModel.fromMap(
                doc.data(),
                doc.id,
              ),
            )
            .toList();
      },
    );
  }

  Stream<List<ChatMessageModel>>
      getMessages(
    String roomId,
  ) {
    return _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy(
          'createdAt',
          descending: false,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    ChatMessageModel.fromMap(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  Future<void> sendMessage({
    required String roomId,
    required String message,
  }) async {
    if (message.trim().isEmpty) {
      return;
    }

    final roomRef = _firestore
        .collection('chat_rooms')
        .doc(roomId);

    await roomRef
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'message': message.trim(),
      'isRead': false,
      'createdAt':
          FieldValue.serverTimestamp(),
    });

    final roomSnapshot =
        await roomRef.get();

    final roomData =
        roomSnapshot.data();

    if (roomData == null) {
      return;
    }

    final requesterId =
        roomData['requesterId'];

    final helperId =
        roomData['helperId'];

    final receiverId =
        currentUserId ==
                requesterId
            ? helperId
            : requesterId;

    await roomRef.update({
      'lastMessage':
          message.trim(),
      'lastMessageTime':
          FieldValue.serverTimestamp(),
      'unreadCount_$receiverId':
          FieldValue.increment(1),
    });
  }

  Stream<int> getUnreadChatCount() {
    final uid = currentUserId;

    return _firestore
        .collection('chat_rooms')
        .snapshots()
        .map(
      (snapshot) {
        int count = 0;

        for (final doc
            in snapshot.docs) {
          final data =
              doc.data();

          if (data['requesterId'] ==
                  uid ||
              data['helperId'] ==
                  uid) {
            final unread =
                data[
                        'unreadCount_$uid'] ??
                    0;

            count += unread as int;
          }
        }

        return count;
      },
    );
  }

  Future<void> markMessagesAsRead(
    String roomId,
  ) async {
    await _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .update({
      'unreadCount_$currentUserId':
          0,
    });
  }
}