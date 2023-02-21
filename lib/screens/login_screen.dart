import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/continue_with_widget.dart';
import '../widgets/custom_field_widget.dart';
import '../widgets/custom_form_button_widget.dart';

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
                  style: Theme.of(context).textTheme.headline1,
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
                Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: Theme.of(context).textTheme.bodyText1,
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
                ContinueWithWidget(
                  togglePages: widget.togglePages,
                  text: 'Not a member? ',
                  toggleText: 'Register now!',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
