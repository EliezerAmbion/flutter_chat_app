import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/home_screen.dart';

class GroupInfoScreen extends StatelessWidget {
  static const routeName = '/group-info';

  const GroupInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groupArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>;

    final groupName = groupArgs['groupName'];
    final groupId = groupArgs['groupId'];

    String getId(String text) {
      return text.substring(0, text.indexOf('_'));
    }

    String getName(String text) {
      return text.substring(text.indexOf('_') + 1);
    }

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
          ),
          child: const Text('Group Info'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  // barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      elevation: 4,
                      title: Text(
                        'Exit',
                        style: Theme.of(context).textTheme.headline3,
                        textAlign: TextAlign.center,
                      ),
                      content: Text(
                        'Are you sure you want to leave this group?',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      actions: [
                        // cancel logout
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),

                        // leave group
                        Container(
                          margin: const EdgeInsets.only(right: 20, left: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).errorColor,
                            ),
                            onPressed: () async {
                              final currentUser = Provider.of<AuthProvider>(
                                context,
                                listen: false,
                              ).currentUser;

                              final uid = currentUser!.uid;
                              final userDisplayName = currentUser.displayName;

                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .update({
                                'groups': FieldValue.arrayRemove(
                                    ['${groupId}_$groupName'])
                              });
                              await FirebaseFirestore.instance
                                  .collection('groups')
                                  .doc(groupId)
                                  .update({
                                'member': FieldValue.arrayRemove(
                                    ['${uid}_$userDisplayName'])
                              });
                              Navigator.of(context)
                                  .pushReplacementNamed(HomeScreen.routeName);
                            },
                            child: const Text('Leave'),
                          ),
                        ),
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .doc(groupId)
            .snapshots(),
        builder: (context, AsyncSnapshot latestSnapshot) {
          if (latestSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          Map<String, dynamic> groupData = latestSnapshot.data.data();

          return ListView.builder(
            itemCount: groupData['member'].length,
            itemBuilder: (context, index) {
              final isAdmin = getId(groupData['member'][index]) ==
                  getId(groupData['admin']);

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                leading: CircleAvatar(
                  radius: 30,
                  child: Text(
                    groupName!.substring(0, 1).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                ),
                title: Text(
                  getName(groupData['member'][index]),
                  style: Theme.of(context).textTheme.headline3,
                ),
                subtitle: isAdmin
                    ? Text(
                        'ADMIN',
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    : Text(
                        'Member',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
              );
            },
          );
        },
      ),
    );
  }
}

//groupId
// gourpName
// adminName

              // ADMIN
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              //   child: Card(
              //     color: Colors.amber,
              //     child: SizedBox(
              //       width: double.infinity,
              //       height: 150,
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Text(
              //             groupName!,
              //             style: TextStyle(
              //               
              //               fontSize: 22,
              //             ),
              //           ),
              //           Text(
              //             'Admin: ${getName(groupData['admin'])}',
              //             style: TextStyle(
              //               
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),