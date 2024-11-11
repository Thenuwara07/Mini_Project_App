import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      authDomain: 'flutter-project-d1d5b.firebaseapp.com',
      projectId: 'flutter-project-d1d5b',
      measurementId: 'your-measurement-id',
      apiKey: 'AIzaSyATcfMsxefbIVdHi-STYP_UdYimr-5v65E',
      appId: '1:1012198463740:android:7e4d44c204c850a3f49f79',
      messagingSenderId: '1012198463740',
      storageBucket: 'flutter-project-d1d5b.firebasestorage.app',
    );
  }
}

// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
// import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
// import 'package:flutter/foundation.dart'
//     show defaultTargetPlatform, kIsWeb, TargetPlatform;

// /// Default [FirebaseOptions] for use with your Firebase apps.
// ///
// /// Example:
// /// dart
// /// import 'firebase_options.dart';
// /// // ...
// /// await Firebase.initializeApp(
// ///   options: DefaultFirebaseOptions.currentPlatform,
// /// );
// /// 
// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     if (kIsWeb) {
//       throw UnsupportedError(
//         'DefaultFirebaseOptions have not been configured for web - '
//         'you can reconfigure this by running the FlutterFire CLI again.',
//       );
//     }
//     switch (defaultTargetPlatform) {
//       case TargetPlatform.android:
//         return android;
//       case TargetPlatform.iOS:
//         return ios;
//       case TargetPlatform.macOS:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for macos - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       case TargetPlatform.windows:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for windows - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       case TargetPlatform.linux:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for linux - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       default:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions are not supported for this platform.',
//         );
//     }
//   }

//   static const FirebaseOptions android = FirebaseOptions(
//     apiKey: 'AIzaSyDMS8yK54Uvo0PB48M0x-55PJdWs-2urzA',
//     appId: '1:926791581909:android:0c3b73c88bce2687b8225c',
//     messagingSenderId: '926791581909',
//     projectId: 'biomark-e9abb',
//     storageBucket: 'biomark-e9abb.appspot.com',
//   );

//   static const FirebaseOptions ios = FirebaseOptions(
//     apiKey: 'AIzaSyATcfMsxefbIVdHi-STYP_UdYimr-5v65E',
//     appId: '1:1012198463740:android:7e4d44c204c850a3f49f79',
//     messagingSenderId: '1012198463740',
//     projectId: 'flutter-project-d1d5b',
//     storageBucket: 'flutter-project-d1d5b.firebasestorage.app',
//     // iosBundleId: 'com.example.biomark',
//   );

// }