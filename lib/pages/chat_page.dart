import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:converse/components/chat_bubble.dart';
import 'package:converse/services/chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserName;
  final String receiverUserId;
  final String receiverUserImageURL;

  const ChatPage(
      {super.key,
      required this.receiverUserName,
      required this.receiverUserId,
      required this.receiverUserImageURL});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final _auth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();
  String chatMessage = '';

  // send message
  void sendMessage() async {
    // only send message to store if there is something to send
    if (messageController.text.isNotEmpty) {
      chatMessage = messageController.text;

      // clear the message controller
      messageController.clear();

      await _chatService.sendMessage(widget.receiverUserId, chatMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 9.0, bottom: 9.0, left: 15),
          child: CircleAvatar(
            backgroundImage: widget.receiverUserImageURL.trim() != ""
                ? NetworkImage(
                    widget.receiverUserImageURL,
                  )
                : null,
            backgroundColor: Colors.white,
            child: widget.receiverUserImageURL.trim() == ""
                ? Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
          ),
        ),
        title: Text(widget.receiverUserName),
      ),
      body: Column(
        children: [
          // messages
          Expanded(
            child: _buildMessageList(),
          ),

          // user input
          _buildMessageInput(),
        ],
      ),
    );
  }

  // building a message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessage(widget.receiverUserId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text(
              'Loading...',
              style: TextStyle(fontSize: 30),
            ),
          );
        }

        return ListView(
          reverse: true,
          children: snapshot.data!.docs.reversed
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // building a message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    String currentUserEmail = _auth.currentUser!.email.toString();

    return MessageBubble(
      message: data['message'],
      timestamp: data['timestamp'],
      isMe: data['senderEmail'] == currentUserEmail,
    );
  }

  // building a message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              child: TextField(
                minLines: 1,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                controller: messageController,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  hintText: 'write / think 🤔',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: sendMessage,
              icon: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
