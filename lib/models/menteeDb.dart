import 'package:cloud_firestore/cloud_firestore.dart';

class Mentee {
  final String uid;
  String? email;
  String? fname;
  String? lname;
  String? edq;
  num? phnno;
  String? ppic;
  String? bio;
  String? interest;

  Mentee(
      {required this.uid,
      this.email,
      this.fname,
      this.lname,
      this.edq,
      this.phnno,
      this.ppic,
      this.bio,
      this.interest});
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fname': fname,
      'lname': lname,
      'education': edq,
      'phone no': phnno,
      'ppic': ppic,
      'bio': bio,
      'interest': interest
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

void addMenteeinterest(String uid, {String? bio, String? interest}) {
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
      .collection('mentee')
      .doc(uid)
      .update(dataToUpdate)
      .then((value) => print("Mentee updated successfully"))
      .catchError((error) => print("Failed to update mentee: $error"));
}

void updatementeeconnection(
    String mentoruid, String menteeuid, String status) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Check if the document with menteeid exists in the collection
  bool isDocumentExists = await checkDocumentExists(
      'mentee/$menteeuid/connectionRequests', mentoruid);

  if (!isDocumentExists) {
    // Create a new document if it does not exist
    Map<String, dynamic> newRequest = {
      "mentorid": mentoruid,
      "menteeid": menteeuid,
      "status": status,
    };

    await firestore
        .collection('mentee')
        .doc(menteeuid)
        .collection('connectionRequests')
        .doc(mentoruid)
        .set(newRequest);
  } else {
    print('Document with menteeid $mentoruid already exists');
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
