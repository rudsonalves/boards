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
