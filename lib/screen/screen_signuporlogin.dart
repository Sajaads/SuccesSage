import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:successage/models/menteeDb.dart';
import 'package:successage/models/mentordb.dart';
import 'package:successage/screen/navbar.dart';
import 'package:successage/screen/screen_mentee_info.dart';

class ScreenRole extends StatelessWidget {
  final String collection;
  const ScreenRole({Key? key, required this.collection});

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
                signInWithGoogle(collection, context);
              },
            ),
            SizedBox(height: 20),
            SignInButton(
              Buttons.googleDark,
              text: "Login with Google",
              onPressed: () {
                LoginWithGoogle(collection, context);
              },
            )
          ],
        ),
      ),
    );
  }
}

Future<dynamic> signInWithGoogle(
    String collection, BuildContext context) async {
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
        await auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      // Check if the user exists in the database
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(user.uid)
          .get();

      if (!userSnapshot.exists) {
        // User does not exist in the database, add them as a mentee
        String uid = user.uid; // Get user UID
        if (collection == "mentor") {
          addMentorToFirestore(uid);
        } else {
          addMenteeToFirestore(uid);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScreenSignupInfo(id: uid)),
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

Future<dynamic> LoginWithGoogle(collection, BuildContext context) async {
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
        await auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      // Check if the user exists in the database
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(user.uid)
          .get();

      if (userSnapshot.exists) {
        if (collection == 'mentee') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctc) => PersistenBottomNavBarDemo(
                    uid: user.uid,
                    collection: collection,
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
