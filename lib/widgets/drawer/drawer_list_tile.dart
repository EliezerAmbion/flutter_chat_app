import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final String route;
  final String text;
  final IconData icon;
  final String navType;

  const DrawerListTile({
    super.key,
    required this.route,
    required this.text,
    required this.icon,
    required this.navType,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (navType == 'pushReplacementNamed') {
          Navigator.of(context).pushReplacementNamed(route);
        }
        if (navType == 'pushNamed') {
          Navigator.pop(context);
          Navigator.of(context).pushNamed(route);
        }
      },
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      leading: Icon(icon),
      title: Text(
        text,
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }
}
