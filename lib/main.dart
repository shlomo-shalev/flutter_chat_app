// packages
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/firebase_options.dart';
// screens
import 'package:flutter_chat_app/screen/auth_screen.dart';
import 'package:flutter_chat_app/screen/chat_screen.dart';
import 'package:flutter_chat_app/screen/loader_screen.dart';

Future<void> _handleBackground(RemoteMessage message) async {
  print('onBackgroundMessage');
  inspect(message);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.pink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        textTheme: const TextTheme(
            headline1: TextStyle(
          color: Colors.white,
        )));

    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter chat app',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          secondary: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme().copyWith(
          color: Colors.pink,
          foregroundColor: Colors.white,
        ),
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoaderScreen();
          }

          FirebaseMessaging.onBackgroundMessage(_handleBackground);
          return StreamBuilder(
            stream: FirebaseAuth.instance.idTokenChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoaderScreen();
              }

              if (snapshot.hasData) {
                return const ChatScreen();
              }
              return const AuthScreen();
            },
          );
        },
      ),
    );
  }
}
