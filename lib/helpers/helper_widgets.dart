import 'package:flutter/material.dart';

class HelperWidget {
  static showSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 4),
        backgroundColor: backgroundColor,
      ),
    );
  }

  static showCircularProgressIndicator(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        );
      },
    );
  }
}
