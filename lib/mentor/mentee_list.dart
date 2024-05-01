import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MenteeList extends StatefulWidget {
  final Map<String, dynamic> schedulelist;
  const MenteeList({Key? key, required this.schedulelist}) : super(key: key);

  @override
  State<MenteeList> createState() => _MenteeListState();
}

class _MenteeListState extends State<MenteeList> {
  late Future<Map<String, dynamic>> menteedata;

  @override
  void initState() {
    super.initState();
    menteedata = _fetchMenteeData();
  }

  Future<Map<String, dynamic>> _fetchMenteeData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('mentee')
          .doc(widget.schedulelist['menteeid'])
          .get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception('Mentee document does not exist');
      }
    } catch (e) {
      // Handle errors gracefully
      debugPrint("Error fetching mentee data: $e");
      rethrow; // Rethrow the error for the caller to handle
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: menteedata,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Placeholder for loading state
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, dynamic>? menteeData = snapshot.data!;
          return Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 158, 178, 175),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(menteeData['ppic']),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menteeData['fname'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.schedulelist['title']),
                    Text(DateFormat('dd-MM-yy').format(
                        (widget.schedulelist['date'] as Timestamp).toDate())),
                    Text(DateFormat('hh:mm a').format(
                        (widget.schedulelist['time'] as Timestamp).toDate())),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child:
                      IconButton(onPressed: () {}, icon: Icon(Icons.message)),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
