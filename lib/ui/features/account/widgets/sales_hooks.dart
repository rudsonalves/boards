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
