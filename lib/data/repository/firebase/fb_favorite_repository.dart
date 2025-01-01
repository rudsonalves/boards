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

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/favorite.dart';
import 'common/errors_codes.dart';
import '/core/abstracts/data_result.dart';
import 'common/data_functions.dart';
import '../interfaces/remote/i_favorite_repository.dart';

class FbFavoriteRepository implements IFavoriteRepository {
  String? _userId;

  static const keyFavorite = 'favorites';
  static const keyUserId = 'userId';

  set ownerId(String ownerId) => _userId = ownerId;

  CollectionReference<Map<String, dynamic>> get _favCollection =>
      FirebaseFirestore.instance.collection(keyFavorite);

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
      final doc = await _favCollection.add(fav.toMap()..remove('id'));

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
      return _handleError('delete', err, ErrorCodes.unknownError);
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
      return _handleError('getAll', err, ErrorCodes.unknownError);
    }
  }

  DataResult<T> _handleError<T>(String module, Object err, [int code = 0]) {
    return DataFunctions.handleError<T>(
        'FbFavoriteRepository', module, err, code);
  }
}
