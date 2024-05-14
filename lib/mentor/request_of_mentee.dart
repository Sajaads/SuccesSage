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

  Future<void> _menteeconnectedmentors() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Define the document path
    String mentorUid = widget.mentee['mentorid'];
    String menteeUid = widget.mentee['menteeid'];
    String status = 'connect';

    // Check if the connection already exists
    bool isConnectionExists = await checkDocumentExists(
        'mentee/$menteeUid/connectedMentors', mentorUid);

    if (!isConnectionExists) {
      // Create a new connection request document
      Map<String, dynamic> newRequest = {
        "mentorid": mentorUid,
        "menteeid": menteeUid,
        "status": status,
      };

      await firestore
          .collection('mentee')
          .doc(menteeUid)
          .collection('connectedMentors')
          .doc(mentorUid)
          .set(newRequest)
          .then((_) {
        print("Document updated successfully");
      }).catchError((error) {
        print("Error updating document: $error");
      });
    } else {
      print('Connection already exists');
    }
  }

  Future<bool> checkDocumentExists(
      String collectionPath, String documentId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get the document snapshot
    DocumentSnapshot documentSnapshot =
        await firestore.collection(collectionPath).doc(documentId).get();

    // Check if the document exists
    return documentSnapshot.exists;
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
            color: Color.fromARGB(255, 255, 255, 255),
            elevation: 2,
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
                          _menteeconnectedmentors();
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
                        icon: Icon(Icons.dangerous_outlined),
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
