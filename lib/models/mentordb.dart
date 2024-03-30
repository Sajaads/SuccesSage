import 'package:cloud_firestore/cloud_firestore.dart';

class mentor {
  final String uid;
  String? email;
  String? fname;
  String? lname;
  String? bio;
  num? phnno;

  mentor(
      {required this.uid,
      this.email,
      this.fname,
      this.lname,
      this.bio,
      this.phnno});
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fname': fname,
      'lname': lname,
      'bio': bio,
      'phone no': phnno
      // Add more properties as needed
    };
  }
}

void addMentorToFirestore(String uid,
    {String? email, String? fname, String? lname, String? bio, num? phnno}) {
  // Initialize Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  mentor Mentor = mentor(
      uid: uid,
      email: email,
      fname: fname,
      lname: lname,
      bio: bio,
      phnno: phnno);

  firestore
      .collection('mentor') // Replace 'mentees' with your collection name
      .doc(Mentor.uid) // Document ID is set to the UID
      .set(Mentor.toMap())
      .then((value) => print("Mentee added successfully"))
      .catchError((error) => print("Failed to add mentee: $error"));
}
