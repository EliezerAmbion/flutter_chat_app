import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble_widget.dart';

class MessagesWidget extends StatelessWidget {
  final String? groupId;

  const MessagesWidget({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .collection('messages')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, chatLatestSnapshot) {
            if (chatLatestSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = chatLatestSnapshot.data!.docs;
            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (context, index) => MessageBubbleWidget(
                message: chatDocs[index]['text'],
                isMe: chatDocs[index]['userId'] == futureSnapshot.data!.uid,
                displayName: chatDocs[index]['displayName'],
                // optional: this is to ensure that flutter is always able to efficiently update data in lists
                key: ValueKey(chatDocs[index].id),
              ),
            );
          },
        );
      },
    );
  }
}
