import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:successage/mentor/mentor_home_screen.dart';
import 'package:successage/mentor/mentor_personal_data.dart';
import 'package:successage/models/menteeDb.dart';
import 'package:successage/models/mentordb.dart';
import 'package:successage/screen/emailandpassword.dart';
import 'package:successage/screen/navbar.dart';
import 'package:successage/screen/screen_mentee_info.dart';
import 'package:successage/screen/auth.dart';

class ScreenRole extends StatefulWidget {
  final String collection;
  const ScreenRole({Key? key, required this.collection});

  @override
  _ScreenRoleState createState() => _ScreenRoleState();
}

class _ScreenRoleState extends State<ScreenRole> {
  late Future<dynamic> _signInFuture;
  late Future<dynamic> _loginFuture;

  @override
  void initState() {
    super.initState();
    _signInFuture = Future.value(null);
    _loginFuture = Future.value(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/Logo1.png",
              scale: 1.5, // Adjust image height as needed
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Mentorship is a shared journey where success is not just about reaching the destination, but about empowering others along the way',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(43, 44, 141, 0.882),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => EmailAndPassword(
                          collection: widget.collection,
                          loginorsignup: "signup",
                        ))));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(
                      255, 255, 255, 255), // Stylish button color
                  padding: EdgeInsets.symmetric(
                      horizontal: 80, vertical: 16), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Rounded button corners
                  ),
                  elevation: 10),
              child: Text(
                "Signup",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => EmailAndPassword(
                          collection: widget.collection,
                          loginorsignup: "login",
                        ))));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 2, 48, 71), // Stylish button color
                  padding: EdgeInsets.symmetric(
                      horizontal: 80, vertical: 16), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Rounded button corners
                  ),
                  elevation: 10),
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder(
              future: _signInFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  return SizedBox();
                }
              },
            ),
            FutureBuilder(
              future: _loginFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  return SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
