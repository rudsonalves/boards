import '../core/abstracts/data_result.dart';
import '../core/models/ad.dart';
import '../core/models/filter.dart';
import '../core/singletons/search_filter.dart';
import '../get_it.dart';
import '../repository/data/interfaces/i_ad_repository.dart';

class AdManager {
  final adRepository = getIt<IAdRepository>();
  final searchFilter = getIt<SearchFilter>();

  static const maxAdsPerList = 20;

  final List<AdModel> _ads = [];
  List<AdModel> get ads => _ads;

  FilterModel get filter => searchFilter.filter;

  Future<bool> getAds() async {
    bool getMorePages = false;

    final result = await adRepository.get(
      filter: filter,
      search: searchFilter.searchString,
    );
    if (result.isFailure) {
      // FIXME: Complete this error handling
      throw Exception('AdManager._getAds error: ${result.error}');
    }
    final newAds = result.data;
    ads.clear();
    if (newAds != null && newAds.isNotEmpty) {
      ads.addAll(newAds);
      getMorePages = maxAdsPerList == newAds.length;
    } else {
      getMorePages = false;
    }

    return getMorePages;
  }

  Future<bool> getMoreAds(int page) async {
    bool getMorePages = false;

    final result = await adRepository.get(
      filter: filter,
      search: searchFilter.searchString,
      page: page,
    );
    if (result.isFailure) {
      // FIXME: Complete this error handling
      throw Exception('AdManager._getMoreAds error: ${result.error}');
    }
    final newAds = result.data;
    if (newAds != null && newAds.isNotEmpty) {
      ads.addAll(newAds);
      getMorePages = maxAdsPerList == newAds.length;
    } else {
      getMorePages = false;
    }

    return getMorePages;
  }

  /// This method gets the ad with id `adId` from the manager's `_ads` list,
  /// or from the server's database if the ad has not been dowloaded.
  Future<DataResult<AdModel>> getAdById(String adId) async {
    try {
      final ad = _ads.firstWhere((ad) => ad.id == adId);
      return DataResult.success(ad);
    } catch (err) {
      final result = await adRepository.getById(adId);
      return result;
    }
  }
}
