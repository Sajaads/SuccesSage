import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:successage/models/mentordb.dart';
import 'package:successage/utils/app_layouts.dart';

class MentorList extends StatefulWidget {
  final Map<String, dynamic> Mentor;
  const MentorList({Key? key, required this.Mentor}) : super(key: key);

  @override
  State<MentorList> createState() => _MentorListState();
}

class _MentorListState extends State<MentorList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(widget.Mentor['ppic']),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.Mentor['fname']} ${widget.Mentor['lname']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 3),
              // Add additional details if needed
            ],
          ),
        ],
      ),
    );
  }
}
