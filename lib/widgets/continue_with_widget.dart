import 'package:flutter/material.dart';

class ContinueWithWidget extends StatelessWidget {
  const ContinueWithWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Colors.grey.shade400,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Or continue with:',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Colors.grey.shade200,
            ),
          ),
        ],
      ),
    );
  }
}
