import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:successage/mentee/mentee_detail.dart';
import 'package:successage/mentee/mentee_home_screen.dart';
import 'package:successage/mentor/mentor_home_screen.dart';
import 'package:successage/mentor/mentor_personal_data.dart';
import 'package:successage/screen/auth.dart';
import 'package:successage/screen/navbar.dart';
import 'package:successage/screen/screen_mentee_info.dart';

class EmailAndPassword extends StatefulWidget {
  final String collection;
  final String loginorsignup;
  EmailAndPassword(
      {Key? key, required this.collection, required this.loginorsignup});

  @override
  _EmailAndPasswordState createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/Logo1.png',
                    scale: .5,
                  ),
                  SizedBox(height: 60),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (widget.loginorsignup == 'signup') {
                        _signUp();
                      } else {
                        _signIn();
                      }
                    },
                    child: Text(
                        widget.loginorsignup == 'signup' ? 'Signup' : 'Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Validate email and password
    if (!_isValidEmail(email) || !_isValidPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email and password.')),
      );
      return;
    }

    try {
      User? user = await auth.signUp(email, password);
      print('User signed up: $user');

      if (user != null) {
        // Navigate to the next screen after successful signup
        if (widget.collection == 'mentor') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MentorPersonalData(uid: user.uid),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ScreenSignupInfo(id: user.uid),
            ),
          );
        }
      } else {
        // Handle null UID
        print('UID is null after sign-up');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing up. Please try again.')),
        );
      }
    } catch (e) {
      // Handle any errors here
      print('Error during signup: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing up. Please try again.')),
      );
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
        .hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6; // Password should be at least 6 characters
  }

  Future<void> _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Validate email and password
    if (!_isValidEmail(email) || !_isValidPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email and password.')),
      );
      return;
    }

    try {
      User? user = await auth.signIn(email, password);
      print('User signed in: $user');

      if (user != null) {
        // Navigate to the next screen after successful signin
        if (widget.collection == 'mentor') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MentorHomeScreen(
                mentorid: user.uid,
              ),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) =>
                    HomeMentee(uid: user.uid, collection: widget.collection)),
          );
        }
      } else {
        // Handle null UID
        print('UID is null after sign-in');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing in. Please try again.')),
        );
      }
    } catch (e) {
      // Handle any errors here
      print('Error during sign-in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing in. Please try again.')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
