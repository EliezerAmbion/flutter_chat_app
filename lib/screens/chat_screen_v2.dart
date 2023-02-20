import 'package:flutter/material.dart';

import '../screens/group_info_screen.dart';

class ChatScreenV2 extends StatelessWidget {
  static const routeName = '/chat-screen';

  const ChatScreenV2({super.key});

  @override
  Widget build(BuildContext context) {
    final groupArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final groupName = groupArgs['groupName'];
    final displayName = groupArgs['displayName'];
    final groupId = groupArgs['groupId'];

    return Scaffold(
      appBar: AppBar(
        title: Text(groupName!),
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
      body: Center(child: Text(groupName)),
    );
  }
}
