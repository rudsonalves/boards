import 'dart:developer';

import '../../../repository/data/common/constantes.dart';
import '/core/models/ad.dart';
import '/core/models/filter.dart';
import '/core/singletons/current_user.dart';
import '/get_it.dart';
import '../../../repository/data/interfaces/i_ads_repository.dart';
import 'my_ads_store.dart';

class MyAdsController {
  late final MyAdsStore store;

  final adRepository = getIt<IAdsRepository>();

  final currentUser = getIt<CurrentUser>().user!;

  AdStatus _productStatus = AdStatus.active;
  AdStatus get productStatus => _productStatus;

  int _adsDataBasePage = 0;

  final List<AdModel> _ads = [];
  List<AdModel> get ads => _ads;

  bool _getMorePages = true;
  bool get getMorePages => _getMorePages;

  void init(MyAdsStore store) {
    this.store = store;

    setProductStatus(AdStatus.active);
  }

  Future<void> getAds() async {
    try {
      store.setStateLoading();
      await _getAds();
      store.setStateSuccess();
    } catch (err) {
      final message = err.toString();
      log(message);
      store.setError(message);
    }
  }

  Future<void> _getAds() async {
    final result = await adRepository.getMyAds(
      currentUser.id!,
      _productStatus.name,
    );
    if (result.isFailure) {
      // FIXME: Complete this error handling
      throw Exception('MyAdsController.getAds error: ${result.error}');
    }
    final newAds = result.data;
    _adsDataBasePage = 0;
    ads.clear();
    if (newAds != null && newAds.isNotEmpty) {
      ads.addAll(newAds);
      _getMorePages = docsPerPage == newAds.length;
    } else {
      _getMorePages = false;
    }
  }

  void setProductStatus(AdStatus newStatus) {
    _productStatus = newStatus;
    getAds();
  }

  Future<void> getMoreAds() async {
    if (!_getMorePages) return;
    try {
      store.setStateLoading();
      await _getMoreAds();
      store.setStateSuccess();
    } catch (err) {
      final message = err.toString();
      log(message);
      store.setError(message);
    }
  }

  Future<void> _getMoreAds() async {
    _adsDataBasePage++;
    final result = await adRepository.get(
      filter: FilterModel(),
      search: '',
      page: _adsDataBasePage,
    );
    if (result.isFailure) {
      // FIXME: Complete this error handling
      throw Exception('MyAdsController._getMoreAds error: ${result.error}');
    }
    final newAds = result.data;
    if (newAds != null && newAds.isNotEmpty) {
      ads.addAll(newAds);
      _getMorePages = docsPerPage == newAds.length;
    } else {
      _getMorePages = false;
    }
  }

  Future<bool> updateAdStatus(AdModel ad) async {
    int currentPage = _adsDataBasePage;
    try {
      store.setStateLoading();
      final result = await adRepository.updateStatus(ad);
      if (result.isFailure) {
        throw Exception(result.error);
      }
      await _getAds();
      while (currentPage > 0) {
        await _getMoreAds();
        currentPage--;
      }
      store.setStateSuccess();
      return true;
    } catch (err) {
      final message = 'MyAdsController.updateAdStatus error: $err';
      log(message);
      store.setError(message);
      return false;
    }
  }

  void updateAd(AdModel ad) {
    getAds();
  }

  Future<void> deleteAd(AdModel ad) async {
    try {
      store.setStateLoading();
      ad.status = AdStatus.deleted;
      await adRepository.updateStatus(ad);
      await _getAds();
      store.setStateSuccess();
    } catch (err) {
      final message = 'MyAdsController.deleteAd error: $err';
      log(message);
      store.setError(message);
    }
  }

  void closeErroMessage() {
    store.setStateSuccess();
  }
}
