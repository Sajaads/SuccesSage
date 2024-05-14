import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/material.dart';

class MentorExperienceList extends StatefulWidget {
  const MentorExperienceList({Key? key}) : super(key: key);

  @override
  State<MentorExperienceList> createState() => _MentorExperienceListState();
}

class _MentorExperienceListState extends State<MentorExperienceList> {
  late FirebaseAuth.User _user;
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.FirebaseAuth.instance.currentUser!;
  }

  Stream<List<Map<String, dynamic>>> _fetchExperienceStream() {
    return FirebaseFirestore.instance
        .collection('mentor')
        .doc(_user.uid)
        .collection('experience')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: StreamBuilder<List<Map<String,dynamic>>>(
        stream: _fetchExperienceStream(),
        builder: (BuildContext context,
        AsyncSnapshot<List<Map<String, dynamic>>> snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Center(child: Text("No Reviews available"));
          }else{
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context,index){
                  final experienceData = snapshot.data![index];
                  print(experienceData['experienc']);
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          experienceData['experience'],
                          style: TextStyle(
                              fontSize: 14,
                              color:
                              Theme.of(context).colorScheme.outline,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              experienceData['from'],
                              style: TextStyle(
                                  fontSize: 14,
                                  color:
                                  Theme.of(context).colorScheme.onBackground,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(experienceData['to'],
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
                  );
            });
          }
        },
      ),
    );
  }
}
