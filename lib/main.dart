import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'services/parse_server/parse_server_server.dart';
import 'get_it.dart';
import 'app.dart';
import 'store/database/providers/database_provider.dart';

void main() async {
  const isLocalServer = false;

  await dotenv.load(fileName: '.env');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // If you are in development mode, connect to the Firestore emulator
  if (!kDebugMode) {
    // FIXME: IS DISABLE!!!
    await FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080);
    FirebaseFunctions.instance.useFunctionsEmulator('127.0.0.1', 5001);
    log('Using firebase emulator...');
  }

  setupDependencies();

  final parseServer = getIt<ParseServerService>();
  parseServer.init(isLocalServer);

  // This DatabaseProvider.initialize call initializes the AppSettings and
  // IAppPreferencesRepository in sequence.
  await DatabaseProvider.initialize();

  runApp(const App());
}
