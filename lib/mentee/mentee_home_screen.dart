import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:successage/mentee/mentee_higlighted_mentor.dart';
import 'package:successage/mentee/mentee_mentor_list.dart';
import 'package:successage/mentee/mentee_profile.dart';
import 'package:successage/utils/app_info_list.dart';

class HomeMentee extends StatefulWidget {
  final String? uid;
  final String? collection;

  HomeMentee({Key? key, required this.uid, required this.collection})
      : super(key: key);

  @override
  State<HomeMentee> createState() => _HomeMenteeState();
}

class _HomeMenteeState extends State<HomeMentee> {
  late Future<Map<String, dynamic>> _userSnapshotFuture;//the Future class represents a potential value or error that will be
  // available at some time in the future. It's commonly used for asynchronous operations such as fetching data from a
  // remote server or performing file I/O.

  @override
  void initState() {
    super.initState();
    _userSnapshotFuture = _fetchUserSnapshot();
  }

  Future<Map<String, dynamic>> _fetchUserSnapshot() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(widget.collection!)
        .doc(widget.uid!)
        .get();

    String name = snapshot.get('fname');
    String lname = snapshot.get('lname');
    String ppic = snapshot.get('ppic');

    return {"name": name, "lname": lname, "ppic": ppic};
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          body: FutureBuilder<Map<String, dynamic>>(
            future: _userSnapshotFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final userSnapshot = snapshot.data!;
                return ListView(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 12),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    NetworkImage(userSnapshot['ppic']!),
                              ),
                              SizedBox(width: 20),
                              Text(
                                "Welcome, ${userSnapshot['name']}",
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [Text("Let's find great mentors")],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFFF4F6FD),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FluentSystemIcons
                                            .ic_fluent_search_regular,
                                        color: Color(0xFFBFC205),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [Text("Mentors in your field")],
                          ),
                          SizedBox(height: 15),
                          Column(
                            children: [
                              HighlightedMentee(Mentor: mentorList.first)
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [Text("All Mentors")],
                          ),
                          SizedBox(height: 15),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.only(left: 20),
                            child: Column(
                              children: mentorList
                                  .map(
                                    (singleMentor) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MentorProfile(),
                                          ),
                                        );
                                      },
                                      child: MentorList(Mentor: singleMentor),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
