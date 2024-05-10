import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectionRequest {
  final String requestId;
  final String mentorId;
  final String menteeId;
  final String status;

  ConnectionRequest({
    required this.requestId,
    required this.mentorId,
    required this.menteeId,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'mentorId': mentorId,
      'menteeId': menteeId,
      'status': status,
    };
  }
}

void addConnectionRequestToFirestore(
    String requestId, String mentorId, String menteeId, String status) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  ConnectionRequest request = ConnectionRequest(
    requestId: requestId,
    mentorId: mentorId,
    menteeId: menteeId,
    status: status,
  );

  firestore
      .collection('connection_requests')
      .doc(request.requestId)
      .set(request.toMap())
      .then((value) => print("Connection request added successfully"))
      .catchError((error) => print("Failed to add connection request: $error"));
}
