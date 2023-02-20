import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

class GroupTileWidget extends StatelessWidget {
  final String groupName;
  final String displayName;
  final String groupId;

  const GroupTileWidget({
    super.key,
    required this.groupName,
    required this.displayName,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).pushNamed(
        //   chatScreenV2.routeName,
        //   arguments: {
        //     'groupName': groupName,
        //     'displayName': displayName,
        //     'groupId': groupId,
        //   },
        // );
        Navigator.of(context).pushNamed(
          ChatScreen.routeName,
          arguments: {
            'groupName': groupName,
            'displayName': displayName,
            'groupId': groupId,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            child: Text(
              groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          title: Text(
            groupName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Join as $displayName',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
