import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../screens/profile_screen.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentuser = Provider.of<AuthProvider>(context, listen: false)
        .currentUser!
        .displayName;

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: [
          Icon(
            Icons.account_circle,
            size: 100,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 20),
          Text(
            currentuser ?? 'Loading...',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 2, thickness: 1),

          // Groups
          ListTile(
            onTap: () {},
            selectedColor: Theme.of(context).colorScheme.tertiary,
            selected: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            leading: const Icon(Icons.group),
            title: Text(
              'Groups',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          // Profile
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProfileScreen.routeName);
            },
            selectedColor: Theme.of(context).colorScheme.primary,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            leading: const Icon(Icons.group),
            title: Text(
              'Profile',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          // Logout
          ListTile(
            onTap: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        // cancel logout
                        IconButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                          ),
                        ),

                        // logout
                        IconButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await FirebaseAuth.instance.signOut();
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  });
            },
            selectedColor: Theme.of(context).colorScheme.primary,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            leading: const Icon(Icons.exit_to_app),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
