import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:successage/mentee/Mentee_Mentor_experience.dart';
import 'package:successage/mentee/mentee_mentor_reviews.dart';
import 'package:successage/models/mentordb.dart';

class MentorProfile extends StatefulWidget {
  final Map<String, dynamic> Mentor;
  final String menteeid;
  MentorProfile({Key? key, required this.Mentor, required this.menteeid});

  @override
  State<MentorProfile> createState() => _MentorProfileState();
}

class _MentorProfileState extends State<MentorProfile> {
  String connectionStatus = 'Connect';
  Color buttonColor = Color.fromARGB(255, 23, 209, 70);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.Mentor['ppic']),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.Mentor['fname']} ${widget.Mentor['lname']}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.Mentor['designation'],
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                '${widget.Mentor['bio']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      sendRequestToMentor(
                          widget.Mentor['uid'], widget.menteeid, "pending");

                      setState(() {
                        connectionStatus = 'Pending';
                        buttonColor = Colors.orange;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: Text(
                      connectionStatus,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              DefaultTabController(
                length: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: 'Experience 1'),
                        Tab(text: 'Reviews'),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 400,
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                6,
                                (index) => MenteeMentorExperience(),
                              ),
                            ),
                          ),
                          MenteeMentorReviews(mentorid: widget.Mentor['uid']),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
