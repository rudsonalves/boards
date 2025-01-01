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
