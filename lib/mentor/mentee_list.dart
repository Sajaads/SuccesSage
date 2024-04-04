import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_layouts.dart';

class MenteeList extends StatefulWidget {
  const MenteeList({Key? key}) : super(key: key);

  @override
  State<MenteeList> createState() => _MenteeListState();
}

class _MenteeListState extends State<MenteeList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12,horizontal: 20),
      decoration: BoxDecoration(
          color: Styles.highlighedbuttonColor,
          borderRadius: BorderRadius.circular(12)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 70,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage(
                        "assets/messi.jpg"
                    )
                )
            ),
          ),
          Column(
            children: [
              Text("Abhinand P S"),
              Text("GD Training"),
              ElevatedButton(
                onPressed: (){},
                child: Text("6:00 - 7:00pm"),
              )
            ],
          )
        ],
      ),
    );
  }
}
