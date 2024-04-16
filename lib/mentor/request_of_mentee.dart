import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:successage/utils/app_layouts.dart';

class RequestOfMentee extends StatefulWidget {
  final Map<String, dynamic> mentee;
  final VoidCallback refreshHomescreen;

  const RequestOfMentee({
    Key? key,
    required this.mentee,
    required this.refreshHomescreen,
  }) : super(key: key);

  @override
  State<RequestOfMentee> createState() => _RequestOfMenteeState();
}

class _RequestOfMenteeState extends State<RequestOfMentee> {
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

  Future<DocumentReference<Map<String, dynamic>>> _menteedataupdate() async {
    DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore.instance
        .collection('mentor')
        .doc(widget.mentee['mentorid'])
        .collection('connectionRequests')
        .doc(widget.mentee['menteeid']);
    return docRef;
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

          return Card(
            color: Color.fromARGB(115, 153, 227, 246),
            elevation: 7,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(menteeData['ppic']),
                    radius: 40,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Name : ${menteeData['fname']} ${menteeData['lname']}"),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Bio : ${menteeData['bio']}"),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Education : ${menteeData['education']}"),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Interest : ${menteeData['interest']}"),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          DocumentReference<Map<String, dynamic>> docRef =
                              await _menteedataupdate();
                          docRef.update({
                            'status': "connect",
                          }).then((_) {
                            print("Document updated successfully");
                            setState(() {
                              // Refresh the widget
                              widget.refreshHomescreen();
                            });
                          }).catchError((error) {
                            print("Error updating document: $error");
                          });
                        },
                        icon: Icon(Icons.favorite),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
