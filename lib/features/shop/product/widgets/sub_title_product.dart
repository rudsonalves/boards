import 'package:flutter/material.dart';

import '/core/theme/app_text_style.dart';

class SubTitleProduct extends StatelessWidget {
  final String subtile;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const SubTitleProduct({
    super.key,
    required this.subtile,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding != null ? padding! : const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        subtile,
        style: AppTextStyle.font16Bold.copyWith(color: color),
      ),
    );
  }
}
