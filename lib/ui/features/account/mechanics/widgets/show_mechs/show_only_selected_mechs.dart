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

import '../../../../../../core/get_it.dart';
import '../../../../../../logic/managers/mechanics_manager.dart';
import '../../mechanics_store.dart';

class ShowOnlySelectedMechs extends StatefulWidget {
  final MechanicsStore store;

  const ShowOnlySelectedMechs({
    super.key,
    required this.store,
  });

  @override
  State<ShowOnlySelectedMechs> createState() => _ShowOnlySelectedMechsState();
}

class _ShowOnlySelectedMechsState extends State<ShowOnlySelectedMechs> {
  final mechanicManager = getIt<MechanicsManager>();
  MechanicsStore get store => widget.store;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mechs = store.selectedMechIds;

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 70),
      itemCount: mechs.length,
      separatorBuilder: (context, index) =>
          const Divider(indent: 24, endIndent: 24),
      itemBuilder: (context, index) {
        final mech = store.selectedMechs[index];

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colorScheme.tertiaryContainer,
          ),
          child: ListTile(
            title: Text(mech.name),
            subtitle: store.hideDescription.value
                ? null
                : Text(mech.description ?? ''),
            onTap: () {
              store.addMech(mech);
              if (store.selectedMechs.isEmpty) {
                store.toggleShowSelected();
              }
              setState(() {});
            },
          ),
        );
      },
    );
  }
}
