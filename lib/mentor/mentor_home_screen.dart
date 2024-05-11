import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:successage/mentor/Mentor_oldmentee.dart';
import 'package:successage/mentor/mentee_list.dart';
import 'package:successage/mentor/mentor_schedule.dart';
import 'package:successage/mentor/request_of_mentee.dart';
import 'package:successage/screen/screen_mentor_or_mentee.dart';
import 'package:successage/utils/app_layouts.dart';
import 'package:successage/utils/drawer.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import 'package:successage/screen/auth.dart';

class MentorHomeScreen extends StatefulWidget {
  final String mentorid;

  const MentorHomeScreen({Key? key, required this.mentorid}) : super(key: key);

  @override
  State<MentorHomeScreen> createState() => _MentorHomeScreenState();
}

class _MentorHomeScreenState extends State<MentorHomeScreen> {
  late Stream<Map<String, dynamic>> _mentorDataStream;
  late Stream<List<Map<String, dynamic>>> _connectionRequestsStream;
  late Stream<List<Map<String, dynamic>>> _connectedMenteeStream;
  AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    _mentorDataStream = _fetchMentorDataStream();
    _connectionRequestsStream = _fetchConnectionRequestsStream();
    _connectedMenteeStream = _fetchConnectedMenteesStream();
  }

  Stream<Map<String, dynamic>> _fetchMentorDataStream() {
    return FirebaseFirestore.instance
        .collection('mentor')
        .doc(widget.mentorid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception('Document does not exist');
      }
    });
  }

  Stream<List<Map<String, dynamic>>> _fetchConnectionRequestsStream() {
    return FirebaseFirestore.instance
        .collection('mentor')
        .doc(widget.mentorid)
        .collection('connectionRequests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  Stream<List<Map<String, dynamic>>> _fetchConnectedMenteesStream() {
    return FirebaseFirestore.instance
        .collection('mentor')
        .doc(widget.mentorid)
        .collection('connectionRequests')
        .where('status', isEqualTo: 'connect')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(title: 'SuccesSage'),
          drawer: MyDrawer(),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SingleChildScrollView(
            child: StreamBuilder<Map<String, dynamic>>(
              stream: _mentorDataStream,
              builder: (context, mentorSnapshot) {
                if (!mentorSnapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else if (mentorSnapshot.hasError) {
                  return Center(child: Text('Error: ${mentorSnapshot.error}'));
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
                                    backgroundImage: NetworkImage(
                                        mentorSnapshot.data!['ppic']),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Text(
                                    "Welcome, ${mentorSnapshot.data!['fname']}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MentorSchedule(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 2, 48, 71),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 10,
                              ),
                              icon: Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                              ),
                              label: Text(
                                'Schedule Appointment',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Appointments",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: const Color.fromARGB(255, 2, 48, 71),
                              ),
                            ),
                            SizedBox(height: 12),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('mentor')
                                    .doc(widget.mentorid)
                                    .collection('scheduledSessions')
                                    .where('status', isEqualTo: 'booked')
                                    .snapshots(),
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
                                  } else if (snapshot.data!.docs.isEmpty) {
                                    return Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'No Upcoming appointments',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ));
                                  } else {
                                    final menteelist = snapshot.data!.docs;
                                    return VsScrollbar(
                                      style: VsScrollbarStyle(thickness: 3),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          children: menteelist.map((mentee) {
                                            final menteedata = mentee.data()
                                                as Map<String, dynamic>;
                                            return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: MenteeList(
                                                  schedulelist: menteedata,
                                                ));
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                            SizedBox(height: 15),
                            Text(
                              "Connection Requests",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: const Color.fromARGB(255, 2, 48, 71),
                              ),
                            ),
                            SizedBox(height: 10),
                            StreamBuilder<List<Map<String, dynamic>>>(
                              stream: _connectionRequestsStream,
                              builder: (context, requestsSnapshot) {
                                if (!requestsSnapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (requestsSnapshot.hasError) {
                                  return Center(
                                      child: Text(
                                          'Error: ${requestsSnapshot.error}'));
                                } else if (requestsSnapshot.data!.isEmpty) {
                                  return Center(
                                      child: Text(
                                    'No pending request',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ));
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
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: RequestOfMentee(
                                              mentee: mentee,
                                              refreshHomescreen: () {},
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: const Color.fromARGB(255, 2, 48, 71),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
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
                                      child: Text(
                                    'No connected mentee',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ));
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
                                            padding: const EdgeInsets.only(
                                                right: 10),
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
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
