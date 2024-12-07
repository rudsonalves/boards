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
/// Example:
/// ```dart
/// class PSAdRepository implements IAdRepository {
///   // Implementation of methods to interact with Parse Server.
/// }
/// ```
///
/// The interface aims to keep the advertisement logic abstracted away from the
/// business logic, allowing for flexibility and scalability in the application
/// architecture.
abstract class IAdsRepository {
  /// Moves multiple advertisements to a new address by updating the associated
  /// address ID.
  ///
  /// This method takes a list of advertisement IDs (`adsIdList`) and assigns
  /// them all to a new address (`moveToId`). It does this by creating a
  /// `ParseObject` for each ad, updating its address to point to the new
  /// address, and then executing all updates in parallel.
  ///
  /// [adsIdList] - A list of advertisement IDs that need to have their address
  ///   updated.
  /// [moveToId] - The ID of the new address to which all advertisements will be
  ///   moved.
  ///
  /// Returns:
  /// - A `DataResult<void>` indicating success if all updates were completed
  ///   successfully.
  ///
  /// Throws:
  /// - `AdRepositoryException` if any of the updates fail, including an
  ///   appropriate error message.
  ///
  // Future<DataResult<void>> moveAdsAddressTo(List<String> adsIdList, String moveToId);

  /// Fetches a list of advertisement IDs that are associated with a specific
  /// address.
  ///
  /// This method queries the Parse Server to find all advertisements linked to
  /// the specified address. It returns the list of advertisement IDs, which
  /// can be used to further interact with or display the ads.
  ///
  /// [addressId] - The unique identifier of the address to filter ads by.
  ///
  /// Returns:
  /// - A `DataResult<List<String>>` containing a list of ad IDs if the query is
  ///   successful. Otherwise, it returns an appropriate failure message.
  ///
  /// Throws:
  /// - `AdRepositoryException` if the query operation fails, with a message
  ///   detailing the issue.
  ///
  // Future<DataResult<List<String>>> adsInAddress(String addressId);

  /// Updates the status of an existing advertisement in the Parse Server.
  ///
  /// This method takes an `AdModel` representing the advertisement whose status
  /// needs to be updated. It creates a `ParseObject` for the specific
  /// advertisement using its unique ID (`objectId`), and then attempts to
  /// update the status field in the Parse Server database.
  ///
  /// [ad] - The `AdModel` instance that contains the updated status information
  ///   and advertisement ID.
  ///
  /// Returns:
  /// - A `DataResult<bool>` indicating whether the update operation was
  ///   successful. If successful, it returns `true`.
  ///
  /// Throws:
  /// - `AdRepositoryException` if the update operation fails, including an
  ///   error message detailing the issue.
  ///
  Future<DataResult<void>> updateStatus(AdModel ad);

  /// Fetches a list of advertisements associated with the current user and a
  /// specific status.
  ///
  /// This method is designed to fetch advertisements from the Parse Server that
  /// belong to the current logged-in user. It filters the ads based on a given
  /// status, such as "active", "sold", or "pending". It also includes related
  /// objects like the advertisement owner and address.
  ///
  /// [usr] - The `UserModel` instance representing the user requesting the ads.
  /// [status] - The status of the advertisements to filter by, represented as
  ///   an string.
  ///
  /// Returns:
  /// - A `DataResult<List<AdModel>?>` that contains the user's advertisements
  ///   if successful, or an appropriate failure message if not.
  ///
  /// Throws:
  /// - `AdRepositoryException` if the query fails, indicating an issue with
  ///   fetching the user ads.
  ///
  Future<DataResult<List<AdModel>?>> getMyAds(String userId, String status);

  /// Fetches a list of advertisements from the Parse Server based on the
  /// provided filters and search string.
  ///
  /// This method allows the client to retrieve advertisements with several
  /// optional filters, including mechanics, price range, product condition,
  /// and search term. Pagination is supported through the `page` parameter.
  /// Sorting can be done either by date or by price.
  ///
  /// [filter] - The `FilterModel` used to apply different conditions like
  ///   price, product condition, etc.
  /// [search] - A search term used to filter advertisements by title.
  /// [page] - The page number for pagination, used to retrieve ads in chunks
  ///   (default is 0).
  ///
  /// Returns:
  /// - A `DataResult<List<AdModel>?>` that contains a list of advertisements
  ///   if successful, or an appropriate failure message if not.
  ///
  /// Throws:
  /// - `AdRepositoryException` if the query operation fails.
  ///
  Future<DataResult<List<AdModel>?>> get(
      {required FilterModel filter, required String search, int page = 0});

  /// Saves a new advertisement to the Parse Server.
  ///
  /// This method takes an `AdModel` that represents the advertisement to be
  /// saved and attempts to save the data to the Parse Server. It includes steps
  /// to process related entities such as user information, images, address, and
  /// boardgame data. If the operation fails, an `AdRepositoryException` is
  /// thrown, and errors are handled accordingly.
  ///
  /// [ad] - The `AdModel` instance containing the data of the ad to be saved.
  ///
  /// Returns:
  /// - A `DataResult<AdModel?>` indicating whether the save operation was
  ///   successful. On success, it returns the saved `AdModel`.
  ///
  /// Throws:
  /// - `AdRepositoryException` if the save operation fails with an appropriate
  ///   error message.
  ///
  Future<DataResult<AdModel?>> add(AdModel ad);

  /// Updates an existing advertisement in the Parse Server.
  ///
  /// This method takes an `AdModel` representing the advertisement to be
  /// updated and attempts to save the updated information in the Parse Server.
  /// It first retrieves the current user, prepares any images to be saved,
  /// and then updates the advertisement with the new data. If the operation
  /// fails, an `AdRepositoryException` is thrown, and errors are handled
  /// accordingly.
  ///
  /// [ad] - The `AdModel` instance containing the updated information of the
  ///   ad.
  ///
  /// Returns:
  /// - A `DataResult<AdModel?>` indicating whether the update was successful.
  ///   On success, it returns the updated `AdModel`.
  ///
  /// Throws:
  /// - `AdRepositoryException` if the update fails with an appropriate error
  ///   message.
  ///
  Future<DataResult<AdModel?>> update(AdModel ad);

  /// Deletes an advertisement from the Parse Server.
  ///
  /// This method attempts to delete a specific advertisement from the
  /// Parse Server database using its unique ID. If the deletion is successful,
  /// it returns a successful `DataResult` with a `null` value. If there is an
  /// error during the deletion process, an `AdRepositoryException` is thrown,
  /// and the error is handled accordingly.
  ///
  /// [ad] - The unique identifier (objectId) of the advertisement to be
  ///   deleted.
  ///
  /// Returns a `DataResult<void>` which indicates the success or failure of
  /// the operation. If successful, returns a `DataResult.success(null)`.
  ///
  /// Throws:
  /// - `AdRepositoryException` if the deletion fails, with the error message
  ///   received from the Parse Server.
  ///
  Future<DataResult<void>> delete(String ad);

  Future<DataResult<AdModel?>> getById(String id);
}
