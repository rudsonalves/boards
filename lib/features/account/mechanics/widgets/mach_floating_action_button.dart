import 'package:flutter/material.dart';

import '/core/singletons/current_user.dart';
import '/get_it.dart';

class MechFloatingActionButton extends StatelessWidget {
  final void Function()? onPressBack;
  final void Function()? onPressAdd;
  final void Function()? onPressDeselect;

  const MechFloatingActionButton({
    super.key,
    this.onPressBack,
    this.onPressAdd,
    this.onPressDeselect,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OverflowBar(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: FloatingActionButton(
            heroTag: 'hero-0',
            backgroundColor: colorScheme.primaryContainer.withOpacity(0.85),
            onPressed: onPressBack,
            tooltip: 'Voltar',
            child: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        if (getIt<CurrentUser>().isAdmin) ...[
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FloatingActionButton(
              heroTag: 'hero-1',
              backgroundColor: colorScheme.primaryContainer.withOpacity(0.85),
              onPressed: onPressAdd,
              tooltip: 'Adicionar',
              child: const Icon(Icons.add),
            ),
          ),
        ],
        FloatingActionButton(
          backgroundColor: colorScheme.primaryContainer.withOpacity(0.85),
          heroTag: 'hero-3',
          onPressed: onPressDeselect,
          tooltip: 'Deselecionar',
          child: const Icon(Icons.deselect),
        ),
      ],
    );
  }
}
