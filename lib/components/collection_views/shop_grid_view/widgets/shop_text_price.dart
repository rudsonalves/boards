import 'package:flutter/material.dart';

import '/core/utils/extensions.dart';
import '/core/theme/app_text_style.dart';

class ShopTextPrice extends StatelessWidget {
  final double value;
  const ShopTextPrice(
    this.value, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      value.formatMoney(),
      style: AppTextStyle.font16,
    );
  }
}
