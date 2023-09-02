import 'package:flutter/material.dart';

import '../widgets/chat/messages_widget.dart';
import '../widgets/chat/new_message_widget.dart';
import 'group/group_info_screen.dart';

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
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
          ),
          child: Text(groupName!),
        ),
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
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // FocusScope.of(context).requestFocus(new FocusNode());
          FocusScope.of(context).unfocus();
        },
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
// add comment 1
// add comment 2
// add comment 3 remote master
// add comment 4 remote master
// add comment 5 remote master
// test rebase w/o fetching
