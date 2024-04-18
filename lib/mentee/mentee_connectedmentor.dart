import 'package:flutter/material.dart';
import 'package:successage/mentee/mentee_connected_mentor_profile.dart';

class Menteeconnectedmentors extends StatelessWidget {
  final Map<String, dynamic> Mentor;
  final String menteeid;
  const Menteeconnectedmentors(
      {Key? key, required this.Mentor, required this.menteeid});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.grey,
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  Menteeconnectedmentorprofile(Mentor: Mentor)));
        },
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(Mentor['ppic']),
        ),
        title: Text(
          '${Mentor['fname']} ${Mentor['lname']}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${Mentor['designation']}',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
