import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:successage/mentor/Mentor_oldmentee.dart';
import 'package:successage/mentor/mentee_list.dart';
import 'package:successage/mentor/request_of_mentee.dart';

import '../utils/app_layouts.dart';

class MentorHomeScreen extends StatefulWidget {
final String? uid;
final String? collection;

  const MentorHomeScreen({Key? key,required this.uid,required this.collection}) : super(key: key);

  @override
  State<MentorHomeScreen> createState() => _MentorHomeScreenState();
}

class _MentorHomeScreenState extends State<MentorHomeScreen> {
  late Future<Map<String, dynamic>> _userSnapshotFuture;
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

  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: FutureBuilder(
          future: _userSnapshotFuture,
          builder: (context,snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting)
              {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            else if (snapshot.hasError){
              return Center(
                child: Text('Error : ${snapshot.error}'),
              );
            }
            else{
              final userSnapshot = snapshot.data!;
              return ListView(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 12,),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(userSnapshot['ppic']!),
                            ),
                            SizedBox(width: 5,),
                            Text(
                                "Welcome,${userSnapshot['name']}",
                            ),
                          ],
                        ),
                        SizedBox(height: 12,),
                        Row(
                          children: [
                            Container(
                              width: 350,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0xFFF4F6FD)
                              ),
                              child: const Row(
                                children: [
                                  Icon(FluentSystemIcons.ic_fluent_search_regular,color: Color(0xFFBFC205)),
                                  Text(
                                    "Search",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12,),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                          ],
                        ),
                        SizedBox(height: 12,),
                        Row(
                          children: [
                            Text("Appointments today",style: Styles.headline1,),
                          ],
                        ),
                        SizedBox(height: 12,),
                        MenteeList(),
                        SizedBox(height: 4,),
                        MenteeList(),
                        SizedBox(height: 12,),
                        Row(
                          children: [
                            Text("Connection Requests",style: Styles.headline1,),
                          ],
                        ),
                        SizedBox(height: 10,),
                        const SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              RequestOfMentee(),
                              SizedBox(width: 10,),
                              RequestOfMentee(),
                              SizedBox(width: 10,),
                              RequestOfMentee(),
                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                        Row(
                          children: [
                            Text("My Mentees",style: Styles.headline1,),
                          ],
                        ),
                        SizedBox(height: 10,),
                        const SingleChildScrollView(
                          child: Column(
                            children: [
                              MentorOldMentee(),
                              SizedBox(height: 4,),
                              MentorOldMentee(),
                              SizedBox(height: 4,),
                              MentorOldMentee()
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
