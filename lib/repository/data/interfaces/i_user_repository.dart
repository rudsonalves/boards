import '/core/abstracts/data_result.dart';
import '/core/models/user.dart';

/// Interface for user-related operations, abstracting the underlying data source.
///
/// This interface is designed to allow different implementations for managing user data,
/// such as Parse Server, Firebase, or any other backend. By relying on this interface, the
/// application logic can remain decoupled from specific backend implementations, which
/// facilitates testing, future changes, or substitution of the backend.
abstract class IUserRepository {
  /// Registers a new user in the system.
  ///
  /// Takes a [UserModel] containing user details such as email, password, and name.
  /// Returns a [DataResult] that encapsulates either a successful response with the
  /// created [UserModel] or an error.
  Future<DataResult<UserModel>> signUp(UserModel user);

  /// Signs in a user using email and password.
  ///
  /// Takes a [UserModel] containing user details like email and password.
  /// Returns a [DataResult] that contains the signed-in [UserModel] on success,
  /// or an error in case of failure.
  Future<DataResult<UserModel>> signInWithEmail(UserModel user);

  /// Signs out the currently authenticated user.
  ///
  /// Returns a [DataResult] that indicates whether the operation was successful or not.
  /// This operation may return an error if the user is not signed in or if there's an issue
  /// with the sign-out process.
  Future<DataResult<void>> signOut();

  /// Retrieves the currently authenticated user.
  ///
  /// Returns a [DataResult] containing the [UserModel] of the current user if authenticated.
  /// If the user is not authenticated or the session token is invalid, returns an error.
  Future<DataResult<UserModel>> getCurrentUser();

  /// Updates the details of the currently authenticated user.
  ///
  /// Takes a [UserModel] with updated user information, such as name or phone number.
  /// Returns a [DataResult] that indicates the success or failure of the operation.
  /// Note: Updating the password might require re-authentication.
  Future<DataResult<void>> update(UserModel user);

  Future<DataResult<void>> resetPassword(String email);

  Future<DataResult<void>> removeByEmail(String userEmail);
}
