import 'package:flutter/material.dart';

class StarRatingBar extends StatelessWidget {
  final double rate;

  const StarRatingBar({
    super.key,
    required this.rate,
  });

  List<Widget> _createRateRow(double rate) {
    List<Widget> row = [];
    final note = (rate * 2).round() / 2;
    final size = 18.0;

    for (int i = 1; i < 6; i++) {
      final halfLeft = note > i - 1;
      final halfRight = halfLeft && note >= i;

      if (!halfLeft && !halfRight) {
        row.add(
          Image.asset(
            'assets/images/star_empty.png',
            width: size,
            height: size,
          ),
        );
      } else if (halfLeft && !halfRight) {
        row.add(
          Image.asset(
            'assets/images/star_half.png',
            width: size,
            height: size,
          ),
        );
      } else if (halfLeft && halfRight) {
        row.add(
          Image.asset(
            'assets/images/star_full.png',
            width: size,
            height: size,
          ),
        );
      }
    }

    return row;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _createRateRow(rate),
    );
  }
}
