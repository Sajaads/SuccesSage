import 'package:flutter/material.dart';
import 'package:successage/mentee/mentee_home_screen.dart';
import 'package:successage/screen/navbar.dart';

class MenteeRegSuccess extends StatefulWidget {
  final String uid;
  String collection;
  MenteeRegSuccess({Key? key, required this.uid, required this.collection});

  @override
  State<MenteeRegSuccess> createState() => _MenteeRegSuccessState();
}

class _MenteeRegSuccessState extends State<MenteeRegSuccess> {
  void initState() {
    gotologin(context, widget.uid, widget.collection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        color: const Color(0xFF8ECAE6),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/Logo1.png'),
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                'assets/Award.png',
                height: 150,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Registration Successful',
                style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.none,
                    color: Colors.black),
                // Apply headline1 text style from Styles class
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> gotologin(BuildContext context, uid, collection) async {
  await Future.delayed(Duration(seconds: 3));
  Navigator.of(context).push(MaterialPageRoute(
      builder: (fcd) => HomeMentee(uid: uid, collection: collection)));
}
