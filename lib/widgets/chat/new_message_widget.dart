import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../custom_field_widget.dart';

class NewMessageWidget extends StatefulWidget {
  const NewMessageWidget({super.key});

  @override
  State<NewMessageWidget> createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  String _enteredMessage = '';
  final _controller = TextEditingController();

  void _sendMessage() async {
    // FocusScope.of(context).unfocus();

    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
    });
    _controller.clear();

    print('userData ==============> ${userData}');
    print('user ==============> ${user}');
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
