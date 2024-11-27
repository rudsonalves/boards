import 'package:flutter/material.dart';

import 'widgets/custom_filled_button.dart';
import 'edit_boardgame_form/edit_boardgame_form.dart';
import '/core/models/boardgame.dart';
import '/components/widgets/state_error_message.dart';
import '/components/widgets/state_loading_message.dart';
import 'edit_boardgame_controller.dart';
import 'edit_boardgame_store.dart';

class EditBoardgamesScreen extends StatefulWidget {
  final BoardgameModel? bg;

  const EditBoardgamesScreen(
    this.bg, {
    super.key,
  });

  static const routeName = '/boardgame';

  @override
  State<EditBoardgamesScreen> createState() => _EditBoardgamesScreenState();
}

class _EditBoardgamesScreenState extends State<EditBoardgamesScreen> {
  final ctrl = EditBoardgameController();
  final store = EditBoardgameStore();

  @override
  void initState() {
    super.initState();

    store.init(widget.bg);
    ctrl.init(store);
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  void _backPage() {
    Navigator.pop(context);
  }

  Future<void> _backPageWithSave() async {
    final result = await ctrl.saveBoardgame();
    if (result.isSuccess) {
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados do Board'),
        centerTitle: true,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ListenableBuilder(
            listenable: store.state,
            builder: (context, _) {
              return Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EditBoardgameForm(
                        store: store,
                      ),
                      const SizedBox(height: 12),
                      OverflowBar(
                        alignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomFilledButton(
                            onPressed: _backPageWithSave,
                            icon: Icons.save,
                            label: 'Salvar',
                            backgroundColor: Colors.green.withOpacity(0.45),
                            foregroundColor: Colors.white,
                          ),
                          CustomFilledButton(
                            onPressed: _backPage,
                            icon: Icons.cancel,
                            label: 'Cancelar',
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (store.isLoading)
                    const Positioned.fill(
                      child: StateLoadingMessage(),
                    ),
                  if (store.isError)
                    Positioned.fill(
                      child: StateErrorMessage(
                        closeDialog: store.setStateSuccess,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
