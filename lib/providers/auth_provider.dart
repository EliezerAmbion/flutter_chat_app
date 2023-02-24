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

  String? get currentUserPhotoUrl {
    return FirebaseAuth.instance.currentUser?.photoURL;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}


// class UsersProvider with ChangeNotifier {
//   List<User> _users = [];

//   List<User> get users {
//     return [..._users];
//   }

//   Future<void> fetchUsers() async {
//     try {
//       final QuerySnapshot<Map<String, dynamic>> userDocs =
//           await FirebaseFirestore.instance.collection('users').get();
//       final List<User> loadedUsers = userDocs.docs
//           .map((userDoc) => User(
//                 id: userDoc.id,
//                 name: userDoc.get('name'),
//                 email: userDoc.get('email'),
//                 // add other fields here
//               ))
//           .toList();
//       _users = loadedUsers;
//       notifyListeners();
//     } catch (error) {
//       // handle error
//     }
//   }
// }