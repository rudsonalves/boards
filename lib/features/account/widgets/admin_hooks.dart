import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../check_mechanics/check_page.dart';
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
            Symbols.sync_rounded,
            color: primary,
          ),
          title: Text(
            'Verificar Mecânicas',
            style: TextStyle(color: primary),
          ),
          onTap: () => Navigator.pushNamed(
            context,
            CheckPage.routeName,
          ),
        ),
      ],
    );
  }
}
