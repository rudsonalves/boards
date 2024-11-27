import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  final String image;
  const ShowImage({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) {
      final color = Theme.of(context).colorScheme.secondaryContainer;

      return Icon(
        Icons.image_not_supported_outlined,
        color: color,
        size: 150,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
      );
    }
  }
}
