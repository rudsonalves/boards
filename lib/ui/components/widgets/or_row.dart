import 'package:flutter/material.dart';

class OrRow extends StatelessWidget {
  const OrRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('ou'),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}
