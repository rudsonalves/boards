import 'package:cloud_firestore/cloud_firestore.dart';

import '/core/abstracts/data_result.dart';
import '../../models/bg_name.dart';
import '../../models/boardgame.dart';
import 'common/data_functions.dart';
import '../interfaces/remote/i_boardgame_repository.dart';
import 'common/errors_codes.dart';
import 'common/fb_functions.dart';

class FbBoardgameRepository implements IBoardgameRepository {
  static const keyBoardgames = 'boardgames';
  static const keyBgNames = 'bgnames';

  CollectionReference<Map<String, dynamic>> get _bgCollection =>
      FirebaseFirestore.instance.collection(keyBoardgames);

  CollectionReference<Map<String, dynamic>> get _bgNameCollection =>
      FirebaseFirestore.instance.collection(keyBgNames);

  @override
  Future<DataResult<BoardgameModel?>> add(BoardgameModel bg) async {
    try {
      // Upload image if needed
      final image = await FbFunctions.uploadImage(bg.image);

      // Update image url
      final newBg = bg.copyWith(image: image);

      // Add board game to Firestore
      final doc = await _bgCollection.add(newBg.toMap()..remove('id'));

      // Return a board game with your id
      return DataResult.success(newBg.copyWith(id: doc.id));
    } catch (err) {
      return _handleError('add', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<void>> delete(String bgId) async {
    try {
      await _bgCollection.doc(bgId).delete();

      return DataResult.success(null);
    } catch (err) {
      return _handleError('delete', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<BoardgameModel?>> get(String bgId) async {
    try {
      final doc = await _bgCollection.doc(bgId).get();
      if (doc.data() == null) {
        return _handleError(
            'get', 'boardgame id $bgId not found', ErrorCodes.bgNotFound);
      }

      final bg = BoardgameModel.fromMap(doc.data()!).copyWith(id: doc.id);

      return DataResult.success(bg);
    } catch (err) {
      return _handleError('get', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<List<BGNameModel>>> getNames() async {
    try {
      final snapshot = await _bgNameCollection.get();
      if (snapshot.docs.isEmpty) {
        return DataResult.success([]);
      }

      final bgNames = snapshot.docs
          .map(
            (doc) => BGNameModel(
              id: doc.id,
              name: doc.data()['name'] as String,
            ),
          )
          .toList();
      return DataResult.success(bgNames);
    } catch (err) {
      return _handleError('get', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<BoardgameModel?>> update(BoardgameModel bg) async {
    try {
      final doc = _bgCollection.doc(bg.id);

      await doc.update(bg.toMap()..remove('id'));

      return DataResult.success(null);
    } catch (err) {
      return _handleError('update', err, ErrorCodes.unknownError);
    }
  }

  DataResult<T> _handleError<T>(String module, Object err, [int code = 0]) {
    return DataFunctions.handleError<T>(
        'FbBoardgameRepository', module, err, code);
  }
}