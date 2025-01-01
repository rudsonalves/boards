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

import '../../../../../data/models/boardgame.dart';
import '/core/theme/app_text_style.dart';
import '../../../../components/widgets/image_view.dart';
import '../../../../../core/get_it.dart';
import '../../../../../logic/managers/mechanics_manager.dart';
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
            Text(mechManager.namesFromIdListString(game.mechIds)),
            DescriptionProduct(
              description: game.description ?? '- * -',
            ),
          ],
        ),
      ),
    );
  }
}
