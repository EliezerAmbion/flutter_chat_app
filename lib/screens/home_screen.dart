import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/create_group_widget.dart';
import '../widgets/custom_appbar_widget.dart';
import '../widgets/custom_drawer_widget.dart';
import '../widgets/group_tile_widget.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

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

  String getId(String text) {
    return text.substring(0, text.indexOf('_'));
  }

  String getName(String text) {
    return text.substring(text.indexOf('_') + 1);
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
        children: const [
          Icon(
            Icons.add_circle,
            size: 75,
          ),
          SizedBox(height: 20),
          Text('You don\'t have any groups!'),
          SizedBox(height: 10),
          Text('You can add one by searching or creating a group.')
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Groups'),
      drawer: const CustomDrawerWidget(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(Provider.of<AuthProvider>(context, listen: false)
                .currentUser!
                .uid)
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

          Map<String, dynamic> userData = latestSnapshot.data.data();

          return ListView.builder(
            itemBuilder: (context, index) {
              int reverseIndex = userData['groups'].length - index - 1;

              return GroupTileWidget(
                groupId: getId(userData['groups'][reverseIndex]),
                groupName: getName(userData['groups'][reverseIndex]),
                displayName: userData['displayName'],
              );
            },
            itemCount: userData['groups'].length,
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
