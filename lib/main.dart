import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/get_it.dart';
import 'app.dart';
import 'data/store/database/providers/database_provider.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // If you are in development mode, connect to the Firestore emulator
  if (kDebugMode) {
    const localhost = '127.0.0.1';
    await FirebaseAuth.instance.useAuthEmulator(localhost, 9099);
    FirebaseFunctions.instance.useFunctionsEmulator(localhost, 5001);
    FirebaseFirestore.instance.useFirestoreEmulator(localhost, 8080);
    await FirebaseStorage.instance.useStorageEmulator(localhost, 9199);
    log('Using firebase emulator...');
  }

  setupDependencies();

  // final parseServer = getIt<ParseServerService>();
  // parseServer.init(isLocalServer);

  // This DatabaseProvider.initialize call initializes the AppSettings and
  // IAppPreferencesRepository in sequence.
  await DatabaseProvider.initialize();

  // Foreground handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Mensagem recebida em foreground: ${message.notification?.title}');
  });

  // OnLine handler
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    final adId = message.data['adId'];
    if (adId != null) {
      log('Navegar para detalhes do anúncio: $adId');
    }
  });

  // Backgound handler
  // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
  // log('Mensagem recebida em backgound: ${message.notification?.title}');
  // });

  runApp(const App());
}
