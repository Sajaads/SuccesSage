import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:successage/utils/app_layouts.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

import 'mentee_commentDialog.dart';

class Menteeconnectedmentorprofile extends StatelessWidget {
  final Map<String, dynamic> Mentor;
  final String menteeid;
  const Menteeconnectedmentorprofile(
      {Key? key, required this.Mentor, required this.menteeid});

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
                            ),
                            ElevatedButton(onPressed: (){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CommentDialog(mentorid:Mentor['uid'],menteeid:menteeid,);
                                },
                              );

                            }, child: Text("Add Reviews")),
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
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('mentor')
                      .doc(Mentor['uid'])
                      .collection('scheduledSessions')
                      .where('status', isEqualTo: 'available')
                      .snapshots(),
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
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No available sessions at the moment'),
                      ));
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
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        elevation: 4,
                                        title: Text(
                                          'Confirm Booking?',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    'Title : ${mentor['title']}',
                                                    textAlign: TextAlign.start),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    'Date : ${DateFormat('dd-MM-yy').format((mentor['date'] as Timestamp).toDate())}',
                                                    textAlign: TextAlign.start),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    'Time : ${DateFormat('hh:mm a').format((mentor['time'] as Timestamp).toDate())}',
                                                    textAlign: TextAlign.start),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('No'),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Yes'),
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('mentor')
                                                  .doc(Mentor['uid'])
                                                  .collection(
                                                      'scheduledSessions')
                                                  .doc(mentor.id)
                                                  .update({
                                                'status': 'booked',
                                                'menteeid': menteeid
                                              }).then((_) {
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 25, 137, 25),
                                                    content: Text(
                                                      'Booking Successful',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    duration: Duration(
                                                        seconds:
                                                            3), // Duration to show the snackbar
                                                  ),
                                                );
                                              }).catchError((error) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Error booking session: $error'),
                                                    duration: Duration(
                                                        seconds:
                                                            2), // Duration to show the snackbar
                                                  ),
                                                );
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
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
