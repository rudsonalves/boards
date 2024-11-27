import 'package:flutter/material.dart';

import '/core/singletons/app_settings.dart';
import '/get_it.dart';
import 'star_rating_bar.dart';

class OwnerRating extends StatelessWidget {
  final String? owner;
  final double note;

  const OwnerRating({
    super.key,
    required this.note,
    this.owner,
  });

  bool get isDark => getIt<AppSettings>().isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(owner ?? ''),
        ),
        StarRatingBar(rate: note)
      ],
    );
  }
}
