import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

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

      await _usersCollection.doc(authResult.user!.uid).set({
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

        await task!.whenComplete(() async {
          String photoURL =
              await FirebaseStorage.instance.ref(destination).getDownloadURL();

          // set the photoUrl of user in auth upon signup
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
      print('error in auth_provider uploadFile ==========> $error');
      return null;
    }
  }

  Future login({
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

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  // get the groups of specific user
  Future<List<dynamic>> getUserGroups(String userId) async {
    try {
      DocumentSnapshot userDoc = await _usersCollection.doc(userId).get();

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
