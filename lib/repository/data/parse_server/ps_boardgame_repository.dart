// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:path/path.dart';

import '/repository/data/parse_server/common/ps_functions.dart';
import '../interfaces/i_boardgame_repository.dart';
import '/core/abstracts/data_result.dart';
import '/core/models/bg_name.dart';
import '/core/models/boardgame.dart';
import 'common/constants.dart';
import 'common/parse_to_model.dart';

/// This class provides methods to interact with the Parse Server
/// to retrieve and save boardgames informations
class PSBoardgameRepository implements IBoardgameRepository {
  @override
  Future<DataResult<BoardgameModel?>> add(BoardgameModel bg) async {
    try {
      final parseUser = await PsFunctions.parseCurrentUser();
      final parseAcl = PsFunctions.createSharedAcl(parseUser);
      final parseImage = await _saveImage(path: bg.image, parseUser: parseUser);

      final parseBg = _prepareBgForSaveOrUpdate(
        bg: bg,
        parseImage: parseImage,
        parseAcl: parseAcl,
      );

      final response = await parseBg.save();
      if (!response.success) {
        throw BoardgameRepositoryException(
            response.error?.message ?? 'Failed to save ad.');
      }

      return DataResult.success(ParseToModel.boardgameModel(parseBg));
    } catch (err) {
      return _handleError('save', err);
    }
  }

  @override
  Future<DataResult<BoardgameModel?>> update(BoardgameModel bg) async {
    try {
      final parseUser = await PsFunctions.parseCurrentUser();
      final parseAcl = PsFunctions.createDefaultAcl(parseUser);
      final parseImage = await _saveImage(path: bg.image, parseUser: parseUser);

      final parseBg = _prepareBgForSaveOrUpdate(
        bg: bg,
        parseImage: parseImage,
        parseAcl: parseAcl,
      );

      final response = await parseBg.update();
      if (!response.success) {
        throw BoardgameRepositoryException(
            response.error?.toString() ?? 'unknow error');
      }

      return DataResult.success(ParseToModel.boardgameModel(parseBg));
    } catch (err) {
      return _handleError('update', err);
    }
  }

  @override
  Future<DataResult<BoardgameModel?>> get(String bgId) async {
    try {
      final parse = ParseObject(keyBgTable);

      final response = await parse.getObject(bgId);
      if (!response.success ||
          response.results == null ||
          response.results!.isEmpty) {
        throw BoardgameRepositoryException(
            response.error?.toString() ?? 'no data found');
      }

      final resultParse = response.results!.first as ParseObject;

      return DataResult.success(ParseToModel.boardgameModel(resultParse));
    } catch (err) {
      return _handleError('getById', err);
    }
  }

  @override
  Future<DataResult<void>> delete(String bgId) async {
    try {
      final parse = ParseObject(keyBgTable)..objectId = bgId;
      final fetchedObject = await parse.fetch();

      final response = await fetchedObject.delete();
      if (!response.success) {
        throw BoardgameRepositoryException(
            response.error?.toString() ?? 'no data found');
      }
      return DataResult.success(null);
    } catch (err) {
      return _handleError('delete', err);
    }
  }

  @override
  Future<DataResult<List<BGNameModel>>> getNames() async {
    try {
      final query = QueryBuilder<ParseObject>(ParseObject(keyBgTable));

      query.keysToReturn([keyBgName, keyBgPublishYear]);

      final response = await query.query();
      if (!response.success) {
        throw BoardgameRepositoryException(
            response.error?.toString() ?? 'unknow error');
      }

      if (response.results == null) {
        return DataResult.success([]);
      }

      List<BGNameModel> bgs = [];
      for (final ParseObject p in response.results!) {
        final bg = ParseToModel.bgNameModel(p);
        bgs.add(bg);
      }
      return DataResult.success(bgs);
    } catch (err) {
      return _handleError('getNames', err);
    }
  }

  /// Prepares a ParseObject for saving or updating an ad.
  ///
  /// [bg] - The BoardgameModel with boardgame information.
  /// [parseImage] - The list of ParseFiles representing the ad images.
  /// [parseAcl] - Optional ACL for the ad.
  ParseObject _prepareBgForSaveOrUpdate({
    required BoardgameModel bg,
    required ParseFile parseImage,
    ParseACL? parseAcl,
  }) {
    final ParseObject parseBg = ParseObject(keyBgTable);
    if (bg.id != null) {
      parseBg.objectId = bg.id!;
    }

    if (parseAcl != null) {
      parseBg.setACL(parseAcl);
    }

    parseBg
      ..setNonNull<String>(keyBgName, bg.name)
      ..setNonNull<ParseFile>(keyBgImage, parseImage)
      ..setNonNull<int>(keyBgPublishYear, bg.publishYear)
      ..setNonNull<int>(keyBgMinPlayers, bg.minPlayers)
      ..setNonNull<int>(keyBgMaxPlayers, bg.maxPlayers)
      ..setNonNull<int>(keyBgMinTime, bg.minTime)
      ..setNonNull<int>(keyBgMaxTime, bg.maxTime)
      ..setNonNull<int>(keyBgMinAge, bg.minAge)
      ..setNonNull<String?>(keyBgDesigner, bg.designer)
      ..setNonNull<String?>(keyBgArtist, bg.artist)
      ..setNonNull<String?>(keyBgDescription, bg.description)
      ..setNonNull<List<String>>(keyBgMechanics, bg.mechIds);

    return parseBg;
  }

  Future<ParseFile> _saveImage({
    required String path,
    required ParseUser parseUser,
  }) async {
    try {
      // Check if the path is a local file path or an existing URL
      if (!path.startsWith('http')) {
        // Create ParseFile from the local file path
        final parseImage = ParseFile(File(path), name: basename(path));
        parseImage.setACL(PsFunctions.createDefaultAcl(parseUser));

        // Save the file to the Parse server
        final response = await parseImage.save();
        if (!response.success) {
          throw BoardgameRepositoryException(
              response.error?.message ?? 'Failed to save file: $path');
        }

        return parseImage;
      }
      // If it's already a URL, create a ParseFile pointing to that URL
      return ParseFile(null, name: basename(path), url: path);
    } catch (err) {
      throw BoardgameRepositoryException('_saveImages: $err');
    }
  }

  DataResult<T> _handleError<T>(String module, Object error) {
    return PsFunctions.handleError<T>('PSBoardgameRepository', module, error);
  }
}
