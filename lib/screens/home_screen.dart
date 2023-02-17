import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/helper_widgets.dart';
import '../providers/auth_provider.dart';
import '../services/database_service.dart';
import '../widgets/custom_appbar_widget.dart';
import '../widgets/custom_drawer_widget.dart';
import '../widgets/custom_field_widget.dart';
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
        return AlertDialog(
          title: const Text('Create a Group'),
          content: Form(
            key: _formKey,
            child: CustomFieldWidget(
              labelText: null,
              controller: _groupController,
              obscureText: false,
              horizontalPadding: 0,
              suffixIcon: Icons.group,
              autoFill: AutofillHints.name,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Group Name can\'t be empty';
                }
                return null;
              },
            ),
          ),
          actions: [
            // cancel btn
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),

            // create btn
            ElevatedButton(
              onPressed: () async {
                final bool isValid = _formKey.currentState!.validate();
                if (!isValid) return;

                final currentUser =
                    Provider.of<AuthProvider>(context, listen: false)
                        .currentUser;

                // TODO: Create a provider for groups
                DatabaseService().addGroupCollection(
                  groupName: _groupController.text,
                  uid: currentUser!.uid,
                  displayName: currentUser.displayName!,
                );

                // pop the alert dialog
                Navigator.of(context).pop();

                HelperWidget.showSnackBar(
                  context: context,
                  message: 'Group created successfully.',
                  backgroundColor: Colors.green,
                );

                _groupController.clear();
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
          const Text('You can add one by searching or creating a group.')
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
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
