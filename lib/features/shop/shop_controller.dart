import 'dart:developer';

import '../../core/config/app_info.dart';
import '../../core/models/ad.dart';
import '../../core/models/filter.dart';
import '../../core/models/user.dart';
import '../../core/singletons/app_settings.dart';
import '../../core/singletons/current_user.dart';
import '../../core/singletons/search_filter.dart';
import '../../data_managers/ad_manager.dart';
import '../../get_it.dart';
import '../../repository/data/interfaces/i_ad_repository.dart';
import 'shop_store.dart';

class ShopController {
  final app = getIt<AppSettings>();
  final currentUser = getIt<CurrentUser>();
  final searchFilter = getIt<SearchFilter>();
  final adRepository = getIt<IAdRepository>();
  final adManager = getIt<AdManager>();

  late final ShopStore store;

  List<AdModel> get ads => adManager.ads;

  int _adsPage = 0;
  bool _getMorePages = true;
  bool get getMorePages => _getMorePages;

  bool get isDark => app.isDark;
  bool get isLogged => currentUser.isLogged;
  UserModel? get user => currentUser.user;
  FilterModel get filter => searchFilter.filter;
  String get searchString => searchFilter.searchString;

  bool get haveSearch => searchFilter.searchString.isNotEmpty;
  bool get haveFilter => searchFilter.haveFilter;

  set filter(FilterModel newFilter) {
    searchFilter.updateFilter(newFilter);
    _getMorePages = true;
  }

  void init(ShopStore store) {
    this.store = store;
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      store.setStateLoading();
      _getMorePages = await adManager.getAds();
      setPageTitle();
      searchFilter.filterNotifier.addListener(getAds);
      searchFilter.searchNotifier.addListener(getAds);
      currentUser.isLogedListernable.addListener(getAds);
      currentUser.isLogedListernable.addListener(setPageTitle);

      store.setStateSuccess();
    } catch (err) {
      final message = 'ShopController._initialize: $err';
      log(message);
      store.setError(message);
    }
  }

  void setPageTitle() {
    store.setPageTitle(
      searchFilter.searchString.isNotEmpty
          ? searchFilter.searchString
          : user == null
              ? AppInfo.name
              : user!.name!,
    );
  }

  void setSearch(String value) {
    searchFilter.searchString = value;
    setPageTitle();
  }

  void cleanSearch() {
    setSearch('');
    filter = FilterModel();
  }

  Future<void> getAds() async {
    try {
      store.setStateLoading();
      // await _getAds();
      _getMorePages = await adManager.getAds();
      _adsPage = 0;
      store.setStateSuccess();
    } catch (err) {
      final message = 'ShopController.getAds: $err';
      log(message);
      store.setError(message);
    }
  }

  Future<void> getMoreAds() async {
    if (!_getMorePages) return;
    _adsPage++;
    try {
      store.setStateLoading();
      // await _getMoreAds();
      _getMorePages = await adManager.getMoreAds(_adsPage);
      await Future.delayed(const Duration(microseconds: 100));
      store.setStateSuccess();
    } catch (err) {
      final message = 'ShopController.getMoreAds: $err';
      log(message);
      store.setError(message);
    }
  }

  void closeErroMessage() {
    store.setStateSuccess();
  }
}
