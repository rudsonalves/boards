import '/core/abstracts/data_result.dart';
import '../../../models/user.dart';

class PhoneVerificationInfo {
  final String verificationId;
  final int? resendToken;

  PhoneVerificationInfo({
    required this.verificationId,
    this.resendToken,
  });
}

/// Interface for user-related operations, abstracting the underlying data
/// source.
///
/// This interface is designed to allow different implementations for managing
/// user data, such as Parse Server, Firebase, or any other backend. By relying
/// on this interface, the application logic can remain decoupled from specific
/// backend implementations, which facilitates testing, future changes, or
/// substitution of the backend.
abstract class IUserRepository {
  /// Registers a new user in the system.
  ///
  /// Takes a [UserModel] containing user details such as email, password, and
  /// name.
  /// Returns a [DataResult] that encapsulates either a successful response
  /// with the created [UserModel] or an error.
  Future<DataResult<UserModel>> signUp(UserModel user);

  /// Signs in a user using email and password.
  ///
  /// Takes a [UserModel] containing user details like email and password.
  /// Returns a [DataResult] that contains the signed-in [UserModel] on success,
  /// or an error in case of failure.
  Future<DataResult<UserModel>> signInWithEmail(UserModel user);

  /// Signs out the currently authenticated user.
  ///
  /// Returns a [DataResult] that indicates whether the operation was successful
  /// or not. This operation may return an error if the user is not signed in or
  /// if there's an issue with the sign-out process.
  Future<DataResult<void>> signOut();

  /// Retrieves the currently authenticated user.
  ///
  /// Returns a [DataResult] containing the [UserModel] of the current user if
  /// authenticated. If the user is not authenticated or the session token is
  /// invalid, returns an error.
  Future<DataResult<UserModel>> getCurrentUser();

  /// Updates the details of the currently authenticated user.
  ///
  /// Takes a [UserModel] with updated user information, such as name or phone
  /// number. Returns a [DataResult] that indicates the success or failure of
  /// the operation.
  /// Note: Updating the password might require re-authentication.
  Future<DataResult<void>> updatePassword(UserModel user);

  /// Requests a password reset for a user identified by their email.
  ///
  /// This method sends a request to the Parse Server to initiate the password
  /// reset process for the user associated with the provided email.
  ///
  /// Parameters:
  /// - [email]: A `String` containing the user's email address. Leading and
  ///   trailing spaces are removed using the `trim()` method.
  ///
  /// Returns:
  /// - A `Future<DataResult<void>>` that indicates the success or failure of
  ///   the operation.
  ///
  /// Throws:
  /// - If the request fails, the method returns a `DataResult.failure`
  ///   containing a `GenericFailure` with the error code and message.
  /// - Any additional errors are handled by `_handleError` and returned as
  ///   `DataResult.failure`.
  Future<DataResult<void>> requestResetPassword(String email);

  /// Sends a verification SMS to the specified phone number.
  ///
  /// This method initiates the phone number verification process with Firebase
  /// Authentication. It handles various potential outcomes, such as automatic
  /// verification, verification failure, SMS code sent successfully, and
  /// auto-retrieval timeout. The result of the verification process is returned
  /// as a `DataResult<PhoneVerificationInfo>` containing relevant details like
  /// the `verificationId` and `resendToken`.
  ///
  /// - [phoneNumber]: The phone number to which the verification SMS will be
  ///   sent.
  ///
  /// Returns a `Future<DataResult<PhoneVerificationInfo>>` containing:
  /// - `PhoneVerificationInfo` if the operation succeeds.
  /// - An error if there is a failure during the verification process.
  ///
  /// Potential Results:
  /// - Automatic verification (no need for SMS code): Returns a
  ///   `PhoneVerificationInfo` indicating success.
  /// - SMS code sent: Contains `verificationId` and optionally `resendToken`.
  /// - Auto-retrieval timeout: Contains `verificationId` only.
  ///
  /// Possible Errors:
  /// - `FirebaseAuthException`: In case of verification failure (e.g., invalid
  ///   number, network issues, etc.).
  ///
  Future<DataResult<PhoneVerificationInfo>> sendPhoneVerificationSMS(
    String phoneNumber,
  );

  /// Submits the verification code received via SMS to complete phone number
  /// verification.
  ///
  /// This method takes the `verificationId` (received when the SMS is sent) and
  /// the `smsCode` provided by the user to create a phone authentication
  /// credential. It then attempts to update the phone number of the current
  /// user using this credential.
  ///
  /// - [verificationId]: The ID associated with the verification process, which
  ///   was returned when the verification SMS was originally sent.
  /// - [smsCode]: The SMS code received by the user for verification purposes.
  ///
  /// Returns a `Future<DataResult<void>>`:
  /// - `DataResult.success()` if the operation is successful.
  /// - `DataResult.failure()` if an error occurs during the verification
  ///   process.
  ///
  /// Possible Errors:
  /// - `FirebaseAuthException`: If the verification fails due to an invalid
  ///   code, expired verification ID, or network issues.
  Future<DataResult<void>> submitPhoneVerificationCode(
    String verificationId,
    String smsCode,
  );
}
