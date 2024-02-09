import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/Message.dart';

class ChatService {
  // get instance of auth and store
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;

  // get user stream

  // SEND MESSAGE
  Future<void> sendMessage(String receiverId, message) async {
    // get current user info
    final currentUserId = _auth.currentUser!.uid;
    final currentUserEmail = _auth.currentUser!.email.toString();
    final timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    // generate chatroom id : (unique) from current id and receiver userid conversation room
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sort the ids (to ensure that chat room id is going to be same for any pair of people)

    String chatRoomId = ids.join(
        '_'); // combine the ids into a single string to use as a chat room id

    // set docId field to chat_room collection
    await _store.collection('chat_rooms').doc(chatRoomId).set({
      'docId': chatRoomId,
      'roomUser1': currentUserId,
      'roomUser2': receiverId
    });

    // add new message to store
    await _store
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // GET MESSAGE
  Stream<QuerySnapshot> getMessage(String otherUserId) {
    // generate unique document id
    final currentUserId = _auth.currentUser!.uid;
    List<String> ids = [currentUserId, otherUserId];
    ids.sort(); // sort the ids (to ensure that chat room id is going to be same for any pair of people)

    String chatRoomId = ids.join(
        '_'); // combine the ids into a single string to use as a chat room id

    // get from store
    return _store
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
