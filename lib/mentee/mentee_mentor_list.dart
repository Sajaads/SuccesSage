import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:successage/mentee/mentee_profile.dart';
import 'package:successage/models/mentordb.dart';
import 'package:successage/utils/app_layouts.dart';

class MentorList extends StatefulWidget {
  final Map<String, dynamic> Mentor;
  final String menteeid;
  const MentorList({Key? key, required this.Mentor, required this.menteeid});

  @override
  State<MentorList> createState() => _MentorListState();
}

class _MentorListState extends State<MentorList> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MentorProfile(
                  Mentor: widget.Mentor, menteeid: widget.menteeid)));
        },
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(widget.Mentor['ppic']),
        ),
        title: Text(
          '${widget.Mentor['fname']} ${widget.Mentor['lname']}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${widget.Mentor['designation']}',
          style: TextStyle(color: Colors.grey),
        ),
        // You can add trailing widgets if needed
        // trailing: Icon(Icons.arrow_forward),
      ),
    );
  }
}
