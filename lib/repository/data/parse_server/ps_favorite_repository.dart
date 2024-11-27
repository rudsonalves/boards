import 'dart:developer';

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '/core/models/ad.dart';
import '/core/models/favorite.dart';
import '../interfaces/i_favorite_repository.dart';
import 'common/constants.dart';
import 'common/parse_to_model.dart';

class PSFavoriteRepository implements IFavoriteRepository {
  @override
  Future<FavoriteModel?> add(String userId, String adId) async {
    try {
      final parseFav = ParseObject(keyFavoriteTable);
      final parseAd = ParseObject(keyAdTable)..objectId = adId;

      parseFav
        ..setNonNull(keyFavoriteOwner, userId)
        ..setNonNull(keyFavoriteAd, parseAd.toPointer());

      final response = await parseFav.save();
      if (!response.success) {
        throw Exception(response.error?.message ?? 'unknown error');
      }

      if (response.results == null || response.results!.isEmpty) {
        throw Exception('No results returned from save operation');
      }

      final savedFav = response.results!.first as ParseObject;
      log('Saved Favorite: ${savedFav.get(keyFavoriteAd).runtimeType}');

      return ParseToModel.favorite(savedFav);
    } catch (err) {
      final message = 'FavoriteRepository.add: $err';
      log(message);
      return null;
    }
  }

  @override
  Future<void> delete(String favId) async {
    try {
      final parseFav = ParseObject(keyFavoriteTable)..objectId = favId;

      final response = await parseFav.delete();
      if (!response.success) {
        throw Exception(response.error?.message ?? 'unknown error');
      }
    } catch (err) {
      final message = 'FavoriteRepository.delete: $err';
      log(message);
      throw Exception(message);
    }
  }

  static Future<(List<AdModel>, List<FavoriteModel>)> getFavorites(
      String userId) async {
    try {
      final parseFav = ParseObject(keyFavoriteTable);

      final query = QueryBuilder<ParseObject>(parseFav);

      query
        ..includeObject([keyFavoriteAd])
        ..includeObject([
          '$keyFavoriteAd.$keyAdOwner',
          '$keyFavoriteAd.$keyAdAddress',
          '$keyFavoriteAd.$keyAdMechanics',
        ])
        ..whereEqualTo(keyFavoriteOwner, userId);

      final response = await query.query();
      if (!response.success) {
        throw Exception(response.error?.message ?? 'unknow error!');
      }

      if (response.results == null) {
        return (<AdModel>[], <FavoriteModel>[]);
      }

      List<AdModel> ads = [];
      List<FavoriteModel> favs = [];
      for (final ParseObject parseFav in response.results!) {
        final fav = ParseToModel.favorite(parseFav);
        final parseAd = parseFav.get(keyFavoriteAd) as ParseObject?;
        if (parseAd != null) {
          final adModel = ParseToModel.ad(parseAd);
          if (adModel != null) {
            ads.add(adModel);
            favs.add(fav);
          }
        }
      }
      return (ads, favs);
    } catch (err) {
      final message = 'FavoriteRepository.getAdsFavorites: $err';
      log(message);
      return (<AdModel>[], <FavoriteModel>[]);
    }
  }
}
