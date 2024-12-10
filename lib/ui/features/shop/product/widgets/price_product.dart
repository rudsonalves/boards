import 'package:flutter/material.dart';

import '/core/utils/extensions.dart';
import '/core/theme/app_text_style.dart';

class PriceProduct extends StatelessWidget {
  final double price;

  const PriceProduct({
    super.key,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Text(
        price.formatMoney(),
        style: AppTextStyle.font24,
      ),
    );
  }
}
