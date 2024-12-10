import 'dart:developer';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

import '/core/abstracts/data_result.dart';
import '../../../models/user.dart';

/// A utility class that encapsulates Firebase-specific operations.
/// Provides methods for role management, image handling, and more.
///
/// This class cannot be instantiated.
class FbFunctions {
  FbFunctions._();

  // The Firebase Storage bucket URL.
  static String get _bucket => kDebugMode
      ? 'b/boards-fc3e5.firebasestorage.app/o'
      : 'gs://boards-fc3e5.firebasestorage.app';

  // Getter for  Firebase Functions instance.
  static FirebaseFunctions get _firebaseFuncs {
    if (kDebugMode) {
      const host = '10.0.2.2';
      const port = 5001;
      return FirebaseFunctions.instanceFor(region: 'southamerica-east1')
        ..useFunctionsEmulator(host, port);
    } else {
      return FirebaseFunctions.instanceFor(region: 'southamerica-east1');
    }
  }

  // Getter for Firebase Storage instance.
  static FirebaseStorage get _firebaseStorage => FirebaseStorage.instance;

  /// Assigns the default user role ('user') to a specified user ID.
  ///
  /// Calls the `assignDefaultUserRole` HTTPS Cloud Function to set
  /// the default role for the given user.
  ///
  /// [uid]: The user ID to assign the role.
  ///
  /// Returns:
  /// - A [DataResult<void>] indicating success or failure.
  static Future<DataResult<void>> assignDefaultUserRole(String uid) async {
    try {
      if (uid.isEmpty) {
        throw Exception('User ID cannot be empty.');
      }
      // Get authenticated user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found.');
      }

      // Revalidar o token de autenticação do usuário
      await user.getIdToken(true);

      final callable = _firebaseFuncs.httpsCallable('assignDefaultUserRole');
      await callable();

      return DataResult.success(null);
    } catch (err) {
      final message = 'FbFunctions.assignDefaultUserRole: $err';
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }

  /// Changes the role of a specified user ID.
  ///
  /// Calls the `changeUserRole` HTTPS Cloud Function to update
  /// the role of a user in the Firebase project.
  ///
  /// [userId]: The user ID whose role will be changed.
  /// [role]: The new [UserRole] to assign to the user.
  ///
  /// Returns:
  /// - A [DataResult<void>] indicating success or failure.
  static Future<DataResult<void>> changeUserRole(
      String userId, UserRole role) async {
    try {
      final callable = _firebaseFuncs.httpsCallable('changeUserRole');
      final result = await callable.call({
        'userId': userId,
        'role': role.name,
      });

      log(result.toString());

      return DataResult.success(null);
    } catch (err) {
      final message = 'FbFunctions.changeUserRole: $err';
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }

  /// Uploads an image to Firebase Storage and returns its download URL.
  ///
  /// If the provided [imagePath] is already a valid Firebase Storage URL,
  /// it is returned without uploading. Otherwise, the image is uploaded to
  /// Firebase Storage, and the generated URL is returned.
  ///
  /// [imagePath]: The local path to the image file or a Firebase Storage URL.
  ///
  /// Returns:
  /// - A [String] containing the Firebase Storage download URL.
  ///
  /// Throws:
  /// - An [Exception] if the upload fails.
  static Future<String> uploadImage(String imagePath) async {
    try {
      // Check if imagePath exist in Firestore
      if (isFirebaseStorageUrl(imagePath)) {
        return imagePath;
      }

      // Reference to the location in Firebase Storage
      final storageRef = _firebaseStorage.ref();
      final imageFile = File(imagePath);
      final fileName = basename(imagePath);
      final fileRef = storageRef.child('uploads/$fileName');

      // Upload it
      await fileRef.putFile(imageFile);

      // Retrieve the file URL
      return await fileRef.getDownloadURL();
    } catch (err) {
      throw Exception('FbBoardgameRepository._uploadImage: $err');
    }
  }

  /// Uploads multiple images to Firebase Storage and returns their download
  /// URLs.
  ///
  /// This method takes a list of image paths and uploads each image to Firebase
  /// Storage.
  ///
  /// It returns a list of download URLs for the uploaded images. If any image
  /// path is already a valid Firebase Storage URL, it is returned as-is without
  /// uploading.
  ///
  /// [imagesPath]: A list of local paths to image files or Firebase Storage
  ///   URLs.
  ///
  /// Returns:
  /// - A [Future] containing a [List<String>] of Firebase Storage download
  ///   URLs.
  ///
  /// Throws:
  /// - An [Exception] if the upload of any image fails.
  static Future<List<String>> uploadMultImages(List<String> imagesPath) async {
    try {
      return await Future.wait<String>(imagesPath.map(uploadImage));
    } catch (err) {
      throw Exception('FbBoardgameRepository._uploadImage: $err');
    }
  }

  /// Checks if a given URL is a valid Firebase Storage URL.
  ///
  /// [imageUrl]: The URL to validate.
  ///
  /// Returns:
  /// - `true` if the URL is a valid Firebase Storage URL, `false` otherwise.
  static bool isFirebaseStorageUrl(String imageUrl) {
    return imageUrl.startsWith(_bucket) ||
        imageUrl.contains(_bucket) ||
        imageUrl.contains('firebasestorage.googleapis.com/v0/b/boards-fc3e5');
  }

  /// Checks if a file exists in Firebase Storage by its URL.
  ///
  /// [imageUrl]: The Firebase Storage URL of the file.
  ///
  /// Returns:
  /// - `true` if the file exists, `false` if it does not exist.
  ///
  /// Throws:
  /// - [FirebaseException] for errors other than `object-not-found`.
  static Future<bool> doesImageExist(String imageUrl) async {
    try {
      // Extract the path from the URL (after the bucket)
      final path = Uri.parse(imageUrl).path.replaceFirst('/b/$_bucket/o/', '');
      final decodedPath = Uri.decodeFull(path);

      // Firebase Storage Reference
      final storageRef = _firebaseStorage.ref(decodedPath);

      // Try to get the file metadata
      await storageRef.getMetadata();
      return true;
    } catch (err) {
      if (err is FirebaseException && err.code == 'object-not-found') {
        return false;
      }
      rethrow;
    }
  }
}
