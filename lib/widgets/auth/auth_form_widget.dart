import 'package:flutter/material.dart';

class AuthFormWidget extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  const AuthFormWidget({
    super.key,
    required this.submitFn,
  });

  @override
  State<AuthFormWidget> createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;

  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  void _submit() {
    final bool isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    // this will close the soft keyboard
    FocusScope.of(context).unfocus();

    // .save will run in every TextFormField and trigger the onSaved function
    _formKey.currentState!.save();
    widget.submitFn(
      _userEmail.trim(),
      _userPassword.trim(),
      _userName.trim(),
      _isLogin,
      context,
    );

    // Use those values to send our auth request to Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                // email
                TextFormField(
                  key: const ValueKey('email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userEmail = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                  ),
                ),

                // username
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('username'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 character';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userName = value!;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),

                // password
                TextFormField(
                  key: const ValueKey('password'),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userPassword = value!;
                  },
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),

                const SizedBox(height: 12),

                // login btn
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: _submit,
                  child: Text(
                    _isLogin ? 'Login' : 'Signup',
                  ),
                ),

                // create new account btn
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.tertiary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(
                    _isLogin
                        ? 'Create a new account'
                        : 'Already have an account?',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
