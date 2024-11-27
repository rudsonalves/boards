import 'package:flutter/material.dart';

class NoAdsFoundCard extends StatelessWidget {
  const NoAdsFoundCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Card(
            color: colorScheme.primaryContainer,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_done,
                    size: 48,
                  ),
                  Text('Nenhum anúncio encontrado.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
