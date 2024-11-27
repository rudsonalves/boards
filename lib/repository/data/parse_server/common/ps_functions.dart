import 'dart:developer';

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '/core/abstracts/data_result.dart';

class PsFunctions {
  PsFunctions._();

  /// Handles errors by logging and wrapping them in a [DataResult] failure
  /// response.
  ///
  /// This method takes the name of the method where the error occurred and the
  /// actual error object.
  /// It logs a detailed error message and returns a failure wrapped in
  /// [DataResult].
  ///
  /// Parameters:
  /// - [className]: The name of the class where error occurred.
  /// - [method]: The name of the method where the error occurred.
  /// - [error]: The error object that describes what went wrong.
  ///
  /// Returns:
  /// A [DataResult.failure] with a [GenericFailure] that includes a detailed
  /// message.
  static DataResult<T> handleError<T>(
      String className, String module, Object error) {
    final fullMessage = '$className.$module: $error';
    log(fullMessage);
    return DataResult.failure(GenericFailure(message: fullMessage));
  }

  /// Fetches the current logged-in user from Parse Server.
  ///
  /// This method attempts to get the current user that is authenticated
  /// in the Parse server. If no user is logged in, it throws a
  /// [Exception].
  ///
  /// Throws:
  /// - [MechanicRepositoryException]: If there is no current user logged in.
  ///
  /// Returns:
  /// A [ParseUser] representing the current logged-in user.
  static Future<ParseUser> parseCurrentUser() async {
    final parseUser = await ParseUser.currentUser() as ParseUser?;
    if (parseUser == null) {
      throw Exception('Current user access error');
    }
    return parseUser;
  }

  /// Creates a default ACL (Access Control List) for an object.
  ///
  /// The default ACL allows public read access but restricts write access to
  /// only the [owner]. This is generally used to protect the integrity of data
  /// while allowing other users to view it.
  ///
  /// Parameters:
  /// - [owner]: The [ParseUser] who will be set as the owner of the ACL, and
  ///   thus the one who will have full write permissions to the object.
  ///
  /// Returns:
  /// A [ParseACL] instance with permissions set for public read access and
  /// write access restricted to the owner.
  static ParseACL createDefaultAcl(ParseUser owner) {
    return ParseACL(owner: owner)
      ..setPublicReadAccess(allowed: true)
      ..setPublicWriteAccess(allowed: false);
  }

  static ParseACL createSharedAcl(ParseUser owner) {
    return ParseACL()
      ..setPublicReadAccess(allowed: true)
      ..setPublicWriteAccess(allowed: true);
  }
}
