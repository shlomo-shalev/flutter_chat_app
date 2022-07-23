import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/message_bubble_widget.dart';

class MessagesWidget extends StatelessWidget {
  const MessagesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<QueryDocumentSnapshot<Object?>> docs =
            (snapshot.data as QuerySnapshot).docs;
        final User user = FirebaseAuth.instance.currentUser as User;
        return ListView.builder(
          reverse: true,
          itemCount: docs.length,
          itemBuilder: (BuildContext context, int index) {
            return MessageBubbleWidget(
              docs[index]['text'],
              docs[index]['username'],
              docs[index]['user_image_url'],
              docs[index]['userId'] == user.uid,
              key: ValueKey(
                docs[index].id,
              ),
            );
          },
        );
      },
    );
  }
}
