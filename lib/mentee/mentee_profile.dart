import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:successage/mentee/Mentee_Mentor_experience.dart';
import 'package:successage/utils//suggestion_button.dart';

import '../utils/app_layouts.dart';

class MentorProfile extends StatefulWidget {
  final Map<String, dynamic> Mentor;
  MentorProfile({Key? key, required this.Mentor});

  @override
  State<MentorProfile> createState() => _MentorProfileState();
}

class _MentorProfileState extends State<MentorProfile> {
  bool showConnectionButton = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                    image:
                                        NetworkImage(widget.Mentor['ppic']))),
                          ),
                          Column(
                            children: [
                              Text('${widget.Mentor['fname']}',
                                  style: Styles.ProfileName),
                              Text(
                                "Happy to help you in",
                                style: Styles.headline2,
                              ),
                              Text(
                                "volunteering fields",
                                style: Styles.headline2,
                              ),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  ),
                                  Icon(
                                    Icons.star_half,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text("5.0")
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (showConnectionButton)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showConnectionButton = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white),
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
                              Text("Connect")
                            ],
                          ),
                        ),
                      if (!showConnectionButton)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue),
                              child: Text("Message"),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Color(0xF45F84F4)),
                              child: Text("Book Session"),
                            ),
                          ],
                        )
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
