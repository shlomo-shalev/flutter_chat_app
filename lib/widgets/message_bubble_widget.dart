import 'package:flutter/material.dart';

class MessageBubbleWidget extends StatelessWidget {
  final String _message;
  final bool _isMe;
  final String username;
  final String userImageUrl;

  const MessageBubbleWidget(
    this._message,
    this.username,
    this.userImageUrl,
    this._isMe, {
    required Key key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Row(
          key: key,
          mainAxisAlignment:
              _isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: 140, //MediaQuery.of(context).size.width / 2 - 20,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 6,
              ),
              decoration: BoxDecoration(
                color: _isMe
                    ? Colors.grey[300]
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(_isMe ? 0 : 12),
                  bottomRight: Radius.circular(!_isMe ? 0 : 12),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    _isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  Text(
                    username,
                    textAlign: _isMe ? TextAlign.start : TextAlign.end,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _isMe
                          ? Colors.black
                          : Theme.of(context).textTheme.headline1!.color,
                    ),
                  ),
                  Text(
                    _message,
                    textAlign: _isMe ? TextAlign.start : TextAlign.end,
                    style: TextStyle(
                      color: _isMe
                          ? Colors.black
                          : Theme.of(context).textTheme.headline1!.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: _isMe ? 120 : null,
          right: _isMe ? null : 120,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImageUrl),
          ),
        ),
      ],
    );
  }
}
