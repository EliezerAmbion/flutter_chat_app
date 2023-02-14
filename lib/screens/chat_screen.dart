import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/chat/messages_widget.dart';
import '../widgets/chat/new_message_widget.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chat-screen';

  const ChatScreen({super.key});

  void _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: const [
            Expanded(child: MessagesWidget()),
            NewMessageWidget(),
          ],
        ),
      ),
    );
  }
}
