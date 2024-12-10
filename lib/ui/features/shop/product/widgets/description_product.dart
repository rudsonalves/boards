import 'package:flutter/material.dart';

import '../../../../components/texts/read_more_text.dart';
import 'sub_title_product.dart';

class DescriptionProduct extends StatelessWidget {
  final String description;

  const DescriptionProduct({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitleProduct(
          subtile: 'Descrição do Produto:',
          color: colorScheme.primary,
        ),
        ReadMoreText(
          description,
          trimMode: TrimMode.line,
          trimLines: 5,
          trimExpandedText: '  [ver menos]',
          trimCollapsedText: '  [ver mais]',
          colorClickableText: colorScheme.primary,
        ),
      ],
    );
  }
}
