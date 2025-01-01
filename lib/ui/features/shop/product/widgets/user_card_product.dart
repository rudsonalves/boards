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
