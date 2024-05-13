import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:successage/chats/chat_pages.dart';
import 'package:successage/utils/app_layouts.dart';

class ChatHeaderMentee extends StatefulWidget {
  final Map<String, dynamic> mentor;

  const ChatHeaderMentee({Key? key, required this.mentor}) : super(key: key);

  @override
  State<ChatHeaderMentee> createState() => _ChatHeaderMenteeState();
}

class _ChatHeaderMenteeState extends State<ChatHeaderMentee> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _menteeDataFuture;
  late Future<QuerySnapshot<Map<String, dynamic>>> _lastMessageFuture;
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _menteeDataFuture = _menteedatafetch();
    _fetchCurrentUserId();
    _lastMessageFuture = _fetchLastMessage();
  }

  void _fetchCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _currentUserId = user.uid;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _menteedatafetch() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('mentor')
        .doc(widget.mentor['mentorid'])
        .get();
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _fetchLastMessage() async {
    // Determine the mentor and mentee IDs
    String mentorId = widget.mentor['mentorid'];
    String menteeId = _currentUserId;

    // Create a combined ID for the chat room, ensuring consistent ordering
    String chatRoomId = mentorId.compareTo(menteeId) < 0
        ? '$mentorId-$menteeId'
        : '$menteeId-$mentorId';

    // Retrieve the last message from the Firestore collection
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedTime =
        '${_addZeroPrefix(dateTime.hour)}:${_addZeroPrefix(dateTime.minute)} ${_getPeriod(dateTime)}';
    return formattedTime;
  }

  String _addZeroPrefix(int number) {
    return number.toString().padLeft(2, '0');
  }

  String _getPeriod(DateTime dateTime) {
    return dateTime.hour < 12 ? 'AM' : 'PM';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _menteeDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Map<String, dynamic> menteeData = snapshot.data!.data()!;

          return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: _lastMessageFuture,
            builder: (context, messageSnapshot) {
              String lastMessage = 'No messages yet';
              String lastMessageTime = '';
              if (messageSnapshot.connectionState == ConnectionState.waiting ||
                  messageSnapshot.data!.docs.isEmpty) {
                lastMessage = 'No messages yet';
              } else if (messageSnapshot.hasError) {
                lastMessage = 'Error fetching message';
              } else {
                lastMessage = messageSnapshot.data!.docs.first['text'];
                Timestamp timestamp =
                    messageSnapshot.data!.docs.first['createdAt'];
                lastMessageTime = _formatTimestamp(timestamp);
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(otheruser: menteeData),
                    ),
                  );
                },
                child: Card(
                  color: Color.fromARGB(255, 250, 250, 250),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 6.0,
                    ),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(menteeData['ppic']),
                    ),
                    title: Text(
                      menteeData['fname'],
                      style: Styles.headline2.copyWith(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      lastMessage,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    trailing: Text(lastMessageTime),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
