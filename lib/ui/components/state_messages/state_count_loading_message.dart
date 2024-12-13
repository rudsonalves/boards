import '/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class StateCountLoadingMessage extends StatelessWidget {
  final int maxCount;
  final int value;

  const StateCountLoadingMessage({
    super.key,
    required this.maxCount,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface.withValues(alpha: 0.7),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    value: (value / maxCount),
                  ),
                ),
                Text(
                  '$value/$maxCount',
                  style: AppTextStyle.font16Bold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
