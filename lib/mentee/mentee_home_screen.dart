import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:successage/mentee/mentee_connectedmentor.dart';
import 'package:successage/mentee/mentee_drawer.dart';
import 'package:successage/mentee/mentee_higlighted_mentor.dart';
import 'package:successage/screen/auth.dart';
import 'package:successage/screen/screen_mentor_or_mentee.dart';
import 'package:successage/utils/app_info_list.dart';
import 'package:successage/mentee/mentee_mentor_list.dart';
import 'package:successage/utils/app_layouts.dart';
import 'package:successage/mentor/drawer.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class HomeMentee extends StatefulWidget {
  final String uid;
  final String collection;

  HomeMentee({Key? key, required this.uid, required this.collection});

  @override
  State<HomeMentee> createState() => _HomeMenteeState();
}

class _HomeMenteeState extends State<HomeMentee> {
  late Future<Map<String, dynamic>> _userSnapshotFuture;
  late Future<List<Map<String, dynamic>>> _allMentorsFuture;
  late Future<List<Map<String, dynamic>>> _connectedMentorsFuture;
  AuthService auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchConnectedMentorIds();
    _userSnapshotFuture = _fetchUserSnapshot();
    _allMentorsFuture = _fetchAllMentors();
    _connectedMentorsFuture = _fetchconnectedmentors();
  }

  Future<Map<String, dynamic>> _fetchUserSnapshot() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(widget.collection!)
        .doc(widget.uid!)
        .get();

    String name = snapshot.get('fname');
    String lname = snapshot.get('lname');
    String ppic = snapshot.get('ppic');
    String interest = snapshot.get('interest');

    return {"name": name, "lname": lname, "ppic": ppic, "interest": interest};
  }

  Future<List<Map<String, dynamic>>> _fetchAllMentors() async {
    // Fetch the list of connected mentors for the current mentee
    List<String> connectedMentorIds = await _fetchConnectedMentorIds();

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('mentor').get();

    List<Map<String, dynamic>> mentors;

    if (connectedMentorIds.isNotEmpty) {
      mentors = snapshot.docs
          .where((doc) => !connectedMentorIds.contains(doc['uid']))
          .map((doc) {
        return {
          "uid": doc['uid'],
          "fname": doc['fname'],
          "lname": doc['lname'],
          "ppic": doc['ppic'],
          "designation": doc['designation'],
          "bio": doc['bio']
        };
      }).toList();
    } else {
      mentors = snapshot.docs.map((doc) {
        return {
          "uid": doc['uid'],
          "fname": doc['fname'],
          "lname": doc['lname'],
          "ppic": doc['ppic'],
          "designation": doc['designation'],
          "bio": doc['bio']
        };
      }).toList();
    }

    return mentors;
  }

  Future<List<Map<String, dynamic>>> _fetchMentorsinyourfield(
      String menteeInterest) async {
    // Fetch the list of connected mentors for the current mentee
    List<String> connectedMentorIds = await _fetchConnectedMentorIds();

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('mentor')
        .where('interest', isEqualTo: menteeInterest)
        .get();

    List<Map<String, dynamic>> mentors;

    if (connectedMentorIds.isNotEmpty) {
      mentors = snapshot.docs
          .where((doc) => !connectedMentorIds.contains(doc['uid']))
          .map((doc) {
        return {
          "uid": doc['uid'],
          "fname": doc['fname'],
          "lname": doc['lname'],
          "ppic": doc['ppic'],
          "designation": doc['designation'],
          "bio": doc['bio']
        };
      }).toList();
    } else {
      mentors = snapshot.docs.map((doc) {
        return {
          "uid": doc['uid'],
          "fname": doc['fname'],
          "lname": doc['lname'],
          "ppic": doc['ppic'],
          "designation": doc['designation'],
          "bio": doc['bio']
        };
      }).toList();
    }

    return mentors;
  }

  Future<List<Map<String, dynamic>>> _fetchconnectedmentors() async {
    // Fetch the list of connected mentors for the current mentee
    List<String> connectedMentorIds = await _fetchConnectedMentorIds();

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('mentor')
        .where('uid', whereIn: connectedMentorIds)
        .get();

    List<Map<String, dynamic>> mentors = snapshot.docs.map((doc) {
      return {
        "uid": doc['uid'],
        "fname": doc['fname'],
        "lname": doc['lname'],
        "ppic": doc['ppic'],
        "designation": doc['designation'],
        "bio": doc['bio']
      };
    }).toList();

    return mentors;
  }

  Future<List<String>> _fetchConnectedMentorIds() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('mentee')
        .doc(widget.uid)
        .collection('connectedMentors')
        .where('status', isEqualTo: 'connect')
        .get();

    if (snapshot.docs.isNotEmpty) {
      List<String> connectedMentorIds =
          snapshot.docs.map((doc) => doc['mentorid'] as String).toList();
      return connectedMentorIds;
    } else {
      return []; // Return an empty list if no connected mentors found
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(title: 'SuccesSage',onDrawerIconTap: (){_scaffoldKey.currentState?.openDrawer();}),
          drawer: MenteeDrawer(),
          backgroundColor: Colors.white,
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
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: const Color.fromARGB(255, 2, 48, 71),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Mentors in your field",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: const Color.fromARGB(255, 2, 48, 71),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
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
                      String menteeInterest =
                          snapshot.data!['interest'] as String;
                      return FutureBuilder<List<Map<String, dynamic>>>(
                        future: _fetchMentorsinyourfield(menteeInterest),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (snapshot.data!.isEmpty) {
                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  'Currently, there are no mentors available in your field at the moment.'),
                            ));
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
                                      child: HighlightedMentee(
                                        Mentor: mentor,
                                        menteeid: widget.uid,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Connected Mentors",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 2, 48, 71),
                    ),
                  ),
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _connectedMentorsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Currently, there are no connected mentors .'),
                        ),
                      );
                    } else if (snapshot.data!.isEmpty) {
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text('Currently, there are no connected mentors .'),
                      ));
                    } else {
                      final mentors = snapshot.data!;
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: mentors.map((mentor) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Menteeconnectedmentors(
                                Mentor: mentor,
                                menteeid: widget.uid,
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "All Mentors",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 2, 48, 71),
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
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: mentors.map((mentor) {
                            return Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: MentorList(
                                Mentor: mentor,
                                menteeid: widget.uid,
                              ),
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
