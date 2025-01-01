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

import '../my_ads/my_ads_screen.dart';
import '../../shop/product/widgets/title_product.dart';

class SalesHooks extends StatelessWidget {
  const SalesHooks({
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
          title: 'Vendas',
          color: primary,
        ),
        ListTile(
          leading: const Icon(Icons.text_snippet),
          title: const Text('Resumo'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.discount, color: primary),
          title: Text(
            'Anúncios',
            style: TextStyle(color: primary),
          ),
          onTap: () {
            Navigator.pushNamed(context, MyAdsScreen.routeName);
          },
        ),
        ListTile(
          leading: const Icon(Icons.forum_outlined),
          title: const Text('Perguntas'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.store),
          title: const Text('Vendas'),
          onTap: () {},
        ),
      ],
    );
  }
}
