import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:successage/mentor/Mentor_oldmentee.dart';
import 'package:successage/mentor/mentee_list.dart';
import 'package:successage/mentor/request_of_mentee.dart';

import '../utils/app_layouts.dart';

class MentorHomeScreen extends StatelessWidget {
  const MentorHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: AssetImage("assets/person_logo.jpg"))),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Welcome,Nikhil"),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFFF4F6FD)),
                        child: Row(
                          children: [
                            Icon(FluentSystemIcons.ic_fluent_search_regular,
                                color: Color(0xFFBFC205)),
                            Text(
                              "Search",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Text(
                      "Appointments today",
                      style: Styles.headline1,
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                MenteeList(),
                SizedBox(
                  height: 4,
                ),
                MenteeList(),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Text(
                      "Connection Requests",
                      style: Styles.headline1,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      RequestOfMentee(),
                      SizedBox(
                        width: 10,
                      ),
                      RequestOfMentee(),
                      SizedBox(
                        width: 10,
                      ),
                      RequestOfMentee(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      "My Mentees",
                      style: Styles.headline1,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      MentorOldMentee(),
                      SizedBox(
                        height: 4,
                      ),
                      MentorOldMentee(),
                      SizedBox(
                        height: 4,
                      ),
                      MentorOldMentee()
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
