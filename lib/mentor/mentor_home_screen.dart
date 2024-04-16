import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:successage/mentor/Mentor_oldmentee.dart';
import 'package:successage/mentor/mentee_list.dart';
import 'package:successage/mentor/request_of_mentee.dart';
import 'package:successage/screen/screen_mentor_or_mentee.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import 'package:successage/screen/auth.dart';

class MentorHomeScreen extends StatefulWidget {
  final String mentorid;

  const MentorHomeScreen({Key? key, required this.mentorid}) : super(key: key);

  @override
  State<MentorHomeScreen> createState() => _MentorHomeScreenState();
}

class _MentorHomeScreenState extends State<MentorHomeScreen> {
  late Future<Map<String, dynamic>> _mentorDataFuture;
  late Future<List<Map<String, dynamic>>> _connectionRequestsFuture;
  late Future<List<Map<String, dynamic>>> _connectedmentee;
  AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    _mentorDataFuture = _fetchmentordata();
    _connectionRequestsFuture = _fetchConnectionRequests();
    _connectedmentee = _fetchconnectedmentees();
  }

  Future<void> refreshHomeScreen() async {
    setState(() {
      _mentorDataFuture = _fetchmentordata(); // Refetch mentor data
      _connectionRequestsFuture = _fetchConnectionRequests();
      _connectedmentee =
          _fetchconnectedmentees(); // Refetch connection requests
    });
  }

  Future<Map<String, dynamic>> _fetchmentordata() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('mentor')
        .doc(widget.mentorid)
        .get();
    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('Document does not exist');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchConnectionRequests() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('mentor')
        .doc(widget.mentorid)
        .collection('connectionRequests')
        .where('status', isEqualTo: 'pending')
        .get();

    List<Map<String, dynamic>> requests = querySnapshot.docs.map((doc) {
      return doc.data() as Map<String, dynamic>;
    }).toList();

    return requests;
  }

  Future<List<Map<String, dynamic>>> _fetchconnectedmentees() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('mentor')
        .doc(widget.mentorid)
        .collection('connectionRequests')
        .where('status', isEqualTo: 'connect')
        .get();

    List<Map<String, dynamic>> requests = querySnapshot.docs.map((doc) {
      return doc.data() as Map<String, dynamic>;
    }).toList();

    return requests;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _mentorDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      NetworkImage(snapshot.data!['ppic']),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Text(
                                  "Welcome, ${snapshot.data!['fname']}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                "Appointments today",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          MenteeList(),
                          SizedBox(height: 15),
                          Text(
                            "Connection Requests",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: _connectionRequestsFuture,
                            builder: (context, requestsSnapshot) {
                              if (requestsSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (requestsSnapshot.hasError) {
                                return Center(
                                    child: Text(
                                        'Error: ${requestsSnapshot.error}'));
                              } else if (requestsSnapshot.data!.isEmpty) {
                                return Center(
                                    child: Text('No pending request'));
                              } else {
                                final mentees = requestsSnapshot.data!;
                                return VsScrollbar(
                                  style: VsScrollbarStyle(thickness: 3),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: mentees.map((mentee) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: RequestOfMentee(
                                            refreshHomescreen:
                                                refreshHomeScreen,
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
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                "My Mentees",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: _connectedmentee,
                            builder: (context, requestsSnapshot) {
                              if (requestsSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (requestsSnapshot.hasError) {
                                return Center(
                                    child: Text(
                                        'Error: ${requestsSnapshot.error}'));
                              } else if (requestsSnapshot.data!.isEmpty) {
                                return Center(
                                    child: Text('No connected mentee'));
                              } else {
                                final mentees = requestsSnapshot.data!;
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
                                          child: MentorOldMentee(
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
                        ],
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Sign Out'),
                  content: Text('Are you sure you want to sign out?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                    TextButton(
                      child: Text('Yes'),
                      onPressed: () {
                        auth.signOut();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => ScreenLogin()),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
          tooltip: 'Sign Out',
          child: Icon(Icons.logout),
          backgroundColor: Colors.red, // Optional: Set your desired color
        ),
      ),
    );
  }
}
