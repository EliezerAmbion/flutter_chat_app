import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  Future createUserWithEmailAndPassword({
    required BuildContext context,
    required emailController,
    required passwordController,
    required usernameController,
  }) async {
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
        email: emailController.text,
        password: passwordController.text,
      );

      // pop the loading circle
      Navigator.of(context).pop();

      // To search for the users collection.
      // NOTE: It will be automatically add it if there are none.

      // Inside the users collection, search for the user.uid.
      // NOTE: It will be automatically add it if there are none.

      // Then set the documents you want/need in the .set
      await FirebaseFirestore.instance
          .collection('users')
          .doc(
            authResult.user!.uid,
          )
          .set({
        'email': emailController.text,
        'groups': [],
        'uid': authResult.user!.uid,
      });

      // set the displayName upon signup
      await authResult.user?.updateDisplayName(usernameController.text);
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

  Future signInWithEmailAndPassword({
    required BuildContext context,
    required emailController,
    required passwordController,
  }) async {
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

      authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // pop loading circle
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      // pop the loading circle then show the error
      Navigator.of(context).pop();

      // show the error
      if (error.code.isNotEmpty) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              // generic message for login
              'email and/or password incorrect!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
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
}
