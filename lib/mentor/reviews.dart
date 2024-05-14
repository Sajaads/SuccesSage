import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'as FirebaseAuth;
import 'package:flutter/material.dart';

class Reviews extends StatefulWidget {
  const Reviews({Key? key}) : super(key: key);

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  late FirebaseAuth.User _user;
  late double rate=0.0;
  int n=1;

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews.."),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 9,horizontal: 10),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _fetchCommentStream(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Center(child: Text("No Reviews available"));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final commentData = snapshot.data![index];
                  print(commentData['comment']);
                  print(commentData['rating']);
                  if (commentData['rating'] is num) {
                    rate += commentData['rating'] as double;
                  }
                  print(rate);

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
                                  commentData['menteeid'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      color:
                                      Theme.of(context).colorScheme.outline,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  commentData['comment'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      color:
                                      Theme.of(context).colorScheme.onBackground,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(commentData['rating'].toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color:
                                      Theme.of(context).colorScheme.onBackground,
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
      ),
    );
  }
}
