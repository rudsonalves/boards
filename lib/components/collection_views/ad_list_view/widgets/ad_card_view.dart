import 'package:flutter/material.dart';

import '/core/models/ad.dart';
import '/features/shop/widgets/ad_text_info.dart';
import '/features/shop/widgets/ad_text_price.dart';
import '/features/shop/widgets/ad_text_title.dart';
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
