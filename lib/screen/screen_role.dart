import 'package:flutter/material.dart';
import 'package:successage/screen/screen_login.dart';
import 'package:successage/screen/screen_loginorsignup.dart';
import 'package:successage/screen/screen_signup_google.dart';

class ScreenRole extends StatelessWidget {
  final bool toggle;
  const ScreenRole({Key? key, required this.toggle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/Logo 1.png",
              height: 100, // Adjust image height as needed
            ),
            SizedBox(height: 20),
            Text(
              'Choose Role',
              style: TextStyle(
                fontSize: 30, // Larger font size
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (toggle) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => Loginform(
                            role: 'mentor',
                          ))));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => ScreenLoginForm(
                            collection: "mentor",
                          ))));
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 47, 38, 94),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 80, vertical: 16), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Rounded button corners
                  ),
                  elevation: 10),
              child: const Text(
                'Mentor',
                style: TextStyle(
                  color: Colors.white, // White text color
                  fontSize: 16, // Font size
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (toggle) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => Loginform(
                            role: 'mentee',
                          ))));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => ScreenLoginForm(
                            collection: "mentee",
                          ))));
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(
                      255, 47, 38, 94), // Same button color as previous code
                  padding: EdgeInsets.symmetric(
                      horizontal: 80, vertical: 16), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Rounded button corners
                  ),
                  elevation: 10),
              child: Text(
                'Mentee',
                style: TextStyle(
                  color: Colors.white, // White text color
                  fontSize: 16, // Font size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
