import 'package:flutter/material.dart';

import '../widgets/chat/messages_widget.dart';
import '../widgets/chat/new_message_widget.dart';
import 'group_info_screen.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chat-screen';

  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groupArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final groupName = groupArgs['groupName'];
    final displayName = groupArgs['displayName'];
    final groupId = groupArgs['groupId'];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              'Group:',
              style: TextStyle(fontSize: 12),
            ),
            Text(groupName!),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(GroupInfoScreen.routeName, arguments: {
                'groupName': groupName,
                'displayName': displayName,
                'groupId': groupId,
              });
            },
            icon: const Icon(
              Icons.info,
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: MessagesWidget(groupId: groupId)),
            NewMessageWidget(
              groupId: groupId,
              groupName: groupName,
            ),
          ],
        ),
      ),
    );
  }
}
