import 'package:flutter/material.dart';

import '/core/theme/app_text_style.dart';

class BagSubTotal extends StatelessWidget {
  final int length;
  final double total;

  const BagSubTotal({
    super.key,
    required this.length,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Subtotal ($length'
            ' ite${length > 1 ? 'ns' : 'm'}): '),
        Text(
          '\$${total.toStringAsFixed(2)}',
          style: AppTextStyle.font16Bold,
        ),
      ],
    );
  }
}
