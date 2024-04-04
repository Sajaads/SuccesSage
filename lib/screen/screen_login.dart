import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:successage/mentee/mentee_home_screen.dart';
import 'package:successage/screen/navbar.dart';

class Loginform extends StatelessWidget {
  final String role;
  Loginform({Key? key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5), // Border color
                ),
                borderRadius:
                    BorderRadius.circular(10.0), // Rounded border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: const Offset(0, 3), // Offset for shadow
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  labelText: 'Email', // Placeholder text for the email field
                  border: InputBorder.none, // No border for the text field
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20, // Horizontal padding
                    vertical: 14, // Vertical padding
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Space between text fields
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5), // Border color
                ),
                borderRadius:
                    BorderRadius.circular(10.0), // Rounded border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: const Offset(0, 3), // Offset for shadow
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  labelText:
                      'Password', // Placeholder text for the password field
                  border: InputBorder.none, // No border for the text field
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20, // Horizontal padding
                    vertical: 14, // Vertical padding
                  ),
                ),
              ),
            ),
            // ignore: prefer_const_constructors
            SizedBox(height: 20), // Space between text fields
            SignInButton(
              Buttons.google,
              text: "Login with Google",
              onPressed: () {
                signInWithGoogle(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> signInWithGoogle(BuildContext context) async {
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
            .collection(role)
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          if (role == 'mentee') {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctc) => PersistenBottomNavBarDemo(
                      uid: user.uid,
                      collection: role,
                    )));
          }
          // User does not exist in the database, add them as a mentee
          print('user exist');
          // Get user UID
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('User does not exist'),
            duration: Duration(seconds: 2),
          ));
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
