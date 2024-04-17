import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:successage/mentee/Mentee_Mentor_experience.dart';
import 'package:successage/models/menteeDb.dart';
import 'package:successage/models/mentordb.dart';
import 'package:successage/utils//suggestion_button.dart';

import '../utils/app_layouts.dart';

class MentorProfile extends StatefulWidget {
  final Map<String, dynamic> Mentor;
  final String menteeid;
  MentorProfile({Key? key, required this.Mentor, required this.menteeid});

  @override
  State<MentorProfile> createState() => _MentorProfileState();
}

class _MentorProfileState extends State<MentorProfile> {
  String connectionStatus = 'Connect';
  Color buttonColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                      color: Styles.cardColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                NetworkImage(widget.Mentor['ppic']),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              Text(
                                  '${widget.Mentor['fname']} ${widget.Mentor['lname']}',
                                  style: Styles.ProfileName),
                              Text('${widget.Mentor['designation']}',
                                  style: TextStyle(color: Colors.grey)),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                '${widget.Mentor['bio']}',
                                style: Styles.headline2,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          sendRequestToMentor(
                              widget.Mentor['uid'], widget.menteeid, "pending");
                          updatementeeconnection(
                              widget.Mentor['uid'], widget.menteeid, "pending");
                          setState(() {
                            connectionStatus = 'Pending';
                            buttonColor = Colors.orange;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                            backgroundColor: buttonColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.group_add,
                              color: Colors.orange,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(connectionStatus)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: AssetImage("assets/linkedIn.png"))),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: AssetImage("assets/fb.png"))),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Column(
                    children: [
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(
                              tabs: [
                                Tab(
                                  child: Text(
                                    "Experience 1",
                                    style: Styles.headline2,
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "Experience 2",
                                    style: Styles.headline2,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height:
                                  700, // Adjust the height of TabBarView as needed
                              child: TabBarView(
                                children: [
                                  // Content for the first tab "Experience 1"
                                  const SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        MenteeMentorExperience(),
                                        MenteeMentorExperience(),
                                        MenteeMentorExperience(),
                                        MenteeMentorExperience(),
                                        MenteeMentorExperience(),
                                        MenteeMentorExperience(),
                                      ],
                                    ),
                                  ),

                                  // Content for the second tab "Experience 2"
                                  Text("Reviews...")
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
