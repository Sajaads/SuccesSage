import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:successage/mentee/mentee_higlighted_mentor.dart';
import 'package:successage/mentee/mentee_mentor_list.dart';
import 'package:successage/mentee/mentee_profile.dart';
import 'package:successage/utils/suggestion_button.dart';
import 'package:successage/utils/app_info_list.dart';

class HomeMentee extends StatelessWidget {
  const HomeMentee({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
            child: Column(
              children: <Widget>[
                SizedBox(height: 12,),
                Row(
                  children: [Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: AssetImage(
                                "assets/person_logo.jpg"
                            )
                        )

                    ),
                  ),
                    SizedBox(width: 5,),
                    Text("Welcome,Abhinav"),


                  ],
                ),
                SizedBox(height: 12,),
                Row(
                  children: [
                    Text("Let's find great mentors")
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
                    SuggestionButton(),
                    SuggestionButton(),
                    SuggestionButton(),
                  ],
                ),
                SizedBox(height: 12,),
                Row(
                  children: [
                    Text("Mentors in your field")
                  ],
                ),
                SizedBox(height: 15,),
                Column(
                  children: [HighlightedMentee(Mentor: mentorList.first)],
                ),
                SizedBox(height: 12,),
                Row(
                  children: [
                    Text("All Mentors"),
                  ],
                ),
                SizedBox(height: 15,),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                      children: mentorList.map((singleMentor) => GestureDetector(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => MentorProfile()));
                        },
                          child: MentorList(Mentor: singleMentor))).toList()
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
