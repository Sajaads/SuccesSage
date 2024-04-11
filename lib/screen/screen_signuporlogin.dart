import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:successage/mentor/mentor_home_screen.dart';
import 'package:successage/mentor/mentor_personal_data.dart';
import 'package:successage/models/menteeDb.dart';
import 'package:successage/models/mentordb.dart';
import 'package:successage/screen/navbar.dart';
import 'package:successage/screen/screen_mentee_info.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/Logo1.png",
              height: 100, // Adjust image height as needed
            ),
            SizedBox(height: 20),
            Text(
              'something',
              style: TextStyle(
                fontSize: 30, // Larger font size
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
            SizedBox(height: 20),
            SignInButton(
              Buttons.google,
              text: "SignUp with Google",
              onPressed: () {
                signInWithGoogle(widget.collection);
              },
            ),
            SizedBox(height: 20),
            SignInButton(
              Buttons.googleDark,
              text: "Login with Google",
              onPressed: () {
                LoginWithGoogle(widget.collection);
              },
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

  Future<dynamic> signInWithGoogle(String collection) async {
    setState(() {
      _signInFuture = _performSignIn(collection);
    });
    return _signInFuture;
  }

  Future<dynamic> LoginWithGoogle(String collection) async {
    setState(() {
      _loginFuture = _performLogin(collection);
    });
    return _loginFuture;
  }

  Future<dynamic> _performSignIn(String collection) async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      FirebaseAuth auth = FirebaseAuth.instance;
      if (FirebaseAuth.instance.currentUser != null) {
        await auth.signOut();
        await googleSignIn.signOut();
      }

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection(collection)
            .doc(user.uid)
            .get();
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;
        dynamic value = userData?['fname'];

        if (!userSnapshot.exists || value == null) {
          String uid = user.uid;
          if (collection == "mentor") {
            addMentorToFirestore(uid);
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => MentorPersonalData(uid: uid))));
          } else {
            addMenteeToFirestore(uid);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScreenSignupInfo(id: uid)),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User Already exists'),
              duration: Duration(seconds: 4),
            ),
          );
        }
      }

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      print('Exception during sign-in: $e');
      return null;
    }
  }

  Future<dynamic> _performLogin(String collection) async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      FirebaseAuth auth = FirebaseAuth.instance;
      if (FirebaseAuth.instance.currentUser != null) {
        await auth.signOut();
        await googleSignIn.signOut();
      }

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection(collection)
            .doc(user.uid)
            .get();
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;
        dynamic value = userData?['fname'];

        switch (userSnapshot.exists && value != null) {
          case true:
            switch (collection == "mentee") {
              case true:
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctc) => PersistenBottomNavBarDemo(
                          uid: user.uid,
                          collection: collection,
                        )));
              case false:
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MentorHomeScreen()));
            }

          case false:
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('User does not exist'),
              duration: Duration(seconds: 2),
            ));
        }
      }

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      print('Exception during sign-in: $e');
      return null;
    }
  }
}
