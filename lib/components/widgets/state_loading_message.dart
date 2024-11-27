import 'package:flutter/material.dart';

class StateLoadingMessage extends StatelessWidget {
  const StateLoadingMessage({super.key});

  Widget containerCircularProgressIndicator(Color color) {
    return Container(
      color: color,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surface.withOpacity(0.7);

    return containerCircularProgressIndicator(color);
  }
}
