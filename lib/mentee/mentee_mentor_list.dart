import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MentorList extends StatefulWidget {
  final Map<String,dynamic> Mentor;
  const MentorList({Key? key,required this.Mentor}) : super(key: key);

  @override
  State<MentorList> createState() => _MentorListState();
}

class _MentorListState extends State<MentorList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage(
                        "assets/virat.jpg"

                    )
                )
            ),
          ),
          Column(
            children: [
              Text(widget.Mentor['name']),
              SizedBox(height: 3,),
              Text(widget.Mentor['title']),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.blue, // Border color
                width: 2, // Border width
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.star,color: Colors.orange,),
                Text(widget.Mentor['rating'].toString())
              ],
            ),
          )
        ],
      ),
    );
  }
}
