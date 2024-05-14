import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MenteeMentorExperience extends StatefulWidget {
  final String mentorid;
  const MenteeMentorExperience({Key? key, required this.mentorid})
      : super(key: key);

  @override
  State<MenteeMentorExperience> createState() => _MenteeMentorExperienceState();
}

class _MenteeMentorExperienceState extends State<MenteeMentorExperience> {
  Stream<List<Map<String, dynamic>>> _fetchCommentStream() {
    if (widget.mentorid.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection('mentor')
          .doc(widget.mentorid)
          .collection('experience')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
    } else {
      // Return an empty stream if mentorid is empty or null
      return Stream.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 10),
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _fetchCommentStream(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Mentor has not provided any experience yet"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text("Mentor has not provided any experience yet"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final experienceData = snapshot.data![index];

                // Safely access the fields using the null-aware operator
                final title = experienceData['experience'] ?? 'No Title';
                final from = experienceData['from'] != null
                    ? experienceData['from']!
                    : 'No From Date';
                final to = experienceData['to'] != null
                    ? experienceData['to']!
                    : 'No To Date';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                from,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                to,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
