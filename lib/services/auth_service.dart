import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helpers/helper_widgets.dart';

// TODO: make this file leaner by deleting the unneccessary show modal and popping
class AuthService {
  Future createUserWithEmailAndPassword({
    required BuildContext context,
    required emailController,
    required passwordController,
    required usernameController,
  }) async {
    // this will close the soft keyboard
    // FocusScope.of(context).unfocus();

    HelperWidget.showCircularProgressIndicator(context);

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

      // .doc(uid).set()
      // FirebaseFirestore.instance.collection('groups').doc(uid).set()
      // Is used to set a new document with a specific ID, or update an existing document with the specified ID.

      // .add() NOTE: there is no .doc(uid)
      // FirebaseFirestore.instance.collection('groups').add()
      // Is used to create a new document with a randomly generated ID.
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
      if (error.code.isNotEmpty) {
        HelperWidget.showSnackBar(
          context: context,
          message: error.message.toString(),
          backgroundColor: Theme.of(context).errorColor,
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
    HelperWidget.showCircularProgressIndicator(context);

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
        HelperWidget.showSnackBar(
          context: context,
          message: 'email and/or password incorrect!',
          backgroundColor: Theme.of(context).errorColor,
        );
      }
    } catch (error) {
      print(error);
    }
  }
}
