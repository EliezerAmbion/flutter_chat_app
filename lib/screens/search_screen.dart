import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/database_service.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  bool _isLoading = false;
  String searchedQuery = '';

  String getName(String text) {
    return text.substring(text.indexOf('_') + 1);
  }

  @override
  Widget build(BuildContext context) {
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
          stream: (searchedQuery.isEmpty)
              ? FirebaseFirestore.instance.collection('groups').snapshots()
              : FirebaseFirestore.instance
                  .collection('groups')
                  .where('groupName', arrayContains: searchedQuery)
                  .snapshots(),
          builder: (context, latestSnapshot) {
            if (latestSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final groupsDocs = latestSnapshot.data!.docs;
            print('groupsDocs ====================> $groupsDocs');

            return ListView.builder(
              itemCount: latestSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
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
                  trailing: Icon(
                    Icons.input_outlined,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                );
              },
            );
          },
        ));
  }
}
