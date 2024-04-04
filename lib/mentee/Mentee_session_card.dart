import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_layouts.dart';

class MenteeSessionCard extends StatefulWidget {

  const MenteeSessionCard({Key? key}) : super(key: key);

  @override
  State<MenteeSessionCard> createState() => _MenteeSessionCardState();
}

class _MenteeSessionCardState extends State<MenteeSessionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      height: 70,
      width: 100,
      margin: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
      decoration: BoxDecoration(
          color: Styles.primaryColor,
          borderRadius: BorderRadius.circular(12)
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text("Resume Review"),
              Text("\u20B9 Free")
            ],
          ),
          Spacer(),
          Radio(
              value: true,
              groupValue: true,
              onChanged: (bool? value) {}
          )
        ],
      ),
    );
  }
}
