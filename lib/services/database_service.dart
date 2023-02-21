import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  Future addGroupCollection({
    required String groupName,
    required String uid,
    required String displayName,
  }) async {
    try {
      final groupDocRef =
          await FirebaseFirestore.instance.collection('groups').add({
        'groupName': groupName,
        'groupIcon': '',
        'admin': '${uid}_$displayName',
        'member': [],
        'groupId': '',
        'recentMessage': '',
        'recentMessageSender': '',
      });

      await groupDocRef.update({
        'member': FieldValue.arrayUnion(['${uid}_$displayName']),
        'groupId': groupDocRef.id,
      });

      // Go to users collection and update the group collection
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "groups": FieldValue.arrayUnion(
          ["${groupDocRef.id}_$groupName"],
        )
      });
    } catch (error) {
      print(error);
    }
  }

  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (error) {
      return null;
    }
  }

  static Future getFileImage(image) async {
    final ref = FirebaseStorage.instance.ref().child(image);
    return ref;
  }
}
