import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_app/providers/auth_provider.dart' as auth_prov;

// import '../widgets/appbars/home_screen_appbar.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user =
        Provider.of<auth_prov.AuthProvider>(context, listen: false).currentUser;
    final String? currentUserEmail = user?.email;
    final String? currentUserDisplayName = user?.displayName;
    final String? currentUserPhotoUrl = user?.photoURL;
    const placeHolderImage = AssetImage('assets/images/no-image.jpg');

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
          ),
          child: const Text('Profile'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
            const SizedBox(height: 55),
            Row(
              children: [
                Text(
                  'Username:',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                Text(
                  currentUserDisplayName ?? 'Loading...',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Text(
                  'Email:',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                Text(
                  currentUserEmail ?? 'Loading...',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await FirebaseAuth.instance.signOut();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
