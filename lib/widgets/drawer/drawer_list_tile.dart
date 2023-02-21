import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final String route;
  final String text;
  final IconData icon;

  const DrawerListTile({
    super.key,
    required this.route,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(route);
      },
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      leading: Icon(icon),
      title: Text(
        text,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
