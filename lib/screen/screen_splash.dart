import 'package:flutter/material.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Image.asset('assets/Logo_SucesSage.png')));
  }
}
