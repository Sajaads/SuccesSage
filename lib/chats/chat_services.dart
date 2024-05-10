import 'package:successage/chats/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  void sendMessage(Messages message) async {
    try {
      await FirebaseFirestore.instance.collection('message').add(message.toMap());
      print('Message stored successfully');
    } catch (e) {
      print('Error storing message: $e');
    }
  }


  //get message
  Stream<QuerySnapshot> getMessages(String userID,otherUserID){
    //construct a chatroom ID for the two users
    List<String> ids = [userID,otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp",descending: false)
        .snapshots();
  }
}