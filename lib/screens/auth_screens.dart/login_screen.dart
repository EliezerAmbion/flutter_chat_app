import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helper_widgets.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/continue_with_widget.dart';
import '../../widgets/custom_field_widget.dart';
import '../../widgets/custom_form_button_widget.dart';

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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final bool isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    // this will close the soft keyboard
    FocusScope.of(context).unfocus();

    HelperWidget.showCircularProgressIndicator(context);

    final result = await authProvider.login(
      emailController: _emailController.text,
      passwordController: _passwordController.text,
    );

    // this means if the result is not a User
    if (result is! User) {
      if (!mounted) return;

      HelperWidget.showSnackBar(
        context: context,
        message: result.toString(),
        backgroundColor: Theme.of(context).colorScheme.error,
      );

      return Navigator.pop(context);
    }

    if (!mounted) return;
    return Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
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

                const SizedBox(height: 20),

                // button
                CustomFormButtonWidget(
                  onPressed: _login,
                  text: 'LOGIN',
                ),

                const SizedBox(height: 40),

                // or Continue with
                const ContinueWithWidget(),

                // not a member?
                RichText(
                  text: TextSpan(
                    text: 'Not a Member? ',
                    style: Theme.of(context).textTheme.bodyText1,
                    children: [
                      TextSpan(
                        text: 'Register Now!',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
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
