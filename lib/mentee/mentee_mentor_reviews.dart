import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MenteeMentorReviews extends StatefulWidget {
  final String mentorid;
  const MenteeMentorReviews({Key? key, required this.mentorid})
      : super(key: key);

  @override
  State<MenteeMentorReviews> createState() => _MenteeMentorReviewsState();
}

class _MenteeMentorReviewsState extends State<MenteeMentorReviews> {
  late FirebaseAuth.User _user;

  Stream<List<Map<String, dynamic>>> _fetchCommentStream() {
    if (widget.mentorid.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection('mentor')
          .doc(widget.mentorid)
          .collection('comments')
          .snapshots()
          .asyncMap((snapshot) async {
        List<Map<String, dynamic>> comments = [];
        for (var doc in snapshot.docs) {
          var commentData = doc.data();
          String menteeId = commentData['menteeid'];
          // Fetch mentee data
          var menteeSnapshot = await FirebaseFirestore.instance
              .collection('mentee')
              .doc(menteeId)
              .get();
          if (menteeSnapshot.exists) {
            var menteeData = menteeSnapshot.data()!;
            // Add profile pic URL to comment data
            commentData['ppic'] = menteeData['ppic'];
          }
          comments.add(commentData);
        }
        return comments;
      });
    } else {
      // Return an empty stream if mentorid is empty or null
      return Stream.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.mentorid);
    print("object");
    return Container(
      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 10),
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _fetchCommentStream(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text("No Reviews available"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No Reviews available"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final commentData = snapshot.data![index];

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
                                commentData['name'],
                                style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(commentData['ppic']),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: Text(
                              commentData['comment'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                commentData['rating'].toString(),
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
