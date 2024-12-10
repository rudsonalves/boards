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
