import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helpers/helper_widgets.dart';

class AuthProvider with ChangeNotifier {
  // TODO: gayahin mo yung uploadFile method sa database service
  Future _createUserWithEmailAndPassword({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController usernameController,
  }) async {
    try {
      UserCredential authResult =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
        'email': emailController.text,
        'groups': [],
        'uid': authResult.user!.uid,
        'displayName': usernameController.text,
      });

      // set the displayName upon signup in the auth
      await authResult.user?.updateDisplayName(usernameController.text);
      return null;
    } on FirebaseAuthException catch (error) {
      return error.message;
    } catch (error) {
      return 'An unknown error occured';
    }
  }

  Future _signInWithEmailAndPassword({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    try {
      UserCredential authResult =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      return null;
    } on FirebaseAuthException catch (error) {
      return error.message;
    } catch (error) {
      return 'An unknown error occured';
    }
  }

  User? get currentUser {
    return FirebaseAuth.instance.currentUser;
  }

  Future login({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) {
    return _signInWithEmailAndPassword(
      context: context,
      emailController: emailController,
      passwordController: passwordController,
    );
  }

  Future signUp({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController usernameController,
  }) {
    return _createUserWithEmailAndPassword(
      context: context,
      emailController: emailController,
      passwordController: passwordController,
      usernameController: usernameController,
    );
  }
}
