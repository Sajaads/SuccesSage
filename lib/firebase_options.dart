// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD2vRGiGsvwPN7YT_xnTiMyYElR9Dh91ns',
    appId: '1:885404466978:web:1d3d777a7134240b326f7b',
    messagingSenderId: '885404466978',
    projectId: 'successage-main-project',
    authDomain: 'successage-main-project.firebaseapp.com',
    storageBucket: 'successage-main-project.appspot.com',
    measurementId: 'G-FZ8MW0W5Y1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyARUHTLVjAJLQ9wAtasU-QEFYpRk5uYHVw',
    appId: '1:885404466978:android:0aab46a2c61c0caf326f7b',
    messagingSenderId: '885404466978',
    projectId: 'successage-main-project',
    storageBucket: 'successage-main-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCUyTZ4yhWHo1Xb9wpsqx3FrkBVh0TEOfk',
    appId: '1:885404466978:ios:db5f08fc3675f8e8326f7b',
    messagingSenderId: '885404466978',
    projectId: 'successage-main-project',
    storageBucket: 'successage-main-project.appspot.com',
    iosClientId: '885404466978-9njcfadf3kguqstl574ektj1n6knim2c.apps.googleusercontent.com',
    iosBundleId: 'com.example.successage',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCUyTZ4yhWHo1Xb9wpsqx3FrkBVh0TEOfk',
    appId: '1:885404466978:ios:970c04b780c10916326f7b',
    messagingSenderId: '885404466978',
    projectId: 'successage-main-project',
    storageBucket: 'successage-main-project.appspot.com',
    iosClientId: '885404466978-germcc4aoigf907sadcar6l46l1gonon.apps.googleusercontent.com',
    iosBundleId: 'com.example.successage.RunnerTests',
  );
}
