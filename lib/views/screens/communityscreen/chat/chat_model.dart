import 'package:flutter/material.dart';
import 'dart:io';

class Chatmodel extends StatelessWidget {
  final String message, time, username, type, replyText, replyName;
  final bool isMe, isGroup, isReply, isOnline;
  final String userImage;

  const Chatmodel({
    super.key,
    required this.message,
    required this.time,
    required this.isMe,
    required this.isGroup,
    required this.username,
    required this.type,
    required this.replyText,
    required this.isReply,
    required this.replyName,
    required this.userImage,
    required this.isOnline,
  });

  Color get chatBubbleColor {
    return isMe ? Colors.green : Colors.grey[300]!;
  }

  Color get chatBubbleReplyColor {
    return Colors.grey[200]!;
  }

  @override
  Widget build(BuildContext context) {
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          )
        : const BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          );

    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        if (!isMe)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(userImage),
                      radius: 20,
                    ),
                    if (isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 8.0),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen,
                  ),
                ),
              ],
            ),
          ),
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            if (!isMe) const SizedBox(width: 48.0),
            Container(
              margin: const EdgeInsets.all(3.0),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: chatBubbleColor,
                borderRadius: radius,
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.3,
                minWidth: 20.0,
              ),
              child: buildChatContent(context),
            ),
          ],
        ),
        Padding(
          padding: isMe
              ? const EdgeInsets.only(right: 10, bottom: 10.0)
              : const EdgeInsets.only(left: 10, bottom: 10.0),
          child: Text(
            time,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontSize: 10.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildChatContent(BuildContext context) {
    List<Widget> content = [];
    if (isReply) {
      content.add(Container(
        decoration: BoxDecoration(
          color: chatBubbleReplyColor,
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
        constraints:
            const BoxConstraints(minHeight: 25, maxHeight: 100, minWidth: 80),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                isMe ? "You" : replyName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 2.0),
              Text(
                replyText,
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontSize: 10.0,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ));
      content.add(const SizedBox(height: 5));
    }

    content.add(Padding(
      padding: EdgeInsets.all(type == "text" ? 5 : 0),
      child: type == "text"
          ? Text(
              message,
              style: TextStyle(
                color: isMe
                    ? Colors.white
                    : Theme.of(context).textTheme.titleLarge?.color,
              ),
            )
          : Image.file(
              File(message),
              height: 130,
              width: MediaQuery.of(context).size.width / 1.3,
              fit: BoxFit.cover,
            ),
    ));

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: content,
    );
  }
}
