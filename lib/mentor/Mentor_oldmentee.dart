import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:successage/chats/chat_pages.dart';

class MentorOldMentee extends StatefulWidget {
  final Map<String, dynamic> mentee;

  const MentorOldMentee({Key? key, required this.mentee}) : super(key: key);

  @override
  State<MentorOldMentee> createState() => _MentorOldMenteeState();
}

class _MentorOldMenteeState extends State<MentorOldMentee> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _menteeDataFuture;

  @override
  void initState() {
    super.initState();
    _menteeDataFuture = _menteedatafetch();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _menteedatafetch() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('mentee')
        .doc(widget.mentee['menteeid'])
        .get();
    return snapshot;
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

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Card(
              color: Color.fromARGB(255, 223, 226, 227),
              elevation: 7,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(menteeData['ppic']),
                ),
                title: Text(menteeData['fname']),
                subtitle: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'About: ${menteeData['bio']}',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Qualification : ${menteeData['education']}')
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ChatPage(
                              otheruser: menteeData,
                            )));
                  },
                  icon: Icon(Icons.message),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
