import 'package:flutter/material.dart';
import 'package:successage/screen/screen_mentor_or_mentee.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    gotologin(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Image.asset('assets/Logo_SucesSage.png')));
  }
}

Future<void> gotologin(BuildContext context) async {
  await Future.delayed(Duration(seconds: 3));
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (fcd) => ScreenLogin()));
}
