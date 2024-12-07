import '/core/abstracts/data_result.dart';
import '/core/models/ad.dart';
import '/core/models/filter.dart';

class AdsRepositoryException implements Exception {
  final String message;
  AdsRepositoryException(this.message);

  @override
  String toString() => 'AdRepositoryException: $message';
}

/// An interface that defines the contract for interacting with advertisement data.
///
/// The `IAdRepository` abstract class provides the blueprint for all
/// advertisement repository implementations. It defines a set of methods that
/// are essential for managing advertisements, including creating, updating,
/// deleting, and retrieving advertisements, as well as updating their statuses
/// and managing relationships with other data entities such as addresses and
/// users.
///
/// This interface is designed to be implemented by repository classes that
/// interact with various data sources, such as a backend service, a local
/// database, or an in-memory cache.
///
/// The interface aims to keep the advertisement logic abstracted away from the
/// business logic, allowing for flexibility and scalability in the application
/// architecture.
abstract class IAdsRepository {
  /// Adds a new ad to Firestore.
  ///
  /// - Uploads images associated with the ad.
  /// - Updates the ad object with the uploaded image URLs.
  /// - Saves the ad to Firestore with an automatically generated ID.
  ///
  /// Returns:
  /// - [DataResult<AdModel?>]: Contains the saved ad with its Firestore ID.
  Future<DataResult<AdModel?>> add(AdModel ad);

  /// Retrieves ads from Firestore based on filters, search term, and pagination.
  ///
  /// - [filter]: A [FilterModel] containing filtering criteria.
  /// - [search]: A search term to filter ads by title.
  /// - [page]: Page number for pagination.
  ///
  /// Returns:
  /// - [DataResult<List<AdModel>?>]: A list of ads matching the filters.
  Future<DataResult<List<AdModel>?>> get({
    required FilterModel filter,
    required String search,
    int page = 0,
  });

  /// Retrieves a specific ad by its Firestore ID.
  ///
  /// - [adId]: The Firestore ID of the ad.
  ///
  /// Returns:
  /// - [DataResult<AdModel?>]: The ad if found, or null if it doesn't exist.
  Future<DataResult<AdModel?>> getById(String id);

  /// Retrieves ads created by a specific owner and filtered by status.
  ///
  /// - [ownerId]: The ID of the owner.
  /// - [status]: The desired status of the ads.
  ///
  /// Returns:
  /// - [DataResult<List<AdModel>?>]: A list of ads matching the filters.
  Future<DataResult<List<AdModel>?>> getMyAds({
    required String ownerId,
    required AdStatus status,
  });

  /// Updates an existing ad in Firestore.
  ///
  /// - [ad]: The ad object containing updated information.
  ///
  /// Returns:
  /// - [DataResult<AdModel?>]: Indicates success or failure of the operation.
  Future<DataResult<AdModel?>> update(AdModel ad);

  /// Updates the status and quantity of an ad in Firestore.
  ///
  /// - [adsId]: The Firestore ID of the ad.
  /// - [status]: The new status of the ad.
  /// - [quantity]: The new quantity of the ad.
  ///
  /// Returns:
  /// - [DataResult<void>]: Indicates success or failure of the operation.
  Future<DataResult<void>> updateStatus({
    required String adsId,
    required AdStatus status,
    required int quantity,
  });

  /// Deletes an ad from Firestore by its ID.
  ///
  /// - [adId]: The Firestore ID of the ad to be deleted.
  ///
  /// Returns:
  /// - [DataResult<void>]: Indicates success or failure of the operation.
  Future<DataResult<void>> delete(String ad);
}
