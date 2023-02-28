import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../../helpers/helper_widgets.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/continue_with_widget.dart';
import '../../widgets/custom_field_widget.dart';
import '../../widgets/custom_form_button_widget.dart';
import '../../widgets/user_image_picker_widget.dart';

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
  String? _destination;
  File? _pickedImage;

  void _imagePickFn(File? pickedImage) {
    if (pickedImage == null) return;

    final name = path.basename(pickedImage.path);
    final destination = 'files/$name';

    setState(() {
      _pickedImage = pickedImage;
      _destination = destination;
    });
  }

  // sign in user
  void _signup() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final bool isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    // this will close the soft keyboard
    FocusScope.of(context).unfocus();

    // NOTE: fix the indicator not popping
    HelperWidget.showCircularProgressIndicator(context);

    if (_pickedImage == null) {
      HelperWidget.showSnackBar(
        context: context,
        message: 'Image can not be empty!',
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      return Navigator.pop(context);
    }

    final result = await authProvider.signUp(
      emailController: _emailController.text,
      passwordController: _passwordController.text,
      usernameController: _usernameController.text,
      pickedImage: _pickedImage,
      destination: _destination,
    );

    if (result is! User) {
      if (!mounted) return;

      HelperWidget.showSnackBar(
        context: context,
        message: result.toString(),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      return Navigator.pop(context);
    }

    print('result ==========> ${result}');

    if (!mounted) return;
    return Navigator.pop(context);
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

                const SizedBox(height: 10),

                // NOTE: use this if you want to continue to upload an image
                UserImagePickerWidget(imagePickFn: _imagePickFn),

                const SizedBox(height: 20),

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

                // email field
                CustomFieldWidget(
                  labelText: 'Username',
                  controller: _usernameController,
                  obscureText: false,
                  suffixIcon: Icons.person_outline,
                  horizontalPadding: 25,
                  autoFill: AutofillHints.username,
                  validator: (value) {
                    const min = 4;
                    const max = 12;

                    if (value!.isEmpty || value.length < min) {
                      return 'Username must be at least $min characters.';
                    }
                    if (value.length > max) {
                      return 'Username must not exceed $max characters.';
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
                    const min = 7;

                    if (value!.isEmpty || value.length < min) {
                      return 'Password must be at least $min characters long';
                    }
                    return null;
                  },
                ),

                // button
                CustomFormButtonWidget(
                  onPressed: _signup,
                  text: 'SIGNUP',
                ),

                const SizedBox(height: 30),

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
