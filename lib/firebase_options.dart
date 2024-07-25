// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxvr5Mw5XfOfytxfsZKyulcJ9bSEyl2Og',
    appId: '1:34433345353:android:1cef12efb9fdd965f51c98',
    messagingSenderId: '34433345353',
    projectId: 'food-delivery-app-1b1e3',
    storageBucket: 'food-delivery-app-1b1e3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB4PifvDQXfIWus-f4yOIdZp7TVowezDrE',
    appId: '1:34433345353:ios:0790f2d844219453f51c98',
    messagingSenderId: '34433345353',
    projectId: 'food-delivery-app-1b1e3',
    storageBucket: 'food-delivery-app-1b1e3.appspot.com',
    iosBundleId: 'com.example.fooddeliveryapp',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBGd54oKp24rPmSZHgUCUUbK7gitDgptEA',
    appId: '1:34433345353:web:d7852c60c04fdf39f51c98',
    messagingSenderId: '34433345353',
    projectId: 'food-delivery-app-1b1e3',
    authDomain: 'food-delivery-app-1b1e3.firebaseapp.com',
    storageBucket: 'food-delivery-app-1b1e3.appspot.com',
  );

}