import 'package:flutter/material.dart';

import '/core/theme/app_text_style.dart';

class ShopTextTitle extends StatelessWidget {
  final String label;

  const ShopTextTitle({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Text(
      label,
      style: AppTextStyle.font15SemiBold.copyWith(color: primary),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
