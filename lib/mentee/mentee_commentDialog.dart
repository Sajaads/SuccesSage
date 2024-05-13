import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentDialog extends StatefulWidget {
  final String mentorid;
  final String menteeid;
  CommentDialog({Key? key, required this.mentorid, required this.menteeid,});
  @override
  _CommentDialogState createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  late Stream<Map<String, dynamic>> _user;
  late Map<String,dynamic> _userData;

  Stream<Map<String, dynamic>> _fetchMenteeDataStream() {
    return FirebaseFirestore.instance
        .collection('mentee')
        .doc(widget.menteeid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception('Document does not exist');
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = _fetchMenteeDataStream();
    _user.listen((userdata){
      setState(() {
        _userData=userdata;
      });
    });
  }


  TextEditingController _commentController = TextEditingController();
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Comment and Rating'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _commentController,
            decoration: InputDecoration(labelText: 'Comment'),
          ),
          SizedBox(height: 10),
          Text('Rating'),
          Slider(
            value: _rating,
            min: 0,
            max: 5,
            divisions: 5,
            onChanged: (value) {
              setState(() {
                _rating = value;
              });
            },
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Save the comment and rating to Firestore
            _saveCommentAndRating();
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  void _saveCommentAndRating() async {
    String comment = _commentController.text;
    double rating = _rating;

    // Add the comment and rating to Firestore
    await FirebaseFirestore.instance.collection('mentor').doc(widget.mentorid).collection('comments').add({
      'menteeid' : widget.menteeid,
      'name' : _userData['fname'],
      'comment': comment,
      'rating': rating,
      'timestamp': Timestamp.now(),
    });

    // Clear the text field and reset the rating
    _commentController.clear();
    setState(() {
      _rating = 0.0;
    });
  }
}
