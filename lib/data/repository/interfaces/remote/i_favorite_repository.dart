import '../../../../core/abstracts/data_result.dart';
import '../../../models/favorite.dart';

abstract class IFavoriteRepository {
  void initialize(String? userId);
  Future<DataResult<FavoriteModel>> add(FavoriteModel fav);
  Future<DataResult<void>> delete(String favId);
  Future<DataResult<List<FavoriteModel>>> getAll();
}
