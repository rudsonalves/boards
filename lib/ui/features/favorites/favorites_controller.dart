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

import '../../../data/models/ad.dart';
import '../../../core/singletons/current_user.dart';
import '../../../logic/managers/ads_manager.dart';
import '../../../logic/managers/favorites_manager.dart';
import '../../../core/get_it.dart';
import 'favorites_store.dart';

class FavoritesController {
  final FavoritesStore store;

  FavoritesController(this.store) {
    _initialize();
  }

  final currentUser = getIt<CurrentUser>();
  final adManager = getIt<AdsManager>();
  final favManager = getIt<FavoritesManager>();

  List<AdModel> get ads => favManager.ads;

  Future<void> _initialize() async {
    try {
      store.setStateLoading();

      favManager.favNotifier.addListener(_refresh);
      // await currentUser.init();
      store.setStateSuccess();
    } catch (err) {
      final message = 'ShopController._initialize: $err';
      log(message);
      store.setError(message);
    }
  }

  Future<void> reloadAds() async {
    try {
      store.setStateLoading();
      await adManager.getAds();
      store.setStateSuccess();
    } catch (err) {
      final message = 'ShopController._initialize: $err';
      log(message);
      store.setError(message);
    }
  }

  Future<void> getMoreAds() async {}

  Future<void> _refresh() async {
    store.setStateLoading();
    await Future.delayed(const Duration(microseconds: 50));
    store.setStateSuccess();
  }
}
