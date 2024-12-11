// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import '../../../components/dialogs/simple_question.dart';
import '../../../components/state_messages/state_error_message.dart';
import '../../../components/state_messages/state_loading_message.dart';
import '../../../../data/models/bg_name.dart';
import 'edit_boardgame/edit_boardgame_screen.dart';
import '../../shop/widgets/search/search_dialog.dart';
import 'boardgames_controller.dart';
import 'boardgames_store.dart';
import 'widgets/custom_floating_action_bar.dart';
import 'widgets/dismissible_boardgame.dart';
import 'widgets/view_boardgame.dart';

class BoardgamesScreen extends StatefulWidget {
  const BoardgamesScreen({super.key});

  static const routeName = '/boardgame_screen';

  @override
  State<BoardgamesScreen> createState() => _BoardgamesScreenState();
}

class _BoardgamesScreenState extends State<BoardgamesScreen> {
  final ctrl = BoardgamesController();
  final store = BoardgamesStore();

  @override
  void initState() {
    super.initState();
    ctrl.init(store);
  }

  @override
  void dispose() {
    store.dispose();

    super.dispose();
  }

  void _backPageWithGame() => Navigator.pop(context, ctrl.selectedBGId);

  Future<void> _addBoardgame() async {
    await Navigator.pushNamed(context, EditBoardgamesScreen.routeName);
    ctrl.addBG();
  }

  Future<void> _editBoardgame(BGNameModel bgName) async {
    final result = await ctrl.getBoardgameSelected(bgName.id);
    if (result.isFailure) {
      throw Exception(result.error);
    }
    final bg = result.data;
    if (bg != null) {
      if (mounted) {
        Navigator.pushNamed(
          context,
          EditBoardgamesScreen.routeName,
          arguments: bg,
        );
      }
    }
    ctrl.addBG();
  }

  Future<bool> _deleteBoardgame(BGNameModel bgName) async {
    final response = await SimpleQuestionDialog.open(
      context,
      title: 'Confirmar Remoção',
      message: 'Confirma a remoção do boardgame ${bgName.name}?',
      type: SQMessageType.confirmCancel,
    );

    if (response) {
      await ctrl.removeBg(bgName);
      ctrl.addBG();
      return true;
    }
    return false;
  }

  Future<void> _openSearchDialog() async {
    String? result = await showSearch<String>(
      context: context,
      delegate: SearchDialog(),
    );

    if (result != null && result.isEmpty) {
      result = null;
    }
    ctrl.changeSearchName(result ?? '');
  }

  Future<void> _viewBoardgame() async {
    final result = await ctrl.getBoardgameSelected();
    if (result.isFailure) {
      throw Exception(result.error);
    }
    final bg = result.data;
    if (bg == null) return;
    if (mounted) {
      Navigator.pushNamed(context, ViewBoardgame.routeName, arguments: bg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boardgames'),
        centerTitle: true,
        leading: IconButton(
          onPressed: _backPageWithGame,
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        actions: [
          IconButton(
            onPressed: _openSearchDialog,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      floatingActionButton: CustomFloatingActionBar(
        backPageWithGame: _backPageWithGame,
        addBoardgame: _addBoardgame,
        viewBoardgame: _viewBoardgame,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: ValueListenableBuilder(
          valueListenable: store.state,
          builder: (context, state, _) => Stack(
            children: [
              ListView.builder(
                itemCount: ctrl.filteredBGs.length,
                itemBuilder: (context, index) => DismissibleBoardgame(
                  bg: ctrl.filteredBGs[index],
                  selectBGId: ctrl.selectBGId,
                  isSelected: ctrl.isSelected,
                  saveBg: _editBoardgame,
                  deleteBg: _deleteBoardgame,
                ),
              ),
              if (store.isLoading)
                const Positioned.fill(
                  child: StateLoadingMessage(),
                ),
              if (store.isError)
                Positioned.fill(
                  child: StateErrorMessage(
                    closeDialog: ctrl.closeError,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
