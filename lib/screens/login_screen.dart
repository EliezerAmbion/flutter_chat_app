import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/custom_field_widget.dart';
import '../widgets/custom_form_button_widget.dart';
import '../widgets/social_media_button.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback togglePages;

  const LoginScreen({
    super.key,
    required this.togglePages,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // text editing controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // sign in user
  void _login() async {
    final bool isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    await Provider.of<AuthProvider>(context, listen: false).signIn(
      context: context,
      emailController: _emailController,
      passwordController: _passwordController,
    );
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

                // welcome back message
                Text(
                  'Welcome back!',
                  style: Theme.of(context).textTheme.headline2,
                ),

                const SizedBox(height: 10),

                Text(
                  'Login to continue',
                  style: Theme.of(context).textTheme.headline4,
                ),

                const SizedBox(height: 60),

                // email field
                CustomFieldWidget(
                  labelText: 'Email Address',
                  controller: _emailController,
                  obscureText: false,
                  suffixIcon: Icons.email_outlined,
                  horizontalPadding: 25,
                  autoFill: AutofillHints.email,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address!';
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
                  autoFill: AutofillHints.password,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 characters long';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                // forgot password
                const Padding(
                  padding: EdgeInsets.only(right: 25),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // button
                CustomFormButtonWidget(
                  onPressed: _login,
                  text: 'LOGIN',
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
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with:',
                          style: TextStyle(),
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
                    text: 'Not a member? ',
                    style: TextStyle(),
                    children: [
                      TextSpan(
                        text: 'Register Now!',
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.togglePages,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
