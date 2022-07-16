// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_app/firebase_options.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/Zyi1M5d7RdcTHoq7soR2/messages')
              .add({'text': 'add item by clicking this button'});
        },
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text('loader app...'),
                ],
              ),
            );
          }
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chats/Zyi1M5d7RdcTHoq7soR2/messages')
                .snapshots(),
            builder: (ctx, stram) {
              return ListView.builder(
                itemCount: stram.data == null
                    ? 0
                    : (stram.data as QuerySnapshot).docs.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8),
                  child:
                      Text((stram.data as QuerySnapshot).docs[index]['text']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
