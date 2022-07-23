// packages
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/messages_widget.dart';
import 'package:flutter_chat_app/widgets/new_message_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    final messaging = FirebaseMessaging.instance;
    Future<NotificationSettings> settings =
        FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    settings.then((value) => inspect(value.authorizationStatus));

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage');
      inspect(message);
    });
    messaging.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('chats'),
        actions: <Widget>[
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color as Color,
            ),
            items: <DropdownMenuItem<Object>>[
              DropdownMenuItem(
                value: 'logout',
                child: SizedBox(
                  child: Row(
                    children: const <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
              ),
            ],
            onChanged: (_) {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: SizedBox(
        child: Column(
          children: const <Widget>[
            Expanded(
              child: MessagesWidget(),
            ),
            NewMessageWidget(),
          ],
        ),
      ),
    );
  }
}
