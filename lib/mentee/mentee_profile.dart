import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:successage/utils//suggestion_button.dart';

import '../utils/app_layouts.dart';

class MentorProfile extends StatefulWidget {
  const MentorProfile({Key? key}) : super(key: key);

  @override
  State<MentorProfile> createState() => _MentorProfileState();
}

class _MentorProfileState extends State<MentorProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(height: 3,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sajad's Profile"),
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                  decoration: BoxDecoration(
                      color: Styles.highlighedbuttonColor,
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                    image: AssetImage(
                                        "assets/virat.jpg"
                                    )
                                )
                            ),
                          ),
                          const Column(
                            children: [
                              Text("Sajad"),
                              Text("Happy to help you in"),
                              Text("volunteering fields"),
                              Row(
                                children: [
                                  Icon(Icons.star,color: Colors.orange,),
                                  Icon(Icons.star,color: Colors.orange,),
                                  Icon(Icons.star,color: Colors.orange,),
                                  Icon(Icons.star,color: Colors.orange,),
                                  Icon(Icons.star,color: Colors.orange,),
                                  SizedBox(width: 5.0,),
                                  Text("5.0")
                                ],

                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SuggestionButton(),
                          SuggestionButton(),
                          SuggestionButton(),
                        ],
                      ),
                      SuggestionButton(),
                    ],
                  ),
                ),
                SizedBox(height: 12,),
                Row(
                  children: [

                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
