import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:successage/mentee/mentee_higlighted_mentor.dart';
import 'package:successage/utils/app_info_list.dart';
import 'package:successage/mentee/mentee_mentor_list.dart';
import 'package:successage/mentee/mentee_profile.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class HomeMentee extends StatefulWidget {
  final String? uid;
  final String? collection;

  HomeMentee({Key? key, required this.uid, required this.collection});

  @override
  State<HomeMentee> createState() => _HomeMenteeState();
}

class _HomeMenteeState extends State<HomeMentee> {
  late Future<Map<String, dynamic>> _userSnapshotFuture;
  late Future<List<Map<String, dynamic>>> _allMentorsFuture;

  @override
  void initState() {
    super.initState();
    _userSnapshotFuture = _fetchUserSnapshot();
    _allMentorsFuture = _fetchAllMentors();
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

  Future<List<Map<String, dynamic>>> _fetchAllMentors() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('mentor').get();

    List<Map<String, dynamic>> mentors = snapshot.docs.map((doc) {
      return {
        "fname": doc['fname'],
        "lname": doc['lname'],
        "ppic": doc['ppic'],
        "designation": doc['designation']
      };
    }).toList();

    return mentors;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<Map<String, dynamic>>(
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
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Mentors in your field",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _allMentorsFuture,
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
                      final mentors = snapshot.data!;
                      return VsScrollbar(
                        style: VsScrollbarStyle(thickness: 3),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: mentors.map((mentor) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: HighlightedMentee(Mentor: mentor),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "All Mentors",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _allMentorsFuture,
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
                      final mentors = snapshot.data!;
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: mentors.map((mentor) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MentorList(Mentor: mentor),
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
