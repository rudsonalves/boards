import '/core/models/favorite.dart';

abstract class IFavoriteRepository {
  Future<FavoriteModel?> add(String userId, String adId);
  Future<void> delete(String favId);
}
