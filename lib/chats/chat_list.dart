import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:successage/chats/chat_header.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';


class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late Stream<List<Map<String, dynamic>>> _connectedMenteeStream;
  late FirebaseAuth.User _user; // Declare _user here

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.FirebaseAuth.instance.currentUser!; // Initialize _user in initState
    _connectedMenteeStream = _fetchConnectedMenteesStream(); // Fetch connected mentees stream
  }

  Stream<List<Map<String, dynamic>>> _fetchConnectedMenteesStream() {
    return FirebaseFirestore.instance
        .collection('mentor')
        .doc(_user.uid) // Use _user.uid to get the current user's ID
        .collection('connectionRequests')
        .where('status', isEqualTo: 'connect')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CHAT ROOM')
      ),
      body:
      StreamBuilder<List<Map<String, dynamic>>>(
        stream: _connectedMenteeStream,
        builder: (context, menteesSnapshot) {
          if (!menteesSnapshot.hasData) {
            return Center(
                child: CircularProgressIndicator());
          } else if (menteesSnapshot.hasError) {
            return Center(
                child: Text(
                    'Error: ${menteesSnapshot.error}'));
          } else if (menteesSnapshot.data!.isEmpty) {
            return Center(
                child: Text('No connected mentee'));
          } else {
            final mentees = menteesSnapshot.data!;
            return VsScrollbar(
              style: VsScrollbarStyle(thickness: 3),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: mentees.map((mentee) {
                    return Padding(
                      padding:
                      const EdgeInsets.only(right: 10),
                      child: ChatHeader(
                        mentee: mentee,
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
