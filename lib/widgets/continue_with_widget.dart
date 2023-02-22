import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'social_media_button.dart';

class ContinueWithWidget extends StatelessWidget {
  final VoidCallback togglePages;
  final String text;
  final String toggleText;

  const ContinueWithWidget({
    super.key,
    required this.togglePages,
    required this.text,
    required this.toggleText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Divider(
                  thickness: 1,
                  color: Colors.grey.shade400,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Or continue with:',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 1,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // google and apple sign in btns
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              // google sign in
              SocialMediaButton(imagePath: 'assets/images/google.png'),

              SizedBox(width: 10),

              // apple sign in
              SocialMediaButton(imagePath: 'assets/images/apple.png'),
            ],
          ),

          const SizedBox(height: 30),

          // not a member?
          RichText(
            text: TextSpan(
              text: text,
              style: Theme.of(context).textTheme.headline6,
              children: [
                TextSpan(
                  text: toggleText,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                  recognizer: TapGestureRecognizer()..onTap = togglePages,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
