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

import '../mechanics_controller.dart';
import '../mechanics_store.dart';
import 'search_mechs_delegate.dart';

class MechAppBar extends StatelessWidget implements PreferredSizeWidget {
  final MechanicsController ctrl;
  final MechanicsStore store;
  final void Function()? onPressed;

  const MechAppBar({
    super.key,
    required this.ctrl,
    required this.store,
    this.onPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: ValueListenableBuilder(
          valueListenable: store.counter,
          builder: (context, value, _) {
            return Text('Mecânicas [$value]');
          }),
      centerTitle: true,
      leading: IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_back_ios_new),
      ),
      actions: [
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: SearchMechsDelegate(
                ctrl.selectMechByName,
              ),
            );
          },
          icon: const Icon(Icons.search),
        ),
        ValueListenableBuilder(
          valueListenable: store.hideDescription,
          builder: (context, hideDescription, _) {
            return IconButton(
              onPressed: store.toggleHideDescription,
              tooltip:
                  hideDescription ? 'Mostrar Descrição' : 'Ocultar Descrição',
              icon: Icon(
                hideDescription
                    ? Icons.description_outlined
                    : Icons.insert_drive_file_outlined,
              ),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: store.showSelected,
          builder: (context, showSelected, _) {
            return IconButton(
              onPressed: store.toggleShowSelected,
              tooltip: showSelected ? 'Mostrar Todos' : 'Mostrar Seleção',
              icon: Icon(
                showSelected ? Icons.ballot_rounded : Icons.ballot_outlined,
              ),
            );
          },
        ),
      ],
    );
  }
}
