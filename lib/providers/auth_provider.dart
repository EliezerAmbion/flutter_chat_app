import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

// In programming, "mapping" usually refers to the process of converting data from one format to another.
// In this case, the _userFromFirebase method maps a FirebaseUser object,
// which is returned by the Firebase authentication API to a User object in the app's domain model.

// The FirebaseUser object contains information about a user's authentication status and profile,
// such as the user's email address, unique user ID, and provider information.
// However, the FirebaseUser object is specific to the Firebase authentication API and
// may not be suitable for use throughout the app's codebase.

// By mapping the FirebaseUser object to a User object in the app's domain model,
// the app can have a more flexible and maintainable representation of a user.
// The User object can contain additional properties and behavior that are specific to the app's requirements,
// and can be used throughout the app's codebase without directly relying on the Firebase authentication API.
  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }

    return User(user.uid, user.email);
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future login({
    required String emailController,
    required String passwordController,
  }) async {
    try {
      auth.UserCredential authResult =
          await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController,
        password: passwordController,
      );

      return _userFromFirebase(authResult.user);
    } on auth.FirebaseAuthException catch (error) {
      return error.message;
    } catch (error) {
      return 'An unknown error occured';
    }
  }

  auth.User? get currentUser {
    return auth.FirebaseAuth.instance.currentUser;
  }

  Future signUp({
    required String emailController,
    required String passwordController,
    required String usernameController,
    required File? pickedImage,
    required String? destination,
  }) async {
    try {
      auth.UserCredential authResult =
          await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController,
        password: passwordController,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
        'email': emailController,
        'groups': [],
        'uid': authResult.user!.uid,
        'displayName': usernameController,
        'emailVerified': false,
      });

      // set the displayName of user in auth upon signup
      await authResult.user?.updateDisplayName(usernameController);

      if (pickedImage != null && destination != null) {
        UploadTask? task = uploadFile(
          destination: destination,
          pickedImage: pickedImage,
        );

        await task!.whenComplete(() async {
          String photoURL =
              await FirebaseStorage.instance.ref(destination).getDownloadURL();

          // set the photoUrl of user in auth upon signup
          await authResult.user?.updatePhotoURL(photoURL);
        });
      }

      return _userFromFirebase(authResult.user);
    } on auth.FirebaseAuthException catch (error) {
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
      print('error in auth_provider uploadFile ==========> $error');
      return null;
    }
  }

  // get the groups of specific user
  Future<List<dynamic>> getUserGroups(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // check first if there is a document under a specific user collection
      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      // if the document exists, do this
      Map<String, dynamic>? userData = userDoc.data()! as Map<String, dynamic>?;
      return userData?['groups'] ?? [];
    } catch (error) {
      print('error in auth_provider getUserGroups ==========> $error');
      rethrow;
    }
  }
}
