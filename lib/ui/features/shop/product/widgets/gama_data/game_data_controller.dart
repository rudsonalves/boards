import 'dart:developer';

import '/logic/managers/mechanics_manager.dart';
import '/data/models/mechanic.dart';
import '/logic/managers/boardgames_manager.dart';
import '/core/get_it.dart';
import '/data/models/boardgame.dart';
import 'game_data_store.dart';

class GameDataController {
  final GameDataStore store;
  final String? bgId;

  GameDataController({
    required this.store,
    required this.bgId,
  });

  final boardgamesManager = getIt<BoardgamesManager>();
  final mechManager = getIt<MechanicsManager>();

  MechanicModel Function(String) get mechFromId => mechManager.mechFromId;

  BoardgameModel? boardgame;

  Future<void> loadBoardgame() async {
    try {
      store.setStateLoading();
      final result = await boardgamesManager.getBoardgameId(bgId!);
      if (result.isFailure) {
        throw Exception(result.error ?? 'unknow error');
      }
      boardgame = result.data!;
      store.setStateSuccess();
    } catch (err) {
      log('GameDataController.loadBoardgame: $err');
      store.setError('Ocorreu um erro. Tente mais tarde.');
    }
  }
}
