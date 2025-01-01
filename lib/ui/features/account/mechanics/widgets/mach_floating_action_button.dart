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
import 'package:material_symbols_icons/symbols.dart';

import '/core/singletons/current_user.dart';
import '../../../../../core/get_it.dart';

class MechFloatingActionButton extends StatelessWidget {
  final void Function()? onPressBack;
  final void Function()? onPressAdd;
  final void Function()? onPressDeselect;
  final void Function()? onPressImportCSV;

  const MechFloatingActionButton({
    super.key,
    this.onPressBack,
    this.onPressAdd,
    this.onPressDeselect,
    this.onPressImportCSV,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OverflowBar(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: FloatingActionButton(
            heroTag: 'hero-0',
            backgroundColor:
                colorScheme.primaryContainer.withValues(alpha: 0.85),
            onPressed: onPressBack,
            tooltip: 'Voltar',
            child: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        if (getIt<CurrentUser>().isAdmin) ...[
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FloatingActionButton(
              heroTag: 'hero-1',
              backgroundColor:
                  colorScheme.primaryContainer.withValues(alpha: 0.85),
              onPressed: onPressAdd,
              tooltip: 'Adicionar',
              child: const Icon(Icons.add),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FloatingActionButton(
              heroTag: 'hero-2',
              backgroundColor:
                  colorScheme.primaryContainer.withValues(alpha: 0.85),
              onPressed: onPressImportCSV,
              tooltip: 'Importar CSV',
              child: const Icon(Symbols.csv),
            ),
          ),
        ],
        FloatingActionButton(
          backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.85),
          heroTag: 'hero-3',
          onPressed: onPressDeselect,
          tooltip: 'Deselecionar',
          child: const Icon(Icons.deselect),
        ),
      ],
    );
  }
}
