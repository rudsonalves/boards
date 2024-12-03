import 'dart:developer';

import '../../core/models/ad.dart';
import '../../core/singletons/current_user.dart';
import '../../data_managers/ads_manager.dart';
import '../../data_managers/favorites_manager.dart';
import '../../get_it.dart';
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

  Future<void> getMoreAds() async {}

  Future<void> _refresh() async {
    store.setStateLoading();
    await Future.delayed(const Duration(microseconds: 50));
    store.setStateSuccess();
  }
}
