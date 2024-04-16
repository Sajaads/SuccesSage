import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

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
  String? menteeid;
  String? status;
  mentor(
      {required this.uid,
      this.email,
      this.fname,
      this.lname,
      this.bio,
      this.phnno,
      this.ppic,
      this.designation,
      this.interest,
      this.menteeid,
      this.status});
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

void sendRequestToMentor(
    String mentoruid, String menteeuid, String status) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Check if the document with menteeid exists in the collection
  bool isDocumentExists = await checkDocumentExists(
      'mentor/$mentoruid/connectionRequests', menteeuid);

  if (!isDocumentExists) {
    // Create a new document if it does not exist
    Map<String, dynamic> newRequest = {
      "mentorid": mentoruid,
      "menteeid": menteeuid,
      "status": status,
    };

    await firestore
        .collection('mentor')
        .doc(mentoruid)
        .collection('connectionRequests')
        .doc(menteeuid)
        .set(newRequest);
  } else {
    print('Document with menteeid $menteeuid already exists');
  }
}

Future<bool> checkDocumentExists(
    String collectionPath, String documentId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Get the document snapshot
  DocumentSnapshot documentSnapshot =
      await firestore.collection(collectionPath).doc(documentId).get();

  // Check if the document exists
  return documentSnapshot.exists;
}
