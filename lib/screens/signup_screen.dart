import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/custom_field_widget.dart';
import '../widgets/custom_form_button_widget.dart';
import '../widgets/social_media_button.dart';

// import '../widgets/user_image_picker_widget.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback togglePages;

  const SignupScreen({
    super.key,
    required this.togglePages,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // text editing controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // sign in user
  void _signup() async {
    final bool isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    await AuthService().createUserWithEmailAndPassword(
      context: context,
      emailController: _emailController,
      passwordController: _passwordController,
      usernameController: _usernameController,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),

                // Lets create an account
                Text(
                  'Create new Account',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    fontFamily: 'MontBold',
                    fontSize: 24,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Let\s create one for you!',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    fontFamily: 'MontReg',
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 60),

                // NOTE: use this if you want to continue to upload an image
                // UserImagePickerWidget(),
                // const SizedBox(height: 20),

                // email field
                CustomFieldWidget(
                  labelText: 'Email Address',
                  controller: _emailController,
                  obscureText: false,
                  suffixIcon: Icons.email_outlined,
                  horizontalPadding: 25,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address!';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // email field
                CustomFieldWidget(
                  labelText: 'Username',
                  controller: _usernameController,
                  obscureText: false,
                  suffixIcon: Icons.person_outline,
                  horizontalPadding: 25,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 4) {
                      return 'Username must be at least 4 characters long.';
                    }
                    if (value.length > 10) {
                      return 'Username must not exceed 10 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // password field
                CustomFieldWidget(
                  labelText: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                  suffixIcon: Icons.lock_outline,
                  horizontalPadding: 25,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 characters long';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // button
                CustomFormButtonWidget(
                  onPressed: _signup,
                  text: 'SIGNUP',
                ),

                const SizedBox(height: 40),

                // or Continue with
                Padding(
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
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
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

                const SizedBox(height: 40),

                // not a member?
                RichText(
                  text: TextSpan(
                    text: 'Already a member? ',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                    children: [
                      TextSpan(
                        text: 'Login now!',
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.togglePages,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
