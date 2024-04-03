import 'package:flutter/material.dart';
import 'package:successage/mentee/Mentee_session_booking.dart';
import 'package:successage/mentee/mentee_home_screen.dart';
import 'package:successage/mentee/mentee_profile.dart';
import 'package:successage/mentor/mentor_home_screen.dart';
import 'package:successage/screen/bottom_bar.dart';
import 'package:successage/screen/screen_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          splashColor: Colors.amber,
          scaffoldBackgroundColor: const Color.fromARGB(255, 231, 231, 231)),
      home: MentorHomeScreen(),
    );
  }
}
