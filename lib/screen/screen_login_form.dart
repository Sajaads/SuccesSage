import 'package:flutter/material.dart';

class ScreenLoginForm extends StatelessWidget {
  const ScreenLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 80),
                child: Image.asset(
                  'assets/Logo 1.png',
                  scale: 0.7,
                ),
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'username'),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'password')),
              SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.check_box),
                  label: Text('LOGIN'))
            ],
          ),
        ),
      ),
    );
  }
}
