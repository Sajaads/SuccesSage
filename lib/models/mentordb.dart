import 'package:cloud_firestore/cloud_firestore.dart';

class mentor {
  final String uid;
  String? email;
  String? fname;
  String? lname;
  String? bio;
  num? phnno;
  String? ppic;
  String? designation;
  String? interest;
  mentor(
      {required this.uid,
      this.email,
      this.fname,
      this.lname,
      this.bio,
      this.phnno,
      this.ppic,
      this.designation,
      this.interest});
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fname': fname,
      'lname': lname,
      'bio': bio,
      'phone no': phnno,
      'ppic': ppic,
      'designation': designation,
      'interest': interest
      // Add more properties as needed
    };
  }
}

void addMentorToFirestore(String uid,
    {String? email,
    String? fname,
    String? lname,
    String? bio,
    num? phnno,
    String? ppic,
    String? designation}) {
  // Initialize Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  mentor Mentor = mentor(
      uid: uid,
      email: email,
      fname: fname,
      lname: lname,
      bio: bio,
      phnno: phnno,
      ppic: ppic,
      designation: designation);

  firestore
      .collection('mentor') // Replace 'mentees' with your collection name
      .doc(Mentor.uid) // Document ID is set to the UID
      .set(Mentor.toMap())
      .then((value) => print("Mentee added successfully"))
      .catchError((error) => print("Failed to add mentee: $error"));
}

void addMentorSkill(String uid, {String? bio, String? interest}) {
  // Initialize Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, dynamic> dataToUpdate = {};
  if (bio != null) {
    dataToUpdate['bio'] = bio;
  }
  if (interest != null) {
    dataToUpdate['interest'] = interest;
  }

  firestore
      .collection('mentor')
      .doc(uid)
      .update(dataToUpdate)
      .then((value) => print("Mentee updated successfully"))
      .catchError((error) => print("Failed to update mentee: $error"));
}
