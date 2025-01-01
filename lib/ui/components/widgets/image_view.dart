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

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

/// A custom widget for displaying images from various sources, with fallbacks for missing or empty images.
///
/// `ImageView` supports loading images from network URLs, local file paths, and assets.
/// If the provided image path is empty, it displays a default asset image. If there is an error loading
/// a network image, it shows an error asset image.
///
/// This widget uses `CachedNetworkImage` for network images to cache them efficiently, reducing data usage.
///
/// Parameters:
/// - `image`: The path or URL of the image to display.
/// - `fit`: Optional [BoxFit] to define how the image should fit within its container.
///
/// Image Loading Logic:
/// 1. **Empty Image Path**: Displays a placeholder asset (`assets/images/image_without.png`).
/// 2. **Network URL**: Uses `CachedNetworkImage` to load the image from the URL.
///    - Shows a loading spinner while fetching.
///    - Displays `assets/images/image_not_found.png` if loading fails.
/// 3. **File Path**: Loads an image from a local file.
///
/// Example:
/// ```dart
/// ImageView(
///   image: 'https://example.com/image.jpg',
///   fit: BoxFit.cover,
/// )
/// ```
class ImageView extends StatelessWidget {
  final String image;
  final BoxFit? fit;

  const ImageView({
    super.key,
    required this.image,
    this.fit,
  });

  Widget displayImage(String showImage) {
    if (showImage.isEmpty) {
      return Image.asset(
        'assets/images/image_witout.png',
        fit: fit,
      );
    } else if (showImage.contains(RegExp(r'^http'))) {
      return CachedNetworkImage(
        imageUrl: showImage,
        fit: fit,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/image_not_found.png',
          fit: fit,
        ),
      );
    } else {
      return Image.file(
        File(showImage),
        fit: fit,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return displayImage(image.trim());
  }
}
