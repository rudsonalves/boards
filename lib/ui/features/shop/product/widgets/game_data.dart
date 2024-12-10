import 'package:flutter/material.dart';

import '/core/theme/app_text_style.dart';
import 'sub_title_product.dart';

class GameData extends StatelessWidget {
  final String bgId;
  final double indent;

  const GameData({
    super.key,
    required this.bgId,
    required this.indent,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(indent: indent, endIndent: indent),
        SubTitleProduct(
          subtile: 'Dados do Jogo',
          color: primary,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'boardgame.minPlayers.toString()',
                style: AppTextStyle.font16Bold,
              ),
              const TextSpan(text: ' a '),
              TextSpan(
                text: 'boardgame.maxPlayers.toString()',
                style: AppTextStyle.font16Bold,
              ),
              const TextSpan(text: ' Jogadores'),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'boardgame.minTime.toString()',
                style: AppTextStyle.font16Bold,
              ),
              const TextSpan(text: ' a '),
              TextSpan(
                text: 'boardgame.maxTime.toString()',
                style: AppTextStyle.font16Bold,
              ),
              const TextSpan(text: ' minutos'),
            ],
          ),
        ),
        RichText(
          text: TextSpan(children: [
            const TextSpan(text: 'Idade recomendada: '),
            TextSpan(
              text: '${'boardgame.minAge'}+',
              style: AppTextStyle.font16Bold,
            ),
          ]),
        ),
        RichText(
          text: TextSpan(
            text: 'Designer: ',
            children: [
              TextSpan(
                text: 'boardgame.designer',
                style: AppTextStyle.font16Bold,
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            text: 'Artistas: ',
            children: [
              TextSpan(
                text: 'boardgame.artist',
                style: AppTextStyle.font16Bold,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
