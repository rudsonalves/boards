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

import 'package:flutter/material.dart';

import 'widgets/custom_filled_button.dart';
import 'edit_boardgame_form/edit_boardgame_form.dart';
import '../../../../../data/models/boardgame.dart';
import '../../../../components/state_messages/state_error_message.dart';
import '../../../../components/state_messages/state_loading_message.dart';
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
                            backgroundColor:
                                Colors.green.withValues(alpha: 0.45),
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
