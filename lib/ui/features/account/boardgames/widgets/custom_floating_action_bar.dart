import 'package:flutter/material.dart';

import '/core/singletons/current_user.dart';
import '../../../../../core/get_it.dart';

/// CustomFloatingActionBar creates a FloatingActionBar with buttons to:
///
///  1. return the selected boardgame;
///  2. add a new boardgame;
///  3. edit the selectes boardgame;
///  4. view the selected boardgame.
///
/// Buttons 2 and 3 are enabled dor admin users only.
class CustomFloatingActionBar extends StatelessWidget {
  final void Function() backPageWithGame;
  final void Function() addBoardgame;
  final void Function() viewBoardgame;

  CustomFloatingActionBar({
    super.key,
    required this.backPageWithGame,
    required this.addBoardgame,
    required this.viewBoardgame,
  });

  final user = getIt<CurrentUser>();

  @override
  Widget build(BuildContext context) {
    return OverflowBar(
      children: [
        FloatingActionButton(
          heroTag: 'Fab00',
          onPressed: backPageWithGame,
          tooltip: 'Selecionar',
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        if (user.isAdmin)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: FloatingActionButton(
              heroTag: 'Fab01',
              onPressed: addBoardgame,
              tooltip: 'Adicionar',
              child: const Icon(Icons.add),
            ),
          ),
        const SizedBox(width: 12),
        FloatingActionButton(
          heroTag: 'Fab03',
          onPressed: viewBoardgame,
          tooltip: 'Visualizar',
          child: const Icon(Icons.visibility),
        ),
      ],
    );
  }
}
