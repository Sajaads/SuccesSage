import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:successage/mentee/mentee_higlighted_mentor.dart';
import 'package:successage/mentee/mentee_mentor_list.dart';
import 'package:successage/mentee/mentee_profile.dart';
import 'package:successage/utils/app_layouts.dart';
import 'package:successage/utils/suggestion_button.dart';
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
  late Future<String> _userSnapshotFuture;

  @override
  void initState() {
    super.initState();
    _userSnapshotFuture = _fetchUserSnapshot();
  }
  Future<String> _fetchUserSnapshot() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(widget.collection!)
        .doc(widget.uid!)
        .get();

    String name = snapshot.get('fname');
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: FutureBuilder<String>(
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
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: const DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: AssetImage("assets/person_logo.jpg"),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Welcome, $userSnapshot",
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
                                          builder: (context) => MentorProfile(),
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
    );
  }
}
