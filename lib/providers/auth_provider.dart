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
    // this will close the soft keyboard
    FocusScope.of(context).unfocus();

    HelperWidget.showCircularProgressIndicator(context);

    try {
      UserCredential authResult =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // pop the loading circle
      Navigator.of(context).pop();

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
    } on FirebaseAuthException catch (error) {
      // pop the loading circle then show error
      Navigator.of(context).pop();

      // show error
      HelperWidget.showSnackBar(
        context: context,
        message: error.message.toString(),
        backgroundColor: Theme.of(context).errorColor,
      );
    } catch (error) {
      print(error);
    }
  }

  Future _signInWithEmailAndPassword({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    // this will close the soft keyboard
    FocusScope.of(context).unfocus();

    HelperWidget.showCircularProgressIndicator(context);

    try {
      UserCredential authResult =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // pop loading circle
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      // pop the loading circle then show the error
      Navigator.of(context).pop();

      // show the error
      HelperWidget.showSnackBar(
        context: context,
        message: error.message.toString(),
        backgroundColor: Theme.of(context).errorColor,
      );
    } catch (error) {
      print(error);
    }
  }

  User? get currentUser {
    return FirebaseAuth.instance.currentUser;
  }

  Future signIn({
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
