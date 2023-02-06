import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/auth_form_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  // bool _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // to add the username of a user in firebase
        await FirebaseFirestore.instance
            .collection('users')
            .doc(
              authResult.user!.uid,
            )
            .set({
          'username': userName,
          'email': email,
        });
      }
    } on PlatformException catch (error) {
      String? message = 'An Error Occurred, please check your credentials';

      if (error.message != null) {
        message = error.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message!),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthFormWidget(submitFn: _submitAuthForm),
    );
  }
}
