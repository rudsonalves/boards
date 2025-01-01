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

import '../../../../../../data/models/mechanic.dart';
import '../../../../../../core/get_it.dart';
import '../../../../../../logic/managers/mechanics_manager.dart';
import '../../mechanics_store.dart';
import 'widgets/dismissible_mech.dart';

class ShowAllMechs extends StatefulWidget {
  final MechanicsStore store;
  final Future<void> Function(MechanicModel)? editMechanic;
  final Future<bool> Function(MechanicModel)? deleteMech;

  const ShowAllMechs({
    super.key,
    required this.store,
    this.editMechanic,
    this.deleteMech,
  });

  @override
  State<ShowAllMechs> createState() => _ShowAllMechsState();
}

class _ShowAllMechsState extends State<ShowAllMechs> {
  final mechanicManager = getIt<MechanicsManager>();
  MechanicsStore get store => widget.store;

  void onTap(MechanicModel mech) {
    store.addMech(mech);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mechs = mechanicManager.mechanics;

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 70),
      itemCount: mechs.length,
      separatorBuilder: (context, index) =>
          const Divider(indent: 24, endIndent: 24),
      itemBuilder: (context, index) {
        final mech = mechs[index];
        final isSelected = store.isSelectedId(mech.id!);

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? colorScheme.tertiaryContainer : null,
          ),
          child: ValueListenableBuilder(
            valueListenable: store.hideDescription,
            builder: (context, hideDescription, _) => DismissibleMech(
              mech: mech,
              onTap: onTap,
              saveMech: widget.editMechanic,
              deleteMech: widget.deleteMech,
            ),
          ),
        );
      },
    );
  }
}
