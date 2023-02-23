import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  Future signUp({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController usernameController,
    required File? pickedImage,
    required String? destination,
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

      // set the displayName of user in auth upon signup
      await authResult.user?.updateDisplayName(usernameController.text);

      if (pickedImage != null && destination != null) {
        UploadTask? task = uploadFile(
          destination: destination,
          pickedImage: pickedImage,
        );

        // set the photoUrl of user in auth upon signup
        await task!.whenComplete(() async {
          String photoURL =
              await FirebaseStorage.instance.ref(destination).getDownloadURL();

          await authResult.user?.updatePhotoURL(photoURL);
        });
      }

      return null;
    } on FirebaseAuthException catch (error) {
      return error.message;
    } catch (error) {
      return 'An unknown error occured';
    }
  }

  UploadTask? uploadFile({File? pickedImage, String? destination}) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(pickedImage!);
    } on FirebaseException catch (error) {
      return null;
    }
  }

  Future getFileImage(image) async {
    final ref = FirebaseStorage.instance.ref().child(image);
    return ref;
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
}
