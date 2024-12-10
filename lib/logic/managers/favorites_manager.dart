import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../data/models/ad.dart';
import '../../data/models/favorite.dart';
import '../../core/singletons/current_user.dart';
import '../../core/get_it.dart';
import '../../data/repository/interfaces/remote/i_favorite_repository.dart';
import 'ads_manager.dart';

class FavoritesManager {
  final favoriteRepository = getIt<IFavoriteRepository>();
  final adsManager = getIt<AdsManager>();

  final List<FavoriteModel> _favs = [];
  final List<AdModel> _ads = [];

  List<FavoriteModel> get favs => _favs;
  List<String> get favAdIds => _favs.map((fav) => fav.adId).toList();
  bool get isLogged => getIt<CurrentUser>().isLogged;
  String? get userId => getIt<CurrentUser>().userId;
  List<AdModel> get ads => _ads;

  final favNotifier = ValueNotifier<bool>(true);

  void dispose() {
    favNotifier.dispose();
  }

  Future<void> login() async {
    if (isLogged) {
      favoriteRepository.initialize(userId);
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
      _toggleFavNotifier();
    }
  }

  Future<void> getFavorites() async {
    try {
      final result = await favoriteRepository.getAll();
      if (result.isFailure) {
        throw Exception(result.error ?? 'unknow error');
      }
      final favs = result.isSuccess ? result.data! : <FavoriteModel>[];

      final List<AdModel> ads = [];
      final Iterable<String> favAdIds = favs.map((fav) => fav.adId);
      for (final adId in favAdIds) {
        final result = await adsManager.getAdById(adId);
        if (result.isFailure || result.data == null) {
          log(result.error?.toString() ??
              'adRepository.getById($adId) unknow error');
          continue;
        }
        final ad = result.data!;
        // Only active ads can be favorited
        if (ad.status == AdStatus.active) {
          ads.add(ad);
        } else {
          // Remove fav ad if ad.status != AdStatus.active
          final removeFavId = favs.firstWhere((fav) => fav.adId == ad.id).id;
          final result = await favoriteRepository.delete(removeFavId!);
          if (result.isFailure) {
            log(result.error?.toString() ??
                'adRepository.getById($adId) unknow error');
          }
        }
      }

      _ads.clear();
      _favs.clear();
      if (ads.isNotEmpty) {
        _ads.addAll(ads);
        _favs.addAll(favs);
      }
      _toggleFavNotifier();
    } catch (err) {
      log('Error fetching favorites: $err');
    }
  }

  Future<void> toggleAdFav(AdModel ad) async {
    if (favAdIds.contains(ad.id!)) {
      _remove(ad);
    } else {
      _add(ad);
    }
  }

  Future<void> _add(AdModel ad) async {
    try {
      final favorite = FavoriteModel(adId: ad.id!, userId: userId!);
      final result = await favoriteRepository.add(favorite);
      if (result.isFailure || result.data == null) {
        throw Exception(
            result.error?.toString() ?? '_add new favotire ad error');
      }

      final fav = result.data!;

      _ads.add(ad);
      _favs.add(fav);
      _toggleFavNotifier();
    } catch (err) {
      log('Error fetching favorites: $err');
    }
  }

  Future<void> _remove(AdModel ad) async {
    try {
      final favId = _getFavId(ad);
      if (favId != null) {
        final result = await favoriteRepository.delete(favId);
        if (result.isFailure) {
          throw Exception(
              result.error?.toString() ?? '_remove favotire ad error');
        }

        _favs.removeWhere((fav) => fav.adId == ad.id);
        _ads.removeWhere((a) => a.id == ad.id);
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
          orElse: () => FavoriteModel(adId: '', userId: ''),
        )
        .id;
  }
}
