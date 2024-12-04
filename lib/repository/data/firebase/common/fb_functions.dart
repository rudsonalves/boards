import 'dart:developer';

import 'package:boards/core/models/bg_name.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../../../core/abstracts/data_result.dart';
import '/core/models/user.dart';

class FbFunctions {
  FbFunctions._();

  static final firebaseFuncs = FirebaseFunctions.instance;

  static Future<DataResult<void>> assignDefaultUserRole(String uid) async {
    try {
      if (uid.isEmpty) {
        throw Exception('User ID cannot be empty.');
      }
      final callable = firebaseFuncs.httpsCallable('AssignDefaultUserRole');
      await callable.call({'userId': uid, 'role': 'user'});

      return DataResult.success(null);
    } catch (err) {
      final message = 'FbFunctions.assignDefaultUserRole: $err';
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }

  static Future<DataResult<void>> sendVerificationEmail(
    String email,
    String displayName,
  ) async {
    try {
      if (email.isEmpty || displayName.isEmpty) {
        throw Exception('Email or displayName cannot be empty.');
      }
      final callable = firebaseFuncs.httpsCallable('SendVerificationEmail');
      await callable.call({'email': email, 'displayName': displayName});

      return DataResult.success(null);
    } catch (err) {
      final message = 'FbFunctions.httpsCallable: $err';
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }

  static Future<DataResult<void>> changeUserRole(
      String userId, UserRole role) async {
    try {
      final callable = firebaseFuncs.httpsCallable('ChangeUserRole');
      await callable.call({'userId': userId, 'role': role.name});

      return DataResult.success(null);
    } catch (err) {
      final message = 'FbFunctions.httpsCallable: $err';
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }

  static Future<DataResult<List<BGNameModel>>> getBoardgameNames() async {
    try {
      final callable = firebaseFuncs.httpsCallable('GetBoardgameNames');
      final response = await callable.call();

      // Verify if response.data is present and has the expected format
      if (response.data != null && response.data is List) {
        final List<dynamic> data = response.data;

        if (data.isEmpty) {
          log('No boardgames found in Firestore');
          return DataResult.success([]);
        }

        final List<BGNameModel> boardgames = data
            .map((bg) => BGNameModel(
                  id: bg['id'] as String,
                  name: '${bg['name']} ${bg['publishYear']}',
                ))
            .toList();

        log('GetBoardgameNames Response: $boardgames');
        return DataResult.success(boardgames);
      } else {
        final message = 'No boardgame data returned or unexpected format';
        log(message);
        return DataResult.success(
            []); // Return an empty list if no data is found
      }
    } catch (err) {
      final message = 'FbFunctions.getBoardgameNames: $err';
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }
}
