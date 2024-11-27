import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

import '/core/models/ad.dart';

class ImageCarousel extends StatelessWidget {
  final AdModel ad;

  const ImageCarousel({
    super.key,
    required this.ad,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 8),
      color: colorScheme.surfaceContainer,
      child: CarouselSlider.builder(
        itemCount: ad.images.length,
        slideBuilder: (index) => CachedNetworkImage(
          imageUrl: ad.images[index],
          fit: BoxFit.fill,
        ),
        slideIndicator: CircularSlideIndicator(
          padding: const EdgeInsets.only(bottom: 32),
        ),
        unlimitedMode: true,
      ),
    );
  }
}
