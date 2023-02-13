import 'package:flutter/material.dart';

import '../screens/search_screen.dart';

class CustomAppBarWidget extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const CustomAppBarWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(SearchScreen.routeName);
          },
          icon: const Icon(Icons.search_outlined),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
