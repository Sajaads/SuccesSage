import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  final String id;
  final String text;
  final String from;
  final String to;
  final DateTime createdAt;
  final String type;

  Messages(
      {required this.id,
      required this.text,
      required this.from,
      required this.to,
      required this.createdAt,
      required this.type});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'from': from,
      'to': to,
      'createdAt': createdAt,
      'type': type
    };
  }

  static Future<void> sendMessage(Messages message) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference messagesCollection =
          FirebaseFirestore.instance.collection('messages');

      // Create a document name combining mentor and mentee UIDs
      String combinedId = '${message.from}_${message.to}';

      // Add the message to the subcollection under the combined mentor and mentee UID
      await messagesCollection.doc(combinedId).set(message.toMap());
    } catch (e) {
      // Handle errors here
      print('Error sending message: $e');
    }
  }
}
