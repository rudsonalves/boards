import 'package:flutter/material.dart';

import '/core/theme/app_text_style.dart';

class TextTitle extends StatelessWidget {
  final String title;

  const TextTitle(
    this.title, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(
        title,
        style: AppTextStyle.font18SemiBold.copyWith(
          color: colorScheme.primary,
        ),
      ),
    );
  }
}
