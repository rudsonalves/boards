import 'package:flutter/material.dart';

import '/core/models/boardgame.dart';
import '/core/theme/app_text_style.dart';
import '/components/widgets/image_view.dart';
import '/get_it.dart';
import '/data_managers/mechanics_manager.dart';
import '../../../shop/product/widgets/description_product.dart';
import '../../../shop/product/widgets/sub_title_product.dart';
import '../../../shop/product/widgets/title_product.dart';

class BGInfoCard extends StatelessWidget {
  final BoardgameModel game;

  BGInfoCard(
    this.game, {
    super.key,
  });

  final mechManager = getIt<MechanicsManager>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleProduct(
              title: '${game.name} (${game.publishYear})',
              color: colorScheme.primary,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.width * .4,
                    child: ImageView(
                      image: game.image,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${game.minPlayers}-${game.maxPlayers} ',
                              style: AppTextStyle.font16.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                            Text(
                              'Jogadores',
                              style: AppTextStyle.font16,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${game.minTime}-${game.maxTime}',
                              style: AppTextStyle.font16.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                            Text(
                              ' Min',
                              style: AppTextStyle.font16,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Idade: ',
                              style: AppTextStyle.font16,
                            ),
                            Text(
                              '${game.minAge}+',
                              style: AppTextStyle.font16.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (game.designer != null)
              Row(
                children: [
                  Text(
                    '${game.designer!.contains(', ') ? 'Designers' : 'Designer'}: ',
                    style: AppTextStyle.font16,
                  ),
                  Expanded(
                    child: Text(
                      game.designer!,
                      style: AppTextStyle.font16.copyWith(
                        color: colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            if (game.artist != null)
              Row(
                children: [
                  Text(
                    '${game.artist!.contains(', ') ? 'Artistas' : 'Artista'}: ',
                    style: AppTextStyle.font16,
                  ),
                  Expanded(
                    child: Text(
                      game.artist!,
                      style: AppTextStyle.font16.copyWith(
                        color: colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            const SubTitleProduct(
              subtile: 'Mecânicas:',
            ),
            Text(mechManager.namesFromIdListString(game.mechsPsIds)),
            DescriptionProduct(
              description: game.description ?? '- * -',
            ),
          ],
        ),
      ),
    );
  }
}
