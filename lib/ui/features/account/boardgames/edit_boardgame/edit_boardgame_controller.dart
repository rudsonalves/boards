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

import '/core/abstracts/data_result.dart';
import '../../../../../logic/managers/boardgames_manager.dart';
import '../../../../../core/get_it.dart';
import 'edit_boardgame_store.dart';

class EditBoardgameController {
  late final EditBoardgameStore store;

  final bgManager = getIt<BoardgamesManager>();

  void init(EditBoardgameStore store) {
    this.store = store;
  }

  void dispose() {}

  Future<DataResult<void>> saveBoardgame() async {
    if (!store.isValid() && !store.isEdited) {
      return DataResult.failure(GenericFailure());
    }

    try {
      store.setStateLoading();

      final result = store.bg.id != null
          ? await bgManager.update(store.bg)
          : await bgManager.save(store.bg);
      if (result.isFailure) {
        throw Exception(result.error);
      }

      store.setStateSuccess();
      return DataResult.success(null);
    } catch (err) {
      final message = 'EditBoardController.saveBoardgame: $err';
      store.setError(message);
      log(message);
      return DataResult.failure(GenericFailure(message: message));
    }
  }
}
