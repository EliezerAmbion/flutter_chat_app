import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/providers/groups_provider.dart';
import 'package:flutter_chat_app/screens/group/requests_screen.dart';
import 'package:provider/provider.dart';

import '../../helpers/helper_functions.dart';
import '../../providers/auth_provider.dart';
import '../home_screen.dart';

class GroupInfoScreen extends StatelessWidget {
  static const routeName = '/group-info';

  const GroupInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groupArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>;

    final groupName = groupArgs['groupName'];
    final groupId = groupArgs['groupId'];

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;
    final uid = currentUser!.uid;
    final userDisplayName = currentUser.displayName;

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
                          Navigator.pop(context);
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
                            // get the groups of specific user
                            List<dynamic> userGroups =
                                await authProvider.getUserGroups(uid);

                            if (userGroups.contains('${groupId}_$groupName')) {
                              await Provider.of<GroupsProvider>(
                                context,
                                listen: false,
                              ).leaveGroup(
                                uid,
                                groupId,
                                groupName,
                                userDisplayName,
                              );
                            }

                            Navigator.of(context)
                                .pushReplacementNamed(HomeScreen.routeName);
                          },
                          child: const Text('Leave'),
                        ),
                      ),
                    ],
                  );
                },
              );
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
          final bool isRequestShow = currentUser.uid == groupData['adminId'];
          int groupRequestsLength = groupData['joinRequests'].length;

          return Column(
            children: [
              if (isRequestShow)
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          RequestScreen.routeName,
                          arguments: {
                            'groupId': groupId,
                            'groupName': groupName,
                          },
                        );
                      },
                      child: Badge(
                        badgeContent: Text(groupRequestsLength.toString()),
                        badgeStyle: BadgeStyle(
                          badgeColor: Theme.of(context).colorScheme.secondary,
                          padding: const EdgeInsets.all(6),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(
                            right: 5,
                            top: 8,
                          ),
                          child: Text('Requests'),
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: groupData['member'].length,
                  itemBuilder: (context, index) {
                    final memberIds =
                        HelperFunction.getId(groupData['member'][index]);
                    final isAdmin = memberIds == groupData['adminId'];

                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(memberIds)
                          .snapshots(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final userData = userSnapshot.data!.data();
                        final String? photoUrl = userData?['photoUrl'];

                        return Column(
                          children: [
                            if (isAdmin)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.teal,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: photoUrl != null
                                          ? NetworkImage(photoUrl)
                                          : const AssetImage(
                                                  'assets/images/no-image.jpg')
                                              as ImageProvider,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Column(
                                        children: [
                                          Text(
                                            HelperFunction.getName(
                                                groupData['member'][index]),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                          const Text('Admin'),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            if (!isAdmin)
                              SingleChildScrollView(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    bottom: 5,
                                    left: 30,
                                    right: 30,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    leading: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: photoUrl != null
                                          ? NetworkImage(photoUrl)
                                          : const AssetImage(
                                                  'assets/images/no-image.jpg')
                                              as ImageProvider,
                                    ),
                                    title: Text(
                                      HelperFunction.getName(
                                          groupData['member'][index]),
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    subtitle: Text(
                                      'Member',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
