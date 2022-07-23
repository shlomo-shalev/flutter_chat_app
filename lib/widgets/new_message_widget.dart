import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessageWidget extends StatefulWidget {
  const NewMessageWidget({Key? key}) : super(key: key);

  @override
  State<NewMessageWidget> createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final TextEditingController _controller = TextEditingController();
  var _message = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final User user = FirebaseAuth.instance.currentUser as User;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _message,
      'createdAt': DateTime.now(),
      'userId': user.uid,
      'username': userData['username'],
      'user_image_url': userData['image_url'],
    });
    _controller.clear();
    _message = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              decoration: const InputDecoration(
                label: Text('Send a message...'),
              ),
              controller: _controller,
              onSubmitted:
                  _message.trim().isEmpty ? null : (_) => _sendMessage(),
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: _message.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
