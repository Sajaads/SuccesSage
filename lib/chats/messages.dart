import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  final String id;
  final String text;
  final String authorId;
  final DateTime createdAt;

  Messages({
    required this.id,
    required this.text,
    required this.authorId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'authorId': authorId,
      'createdAt': createdAt,
    };
  }
}

