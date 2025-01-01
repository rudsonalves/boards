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

import '../../../../../../components/widgets/base_dismissible_container.dart';
import '../../../../../../../data/models/mechanic.dart';

class DismissibleMech extends StatelessWidget {
  final MechanicModel mech;
  final bool hideDescription;
  final void Function(MechanicModel value) onTap;
  final Future<void> Function(MechanicModel)? saveMech;
  final Future<bool> Function(MechanicModel)? deleteMech;

  final Color colorLeft;
  final IconData iconLeft;
  final String labelLeft;

  final Color colorRight;
  final IconData iconRight;
  final String labelRight;

  const DismissibleMech({
    super.key,
    required this.mech,
    this.hideDescription = false,
    this.colorLeft = Colors.green,
    this.iconLeft = Icons.edit,
    this.labelLeft = 'Editar',
    this.colorRight = Colors.red,
    this.iconRight = Icons.delete,
    this.labelRight = 'Remover',
    required this.onTap,
    this.saveMech,
    this.deleteMech,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: baseDismissibleContainer(
        context,
        alignment: Alignment.centerLeft,
        color: colorLeft.withValues(alpha: 0.3),
        icon: iconLeft,
        label: labelLeft,
        enable: saveMech != null,
      ),
      secondaryBackground: baseDismissibleContainer(
        context,
        alignment: Alignment.centerRight,
        color: colorRight.withValues(alpha: 0.3),
        icon: iconRight,
        label: labelRight,
        enable: deleteMech != null,
      ),
      child: ListTile(
        title: Text(mech.name),
        subtitle: hideDescription ? null : Text(mech.description ?? ''),
        onTap: () => onTap(mech),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          if (saveMech != null) {
            saveMech!(mech);
          }
          return false;
        } else if (direction == DismissDirection.endToStart) {
          if (deleteMech != null) {
            return deleteMech!(mech);
          }
          return false;
        }
        return false;
      },
    );
  }
}
