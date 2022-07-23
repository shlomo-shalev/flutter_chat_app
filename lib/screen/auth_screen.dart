// packages
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// widgets
import 'package:flutter_chat_app/widgets/auth_form_widget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoader = false;

  void _createUser(
    String userName,
    String email,
    String password,
    File? image,
    bool isLogin,
    void Function(String message) onMessage,
  ) async {
    UserCredential authResult;
    setState(() {
      _isLoader = true;
    });
    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${authResult.user!.uid}.jpg');

        await ref.putFile(image as File).whenComplete(() => null);

        final String url = await ref.getDownloadURL();

        if (authResult.user?.uid == null) {
          throw FirebaseAuthException(
            code: '-1',
            message: 'crerate user is failed',
          );
        }
        await FirebaseFirestore.instance
            .collection('users')
            .doc(
              authResult.user!.uid,
            )
            .set({
          'username': userName,
          'email': email,
          'image_url': url,
        });
      }
    } on FirebaseAuthException catch (err) {
      var message = 'An error occurred, pelase check your credentials.';

      if (err.message != null) {
        message = err.message as String;
      }

      onMessage(message);
      setState(() {
        _isLoader = false;
      });
    } catch (err) {
      onMessage('An error occurred, pelase check your credentials.');
      setState(() {
        _isLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthFormWidget(_createUser, _isLoader),
    );
  }
}
