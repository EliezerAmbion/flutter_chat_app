import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helpers/helper_widgets.dart';
import 'package:flutter_chat_app/services/database_service.dart';
import 'package:flutter_chat_app/widgets/custom_field_widget.dart';

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
  final _groupController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getUserData();
    super.initState();
  }

// TODO: put this in database service
  getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    setState(() {
      displayName = user!.displayName;
      uid = user.uid;
    });
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

                groupName = _groupController.text;

                DatabaseService().addGroupCollection(
                  groupName: groupName,
                  uid: uid!,
                  displayName: displayName!,
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
