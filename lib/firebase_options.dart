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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBHZIJMoAbPBnFx10lMAwN6hB3Uhd2mpGk',
    appId: '1:693382005476:web:faf15fb165af1d077da2f1',
    messagingSenderId: '693382005476',
    projectId: 'fir-app-project-570db',
    authDomain: 'fir-app-project-570db.firebaseapp.com',
    storageBucket: 'fir-app-project-570db.firebasestorage.app',
    measurementId: 'G-GQ7HFZK27M',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCBc1iPv84x8TOY5N6uQSdIoI2MSucAang',
    appId: '1:693382005476:android:e8f9e16518c30a9d7da2f1',
    messagingSenderId: '693382005476',
    projectId: 'fir-app-project-570db',
    storageBucket: 'fir-app-project-570db.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDzTZPNmT52MURDHo9Rh4lStHcBUV-7-WM',
    appId: '1:693382005476:ios:55eae34da462ae2d7da2f1',
    messagingSenderId: '693382005476',
    projectId: 'fir-app-project-570db',
    storageBucket: 'fir-app-project-570db.firebasestorage.app',
    iosBundleId: 'com.example.firebaseApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDzTZPNmT52MURDHo9Rh4lStHcBUV-7-WM',
    appId: '1:693382005476:ios:55eae34da462ae2d7da2f1',
    messagingSenderId: '693382005476',
    projectId: 'fir-app-project-570db',
    storageBucket: 'fir-app-project-570db.firebasestorage.app',
    iosBundleId: 'com.example.firebaseApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBHZIJMoAbPBnFx10lMAwN6hB3Uhd2mpGk',
    appId: '1:693382005476:web:1598fb0edd820b847da2f1',
    messagingSenderId: '693382005476',
    projectId: 'fir-app-project-570db',
    authDomain: 'fir-app-project-570db.firebaseapp.com',
    storageBucket: 'fir-app-project-570db.firebasestorage.app',
    measurementId: 'G-20G37JPEKM',
  );
}
