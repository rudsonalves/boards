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

import '../../../../../data/models/ad.dart';
import '../../../../features/shop/widgets/ad_text_info.dart';
import '../../../../features/shop/widgets/ad_text_price.dart';
import '../../../../features/shop/widgets/ad_text_title.dart';
import 'show_image.dart';

class AdCardView extends StatelessWidget {
  final AdModel ads;

  const AdCardView({
    super.key,
    required this.ads,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        color: colorScheme.surfaceContainer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [
            ShowImage(image: ads.images[0]),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdTextTitle(ads.title),
                    AdTextPrice(ads.price),
                    AdTextInfo(
                      date: ads.createdAt,
                      city: ads.ownerCity ?? '**',
                      state: ads.ownerState ?? '**',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
