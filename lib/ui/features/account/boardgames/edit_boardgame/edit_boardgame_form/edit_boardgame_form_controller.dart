import 'package:flutter/material.dart';

import '../../../../../components/form_controllers/numeric_edit_controller.dart';
import '../../../../../../data/models/boardgame.dart';
import '../../../../../../core/get_it.dart';
import '../../../../../../logic/managers/boardgames_manager.dart';
import '../../../../../../logic/managers/mechanics_manager.dart';
import '../edit_boardgame_store.dart';

class EditBoardgameFormController {
  final bgManager = getIt<BoardgamesManager>();
  final mechManager = getIt<MechanicsManager>();

  late final EditBoardgameStore store;

  final nameController = TextEditingController();
  final yearController = NumericEditController<int>(initialValue: 2010);
  final imageController = TextEditingController();
  final minPlayersController = NumericEditController<int>();
  final maxPlayersController = NumericEditController<int>();
  final minTimeController = NumericEditController<int>();
  final maxTimeController = NumericEditController<int>();
  final ageController = NumericEditController<int>();
  final designerController = TextEditingController();
  final artistController = TextEditingController();
  final descriptionController = TextEditingController();
  final mechsController = TextEditingController();

  final descriptionFocus = FocusNode();

  List<String> get bgNames => bgManager.bgNames;

  void init(EditBoardgameStore store) {
    this.store = store;
    _setBoardgameToForm(store.bg);
  }

  void dispose() {
    nameController.dispose();
    yearController.dispose();
    imageController.dispose();
    minPlayersController.dispose();
    maxPlayersController.dispose();
    minTimeController.dispose();
    maxTimeController.dispose();
    ageController.dispose();
    designerController.dispose();
    artistController.dispose();
    descriptionController.dispose();
    mechsController.dispose();
    descriptionFocus.dispose();
  }

  void _setBoardgameToForm(BoardgameModel bg) {
    nameController.text = bg.name;
    yearController.numericValue = bg.publishYear.toInt();
    imageController.text = bg.image;
    minPlayersController.numericValue = bg.minPlayers;
    maxPlayersController.numericValue = bg.maxPlayers;
    minTimeController.numericValue = bg.minTime;
    maxTimeController.numericValue = bg.maxTime;
    ageController.numericValue = bg.minAge;
    designerController.text = bg.designer ?? '';
    artistController.text = bg.designer ?? '';
    descriptionController.text = bg.description ?? '';
    setMechanicsPsIds(bg.mechIds);
  }

  void setMechanicsPsIds(List<String> mechPsIds) {
    store.setMechsPsIds(mechPsIds);
    _updateMechsController();
  }

  void _updateMechsController() {
    mechsController.text =
        mechManager.namesFromPsIdList(store.bg.mechIds).join(', ');
  }

  void setImage(String? image) {
    if (image != null) {
      imageController.text = image;
      store.setImage(image);
    }
  }
}
