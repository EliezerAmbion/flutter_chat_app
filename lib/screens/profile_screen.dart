import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/custom_appbar_widget.dart';
import '../widgets/custom_drawer_widget.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = Provider.of<AuthProvider>(context).currentUser;

    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Profile'),
      drawer: const CustomDrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.account_circle,
              size: 150,
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Username:',
                  style: TextStyle(),
                ),
                Text(
                  currentUser!.displayName!,
                  style: TextStyle(),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Email:',
                  style: TextStyle(),
                ),
                Text(
                  currentUser.email!,
                  style: TextStyle(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
