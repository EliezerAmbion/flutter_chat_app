import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/chat_screen.dart';

class GroupTileWidget extends StatelessWidget {
  final String groupName;
  final String displayName;

  const GroupTileWidget({
    super.key,
    required this.groupName,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ChatScreen.routeName);
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
