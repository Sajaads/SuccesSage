import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:successage/utils/app_layouts.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class Menteeconnectedmentorprofile extends StatelessWidget {
  final Map<String, dynamic> Mentor;
  const Menteeconnectedmentorprofile({Key? key, required this.Mentor});

  Future<QuerySnapshot> _fetchmentorschedule() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('mentor')
        .doc(Mentor['uid'])
        .collection('scheduledSessions')
        .get();
    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.amber[50],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(Mentor['ppic']),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${Mentor['fname']} ${Mentor['lname']}',
                                style: Styles.ProfileName),
                            Text('${Mentor['designation']}',
                                style: TextStyle(color: Colors.grey)),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '${Mentor['bio']}',
                              style: Styles.headline2,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 2, 48, 71),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 80,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 3,
                              ),
                              child: Text(
                                'Message',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Mentor Schedules',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                  future: _fetchmentorschedule(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'There are no scheduled sessions available at the moment.',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else {
                      final mentors = snapshot.data!.docs;
                      return VsScrollbar(
                        style: VsScrollbarStyle(thickness: 3),
                        child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(10),
                          children: mentors.map((mentor) {
                            return Card(
                              child: ListTile(
                                onTap: () {},
                                title: Text(
                                  mentor['title'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(DateFormat('dd-MM-yy').format(
                                    (mentor['date'] as Timestamp).toDate())),
                                trailing: Text(DateFormat('hh:mm a').format(
                                    (mentor['time'] as Timestamp).toDate())),
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
