import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Timestamp timestamp;
  final String message;
  final bool isMe;

  const MessageBubble(
      {super.key,
      required this.message,
      required this.timestamp,
      required this.isMe});

  String convertIntoDate(Timestamp timestamp) {
    Timestamp firebaseTimestamp = timestamp;
    var date = firebaseTimestamp.toDate();

    return DateFormat('MM/dd, hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            convertIntoDate(timestamp),
            style: TextStyle(
              fontSize: 13.0,
              color: Colors.black54,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: isMe
                ? const EdgeInsets.only(left: 60)
                : const EdgeInsets.only(right: 60),
            child: Material(
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0))
                  : const BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
              elevation: 5.0,
              color:
                  isMe ? Theme.of(context).colorScheme.primary : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Text(
                  message,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black87,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
