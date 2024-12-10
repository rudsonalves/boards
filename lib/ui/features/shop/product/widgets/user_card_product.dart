import 'package:flutter/material.dart';

import '../../../../components/collection_views/shop_grid_view/widgets/star_rating_bar.dart';
import '/core/utils/extensions.dart';
import '/core/theme/app_text_style.dart';

class UserCard extends StatelessWidget {
  final String name;
  final double rate;
  final DateTime createAt;
  final String address;

  const UserCard({
    super.key,
    required this.name,
    required this.address,
    required this.createAt,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: AppTextStyle.font18SemiBold,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: StarRatingBar(rate: rate),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Localização: $address'),
                  Text(
                    'Usuário desde ${createAt.formatDate()}',
                    style: AppTextStyle.font12
                        .copyWith(color: colorScheme.secondary),
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
