import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:successage/mentee/mentee_detail.dart';
import 'package:successage/screen/screen_mentor_or_mentee.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: GoogleFonts.firaSansTextTheme(),
          splashColor: Colors.amber,
          scaffoldBackgroundColor: const Color(0xFF8ECAE6)),
      home: const ScreenSplash(),
    );
  }
}
