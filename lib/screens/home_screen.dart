import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/helper_functions.dart';
import '../providers/auth_provider.dart';
import '../widgets/create_group_widget.dart';
import '../widgets/custom_appbar_widget.dart';
import '../widgets/group_tile_widget.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _groupController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _groupController.dispose();
    super.dispose();
  }

  createGroup() async {
    showDialog(
      context: context,
      builder: (context) {
        return CreateGroupWidget(
          formKey: _formKey,
          groupController: _groupController,
        );
      },
    );
  }

  Widget noGroupWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_circle,
            size: 75,
          ),
          const SizedBox(height: 20),
          Text(
            'You don\'t have any groups!',
            style: Theme.of(context).textTheme.headline3,
          ),
          const SizedBox(height: 10),
          Text(
            'You can add one by searching or creating a group.',
            style: Theme.of(context).textTheme.headline6,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user =
        Provider.of<AuthProvider>(context, listen: false).currentUser;

    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Your Groups'),
      // drawer: const CustomDrawerWidget(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot latestSnapshot) {
          if (latestSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // fallback:
          // the purpose of this is to omit the error showing in vscode
          // if there is no users collection
          if (!latestSnapshot.data.exists &&
              latestSnapshot.data.data() == null) {
            return const Center(child: Text('No data'));
          }

          // if there is a user but no groups yet
          if (latestSnapshot.data['groups'].length == 0) {
            return noGroupWidget();
          }

          Map<String, dynamic>? userData = latestSnapshot.data.data();

          return Container(
            margin: const EdgeInsets.only(top: 20),
            child: ListView.builder(
              itemBuilder: (context, index) {
                String? userGroups = userData?['groups'][index];
                String? userGroupId = HelperFunction.getId(userGroups);
                String? userGroupName = HelperFunction.getName(userGroups!);

                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('groups')
                      .doc(userGroupId)
                      .snapshots(),
                  builder: (context, groupSnapshot) {
                    String? recentMessage =
                        groupSnapshot.data?['recentMessage'];
                    String? recentMessageSenderId =
                        groupSnapshot.data?['recentMessageSenderId'];
                    String? recentMessageSenderName =
                        groupSnapshot.data?['recentMessageSenderName'];

                    bool isCurrentUser =
                        userData?['uid'] == recentMessageSenderId;

                    return GroupTileWidget(
                      groupName: userGroupName,
                      displayName: userData?['displayName'],
                      groupId: userGroupId,
                      recentMessage:
                          '${isCurrentUser ? 'You:' : '$recentMessageSenderName:'} $recentMessage',
                    );
                  },
                );
              },
              itemCount: userData?['groups'].length,
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => createGroup(),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
