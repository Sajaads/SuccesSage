import 'package:flutter/material.dart';
import 'package:successage/screen/screen_role.dart';

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to',
            style: TextStyle(
              fontSize: 50,
              color: Color.fromARGB(255, 29, 24, 101),
              fontWeight: FontWeight.w700,
              fontFamily: 'Circular', // Use a round font
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/Logo_SucesSage.png'),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => ScreenRole(
                  toggle: false,
                ),
              ));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 47, 38, 94), // Stylish button color
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
                  toggle: true,
                ),
              ));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 47, 38, 94), // Stylish button color
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
        ],
      ),
    );
  }
}
