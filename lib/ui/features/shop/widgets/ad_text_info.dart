import 'package:flutter/material.dart';

import '/core/utils/extensions.dart';
import '/core/theme/app_text_style.dart';

class AdTextInfo extends StatelessWidget {
  final DateTime date;
  final String city;
  final String state;

  const AdTextInfo({
    super.key,
    required this.date,
    required this.city,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${date.formatDate()} - $city - $state',
      style: AppTextStyle.font12,
      textAlign: TextAlign.start,
    );
  }
}
