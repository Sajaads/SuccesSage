import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:successage/utils/app_layouts.dart';
import 'package:successage/mentor/drawer.dart';

class FirestoreService {
  final CollectionReference mentorsCollection =
      FirebaseFirestore.instance.collection('mentor');

  Future<List<ScheduledSession>> getScheduledSessions(String mentorId) async {
    try {
      QuerySnapshot querySnapshot = await mentorsCollection
          .doc(mentorId)
          .collection('scheduledSessions')
          .get();

      List<ScheduledSession> sessions = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Timestamp timestamp = data['time'] as Timestamp;
        DateTime dateTime = timestamp.toDate();
        return ScheduledSession(
          id: doc.id,
          title: data['title'],
          date: dateTime,
          time: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
          fee: data['fee'], // Retrieve fee from Firestore
        );
      }).toList();

      return sessions;
    } catch (e) {
      print('Error fetching scheduled sessions: $e');
      return [];
    }
  }

  Future<void> scheduleSession(
      String mentorId, ScheduledSession session) async {
    try {
      DateTime combinedDateTime = DateTime(
        session.date.year,
        session.date.month,
        session.date.day,
        session.time.hour,
        session.time.minute,
      );

      Timestamp timestamp = Timestamp.fromDate(combinedDateTime);

      DocumentReference docRef = await mentorsCollection
          .doc(mentorId)
          .collection('scheduledSessions')
          .add({
        'title': session.title,
        'date': session.date,
        'time': timestamp,
        'fee': session.fee,
        'status': 'available',
      });

      // Update the SID field with the document ID
      await docRef.update({'sid': docRef.id});
    } catch (e) {
      print('Error scheduling session: $e');
    }
  }

  Future<void> updateSession(
      String mentorId, String sessionId, ScheduledSession session) async {
    try {
      DateTime combinedDateTime = DateTime(
        session.date.year,
        session.date.month,
        session.date.day,
        session.time.hour,
        session.time.minute,
      );

      Timestamp timestamp = Timestamp.fromDate(combinedDateTime);

      await mentorsCollection
          .doc(mentorId)
          .collection('scheduledSessions')
          .doc(sessionId)
          .update({
        'title': session.title,
        'date': session.date,
        'time': timestamp,
        'fee': session.fee, // Update fee in Firestore
      });
    } catch (e) {
      print('Error updating session: $e');
    }
  }

  Future<void> deleteSession(String mentorId, String sessionId) async {
    try {
      await mentorsCollection
          .doc(mentorId)
          .collection('scheduledSessions')
          .doc(sessionId)
          .delete();
    } catch (e) {
      print('Error deleting session: $e');
    }
  }
}

class MentorSchedule extends StatefulWidget {
  const MentorSchedule({Key? key}) : super(key: key);

  @override
  _MentorScheduleState createState() => _MentorScheduleState();
}

class _MentorScheduleState extends State<MentorSchedule> {
  final _titleController = TextEditingController();
  final _feeController = TextEditingController(); // Controller for fee
  List<ScheduledSession> scheduledSessions = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _loadScheduledSessions();
    _checkAndDeleteExpiredSessions();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void _startTimer() {
    const Duration checkInterval = Duration(hours: 1);
    _timer = Timer.periodic(checkInterval, (timer) {
      _checkAndDeleteExpiredSessions();
    });
  }

  _checkAndDeleteExpiredSessions() async {
    try {
      final mentorId = FirebaseAuth.instance.currentUser?.uid;
      if (mentorId != null) {
        final sessions =
            await FirestoreService().getScheduledSessions(mentorId);

        final DateTime now = DateTime.now();
        final List<ScheduledSession> expiredSessions =
            sessions.where((session) => session.date.isBefore(now)).toList();

        for (final session in expiredSessions) {
          await FirestoreService().deleteSession(mentorId, session.id);
          setState(() {
            scheduledSessions.removeWhere((s) => s.id == session.id);
          });
        }
      }
    } catch (e) {
      print('Error checking and deleting expired sessions: $e');
    }
  }

  _loadScheduledSessions() async {
    final mentorId = FirebaseAuth.instance.currentUser?.uid;
    if (mentorId != null) {
      final sessions = await FirestoreService().getScheduledSessions(mentorId);
      setState(() {
        scheduledSessions = sessions;
      });
    }
  }

  void _showScheduleSessionDialog() async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (selectedDate != null && selectedDate.isAfter(now)) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (selectedTime != null) {
        final enteredTitle = _titleController.text.trim();
        final enteredFee = int.tryParse(_feeController.text.trim()) ??
            0; // Parse fee as integer

        if (enteredTitle.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enter a title for your session'),
            ),
          );
          return;
        }

        if (enteredFee < 0 || enteredFee > 1000) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fee must be between 0 and 1000'),
            ),
          );
          return;
        }

        final mentorId = FirebaseAuth.instance.currentUser?.uid;
        if (mentorId != null) {
          final session = ScheduledSession(
            id: '',
            title: enteredTitle,
            date: selectedDate,
            time: selectedTime,
            fee: enteredFee,
          );
          await FirestoreService().scheduleSession(mentorId, session);
          setState(() {
            scheduledSessions.add(session);
            _titleController.clear();
            _feeController.clear(); // Clear fee field after adding
          });
        } else {
          print('Error: Current user is null');
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a future date and time'),
        ),
      );
    }
  }

  void _editSession(int index) async {
    final session = scheduledSessions[index];
    _titleController.text = session.title;
    _feeController.text = session.fee.toString(); // Set fee controller text

    final newDate = await showDatePicker(
      context: context,
      initialDate: session.date,
      firstDate: DateTime.now(),
      lastDate: DateTime(session.date.year + 1),
    );
    if (newDate != null && newDate.isAfter(DateTime.now())) {
      final newTime = await showTimePicker(
        context: context,
        initialTime: session.time,
      );
      if (newTime != null) {
        final enteredTitle = _titleController.text.trim();
        final enteredFee = int.tryParse(_feeController.text.trim()) ??
            0; // Parse fee as integer

        if (enteredTitle.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enter a title for your session'),
            ),
          );
          return;
        }

        if (enteredFee < 0 || enteredFee > 1000) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fee must be between 0 and 1000'),
            ),
          );
          return;
        }

        final mentorId = FirebaseAuth.instance.currentUser?.uid;
        if (mentorId != null) {
          await FirestoreService().updateSession(
            mentorId,
            session.id,
            ScheduledSession(
              id: session.id,
              title: enteredTitle,
              date: newDate,
              time: newTime,
              fee: enteredFee,
            ),
          );
          setState(() {
            scheduledSessions[index].title = enteredTitle;
            scheduledSessions[index].date = newDate;
            scheduledSessions[index].time = newTime;
            scheduledSessions[index].fee = enteredFee;
            _titleController.clear();
            _feeController.clear(); // Clear title and fee fields after editing
          });
        } else {
          print('Error: Current user is null');
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a future date for your session'),
        ),
      );
    }
  }

  void _deleteSession(int index) async {
    final session = scheduledSessions[index];
    final mentorId = FirebaseAuth.instance.currentUser?.uid;
    if (mentorId != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Session'),
            content: Text('Are you sure you want to delete this session?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  FirestoreService().deleteSession(mentorId, session.id);
                  setState(() {
                    scheduledSessions.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: Text('Delete'),
              ),
            ],
          );
        },
      );
    } else {
      print('Error: Current user is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Schedule Your Sessions',onDrawerIconTap: (){Scaffold.of(context).openDrawer();},),
      drawer: MyDrawer(),
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Session Title',
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _feeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Session Fee',
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _showScheduleSessionDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 2, 48, 71),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 10,
            ),
            child: const Text(
              'Schedule Session',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scheduledSessions.length,
              itemBuilder: (context, index) {
                final session = scheduledSessions[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      session.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: ${DateFormat('yyyy-MM-dd').format(session.date)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Time: ${session.time.format(context)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Fee: \$${session.fee}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editSession(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteSession(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduledSession {
  String id;
  String title;
  DateTime date;
  TimeOfDay time;
  int fee;

  ScheduledSession({
    required this.title,
    required this.date,
    required this.time,
    required this.id,
    required this.fee,
  });
}
