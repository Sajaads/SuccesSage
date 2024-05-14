import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'messages.dart';

class ChatService {
  //get instance of firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream(String id) {
    return _firestore.collection(id).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //go through each individual user
        final user = doc.data();

        //return user
        return user;
      }).toList();
    });
  }

  //send message

  Future<void> sendMessage(Messages message) async {
    try {
      // Determine the mentor and mentee IDs
      String mentorId = message.from;
      String menteeId = message.to;

      // Create a combined ID for the chat room, ensuring consistent ordering
      String chatRoomId = mentorId.compareTo(menteeId) < 0
          ? '$mentorId-$menteeId'
          : '$menteeId-$mentorId';

      // Get a reference to the Firestore collection
      CollectionReference messagesCollection =
          FirebaseFirestore.instance.collection('messages');

      // Add the message to the subcollection under the combined mentor and mentee UID
      await messagesCollection
          .doc(chatRoomId)
          .collection('chats')
          .add(message.toMap());
    } catch (e) {
      // Handle errors here
      print('Error sending message: $e');
    }
  }

  //get message
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // Construct a chatroom ID for the two users
    List<String> ids = [userID, otherUserID];
    String chatRoomID = ids.join('-');

    // Get a reference to the subcollection containing messages
    CollectionReference messagesCollection = FirebaseFirestore.instance
        .collection("messages")
        .doc(chatRoomID)
        .collection('messages');

    // Query the messages in descending order of creation time
    return messagesCollection
        .orderBy("createdAt", descending: true)
        .snapshots();
  }
}
