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
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser!;
    final currentUserDisplayName = user.displayName;
    final currentUserPhotoUrl = user.photoURL;
    const placeHolderImage = AssetImage('assets/images/no-image.jpg');

    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            CircleAvatar(
              radius: 50,
              child: ClipOval(
                child: FadeInImage(
                  placeholder: placeHolderImage,
                  image: currentUserPhotoUrl != null
                      ? NetworkImage(currentUserPhotoUrl)
                      : placeHolderImage as ImageProvider,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              currentUserDisplayName ?? 'Loading...',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(height: 2, thickness: 1),

            // Groups
            const DrawerListTile(
              route: HomeScreen.routeName,
              text: 'Groups',
              icon: Icons.groups_outlined,
            ),

            // Profile
            const DrawerListTile(
              route: ProfileScreen.routeName,
              text: 'Profile',
              icon: Icons.person_outline,
            ),

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
                          style: Theme.of(context).textTheme.headline3,
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
                          Container(
                            margin: const EdgeInsets.only(right: 20, left: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).errorColor,
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await FirebaseAuth.instance.signOut();
                              },
                              child: const Text('Logout'),
                            ),
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
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
