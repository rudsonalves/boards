import 'package:cloud_firestore/cloud_firestore.dart';

import '/core/models/favorite.dart';
import '/repository/data/firebase/common/errors_codes.dart';
import '../../../core/abstracts/data_result.dart';
import '../functions/data_functions.dart';
import '../interfaces/i_favorite_repository.dart';

class FbFavoriteRepository implements IFavoriteRepository {
  final _firebase = FirebaseFirestore.instance;
  String? _userId;

  static const keyFavorite = 'favorites';
  static const keyUserId = 'userId';

  set ownerId(String ownerId) => _userId = ownerId;

  CollectionReference<Map<String, dynamic>> get _favCollection =>
      _firebase.collection(keyFavorite);

  @override
  void initialize(String? userId) {
    _userId = userId;
  }

  @override
  Future<DataResult<FavoriteModel>> add(FavoriteModel fav) async {
    try {
      if (_userId == null) {
        throw Exception('UserId is null');
      }

      // Add new favorite
      final doc = await _favCollection.add(fav.toMap());

      // Update Favorite Id from firebase fav object
      final newFav = fav.copyWith(id: doc.id);

      return DataResult.success(newFav);
    } catch (err) {
      return _handleError('add', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<void>> delete(String favId) async {
    try {
      if (_userId == null) {
        throw Exception('UserId is null');
      }

      await _favCollection.doc(favId).delete();

      return DataResult.success(null);
    } catch (err) {
      return _handleError('add', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<List<FavoriteModel>>> getAll() async {
    try {
      if (_userId == null) {
        throw Exception('UserId is null');
      }

      final favDocs =
          await _favCollection.where(keyUserId, isEqualTo: _userId).get();

      final favs = favDocs.docs
          .map((doc) => FavoriteModel.fromMap(doc.data()).copyWith(id: doc.id))
          .toList();

      return DataResult.success(favs);
    } catch (err) {
      return _handleError('add', err, ErrorCodes.unknownError);
    }
  }

  DataResult<T> _handleError<T>(String module, Object err, [int code = 0]) {
    return DataFunctions.handleError<T>(
        'FbFavoriteRepository', module, err, code);
  }
}
