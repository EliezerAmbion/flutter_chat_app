import 'package:flutter/material.dart';

import 'social_media_button.dart';

class ContinueWithWidget extends StatelessWidget {
  const ContinueWithWidget({super.key});

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
          const SizedBox(height: 30),

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
        ],
      ),
    );
  }
}
