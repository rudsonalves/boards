import 'package:cloud_firestore/cloud_firestore.dart';

import '../common/constantes.dart';
import '/core/models/ad.dart';
import '/core/models/filter.dart';
import 'common/errors_codes.dart';
import 'common/fb_functions.dart';
import '/repository/data/interfaces/i_ads_repository.dart';
import '../functions/data_functions.dart';
import '/core/abstracts/data_result.dart';

class PaginatedResult<T> {
  final List<T> data;
  final DocumentSnapshot? lastDocument;

  PaginatedResult({required this.data, this.lastDocument});
}

class FbAdsRepository implements IAdsRepository {
  static const keyCollection = 'ads';
  static const keyAdsTitle = 'title';
  static const keyAdsMechanics = 'mechanicsIds';
  static const keyAdsPrice = 'price';
  static const keyAdsCondition = 'condition';
  static const keyAdsCreatedAt = 'createdAt';
  static const keyAdsStatus = 'status';
  static const keyAdsQuantity = 'quantity';
  static const keyAdsOwnerId = 'ownerId';

  CollectionReference<Map<String, dynamic>> get _adsCollection =>
      FirebaseFirestore.instance.collection(keyCollection);

  // Internal pagination
  DocumentSnapshot? _lastFetchedDocument;

  @override
  Future<DataResult<AdModel?>> add(AdModel ad) async {
    try {
      // Upload images
      final images = await FbFunctions.uploadMultImages(ad.images);

      // Update images url
      final newAd = ad.copyWith(images: images);

      // Add ad to Firestore
      final doc = await _adsCollection.add(newAd.toMap()..remove('id'));

      // Return an ad with your id
      return DataResult.success(newAd.copyWith(id: doc.id));
    } catch (err) {
      return _handleError('add', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<void>> delete(String adId) async {
    try {
      await _adsCollection.doc(adId).delete();

      return DataResult.success(null);
    } catch (err) {
      return _handleError('delete', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<List<AdModel>?>> get({
    required FilterModel filter,
    required String search,
    int page = 0,
  }) async {
    try {
      // Reseta pagination to first page
      if (page == 0) {
        _lastFetchedDocument = null;
      }

      // Build the query dynamically based on the provided filters
      Query query = _adsCollection;

      // Apply search filter if the search term is not empty
      if (search.trim().isNotEmpty) {
        query = query.where(keyAdsTitle, arrayContains: search.trim());
      }

      // Apply mechanics filter if there are selected mechanics IDs
      if (filter.mechanicsId.isNotEmpty) {
        query =
            query.where(keyAdsMechanics, arrayContainsAny: filter.mechanicsId);
      }

      // Apply price filters if they are set
      if (filter.minPrice > 0) {
        query =
            query.where(keyAdsPrice, isGreaterThanOrEqualTo: filter.minPrice);
      }
      if (filter.maxPrice > 0) {
        query = query.where(keyAdsPrice, isLessThanOrEqualTo: filter.maxPrice);
      }

      // Apply product condition filter if it is not 'all'
      if (filter.condition != ProductCondition.all) {
        query = query.where(keyAdsCondition, isEqualTo: filter.condition.name);
      }

      // Sort by price or date as specified by the filter
      if (filter.sortBy == SortOrder.price) {
        query.orderBy(keyAdsPrice, descending: false);
      } else {
        query.orderBy(keyAdsCreatedAt, descending: true);
      }

      // Add pagination using startAfterDocument if provided
      if (_lastFetchedDocument != null) {
        query = query.startAfterDocument(_lastFetchedDocument!);
      }

      // Limit results to the page size
      final querySnapshot = await query.limit(docsPerPage).get();

      // Map Firestore documents to AdModel
      final ads = querySnapshot.docs
          .map((doc) => AdModel.fromMap(doc.data() as Map<String, dynamic>)
            ..copyWith(id: doc.id))
          .toList();

      // Update the last document for pagination
      if (querySnapshot.docs.isNotEmpty) {
        _lastFetchedDocument = querySnapshot.docs.last;
      }

      return DataResult.success(ads);
    } catch (err) {
      return _handleError('get', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<List<AdModel>?>> getMyAds({
    required String ownerId,
    required AdStatus status,
  }) async {
    try {
      // Build the query dynamically based on the provided filters
      Query query = _adsCollection;

      final querySnapshot = await query
          .where(keyAdsOwnerId, isEqualTo: ownerId)
          .where(keyAdsStatus, isEqualTo: status.name)
          .limit(docsPerPage)
          .get();

      // Map Firestore documents to AdModel
      final ads = querySnapshot.docs
          .map((doc) => AdModel.fromMap(doc.data() as Map<String, dynamic>)
            ..copyWith(id: doc.id))
          .toList();

      return DataResult.success(ads);
    } catch (err) {
      return _handleError('get', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<AdModel?>> getById(String adId) async {
    try {
      final docSnapshot = await _adsCollection.doc(adId).get();

      if (!docSnapshot.exists) {
        return DataResult.success(null);
      }

      final map = docSnapshot.data()!;
      return DataResult.success(AdModel.fromMap(map)..copyWith(id: adId));
    } catch (err) {
      return _handleError('get', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<AdModel?>> update(AdModel ad) async {
    try {
      final doc = _adsCollection.doc(ad.id);

      await doc.update(ad.toMap()..remove('id'));

      return DataResult.success(null);
    } catch (err) {
      return _handleError('update', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<void>> updateStatus({
    required String adsId,
    required AdStatus status,
    required int quantity,
  }) async {
    try {
      final doc = _adsCollection.doc(adsId);

      await doc.update({
        keyAdsStatus: status.name,
        keyAdsQuantity: quantity,
      });

      return DataResult.success(null);
    } catch (err) {
      return _handleError('update', err, ErrorCodes.unknownError);
    }
  }

  DataResult<T> _handleError<T>(String module, Object err, [int code = 0]) {
    return DataFunctions.handleError<T>('FbAdsRepository', module, err, code);
  }
}
