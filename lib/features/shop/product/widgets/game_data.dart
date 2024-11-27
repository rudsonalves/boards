import 'package:flutter/material.dart';

import '/core/models/ad.dart';
import '/core/theme/app_text_style.dart';
import 'sub_title_product.dart';

class GameData extends StatelessWidget {
  final AdModel ad;
  final double indent;

  const GameData({
    super.key,
    required this.ad,
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
                text: ad.boardgame!.minPlayers.toString(),
                style: AppTextStyle.font16Bold,
              ),
              const TextSpan(text: ' a '),
              TextSpan(
                text: ad.boardgame!.maxPlayers.toString(),
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
                text: ad.boardgame!.minTime.toString(),
                style: AppTextStyle.font16Bold,
              ),
              const TextSpan(text: ' a '),
              TextSpan(
                text: ad.boardgame!.maxTime.toString(),
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
              text: '${ad.boardgame!.minAge}+',
              style: AppTextStyle.font16Bold,
            ),
          ]),
        ),
        RichText(
          text: TextSpan(
            text: 'Designer: ',
            children: [
              TextSpan(
                text: ad.boardgame!.designer,
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
                text: ad.boardgame!.artist,
                style: AppTextStyle.font16Bold,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
