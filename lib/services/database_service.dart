import 'package:cloud_firestore/cloud_firestore.dart';

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
}
