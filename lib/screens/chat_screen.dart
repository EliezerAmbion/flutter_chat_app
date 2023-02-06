import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
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
              icon: const Icon(
                Icons.logout,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/8xoAGkmT8w3xf8wLFkON/messages')
            .snapshots(),
        builder: (context, streamLatestSnapshot) {
          if (streamLatestSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final documents = streamLatestSnapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(8),
              child: Text(documents[index]['text']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/8xoAGkmT8w3xf8wLFkON/messages')
              .add({'text': 'burat is robert'});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// StreamBuilder needs a stream and builder arguments
// stream ex:
// FirebaseFirestore.instance.collection('chats/8xoAGkmT8w3xf8wLFkON/messages').snapshots()
// the .snapshot gives you a stream which means it emits a new value whenever a data source gives you a new value.
// NOTE: streams are like observables

// builder ex:
// a function which takes the BuildContext and the latest snapshot you get from the stream.
// NOTE: you get a new snapshot whenever a stream changes,
// meaning, the builder function is re-executed whenever the stream gives you a new value.
// With the example above, the ListViewBuilder will be re-evaluated and flutter will check
// if something needs to update in the ListViewBuilder.
