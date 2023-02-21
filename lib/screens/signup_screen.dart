import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/helper_widgets.dart';
import '../providers/auth_provider.dart';
import '../widgets/continue_with_widget.dart';
import '../widgets/custom_field_widget.dart';
import '../widgets/custom_form_button_widget.dart';

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

    // this will close the soft keyboard
    FocusScope.of(context).unfocus();

    // HelperWidget.showCircularProgressIndicator(context);

    final result =
        await Provider.of<AuthProvider>(context, listen: false).signUp(
      context: context,
      emailController: _emailController,
      passwordController: _passwordController,
      usernameController: _usernameController,
    );

    // if the result returns an error.message
    if (result != null) {
      HelperWidget.showSnackBar(
        context: context,
        message: result.toString(),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      // pop loading circle
      // return Navigator.of(context).pop();
    }

    // return Navigator.of(context).pop();
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
                  style: Theme.of(context).textTheme.headline1,
                ),

                const SizedBox(height: 10),

                Text(
                  'Let\'s create one for you!',
                  style: Theme.of(context).textTheme.headline4,
                ),

                const SizedBox(height: 60),

                // NOTE: use this if you want to continue to upload an image
                // const UserImagePickerWidget(),
                // const SizedBox(height: 20),

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

                // email field
                CustomFieldWidget(
                  labelText: 'Username',
                  controller: _usernameController,
                  obscureText: false,
                  suffixIcon: Icons.person_outline,
                  horizontalPadding: 25,
                  autoFill: AutofillHints.username,
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
                  autoFill: AutofillHints.password,
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
                ContinueWithWidget(
                  togglePages: widget.togglePages,
                  text: 'Already a Member ',
                  toggleText: 'Login now!',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
