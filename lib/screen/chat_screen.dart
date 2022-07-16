// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/2Bf1Oul9ZRfE6TTloraT/messages')
              .snapshots()
              .listen((data) {
            print(data);
          });
        },
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: ((context, index) => const Padding(
              padding: EdgeInsets.all(8),
              child: Text('that works!'),
            )),
      ),
    );
  }
}
