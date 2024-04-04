import 'package:cloud_firestore/cloud_firestore.dart';

class Mentee {
  final String uid;
  String? email;
  String? fname;
  String? lname;
  String? edq;
  num? phnno;
  String? ppic;

  Mentee(
      {required this.uid,
      this.email,
      this.fname,
      this.lname,
      this.edq,
      this.phnno,
      this.ppic});
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fname': fname,
      'lname': lname,
      'education': edq,
      'phone no': phnno,
      'ppic': ppic
      // Add more properties as needed
    };
  }
}

void addMenteeToFirestore(String uid,
    {String? email,
    String? fname,
    String? lname,
    String? edq,
    num? phnno,
    String? ppic}) {
  // Initialize Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Mentee mentee = Mentee(
      uid: uid,
      email: email,
      fname: fname,
      lname: lname,
      edq: edq,
      phnno: phnno,
      ppic: ppic);

  firestore
      .collection('mentee') // Replace 'mentees' with your collection name
      .doc(mentee.uid) // Document ID is set to the UID
      .set(mentee.toMap())
      .then((value) => print("Mentee added successfully"))
      .catchError((error) => print("Failed to add mentee: $error"));
}
