import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/main.dart';

import '../widgets/custom_appbar_widget.dart';
import '../widgets/custom_drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String groupName = '';
  String? displayName = '';
  String? uid = '';

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    setState(() {
      displayName = user!.displayName;
      uid = user.uid;
    });
  }

  createGroup() async {
    print('test');
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Create a Group',
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (val) {
                      setState(() {
                        groupName = val;
                      });
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final groupDocRef = await FirebaseFirestore.instance
                          .collection('groups')
                          .add({
                        'groupName': groupName,
                        'groupIcon': '',
                        'admin': '${uid}_$displayName',
                        'members': [],
                        'groupId': '',
                        'recentMessage': '',
                        'recentMessageSender': '',
                      });

                      await groupDocRef.update({
                        'member':
                            FieldValue.arrayUnion(['${uid}_$displayName']),
                        'groupId': groupDocRef.id,
                      });

                      final userDocRef = await FirebaseFirestore.instance
                          .collection("users")
                          .doc(uid);

                      userDocRef.update({
                        "groups": FieldValue.arrayUnion(
                            ["${groupDocRef.id}_$groupName"])
                      });
                    } on FirebaseAuthException catch (error) {
                      // pop the loading circle then show error
                      Navigator.of(context).pop();

                      // show error
                      if (error.code.isNotEmpty) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              // generic message for login
                              error.message.toString(),
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            duration: const Duration(seconds: 4),
                            backgroundColor: Theme.of(context).errorColor,
                          ),
                        );
                      }
                    } catch (error) {
                      print(error);
                    }
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Group created successfully.'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                  ),
                  child: const Text('CREATE'),
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget noGroupWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle,
            size: 75,
            color: Colors.grey.shade700,
          ),
          const SizedBox(height: 20),
          const Text('You don\'t have any groups!'),
          const SizedBox(height: 10),
          const Text('You can add one by searching or adding a group.')
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Home'),
      drawer: const CustomDrawerWidget(),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, AsyncSnapshot latestSnapshot) {
          if (latestSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (latestSnapshot.data['groups'].length == 0) {
            return noGroupWidget();
          }

          print('=============> ${latestSnapshot.data['groups']}');
          return Text('test');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createGroup(),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
