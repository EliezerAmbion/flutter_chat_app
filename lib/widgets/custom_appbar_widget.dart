import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/search_screen.dart';

class CustomAppBarWidget extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const CustomAppBarWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final User? user =
        Provider.of<AuthProvider>(context, listen: false).currentUser;
    final String? currentUserPhotoUrl = user?.photoURL;
    const placeHolderImage = AssetImage('assets/images/no-image.jpg');

    return AppBar(
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline3!.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
              ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_outlined),
          onPressed: () {
            Navigator.of(context).pushNamed(SearchScreen.routeName);
          },
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProfileScreen.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
              radius: 15,
              child: ClipOval(
                child: FadeInImage(
                  placeholder: placeHolderImage,
                  image: currentUserPhotoUrl != null
                      ? NetworkImage(currentUserPhotoUrl)
                      : placeHolderImage as ImageProvider,
                  fit: BoxFit.cover,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
