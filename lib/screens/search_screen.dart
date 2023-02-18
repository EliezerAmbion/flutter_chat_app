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
                hintText: 'Search for groups...',
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
          Map<String, dynamic>? userDocs = userSnapshot.data?.data();

          return StreamBuilder(
            stream:
                // (searchedQuery.isEmpty) ? FirebaseFirestore.instance.collection('groups').snapshots() :
                FirebaseFirestore.instance
                    .collection('groups')
                    .where('groupName', isEqualTo: searchedQuery)
                    .snapshots(),
            builder: (context, latestSnapshot) {
              if (latestSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final groupsDocs = latestSnapshot.data!.docs;

              return ListView.builder(
                itemCount: latestSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final unionName = '${groupsDocs[index].id}_$searchedQuery';

                  // print('$searchedQuery =====> ${groupsDocs[index].id}');
                  // print(userDocs?['groups'].contains(unionName));

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      child: Text(
                        groupsDocs[index]['groupName']
                            .substring(0, 1)
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    title: Text(
                      groupsDocs[index]['groupName'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Admin: ${getName(groupsDocs[index]['admin'])}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                    trailing: userDocs?['groups'].contains(unionName)
                        ? TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.input_outlined),
                            label: const Text('Joined'),
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                          )
                        : TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.input_outlined),
                            label: const Text('Join'),
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.tertiary,
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
