import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_field_widget.dart';
import '../widgets/social_media_button.dart';

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

    // this will close the soft keyboard
    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      UserCredential authResult;

      authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // pop the loading circle
      Navigator.of(context).pop();

      // to add the username of a user in firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(
            authResult.user!.uid,
          )
          .set({
        'username': _usernameController.text,
        'email': _emailController.text,
      });
    } on FirebaseAuthException catch (error) {
      // pop the loading circle then show error
      Navigator.of(context).pop();

      // show error
      if (error.code.isNotEmpty) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              // generic message for login
              error.message.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            duration: const Duration(seconds: 4),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    } catch (error) {
      print(error);
    }
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
                const SizedBox(height: 50),
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(height: 20),

                // welcome back message
                Text(
                  'Let\'s create an account for you!',
                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(height: 40),

                // email field
                CustomFieldWidget(
                  labelText: 'Email Address',
                  controller: _emailController,
                  obscureText: false,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address!';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // email field
                CustomFieldWidget(
                  labelText: 'Username',
                  controller: _usernameController,
                  obscureText: false,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 4) {
                      return 'Username must be at least 4 characters long.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // password field
                CustomFieldWidget(
                  labelText: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 characters long';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // button
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _signup,
                    child: const Text(
                      'Signup',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
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
                            color: Colors.grey.shade800,
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
                    text: 'Not a member? ',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    children: [
                      TextSpan(
                        text: 'Register Now!',
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.togglePages,
                        style: const TextStyle(
                          color: Colors.blue,
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
