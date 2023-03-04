import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class GroupsProvider with ChangeNotifier {
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
        'adminId': uid,
        'adminName': displayName,
        'member': [],
        'joinRequests': [],
        'groupId': '',
        'recentMessage': '',
        'recentMessageSenderId': '',
        'recentMessageSenderName': '',
      });

      await groupDocRef.update({
        'member': FieldValue.arrayUnion(['${uid}_$displayName']),
        'groupId': groupDocRef.id,
      });

      // Go to users collection and update the group collection
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        'groups': FieldValue.arrayUnion(
          ["${groupDocRef.id}_$groupName"],
        )
      });
    } catch (error) {
      print(error);
    }
  }

  Future leaveGroup(uid, groupId, groupName, userDisplayName) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'groups': FieldValue.arrayRemove(['${groupId}_$groupName'])
    });
    await FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'member': FieldValue.arrayRemove(['${uid}_$userDisplayName'])
    });
  }
}
