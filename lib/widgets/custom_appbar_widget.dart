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
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline2!.copyWith(
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
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
