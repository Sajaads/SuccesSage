import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'as FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExperienceDialogContent extends StatefulWidget {
  @override
  _AddExperienceDialogContentState createState() =>
      _AddExperienceDialogContentState();
}

class _AddExperienceDialogContentState extends State<AddExperienceDialogContent> {
  TextEditingController _titleController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  late FirebaseAuth.User _user;
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.FirebaseAuth.instance.currentUser!;
    print(_user.uid);
  }
  Stream<Map<String, dynamic>> _fetchMenteeDataStream() {
    return FirebaseFirestore.instance
        .collection('mentor')
        .doc(_user.uid)
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
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: "Title",
            labelStyle: TextStyle(color: Colors.black), // Change label text color to black
            filled: true,
            fillColor: Color(0xFFf2fcff), // Light blue color
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
            ),
            focusedBorder: OutlineInputBorder( // Change border color when focused
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.black), // Change border color to black
            ),
          ),
        ),


        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("From:",style: TextStyle(fontSize: 16),),
            SizedBox(width: 7,),
            ElevatedButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                ).then((value) {
                  setState(() {
                    _fromDate = value;
                  });
                });
              },
              child: Text(_fromDate != null
                  ? DateFormat.yMMMd().format(_fromDate!)
                  : "Select date"),
            ),
          ],
        ),

        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("To:",style: TextStyle(fontSize: 16),),
            ElevatedButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                ).then((value) {
                  setState(() {
                    _toDate = value;
                  });
                });
              },
              child: Text(_toDate != null
                  ? DateFormat.yMMMd().format(_toDate!)
                  : "Select date"),
            ),
          ],
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Save the data to Firestore
            if (_titleController.text.isNotEmpty &&
                _fromDate != null &&
                _toDate != null) {
              addExperience();
              Navigator.of(context).pop();
            } else {
              // Show an error message if any of the fields are empty
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Please fill in all fields"),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black, backgroundColor: Color(0xFF00B2E7), // Text color
          ),
          child: Text(
            "Save",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

      ],
    );
  }
  void addExperience() async{
    String title = _titleController.text;
    String toDate = DateFormat.yMMMd().format(_toDate!);
    String fromDate = DateFormat.yMMMd().format(_fromDate!);
    await FirebaseFirestore.instance.collection('mentor').doc(_user.uid).collection('experience').add({
      'experience': title,
      'to': toDate,
      'from': fromDate,
    });
  }
}