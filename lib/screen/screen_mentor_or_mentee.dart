import 'package:flutter/material.dart';
import 'package:successage/screen/screen_signuporlogin.dart';

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/Logo_SucesSage.png',
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => ScreenRole(
                  collection: "mentor",
                ),
              ));
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
              "Mentor",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => ScreenRole(
                  collection: "mentee",
                ),
              ));
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
              "Mentee",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
