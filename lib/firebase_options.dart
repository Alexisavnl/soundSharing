// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGnTcXmiKaChAnVXRHIqe23_OlDUv11Jo',
    appId: '1:319724448727:android:06fad0438a8fff7b6e7992',
    messagingSenderId: '319724448727',
    projectId: 'dasong-3713a',
    databaseURL: 'https://dasong-3713a-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'dasong-3713a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAtIXNVGkt3E5iBvoqtaEkPmkrm96-N7JY',
    appId: '1:319724448727:ios:93f4f9a2750eaf646e7992',
    messagingSenderId: '319724448727',
    projectId: 'dasong-3713a',
    databaseURL: 'https://dasong-3713a-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'dasong-3713a.appspot.com',
    androidClientId: '319724448727-g0fv053r873dlrikume01c4arucdc92u.apps.googleusercontent.com',
    iosClientId: '319724448727-hlhbe01c9584mb4uqk3me413isqdcl0h.apps.googleusercontent.com',
    iosBundleId: 'com.alexisavenel.daSong',
  );
}
