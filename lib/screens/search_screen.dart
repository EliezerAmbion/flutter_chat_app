import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../helpers/helper_functions.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchedQuery = '';

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final uid = authProvider.currentUser?.uid;
    final userDisplayName = authProvider.currentUser!.displayName;

    return Scaffold(
      appBar: AppBar(
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
            stream: FirebaseFirestore.instance
                .collection('groups')
                .where('groupName', isEqualTo: searchedQuery)
                .snapshots(),

            // NOTE: use this if you want to show the groups as you type
            // FirebaseFirestore.instance
            //     .collection('groups')
            //     .orderBy('groupName')
            //     .startAt([searchedQuery]).endAt(
            //         ['$searchedQuery\uf8ff']).snapshots(),
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
                  final groupName = groupsDocs[index]['groupName'];
                  final unionName = '${groupId}_$groupName';

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
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    subtitle: Text(
                      'Admin: ${groupsDocs[index]['adminName']}',
                      style: Theme.of(context).textTheme.bodyText1,
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
                            icon: Icon(
                              Icons.input_outlined,
                              color: Colors.grey.shade700,
                            ),
                            label: Text(
                              'Joined',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(
                                    color: Colors.grey.shade700,
                                  ),
                            ),
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
                            icon: Icon(
                              Icons.input,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            label: Text(
                              'Join',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
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
