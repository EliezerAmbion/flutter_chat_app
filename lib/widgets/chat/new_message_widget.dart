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
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .collection('messages')
        .add({
      'text': _enteredMessage,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': user!.uid,
      'displayName': user!.displayName,
    });

    FirebaseFirestore.instance.collection('groups').doc(widget.groupId).update({
      'recentMessage': _enteredMessage,
      'recentMessageSender': user!.displayName,
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              // style: TextStyle(),
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Send a message...',

                // label inside
                labelStyle: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Colors.grey.shade600,
                    ),

                // label above
                floatingLabelStyle: Theme.of(context).textTheme.headline5,

                // border unfocused
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
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
            color: Theme.of(context).colorScheme.secondary,
          )
        ],
      ),
    );
  }
}
