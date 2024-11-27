import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../core/models/ad.dart';
import '../core/models/favorite.dart';
import '../core/singletons/current_user.dart';
import '../get_it.dart';
import '../repository/data/interfaces/i_favorite_repository.dart';
import '../repository/data/parse_server/ps_favorite_repository.dart';

class FavoritesManager {
  final favoriteRepository = getIt<IFavoriteRepository>();

  final List<FavoriteModel> _favs = [];
  final List<AdModel> _ads = [];
  final List<String> _favIds = [];

  List<FavoriteModel> get favs => _favs;
  List<String> get favAdIds => _favIds;
  bool get isLogged => getIt<CurrentUser>().isLogged;
  String? get userId => getIt<CurrentUser>().userId;
  List<AdModel> get ads => _ads;

  final favNotifier = ValueNotifier<bool>(true);

  void dispose() {
    favNotifier.dispose();
  }

  Future<void> login() async {
    if (isLogged) {
      await getFavorites();
    }
  }

  void _toggleFavNotifier() {
    favNotifier.value = !favNotifier.value;
  }

  Future<void> logout() async {
    if (isLogged) {
      _favs.clear();
      _ads.clear();
      _favIds.clear();
      _toggleFavNotifier();
    }
  }

  Future<void> getFavorites() async {
    try {
      final List<AdModel> ads;
      final List<FavoriteModel> favs;
      (ads, favs) = await PSFavoriteRepository.getFavorites(userId!);

      _ads.clear();
      _favs.clear();
      _favIds.clear();
      if (ads.isNotEmpty) {
        _ads.addAll(ads);
        _favs.addAll(favs);
        _favIds.addAll(_favs.map((fav) => fav.adId));
      }
      _toggleFavNotifier();
    } catch (err) {
      log('Error fetching favorites: $err');
    }
  }

  Future<void> toggleAdFav(AdModel ad) async {
    if (_favIds.contains(ad.id!)) {
      _remove(ad);
    } else {
      _add(ad);
    }
  }

  Future<void> _add(AdModel ad) async {
    try {
      final fav = await favoriteRepository.add(userId!, ad.id!);

      if (fav != null) {
        _ads.add(ad);
        _favs.add(fav);
        _favIds.add(ad.id!);
        _toggleFavNotifier();
      }
    } catch (err) {
      log('Error fetching favorites: $err');
    }
  }

  Future<void> _remove(AdModel ad) async {
    try {
      final favId = _getFavId(ad);
      if (favId != null) {
        await favoriteRepository.delete(favId);
        _favs.removeWhere((f) => f.adId == ad.id);
        _ads.removeWhere((a) => a.id == ad.id);
        _favIds.removeWhere((id) => id == ad.id);
        _toggleFavNotifier();
      }
    } catch (err) {
      log('Error fetching favorites: $err');
    }
  }

  String? _getFavId(ad) {
    return _favs
        .firstWhere(
          (f) => f.adId == ad.id,
          orElse: () => FavoriteModel(adId: ''),
        )
        .id;
  }
}
