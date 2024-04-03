import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MentorOldMentee extends StatefulWidget {
  const MentorOldMentee({Key? key}) : super(key: key);

  @override
  State<MentorOldMentee> createState() => _MentorOldMenteeState();
}

class _MentorOldMenteeState extends State<MentorOldMentee> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage(
                        "assets/ronaldo.jpg"
                    )
                )
            ),
          ),
          Text("Sahil Sadar"),
          Icon(Icons.message,color: Colors.black,)
        ],
      ),
    );
  }
}
