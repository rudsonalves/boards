// Copyright (C) 2025 Rudson Alves
//
// This file is part of boards.
//
// boards is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// boards is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with boards.  If not, see <https://www.gnu.org/licenses/>.

import 'dart:developer';

import '/core/config/app_info.dart';
import '/data/models/ad.dart';
import '/data/models/filter.dart';
import '/data/models/user.dart';
import '/core/singletons/app_settings.dart';
import '/core/singletons/current_user.dart';
import '/core/singletons/search_filter.dart';
import '/logic/managers/ads_manager.dart';
import '/core/get_it.dart';
import 'shop_store.dart';

class ShopController {
  final app = getIt<AppSettings>();
  final currentUser = getIt<CurrentUser>();
  final searchFilter = getIt<SearchFilter>();
  final adManager = getIt<AdsManager>();

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

  void _initialize() {
    searchFilter.filterNotifier.addListener(getAds);
    searchFilter.searchNotifier.addListener(getAds);
    currentUser.isLogedListernable.addListener(getAds);
    currentUser.isLogedListernable.addListener(setPageTitle);

    reloadAds();
  }

  Future<void> reloadAds() async {
    try {
      store.setStateLoading();
      _getMorePages = await adManager.getAds();
      setPageTitle();
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
