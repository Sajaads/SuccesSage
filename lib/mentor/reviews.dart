import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Reviews extends StatefulWidget {
  const Reviews({Key? key}) : super(key: key);

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  late FirebaseAuth.User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.FirebaseAuth.instance.currentUser!;
  }

  Stream<List<Map<String, dynamic>>> _fetchCommentStream() {
    return FirebaseFirestore.instance
        .collection('mentor')
        .doc(_user.uid)
        .collection('comments')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Stream<Map<String, dynamic>> _fetchMenteeDataStream(String menteeId) {
    return FirebaseFirestore.instance
        .collection('mentee')
        .doc(menteeId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception('Document does not exist');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "REVIEWS",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
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
                  final String menteeId = commentData['menteeid'];

                  return StreamBuilder<Map<String, dynamic>>(
                    stream: _fetchMenteeDataStream(menteeId).first.asStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error fetching mentee data");
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text("Mentee data not found");
                      } else {
                        final menteeData = snapshot.data!;
                        final String name = menteeData['fname'];
                        final String ppicUrl = menteeData['ppic'];

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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(height: 12),
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(ppicUrl),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        name,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    commentData['comment'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('Rating:'),
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
                      }
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
