import 'package:flutter/material.dart';

import '/core/theme/app_text_style.dart';

class AdTextSubtitle extends StatelessWidget {
  final String text;

  const AdTextSubtitle(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      style: AppTextStyle.font16,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
    );
  }
}
