// Copyright (C) 2025 Rudson Alves
// 
// This file is part of boards.
// 
// boards is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// boards is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with boards.  If not, see <https://www.gnu.org/licenses/>.

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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDvsjrvbz8YG-u-mstVnMIqKZ0Wh1nFmzU',
    appId: '1:549566189735:web:814fbf22adc3da24598b82',
    messagingSenderId: '549566189735',
    projectId: 'boards-fc3e5',
    authDomain: 'boards-fc3e5.firebaseapp.com',
    storageBucket: 'boards-fc3e5.firebasestorage.app',
    measurementId: 'G-F2VPC4QPXD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDchmvs6PX3fW_JxN2l8XqYb8GMQDRpKbA',
    appId: '1:549566189735:android:9fd3ce824f08a6a3598b82',
    messagingSenderId: '549566189735',
    projectId: 'boards-fc3e5',
    storageBucket: 'boards-fc3e5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCQutNaMWztIMrvzKiwDfYclsajy-jRAPI',
    appId: '1:549566189735:ios:7dee114366300723598b82',
    messagingSenderId: '549566189735',
    projectId: 'boards-fc3e5',
    storageBucket: 'boards-fc3e5.firebasestorage.app',
    iosBundleId: 'br.dev.rralves.boards',
  );
}
