import 'package:flutter/material.dart';

import '../../favorites/favorites_screen.dart';
import '../../shop/product/widgets/title_product.dart';

class ShoppingHooks extends StatelessWidget {
  const ShoppingHooks({
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
          title: 'Compras',
          color: primary,
        ),
        ListTile(
          leading: Icon(Icons.favorite, color: primary),
          title: Text(
            'Favoritos',
            style: TextStyle(color: primary),
          ),
          onTap: () => Navigator.pushNamed(context, FavoritesScreen.routeName),
        ),
        ListTile(
          leading: const Icon(Icons.message),
          title: const Text('Perguntas'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.shopping_bag),
          title: const Text('Minhas Compras'),
          onTap: () {},
        ),
      ],
    );
  }
}
