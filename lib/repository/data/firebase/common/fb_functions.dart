import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';

class FbFunctions {
  FbFunctions._();

  static final firebaseFuncs = FirebaseFunctions.instance;

  static Future<void> assignDefaultUserRole(String uid) async {
    try {
      if (uid.isEmpty) {
        throw Exception('User ID cannot be empty.');
      }
      final callable = firebaseFuncs.httpsCallable('AssignDefaultUserRole');
      await callable.call({'userId': uid, 'role': 'user'});
    } catch (err) {
      final message = 'FbFunctions.assignDefaultUserRole: $err';
      log(message);
      throw Exception(message);
    }
  }

  static Future<void> sendVerificationEmail(
    String email,
    String displayName,
  ) async {
    try {
      if (email.isEmpty || displayName.isEmpty) {
        throw Exception('Email or displayName cannot be empty.');
      }
      final callable = firebaseFuncs.httpsCallable('SendVerificationEmail');
      await callable.call({'email': email, 'displayName': displayName});
    } catch (err) {
      final message = 'FbFunctions.httpsCallable: $err';
      log(message);
      throw Exception(message);
    }
  }
}
