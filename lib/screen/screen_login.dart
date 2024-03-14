import 'package:flutter/material.dart';
import 'package:successage/screen/screen_login_form.dart';

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
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
            onPressed: () {
              login(context);
            },
            child: Text("Login", style: TextStyle(color: Colors.white)),
            style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Color.fromARGB(255, 47, 38, 94))),
          ),
          ElevatedButton(
              onPressed: () {},
              child: const Text(
                "Signup",
                style: TextStyle(color: Colors.white),
              ),
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 47, 38, 94))))
        ],
      ),
    );
  }

  void login(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => ScreenLoginForm()));
  }
}
