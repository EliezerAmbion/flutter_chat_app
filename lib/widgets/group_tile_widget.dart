import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

class GroupTileWidget extends StatelessWidget {
  final String groupName;
  final String displayName;
  final String groupId;
  final String? recentMessage;

  const GroupTileWidget({
    super.key,
    required this.groupName,
    required this.displayName,
    required this.groupId,
    required this.recentMessage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ChatScreen.routeName,
          arguments: {
            'groupName': groupName,
            'displayName': displayName,
            'groupId': groupId,
          },
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Text(
                groupName.substring(0, 1).toUpperCase(),
                textAlign: TextAlign.center,
              ),
            ),
            title: Text(
              groupName,
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              recentMessage ?? 'No message yet',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ),
      ),
    );
  }
}
