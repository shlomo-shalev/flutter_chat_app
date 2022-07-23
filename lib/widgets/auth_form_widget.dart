import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/pickers/take_image_widget.dart';

class AuthFormWidget extends StatefulWidget {
  final void Function(
    String username,
    String email,
    String password,
    File? image,
    bool isLogin,
    void Function(String message) onMessage,
  ) _createUser;
  final bool isLoader;

  const AuthFormWidget(
    this._createUser,
    this.isLoader, {
    Key? key,
  }) : super(key: key);

  @override
  State<AuthFormWidget> createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = false;
  final Map<String, dynamic> _data = {
    'email': '',
    'username': '',
    'password': '',
    'image': null,
  };

  void _onErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _trySubmit() {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (_data['image'] == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please take image.',
            style: TextStyle(
              color: Theme.of(context).textTheme.headline1!.color,
            ),
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      widget._createUser(
        (_data['username'] as String).trim(),
        (_data['email'] as String).trim(),
        (_data['password'] as String).trim(),
        _data['image'],
        _isLogin,
        _onErrorMessage,
      );
    }
  }

  void _getImage(File image) {
    _data['image'] = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  if (!_isLogin) TakeImageWidget(_getImage),
                  TextFormField(
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: ((value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a vaild email address';
                      }
                      return null;
                    }),
                    onSaved: (value) {
                      setState(() {
                        _data['email'] = value as String;
                      });
                    },
                    key: const ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      label: Text('Email address'),
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      validator: ((value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      }),
                      onSaved: (value) {
                        setState(() {
                          _data['username'] = value as String;
                        });
                      },
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      key: const ValueKey('username'),
                      decoration: const InputDecoration(
                        label: Text('Username'),
                      ),
                    ),
                  TextFormField(
                    validator: ((value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    }),
                    onSaved: (value) {
                      setState(() {
                        _data['password'] = value as String;
                      });
                    },
                    key: const ValueKey('password'),
                    decoration: const InputDecoration(
                      label: Text('Password'),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoader) const CircularProgressIndicator(),
                  if (!widget.isLoader)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                    ),
                  if (!widget.isLoader)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? 'Create new account'
                            : 'I always have a account!',
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
