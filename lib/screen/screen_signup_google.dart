import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:successage/models/mentordb.dart';
import 'package:successage/screen/screen_mentee_info.dart';
import 'package:successage/models/menteeDb.dart';

class ScreenLoginForm extends StatefulWidget {
  final String collection;
  const ScreenLoginForm({Key? key, required this.collection}) : super(key: key);

  @override
  State<ScreenLoginForm> createState() => _ScreenLoginFormState();
}

class _ScreenLoginFormState extends State<ScreenLoginForm> {
  ValueNotifier userCredential = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/Logo 1.png",
            ),
            const SizedBox(
              height: 70,
            ),
            Container(
              child: Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      onPressed: () {
                        signInWithGoogle();
                        //_checkUserExistence();
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          elevation: 10 // Adjust as needed
                          ),
                      child: Row(
                        children: [
                          Image.asset('assets/google.png'),
                          SizedBox(
                            width: 20,
                          ),
                          Text('Sign in with google')
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      FirebaseAuth auth = FirebaseAuth.instance;
      if (FirebaseAuth.instance.currentUser != null) {
        // If a user is already signed in, sign them out first
        await auth.signOut();
        await googleSignIn.signOut();
      }

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Check if the user exists in the database
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection(widget.collection)
            .doc(user.uid)
            .get();

        if (!userSnapshot.exists) {
          // User does not exist in the database, add them as a mentee
          String uid = user.uid; // Get user UID
          if (widget.collection == "mentor") {
            addMentorToFirestore(uid);
          } else {
            addMenteeToFirestore(uid);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScreenSignupInfo(id: uid)),
            );
          }
        } else {
          // User already exists in the database, show a message
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
      // Handle exceptions
      print('Exception during sign-in: $e');
      return null;
    }
  }

  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
}
