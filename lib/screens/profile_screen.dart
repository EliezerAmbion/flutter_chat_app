import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/custom_appbar_widget.dart';
import '../widgets/drawer/custom_drawer_widget.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final User? user =
        Provider.of<AuthProvider>(context, listen: false).currentUser;
    final String? currentUserEmail = user?.email;
    final String? currentUserDisplayName = user?.displayName;
    final String? currentUserPhotoUrl = user?.photoURL;
    const placeHolderImage = AssetImage('assets/images/no-image.jpg');

    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Profile'),
      drawer: const CustomDrawerWidget(),
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
                  style: Theme.of(context).textTheme.headline5,
                ),
                const Spacer(),
                Text(
                  currentUserDisplayName!,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Text(
                  'Email:',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const Spacer(),
                Text(
                  currentUserEmail!,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
