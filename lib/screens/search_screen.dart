import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchedQuery = '';

  String getName(String text) {
    return text.substring(text.indexOf('_') + 1);
  }

  String getId(String text) {
    return text.substring(0, text.indexOf('_'));
  }

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<AuthProvider>(context).currentUser!.uid;
    final userDisplayName =
        Provider.of<AuthProvider>(context).currentUser!.displayName;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchedQuery = value;
                });
              },
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.search_outlined),
                hintText: 'Search groups...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, userSnapshot) {
          return StreamBuilder(
            stream:
                // (searchedQuery.isEmpty) ? FirebaseFirestore.instance.collection('groups').snapshots() :
                FirebaseFirestore.instance
                    .collection('groups')
                    .orderBy('groupName')
                    .startAt([searchedQuery]).endAt(
                        [searchedQuery + '\uf8ff']).snapshots(),
            builder: (context, latestSnapshot) {
              if (latestSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                itemCount: latestSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final groupsDocs = latestSnapshot.data!.docs;
                  final groupId = groupsDocs[index].id;
                  final unionName = '${groupId}_$searchedQuery';
                  Map<String, dynamic>? userDocs = userSnapshot.data?.data();

                  final hasJoined = userDocs?['groups'].contains(unionName);

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    leading: CircleAvatar(
                      radius: 30,
                      child: Text(
                        groupsDocs[index]['groupName']
                            .substring(0, 1)
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    title: Text(
                      groupsDocs[index]['groupName'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Admin: ${getName(groupsDocs[index]['admin'])}',
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    trailing: hasJoined
                        ? TextButton.icon(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .update({
                                'groups': FieldValue.arrayRemove([unionName])
                              });
                              await FirebaseFirestore.instance
                                  .collection('groups')
                                  .doc(groupId)
                                  .update({
                                'member': FieldValue.arrayRemove(
                                    ['${uid}_$userDisplayName'])
                              });
                            },
                            icon: const Icon(Icons.input_outlined),
                            label: const Text('Joined'),
                          )
                        : TextButton.icon(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .update({
                                'groups': FieldValue.arrayUnion([unionName])
                              });
                              await FirebaseFirestore.instance
                                  .collection('groups')
                                  .doc(groupId)
                                  .update({
                                'member': FieldValue.arrayUnion(
                                    ['${uid}_$userDisplayName'])
                              });
                            },
                            icon: const Icon(Icons.input_outlined),
                            label: const Text('Join'),
                          ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
