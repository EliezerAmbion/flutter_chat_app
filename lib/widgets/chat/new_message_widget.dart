import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessageWidget extends StatefulWidget {
  final String? groupId;
  final String? groupName;

  const NewMessageWidget({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  State<NewMessageWidget> createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  String _enteredMessage = '';
  final _controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  void _sendMessage() async {
    // NOTE: save this for reference
    // final user = FirebaseAuth.instance.currentUser;
    // FirebaseFirestore.instance.collection('chat').add({
    //   'text': _enteredMessage,
    //   'createdAt': Timestamp.now(),
    //   'userId': user!.uid,
    //   'displayName': user.displayName,
    // });

    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .collection('messages')
        .add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user!.uid,
      'displayName': user!.displayName,
    });

    FirebaseFirestore.instance.collection('groups').doc(widget.groupId).update({
      'recentMessage': _enteredMessage,
      'recentMessageSender': user!.displayName,
    });

    print(user!.displayName);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     'id =====> ${FirebaseFirestore.instance.collection('groups').doc().id}');
    print(user!.displayName);
    print(widget.groupId);
    print(widget.groupName);

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: Theme.of(context).colorScheme.tertiary,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Send a message...',

                // label inside
                labelStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2!.color,
                ),

                // label above
                floatingLabelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),

                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                fillColor: Theme.of(context).colorScheme.secondary,
                // fillColor: Colors.white,
                filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.tertiary,
          )
        ],
      ),
    );
  }
}
