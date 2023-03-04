import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helpers/helper_functions.dart';

class RequestScreen extends StatelessWidget {
  static const routeName = '/requests';

  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groupArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    final groupId = groupArgs['groupId'];
    final groupName = groupArgs['groupName'];

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
          ),
          child: const Text('Requests'),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .doc(groupId)
            .snapshots(),
        builder: (context, requestSnapshot) {
          if (requestSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final reqSnap = requestSnapshot.data?.data();
          final unionName = '${groupId}_$groupName';

          print('unionName ==========> ${unionName}');

          if (reqSnap?['joinRequests'].length == 0) {
            return const Center(
              child: Text('No requests'),
            );
          }

          return ListView.builder(
            itemCount: reqSnap?['joinRequests'].length,
            itemBuilder: (context, index) {
              final requesterId =
                  HelperFunction.getId(reqSnap?['joinRequests'][index]);

              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(requesterId)
                    .snapshots(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final userData = userSnapshot.data?.data();

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: userData?['photoUrl'] != null
                          ? NetworkImage(userData?['photoUrl'])
                          : const AssetImage('assets/images/no-image.jpg')
                              as ImageProvider,
                    ),
                    title: Text(userData?['displayName']),
                    subtitle: Text(userData?['email']),
                    trailing: TextButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(requesterId)
                            .update({
                          'groupRequests': FieldValue.arrayRemove(
                            [unionName],
                          )
                        });
                        await FirebaseFirestore.instance
                            .collection('groups')
                            .doc(groupId)
                            .update({
                          'joinRequests': FieldValue.arrayRemove(
                              [reqSnap?['joinRequests'][index]])
                        });

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(requesterId)
                            .update({
                          'groups': FieldValue.arrayUnion([unionName])
                        });
                        await FirebaseFirestore.instance
                            .collection('groups')
                            .doc(groupId)
                            .update({
                          'member': FieldValue.arrayUnion(
                              [reqSnap?['joinRequests'][index]])
                        });
                      },
                      child: const Text('Accept'),
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
