import 'package:flutter/material.dart';

import '/core/theme/app_text_style.dart';

class AdsNotFoundMessage extends StatelessWidget {
  const AdsNotFoundMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Card(
            color: colorScheme.primaryContainer.withValues(alpha: .45),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Icon(
                    Icons.warning_amber,
                    color: Colors.amber,
                    size: 80,
                  ),
                  Text(
                    'Nenhum anúncio encontrado',
                    style: AppTextStyle.font18Bold,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
