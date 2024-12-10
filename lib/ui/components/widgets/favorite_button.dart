import 'package:flutter/material.dart';

import '../../../data/models/ad.dart';
import '../../../core/get_it.dart';
import '../../../logic/managers/favorites_manager.dart';

class FavoriteStackButton extends StatelessWidget {
  final AdModel ad;

  FavoriteStackButton({
    super.key,
    required this.ad,
  });

  final favoritesManager = getIt<FavoritesManager>();
  List<String> get favAdIds => favoritesManager.favAdIds;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: ListenableBuilder(
              listenable: favoritesManager.favNotifier,
              builder: (context, _) {
                return Icon(
                  favAdIds.contains(ad.id!)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: favAdIds.contains(ad.id!) ? Colors.red : null,
                );
              }),
          onPressed: () => favoritesManager.toggleAdFav(ad),
        ),
      ],
    );
  }
}
