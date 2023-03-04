import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../widgets/chat/messages_widget.dart';
import '../widgets/chat/new_message_widget.dart';
import 'group/group_info_screen.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    //Fired when the app is in the foreground
    FirebaseMessaging.onMessage.listen((message) {
      print('foreground message title: ${message.notification?.title}');
      print('foreground message body: ${message.notification?.body}');
    });
    //Fired when the app is terminated or in the background
    FirebaseMessaging.onBackgroundMessage((message) {
      print('background message title: ${message.notification?.title}');
      print('background message: ${message.notification?.body}');
      return Future.delayed(Duration.zero); //Mock Future
    });
    super.initState();
  }

  init() async {
    String deviceToken = await getDeviceToken();
    print('deviceToken ==========> $deviceToken');
  }

  Future getDeviceToken() async {
    FirebaseMessaging firebaseMessage = FirebaseMessaging.instance;
    String? deviceToken = await firebaseMessage.getToken();

    if (deviceToken == null) {
      return;
    }

    return deviceToken;
  }

  @override
  Widget build(BuildContext context) {
    final groupArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final groupName = groupArgs['groupName'];
    final displayName = groupArgs['displayName'];
    final groupId = groupArgs['groupId'];

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
          ),
          child: Text(groupName!),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(GroupInfoScreen.routeName, arguments: {
                'groupName': groupName,
                'displayName': displayName,
                'groupId': groupId,
              });
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // FocusScope.of(context).requestFocus(new FocusNode());
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(child: MessagesWidget(groupId: groupId)),
            NewMessageWidget(
              groupId: groupId,
              groupName: groupName,
            ),
          ],
        ),
      ),
    );
  }
}
