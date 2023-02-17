import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/custom_appbar_widget.dart';

class GroupInfoScreen extends StatelessWidget {
  static const routeName = '/group-info';

  const GroupInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groupArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>;

    final groupName = groupArgs['groupName'];
    final displayName = groupArgs['displayName'];
    final groupId = groupArgs['groupId'];

    String getId(String text) {
      return text.substring(0, text.indexOf('_'));
    }

    String getName(String text) {
      return text.substring(text.indexOf('_') + 1);
    }

    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Group Info'),
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
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  child: Text(
                    groupName!.substring(0, 1).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                title: Text(
                  getName(groupData['member'][index]),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: isAdmin
                    ? const Text(
                        'ADMIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const Text(''),
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
              //               color: Theme.of(context).colorScheme.primary,
              //               fontSize: 22,
              //             ),
              //           ),
              //           Text(
              //             'Admin: ${getName(groupData['admin'])}',
              //             style: TextStyle(
              //               color: Theme.of(context).colorScheme.primary,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),