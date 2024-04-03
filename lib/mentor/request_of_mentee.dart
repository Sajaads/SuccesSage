import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:successage/utils/app_layouts.dart';

class RequestOfMentee extends StatefulWidget {
  const RequestOfMentee({Key? key}) : super(key: key);

  @override
  State<RequestOfMentee> createState() => _RequestOfMenteeState();
}

class _RequestOfMenteeState extends State<RequestOfMentee> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Styles.highlighedbuttonColor,

      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage(
                        "assets/neymar.jpg"
                    )
                )
            ),
          ),
          Text("Sanet"),
          Row(
            children: [
              Icon(Icons.check,color: Colors.orange,),
              Icon(Icons.close,color: Colors.orange,),
            ],
          )
        ],
      ),
    );
  }
}
