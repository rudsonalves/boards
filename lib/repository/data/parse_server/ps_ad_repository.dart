import 'dart:io';

import 'package:path/path.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '/repository/data/parse_server/common/ps_functions.dart';
import '/core/abstracts/data_result.dart';
import '/core/models/ad.dart';
import '/core/models/boardgame.dart';
import '/core/models/filter.dart';
import '/core/models/user.dart';
import '../interfaces/i_ad_repository.dart';
import 'common/constants.dart';
import 'common/parse_to_model.dart';

/// This class provides methods to interact with the Parse Server
/// to retrieve and save advertisements.
class PSAdRepository implements IAdRepository {
  @override
  Future<DataResult<void>> moveAdsAddressTo(
    List<String> adsIdList,
    String moveToId,
  ) async {
    try {
      // Create the address object to set the new address for all ads
      final parseAddress = ParseObject(keyAddressTable)..objectId = moveToId;

      // Create a list of futures to perform the updates in parallel
      final List<Future<ParseResponse>> updateFutures = [];

      // For each ad, prepare the update and add the future to the list
      for (String id in adsIdList) {
        final parseAd = ParseObject(keyAdTable)
          ..objectId = id
          ..set(keyAdAddress, parseAddress.toPointer());

        updateFutures.add(parseAd.update());
      }

      // Wait for all updates to complete
      final responses = await Future.wait(updateFutures);

      // Check if all updates were successful
      for (final response in responses) {
        if (!response.success) {
          throw AdRepositoryException(
              response.error?.toString() ?? 'Failed to update ad address');
        }
      }

      return DataResult.success(null);
    } catch (err) {
      return _handleError('moveAdsAddressTo', err);
    }
  }

  @override
  Future<DataResult<List<String>>> adsInAddress(String addressId) async {
    try {
      // Create the address object to use as a filter in the query
      final parseAddress = ParseObject(keyAddressTable)..objectId = addressId;

      // Build the query to find ads associated with the given address
      final query = QueryBuilder<ParseObject>(ParseObject(keyAdTable))
        ..whereEqualTo(keyAdAddress, parseAddress.toPointer());

      // Execute the query
      final response = await query.query();

      // Handle the query response
      if (!response.success) {
        throw AdRepositoryException(
            response.error?.message ?? 'Failed to query ads in address');
      }

      // Extract ad IDs from response results
      final adsId =
          response.results?.map((parse) => parse.objectId as String).toList() ??
              [];

      return DataResult.success(adsId);
    } catch (err) {
      return _handleError('adsInAddress', err);
    }
  }

  @override
  Future<DataResult<bool>> updateStatus(AdModel ad) async {
    try {
      // Create the ad ParseObject with the provided ID to update its status
      final parse = ParseObject(keyAdTable)
        ..objectId = ad.id!
        ..set(keyAdStatus, ad.status.name);

      // Execuet the update operation
      final response = await parse.update();

      // Check if the update was successful
      if (!response.success) {
        throw AdRepositoryException(
            response.error?.message ?? 'Failed to update ad status');
      }

      return DataResult.success(true);
    } catch (err) {
      return _handleError('updateStatus', err);
    }
  }

  @override
  Future<DataResult<List<AdModel>?>> getMyAds(
    UserModel usr,
    String status,
  ) async {
    try {
      // Retrieve the current user from the Parse server
      final parseUser = await ParseUser.currentUser() as ParseUser?;
      if (parseUser == null) {
        throw AdRepositoryException(
            'Current user not found. Please login again.');
      }

      // Create query to get ads associated with the current user and specific status
      final query = QueryBuilder<ParseObject>(ParseObject(keyAdTable))
        ..setLimit(100)
        ..whereEqualTo(keyAdOwner, parseUser.toPointer())
        ..whereEqualTo(keyAdStatus, status)
        ..orderByDescending(keyAdCreatedAt)
        ..includeObject([keyAdOwner, keyAdAddress]);

      // Execute the query
      final response = await query.query();

      // Handle errors in response
      if (!response.success) {
        throw AdRepositoryException(
            response.error?.message ?? 'Failed to fetch user ads.');
      }

      // Convert the results into a list of AdModel objects
      List<AdModel> ads = response.results
              ?.map((parseObject) => ParseToModel.ad(parseObject))
              .whereType<AdModel>()
              .toList() ??
          [];

      return DataResult.success(ads);
    } catch (err) {
      return _handleError('getMyAds', err);
    }
  }

  @override
  Future<DataResult<List<AdModel>?>> get({
    required FilterModel filter,
    required String search,
    bool full = false,
    int page = 0,
  }) async {
    try {
      // Create query for ads from the Parse server
      late QueryBuilder<ParseObject> query;

      if (full) {
        query = QueryBuilder<ParseObject>(ParseObject(keyAdTable))
          ..setAmountToSkip(page * maxAdsPerList)
          ..setLimit(maxAdsPerList)
          ..includeObject([keyAdOwner, keyAdAddress])
          ..whereEqualTo(keyAdStatus, AdStatus.active.name);
      } else {
        query = QueryBuilder<ParseObject>(ParseObject(keyAdTable))
          ..setAmountToSkip(page * maxAdsPerList)
          ..setLimit(maxAdsPerList)
          ..whereEqualTo(keyAdStatus, AdStatus.active.name);
      }

      // Apply search filter if the search term is not empty
      if (search.trim().isNotEmpty) {
        query.whereContains(keyAdTitle, search.trim(), caseSensitive: false);
      }

      // Apply mechanics filter if there are selected mechanics IDs
      if (filter.mechanicsPsId.isNotEmpty) {
        query.whereContainedIn(keyAdMechanics, filter.mechanicsPsId);
      }

      // Apply price filters if they are set
      if (filter.minPrice > 0) {
        query.whereGreaterThanOrEqualsTo(keyAdPrice, filter.minPrice);
      }
      if (filter.maxPrice > 0) {
        query.whereLessThanOrEqualTo(keyAdPrice, filter.maxPrice);
      }

      // Apply product condition filter if it is not 'all'
      if (filter.condition != ProductCondition.all) {
        query.whereEqualTo(keyAdCondition, filter.condition.index);
      }

      // Sort by price or date as specified by the filter
      if (filter.sortBy == SortOrder.price) {
        query.orderByAscending(keyAdPrice);
      } else {
        query.orderByDescending(keyAdCreatedAt);
      }

      // Execute the query
      final response = await query.query();

      // Handle the response
      if (!response.success) {
        throw AdRepositoryException(
            response.error?.message ?? 'Failed to fetch ads.');
      }

      // Convert the results into a list of AdModel objects
      final List<AdModel> ads = response.results
              ?.map((parseObject) => ParseToModel.ad(parseObject))
              .whereType<AdModel>()
              .toList() ??
          [];

      return DataResult.success(ads);
    } catch (err) {
      return _handleError('get', err);
    }
  }

  @override
  Future<DataResult<AdModel>> getById(String id, [bool full = true]) async {
    try {
      // Create query for ads from the Parse server
      late QueryBuilder<ParseObject> query;

      if (full) {
        query = QueryBuilder<ParseObject>(ParseObject(keyAdTable))
          ..includeObject([keyAdOwner, keyAdAddress])
          ..whereEqualTo(keyAdId, id);
      } else {
        query = QueryBuilder<ParseObject>(ParseObject(keyAdTable))
          ..whereEqualTo(keyAdId, id);
      }

      // Execute the query
      final response = await query.query();

      // Handle the response
      if (!response.success) {
        throw AdRepositoryException(
            response.error?.message ?? 'Failed to fetch ads.');
      }

      // Convert the results into a AdModel objects
      final AdModel? ad = ParseToModel.ad(
        response.results!.first as ParseObject,
      );
      if (ad == null) {
        throw Exception('Convert parse to AdModel error');
      }

      return DataResult.success(ad);
    } catch (err) {
      return _handleError('getById', err);
    }
  }

  @override
  Future<DataResult<AdModel?>> save(AdModel ad) async {
    try {
      final parseUser = await PsFunctions.parseCurrentUser();
      final List<ParseFile> parseImages =
          await _saveImages(ad.images, parseUser);
      final parseAddress = _parseAddress(ad.address!.id!);
      final parseBoardgame = _parseBoardgame(ad.boardgame);
      final parseAcl = PsFunctions.createDefaultAcl(parseUser);

      final parseAd = _prepareAdForSaveOrUpdate(
        ad: ad,
        parseUser: parseUser,
        parseImages: parseImages,
        parseAddress: parseAddress,
        parseBoardgame: parseBoardgame,
        parseAcl: parseAcl,
      );

      final response = await parseAd.save();
      if (!response.success) {
        throw AdRepositoryException(
            response.error?.message ?? 'Failed to save ad.');
      }

      return DataResult.success(ad.copyWith(id: parseAd.objectId));
    } catch (err) {
      return _handleError<AdModel?>('save', err);
    }
  }

  @override
  Future<DataResult<AdModel?>> update(AdModel ad) async {
    try {
      final parseUser = await PsFunctions.parseCurrentUser();
      final List<ParseFile> parseImages =
          await _saveImages(ad.images, parseUser);
      final parseAddress = _parseAddress(ad.address!.id!);
      final parseBoardgame = _parseBoardgame(ad.boardgame);

      final parseAd = _prepareAdForSaveOrUpdate(
        ad: ad,
        parseUser: parseUser,
        parseImages: parseImages,
        parseAddress: parseAddress,
        parseBoardgame: parseBoardgame,
      );

      final response = await parseAd.update();
      if (!response.success) {
        throw AdRepositoryException(
            response.error?.message ?? 'Failed to update ad.');
      }

      return DataResult.success(ad);
    } catch (err) {
      return _handleError('update', err);
    }
  }

  @override
  Future<DataResult<void>> delete(String id) async {
    try {
      // Create a ParseObject representing the advertisement to be deleted
      final parse = ParseObject(keyAdTable)..objectId = id;

      // Attempt to delete the object from the Parse Server
      final response = await parse.delete();

      // Check if the response is successful
      if (!response.success) {
        throw AdRepositoryException(
            response.error?.toString() ?? 'delete ad table error');
      }
      return DataResult.success(null);
    } catch (err) {
      return _handleError('delete', err);
    }
  }

  /// Prepares a ParseObject for saving or updating an ad.
  ///
  /// [ad] - The AdModel with ad information.
  /// [parseUser] - The current Parse user, used for ACL.
  /// [parseImages] - The list of ParseFiles representing the ad images.
  /// [parseAddress] - The ParseObject representing the address of the ad.
  /// [parseBoardgame] - The ParseObject representing the board game of the ad.
  /// [parseAcl] - Optional ACL for the ad.
  ParseObject _prepareAdForSaveOrUpdate({
    required AdModel ad,
    required ParseUser parseUser,
    required List<ParseFile> parseImages,
    required ParseObject parseAddress,
    ParseObject? parseBoardgame,
    ParseACL? parseAcl,
  }) {
    final parseAd = ParseObject(keyAdTable);
    if (ad.id != null) {
      parseAd.objectId = ad.id!;
    }

    if (parseAcl != null) {
      parseAd.setACL(parseAcl);
    }

    final shortAddress = '${ad.address!.city} - ${ad.address!.state}';

    parseAd
      ..setNonNull<ParseUser>(keyAdOwner, parseUser)
      ..setNonNull<String>(keyAdOwnerId, ad.owner!.id)
      ..setNonNull<String>(keyAdOwnerName, ad.owner!.name)
      // FIXME: fazer o rate de usuário
      ..setNonNull<double>(keyAdOwnerRate, 4.5)
      ..setNonNull<String>(keyAdOwnerCity, shortAddress)
      ..setNonNull<DateTime>(keyAdOwnerCreatedAt, ad.owner!.createdAt)
      ..setNonNull<String>(keyAdTitle, ad.title)
      ..setNonNull<String>(keyAdDescription, ad.description)
      ..setNonNull<double>(keyAdPrice, ad.price)
      ..setNonNull<int>(keyAdQuantity, ad.quantity)
      ..setNonNull<String>(keyAdStatus, ad.status.name)
      ..setNonNull<String>(keyAdCondition, ad.condition.name)
      ..setNonNull<ParseObject>(keyAdAddress, parseAddress)
      ..setNonNull<List<ParseFile>>(keyAdImages, parseImages)
      ..setNonNull<List<String>>(keyAdMechanics, ad.mechanicsIds);

    if (parseBoardgame != null) {
      parseAd.setNonNull<ParseObject>(keyAdBoardGame, parseBoardgame);
    }

    return parseAd;
  }

  /// Saves the images to the Parse Server.
  ///
  /// [imagesPaths] - The list of image paths to save.
  /// [parseUser] - The current Parse user.
  /// Returns a list of `ParseFile` representing the saved images.
  /// Throws an exception if the save operation fails.
  Future<List<ParseFile>> _saveImages(
    List<String> imagesPaths,
    ParseUser parseUser,
  ) async {
    final parseImages = <ParseFile>[];

    try {
      for (final path in imagesPaths) {
        // Check if the path is a local file path or an existing URL
        if (!path.startsWith('http')) {
          // Create ParseFile from the local file path
          final parseFile = ParseFile(File(path), name: basename(path));
          parseFile.setACL(PsFunctions.createDefaultAcl(parseUser));

          // Save the file to the Parse server
          final response = await parseFile.save();

          if (!response.success || parseFile.url == null) {
            throw AdRepositoryException(
                response.error?.message ?? 'Failed to save file: $path');
          }

          parseImages.add(parseFile);
        } else {
          // If it's already a URL, create a ParseFile pointing to that URL
          parseImages.add(ParseFile(null, name: basename(path), url: path));
        }
      }

      return parseImages;
    } catch (err) {
      throw AdRepositoryException('_saveImages: $err');
    }
  }

  /// Returns a ParseObject for the provided board game, or null if no board game is provided.
  ///
  /// [boardgame] - The board game model to convert into a ParseObject.
  /// If the boardgame is null, this function returns null.
  ParseObject? _parseBoardgame(BoardgameModel? boardgame) {
    if (boardgame != null) {
      return ParseObject(keyBgTable)..objectId = boardgame.id;
    } else {
      return null;
    }
  }

  /// Returns a ParseObject for the provided address ID.
  ///
  /// [id] - The ID of the address that needs to be represented as a ParseObject.
  ParseObject _parseAddress(String id) {
    return ParseObject(keyAddressTable)..objectId = id;
  }

  DataResult<T> _handleError<T>(String module, Object error) {
    return PsFunctions.handleError('PSAdRepository', module, error);
  }
}
