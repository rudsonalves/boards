import 'package:flutter/material.dart';

import '/core/theme/app_text_style.dart';

class AdTextTitle extends StatelessWidget {
  final String text;

  const AdTextTitle(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      text,
      maxLines: 2,
      style: AppTextStyle.font18SemiBold.copyWith(color: colorScheme.primary),
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
    );
  }
}
