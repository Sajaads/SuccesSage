import 'package:flutter/material.dart';
import 'package:successage/screen/screen_mentor_or_mentee.dart';
import 'package:successage/screen/screen_signuporlogin.dart';

class MyWidget2 extends StatelessWidget {
  const MyWidget2({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(context);
              },
              child: Text('signout'))),
    );
  }
}
