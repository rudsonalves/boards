import 'package:cloud_firestore/cloud_firestore.dart';

import '../common/constantes.dart';
import '/core/models/ad.dart';
import '/core/models/filter.dart';
import 'common/errors_codes.dart';
import 'common/fb_functions.dart';
import '/repository/data/interfaces/i_ads_repository.dart';
import '../functions/data_functions.dart';
import '/core/abstracts/data_result.dart';

class FbAdsRepository implements IAdsRepository {
  static const keyCollection = 'ads';
  static const keyAdsTitle = 'title';
  static const keyAdsMechanics = 'mechanicsIds';
  static const keyAdsPrice = 'price';
  static const keyAdsCondition = 'condition';
  static const keyAdsCreatedAt = 'createdAt';
  static const keyAdsStatus = 'status';
  static const keyAdsQuantity = 'quantity';

  CollectionReference<Map<String, dynamic>> get _adsCollection =>
      FirebaseFirestore.instance.collection(keyCollection);

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
      // Calculates how many documents to ignore based on the current page
      final offSet = page * docsPerPage;

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

      final querySnapshot =
          await query.startAt([offSet]).limit(docsPerPage).get();

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
  Future<DataResult<void>> updateStatus(AdModel ad) async {
    try {
      final doc = _adsCollection.doc(ad.id);

      await doc.update({
        keyAdsStatus: ad.status.name,
        keyAdsQuantity: ad.quantity,
      });

      return DataResult.success(null);
    } catch (err) {
      return _handleError('update', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<List<AdModel>?>> getMyAds(String userId, String status) {
    // TODO: implement moveAdsAddressTo
    throw UnimplementedError();
  }

  // @override
  // Future<DataResult<void>> moveAdsAddressTo(
  //     List<String> adsIdList, String moveToId) {
  //   // TODO: implement moveAdsAddressTo
  //   throw UnimplementedError();
  // }

  DataResult<T> _handleError<T>(String module, Object err, [int code = 0]) {
    return DataFunctions.handleError<T>('FbAdsRepository', module, err, code);
  }
}
