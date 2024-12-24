import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/get_it.dart';
import '/core/abstracts/data_result.dart';
import '../../models/user.dart';
import 'common/data_functions.dart';
import '../interfaces/remote/i_user_repository.dart';
import 'common/fb_functions.dart';
import 'common/errors_codes.dart';
import '../../services/firebase/firebase_messaging_service.dart';

extension ToUserModel on User {
  UserModel get toUserModel => UserModel(
        id: uid,
        name: displayName,
        email: email!,
        isEmailVerified: emailVerified,
        phone: phoneNumber,
        isPhoneVerified: phoneNumber != null,
        createdAt: metadata.creationTime ?? DateTime.now(),
      );
}

class FbUserRepository implements IUserRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseFirestore = FirebaseFirestore.instance;

  static const keyUsers = 'users';
  static const keyUnverifiedPhone = 'unverifiedPhoneNumber';

  final _messagesService = getIt<FirebaseMessagingService>();

  @override
  Future<DataResult<UserModel>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return _handleError(
          'getCurrentUser',
          'user not logged',
          ErrorCodes.userNotLogged,
        );
      }

      await user.getIdToken(true);

      // Use the extension to convert the Firebase User to a UserModel
      UserModel currentUser = user.toUserModel;

      // Recover cunstom claims
      currentUser = await _getClaims(user, currentUser);

      // Get firebase message token
      final token = await _messagesService.getAndUpdateToken();
      currentUser.fcmToken = token;

      return DataResult.success(currentUser);
    } catch (err) {
      return _handleError('getCurrentUser', err);
    }
  }

  @override
  Future<DataResult<UserModel>> signInWithEmail(UserModel user) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password!,
      );
      final fbUser = credential.user;
      if (fbUser == null) {
        return _handleError(
          'signInWithEmail',
          'unknown FirebaseAuth error',
          ErrorCodes.unknownError,
        );
      }

      // Check if email is verificated
      if (!fbUser.emailVerified) {
        await signOut();
        return _handleError(
          'signInWithEmail',
          'email not checked',
          ErrorCodes.emailNotChecked,
        );
      }

      // Mount loged UserModel
      UserModel logedUser = await _getUserFrom(fbUser);
      if (!logedUser.isPhoneVerified) {
        logedUser = await _signInUsers(logedUser);
      }

      // Recover cunstom claims
      logedUser = await _getClaims(fbUser, logedUser);

      // Get faribase message token in user
      final token = await _messagesService.getAndUpdateToken();
      logedUser.fcmToken = token;

      return DataResult.success(logedUser);
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        return _handleError(
          'signInWithEmail',
          'No user found for that email.',
          ErrorCodes.userNotFound,
        );
      } else if (err.code == 'wrong-password') {
        return _handleError(
          'wrong-password',
          'Wrong password provided for that user.',
          204,
        );
      }
      return _handleError('unknow-error', err, ErrorCodes.unknownError);
    } catch (err) {
      return _handleError('signInWithEmail', err, ErrorCodes.unknownError);
    }
  }

  Future<UserModel> _signInUsers(UserModel user) async {
    // Save users informations
    final usersDoc = _firebaseFirestore.collection(keyUsers).doc(user.id!);

    // Check if uid document already exists, to avoid overwriting data.
    final docSnapshot = await usersDoc.get();
    if (!docSnapshot.exists) {
      throw Exception('users uid don`t exists!');
    }

    return user.copyWith(
        phone: docSnapshot.data()![keyUnverifiedPhone] as String?);
  }

  @override
  Future<DataResult<UserModel>> signUp(UserModel user) async {
    try {
      // Create user with email and password in firebase authentication
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password!,
      );

      // Update user display name
      final newUser = await _updateProfile(
        currentUser: credential.user!,
        displayName: user.name,
      );

      // Send verification email
      await newUser.sendEmailVerification();

      // Call to add the custom claim via Cloud Function
      final result = await FbFunctions.assignDefaultUserRole();
      if (result.isFailure) {
        await signOut();
        _handleError(
          'signInWithEmail',
          'claims error',
          ErrorCodes.claimsError,
        );
      }

      // Save users informations
      final usersData = {keyUnverifiedPhone: user.phone};
      await _signUpUsers(newUser.uid, usersData);

      // sign out
      await signOut();

      return DataResult.success(user.copyWith(id: newUser.uid));
    } on FirebaseAuthException catch (err) {
      if (err.code == 'weak-password') {
        return _handleError(
          'signInWithEmail',
          'The password provided is too weak.',
          ErrorCodes.weakPassaword,
        );
      } else if (err.code == 'email-already-in-use') {
        return _handleError(
          'signInWithEmail',
          'The account already exists for that email.',
          ErrorCodes.emailAlreadyInUse,
        );
      }
      return _handleError('signInWithEmail', err, ErrorCodes.unknownError);
    } catch (err) {
      return _handleError('signInWithEmail', err, ErrorCodes.unknownError);
    }
  }

  // Update firebase profile with displayname, photoURL, PhoneAuthCredendial
  Future<User> _updateProfile({
    required User currentUser,
    String? displayName,
    String? photoURL,
    String? newPassword,
    PhoneAuthCredential? phoneCredential,
  }) async {
    try {
      if (displayName != null) {
        await currentUser.updateDisplayName(displayName);
      }
      if (photoURL != null) {
        await currentUser.updatePhotoURL(photoURL);
      }
      if (newPassword != null) {
        await currentUser.updatePassword(newPassword);
      }
      if (phoneCredential != null) {
        await currentUser.updatePhoneNumber(phoneCredential);
      }

      await currentUser.reload();
      return _firebaseAuth.currentUser!;
    } catch (err) {
      log('Update profile error: $err');
      rethrow;
    }
  }

  Future<void> _signUpUsers(String uid, Map<String, dynamic> data) async {
    // Save users informations
    final usersDoc = _firebaseFirestore.collection(keyUsers).doc(uid);

    // Check if uid document already exists, to avoid overwriting data.
    await _firebaseFirestore.runTransaction((transaction) async {
      final docSnapshot = await transaction.get(usersDoc);
      if (docSnapshot.exists) {
        throw Exception('users uid exists!');
      }
      transaction.set(usersDoc, data);
    });
  }

  @override
  Future<DataResult<void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return DataResult.success(null);
    } catch (err) {
      return _handleError('signOut', err);
    }
  }

  @override
  Future<DataResult<void>> updatePassword(UserModel user) async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        throw FirebaseAuthException(
          code: 'no-current-user',
          message: 'No user is currently signed in.',
        );
      }

      if (user.password != null) {
        await currentUser.updatePassword(user.password!);
        await currentUser.reload();
      }

      return DataResult.success(null);
    } catch (err) {
      return _handleError('update', err);
    }
  }

  @override
  Future<DataResult<void>> requestResetPassword(String email) async {
    try {
      final acs = ActionCodeSettings(
          url: 'https://rralves.dev.br/boards/',
          androidPackageName: 'br.dev.rralves.boards',
          handleCodeInApp: true,
          androidInstallApp: true,
          androidMinimumVersion: '12');

      await _firebaseAuth
          .sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: acs,
      )
          .catchError(
        (onError) {
          final message = 'Error sending email verification: $onError';
          throw Exception(message);
        },
      );

      log('Successfully sent email verification');
      return DataResult.success(null);
    } catch (err) {
      return _handleError(
        'requestResetPassword',
        err,
        ErrorCodes.unknownError,
      );
    }
  }

  @override
  Future<DataResult<PhoneVerificationInfo>> sendPhoneVerificationSMS(
    String phoneNumber,
  ) async {
    try {
      final completer = Completer<DataResult<PhoneVerificationInfo>>();

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Automatic verification successful
          completer.complete(
            _handleAutomaticVerification(credential),
          );
        },
        verificationFailed: (FirebaseAuthException err) {
          // Handling verification failure
          completer.complete(
            _handleError(
              'sendPhoneVerificationSMS',
              err.message ?? 'Unknow error!',
              ErrorCodes.verificationFailed,
            ),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          // SMS code sent successfully
          completer.complete(
            DataResult.success(
              PhoneVerificationInfo(
                verificationId: verificationId,
                resendToken: resendToken,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-recovery timeout
          completer.complete(
            DataResult.success(
              PhoneVerificationInfo(verificationId: verificationId),
            ),
          );
        },
      );

      return completer.future;
    } catch (err) {
      return _handleError(
        'sendVerificationSMS',
        err,
        ErrorCodes.unknownError,
      );
    }
  }

  @override
  Future<DataResult<void>> submitPhoneVerificationCode(
    String verificationId,
    String smsCode,
  ) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      return _updatePhoneNumber(credential);
    } catch (err) {
      return _handleError(
        'submitVerificationCode',
        err,
        ErrorCodes.unknownError,
      );
    }
  }

  Future<UserModel> _getUserFrom(User user) async {
    await user.reload();

    return UserModel(
      id: user.uid,
      name: user.displayName,
      email: user.email!,
      phone: user.phoneNumber,
      createdAt: user.metadata.creationTime,
    );
  }

  Future<UserModel> _getClaims(User firebaseUser, UserModel user) async {
    final idTokenResult = await firebaseUser.getIdTokenResult(true);
    final claims = idTokenResult.claims!;
    final roleName = claims['role'] as String;
    return user.copyWith(
      role: UserRole.values.firstWhere((role) => role.name == roleName),
    );
  }

  /// Handles the automatic phone verification process when it is successfully
  /// completed.
  ///
  /// This method is used internally to handle the scenario where the phone
  /// verification is automatically completed by Firebase without the user
  /// needing to manually input an SMS code. It returns a success result
  /// indicating that the verification was completed automatically.
  ///
  /// - [credential]: The `PhoneAuthCredential` provided by Firebase upon
  ///   successful automatic verification.
  ///
  /// Returns a `DataResult<PhoneVerificationInfo>`:
  /// - `PhoneVerificationInfo` with a placeholder `verificationId` indicating
  ///   that the process was automatically verified.
  DataResult<PhoneVerificationInfo> _handleAutomaticVerification(
      PhoneAuthCredential credential) {
    // Return a success result indicating automatic verification was completed.
    return DataResult.success(PhoneVerificationInfo(
      verificationId: 'AUTO_VERIFIED',
    ));
  }

  /// Updates the current user's phone number using the provided phone
  /// authentication credential.
  ///
  /// This method attempts to update the phone number of the currently
  /// authenticated user by using the `PhoneAuthCredential` provided. It checks
  /// if a user is currently logged in and proceeds to update their phone
  /// number. In case of any failure, it returns an appropriate error result.
  ///
  /// - [credential]: The `PhoneAuthCredential` containing the necessary
  ///   information for verification and phone number update.
  ///
  /// Returns a `Future<DataResult<void>>`:
  /// - `DataResult.success()`: Indicates that the phone number was successfully
  ///   updated.
  /// - `DataResult.failure()`: If an error occurs during the process, such as
  ///   no user being logged in or an issue with the Firebase operation.
  ///
  /// Possible Errors:
  /// - `FirebaseAuthException`: If there is an issue during the phone number
  ///   update, such as an invalid credential or a network problem.
  /// - Custom Error: If no user is logged in when trying to update the phone
  ///   number.
  Future<DataResult<void>> _updatePhoneNumber(
      PhoneAuthCredential credential) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      // Ensure there is a user currently logged in before proceeding.
      if (currentUser == null) {
        _handleError(
          'updatePhoneNumber',
          'No user is currently logged in.',
          ErrorCodes.userNotLogged,
        );
      }

      // Update the current user's phone number using the provided credential.
      await currentUser!.updatePhoneNumber(credential);
      return DataResult.success(null);
    } on FirebaseAuthException catch (err) {
      return _handleError(
        'updatePhoneNumber',
        err,
        ErrorCodes.unknownError,
      );
    } catch (err) {
      return _handleError(
        'updatePhoneNumber',
        err,
        ErrorCodes.unknownError,
      );
    }
  }

  DataResult<T> _handleError<T>(String module, Object err, [int code = 0]) {
    return DataFunctions.handleError<T>('FbUserRepository', module, err, code);
  }
}
