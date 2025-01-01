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

import '../tools/tools_screen.dart';
import '../boardgames/boardgames_screen.dart';
import '../mechanics/mechanics_screen.dart';
import '../../shop/product/widgets/title_product.dart';

class AdminHooks extends StatelessWidget {
  const AdminHooks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        TitleProduct(
          title: 'Administração',
          color: primary,
        ),
        ListTile(
          leading: Icon(
            Icons.precision_manufacturing,
            color: primary,
          ),
          title: Text(
            'Mecânicas',
            style: TextStyle(color: primary),
          ),
          onTap: () => Navigator.pushNamed(
            context,
            MechanicsScreen.routeName,
            arguments: <String>[],
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.casino,
            color: primary,
          ),
          title: Text(
            'Boardgames',
            style: TextStyle(color: primary),
          ),
          onTap: () => Navigator.pushNamed(
            context,
            BoardgamesScreen.routeName,
          ),
        ),
        ListTile(
          leading: Icon(
            Symbols.construction_rounded,
            color: primary,
          ),
          title: Text(
            'Ferramentas',
            style: TextStyle(color: primary),
          ),
          onTap: () => Navigator.pushNamed(
            context,
            ToolsScreen.routeName,
          ),
        ),
      ],
    );
  }
}
