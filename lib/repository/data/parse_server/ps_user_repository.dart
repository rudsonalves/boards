import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '/repository/data/parse_server/common/ps_functions.dart';
import '../interfaces/i_user_repository.dart';
import '/core/abstracts/data_result.dart';
import '/core/models/user.dart';
import 'common/errors_mensages.dart';
import '/core/singletons/current_user.dart';
import '/get_it.dart';
import 'common/constants.dart';
import 'common/parse_to_model.dart';

class UserRepositoryException implements Exception {
  final String message;
  UserRepositoryException(this.message);

  @override
  String toString() => 'UserRepositoryException: $message';
}

class PSUserRepository implements IUserRepository {
  @override
  Future<DataResult<UserModel>> signUp(UserModel user) async {
    try {
      // Create a new ParseUser using the provided user details.
      final parseUser = ParseUser(user.email, user.password, user.email);

      // Set additional user details, such as nickname, phone, and user type.
      parseUser
        ..setNonNull<String>(keyUserName, user.email)
        ..setNonNull<String>(keyUserNickname, user.name!)
        ..setNonNull<String>(keyUserPhone, user.phone!)
        ..setNonNull<String>(keyUserRole, user.role.name);

      // Attempt to sign up the user on the Parse Server.
      final response = await parseUser.signUp();
      if (!response.success) {
        // Throw a custom exception if the sign up fails.
        throw UserRepositoryException(
            response.error?.message ?? 'unknown error');
      }

      // Convert the ParseUser to UserModel and return it as a success result.
      final newUser = ParseToModel.user(parseUser);

      // Logout the newly created user session.
      parseUser.logout();

      return DataResult.success(newUser);
    } catch (err) {
      // Handle any error that occurs during the sign up process.
      return _handleError<UserModel>('signUp', err);
    }
  }

  @override
  Future<DataResult<void>> removeByEmail(String userEmail) async {
    try {
      final query = QueryBuilder<ParseUser>(ParseUser.forQuery())
        ..whereEqualTo(keyUserEmail, userEmail);
      final response = await query.query();

      if (!response.success ||
          response.result == null ||
          response.results!.isEmpty) {
        throw Exception(response.error?.toString() ??
            'User with email $userEmail not found.');
      }

      // get user object
      final user = response.results!.first as ParseUser;

      // try remove user
      final deleteResponse = await user.delete();

      if (!deleteResponse.success) {
        throw UserRepositoryException(
          deleteResponse.error?.message ?? 'Failed to delete user.',
        );
      }

      return DataResult.success(null);
    } catch (err) {
      return _handleError<UserModel>('removeByEmail', err);
    }
  }

  @override
  Future<DataResult<UserModel>> signInWithEmail(UserModel user) async {
    try {
      // Create a ParseUser using the provided email and password for sign in.
      final parseUser = ParseUser(user.email, user.password, null);
      final response = await parseUser.login();

      // If the login fails, handle the error.
      if (!response.success) {
        if (response.error == null) {
          throw UserRepositoryException('Error desconhecido!');
        }
        int code = response.error!.code;
        return DataResult.failure(GenericFailure(
          message: ParserServerErrors.message(code),
          code: code,
        ));
      }

      // Check and update user permissions if needed.
      await _checksPermissions(parseUser);
      return DataResult.success(ParseToModel.user(parseUser));
    } catch (err) {
      // Handle any error that occurs during the login process.
      return _handleError<UserModel>('loginWithEmail', err);
    }
  }

  @override
  Future<DataResult<void>> signOut() async {
    try {
      // Get the current user from the Parse Server and log out.
      final user = await ParseUser.currentUser() as ParseUser;
      await user.logout();
      return DataResult.success(null);
    } catch (err) {
      // Handle any error that occurs during the sign out process.
      return _handleError<void>('loginWithEmail', err);
    }
  }

  @override
  Future<DataResult<UserModel>> getCurrentUser() async {
    try {
      // Retrieve the currently authenticated user.
      ParseUser? parseCurrentUser = await ParseUser.currentUser() as ParseUser?;
      if (parseCurrentUser == null) {
        throw UserRepositoryException('user token is invalid');
      }

      // Check whether the user's session token is valid.
      final response = await ParseUser.getCurrentUserFromServer(
          parseCurrentUser.sessionToken!);

      if (response != null && response.success) {
        // Update user permissions if necessary.
        await _checksPermissions(response.result as ParseUser);
        return DataResult.success(ParseToModel.user(parseCurrentUser));
      } else {
        // Logout the user if the session is invalid.
        await parseCurrentUser.logout();
        throw UserRepositoryException(
            response?.error.toString() ?? 'unknown error');
      }
    } catch (err) {
      // Handle any error that occurs while retrieving the current user.
      return _handleError<UserModel>('getCurrentUser', err);
    }
  }

  @override
  Future<DataResult<void>> update(UserModel user) async {
    try {
      // Create a new ParseUser with the user ID to update.
      final parseUser = ParseUser(null, null, null)..objectId = user.id;

      // Update the user details if they are provided.
      if (user.name != null) {
        parseUser.set(keyUserNickname, user.name);
      }

      if (user.phone != null) {
        parseUser.set(keyUserPhone, user.phone);
      }

      if (user.password != null) {
        parseUser.set(keyUserPassword, user.password);
      }

      // Attempt to update the user information on the Parse Server.
      final response = await parseUser.update();

      if (!response.success) {
        throw UserRepositoryException(response.error.toString());
      }

      // If the password was updated, the user must re-login.
      if (user.password != null) {
        parseUser.set(keyUserPassword, user.password);

        final updatedUser = getIt<CurrentUser>().user;
        if (updatedUser == null) {
          return DataResult.failure(const GenericFailure());
        }

        await parseUser.logout();
        final loginResponse =
            await ParseUser(updatedUser.email, user.password, updatedUser.email)
                .login();

        if (!loginResponse.success) {
          throw UserRepositoryException(loginResponse.error.toString());
        }
      }
      return DataResult.success(null);
    } catch (err) {
      // Handle any error that occurs during the update process.
      return _handleError<void>('update', err);
    }
  }

  @override
  Future<DataResult<void>> resetPassword(String email) async {
    try {
      final user = ParseUser(null, null, email.trim());
      final ParseResponse response = await user.requestPasswordReset();
      if (!response.success) {
        final code = response.error!.code;
        return DataResult.failure(GenericFailure(
          message: ParserServerErrors.message(code),
          code: code,
        ));
      }
      return DataResult.success(null);
    } catch (err) {
      return _handleError<void>('resetPassword', err);
    }
  }

  // Future<void> _assignUserToRole(ParseUser user, String roleName) async {
  //   try {
  //     // ;search for the Role by name
  //     final query = QueryBuilder<ParseObject>(ParseObject(keyRoleTable))
  //       ..whereEqualTo(keyRoleName, roleName);
  //     final response = await query.query();

  //     if (!response.success ||
  //         response.results == null ||
  //         response.results!.isEmpty) {
  //       throw UserRepositoryException(
  //           'Role "$roleName" not found or query failed.');
  //     }

  //     // Get the Role found
  //     final role = response.results!.first as ParseObject;

  //     // Add the user to the Role relationship
  //     final relation = role.getRelation<ParseObject>(keyRoleUsers);
  //     relation.add(user);

  //     // Save the Role with the new relationship
  //     final saveResponse = await role.save();
  //     if (!saveResponse.success) {
  //       throw UserRepositoryException(
  //           'Failed to save role "$roleName": ${saveResponse.error?.message ?? 'Unknown error'}');
  //     }
  //   } catch (err) {
  //     // Log the error and wrap it in a specific exception
  //     throw UserRepositoryException(
  //         'Failed to assign user to role "$roleName": $err');
  //   }
  // }

  Future<void> _checksPermissions(ParseUser parseUser) async {
    final parseAcl = parseUser.getACL();
    if (parseAcl.getPublicReadAccess() == true) return;

    parseAcl.setPublicReadAccess(allowed: true);
    parseAcl.setPublicWriteAccess(allowed: false);

    parseUser.setACL(parseAcl);
    final aclResponse = await parseUser.save();
    if (!aclResponse.success) {
      throw UserRepositoryException(
          'error setting ACL permissions: ${aclResponse.error?.message ?? 'unknown error'}');
    }
  }

  DataResult<T> _handleError<T>(String module, Object error) {
    return PsFunctions.handleError<T>('UserRepository', module, error);
  }
}
