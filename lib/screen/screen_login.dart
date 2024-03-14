import 'package:flutter/material.dart';

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to',
            style: TextStyle(
              fontSize: 60,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/Logo_SucesSage.png'),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("Mentor", style: TextStyle(color: Colors.white)),
            style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Color.fromARGB(255, 47, 38, 94))),
          ),
          ElevatedButton(
              onPressed: () {},
              child: Text(
                "Mentee",
                style: TextStyle(color: Colors.white),
              ),
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 47, 38, 94))))
        ],
      ),
    );
  }
}
