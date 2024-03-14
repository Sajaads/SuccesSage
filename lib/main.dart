import 'package:flutter/material.dart';
import 'package:successage/screen/screen_splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(splashColor: Colors.amber),
      home: ScreenSplash(),
    );
  }
}
