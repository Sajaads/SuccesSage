import 'package:flutter/material.dart';

class MenteeMentorExperience extends StatefulWidget {
  const MenteeMentorExperience({Key? key}) : super(key: key);

  @override
  State<MenteeMentorExperience> createState() => _MenteeMentorExperienceState();
}

class _MenteeMentorExperienceState extends State<MenteeMentorExperience> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            height: 50,
            width: 100,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage(
                        "assets/IEEE-symbol.jpg"
                    )
                )
            ),
          ),
          SizedBox(width: 10,),
          Column(
            children: [
              Text("Student Branch Chairperson"),
              Text("2020-present"),
              Text("Conductrd 20+ IEEE flagships"),
            ],
          )
        ],
      ),
    );
  }
}
