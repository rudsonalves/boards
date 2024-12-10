import 'package:flutter/material.dart';

import '/core/utils/extensions.dart';
import '/core/theme/app_text_style.dart';

class AdTextPrice extends StatelessWidget {
  final double value;
  const AdTextPrice(
    this.value, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    return Text(
      value.formatMoney(),
      style: AppTextStyle.font20,
    );
  }
}
