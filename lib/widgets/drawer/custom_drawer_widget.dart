import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/drawer/drawer_list_tile.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../screens/home_screen.dart';
import '../../screens/profile_screen.dart';

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
          const Icon(
            Icons.account_circle,
            size: 100,
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
          const DrawerListTile(route: HomeScreen.routeName, text: 'Groups'),

          // Profile
          const DrawerListTile(route: ProfileScreen.routeName, text: 'Profile'),

          // Logout
          ListTile(
            onTap: () {
              showDialog(
                  // barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Logout',
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.center,
                      ),
                      content: Text(
                        'Are you sure you want to logout?',
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

                        // logout
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).errorColor,
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await FirebaseAuth.instance.signOut();
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    );
                  });
            },
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            leading: const Icon(Icons.exit_to_app),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ],
      ),
    );
  }
}