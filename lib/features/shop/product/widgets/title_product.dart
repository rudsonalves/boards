import 'package:flutter/material.dart';

import '/core/theme/app_text_style.dart';

class TitleProduct extends StatelessWidget {
  final String title;
  final Color? color;

  const TitleProduct({
    super.key,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: AppTextStyle.font20SemiBold.copyWith(color: color),
      ),
    );
  }
}
