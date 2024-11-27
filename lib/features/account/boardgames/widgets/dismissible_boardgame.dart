import 'package:flutter/material.dart';

import '/components/widgets/base_dismissible_container.dart';
import '/core/models/bg_name.dart';

class DismissibleBoardgame extends StatelessWidget {
  final BGNameModel bg;
  final Function(BGNameModel) selectBGId;
  final Function(BGNameModel) isSelected;
  final Future<void> Function(BGNameModel)? saveBg;
  final Future<bool> Function(BGNameModel)? deleteBg;

  final Color colorLeft;
  final IconData iconLeft;
  final String labelLeft;

  final Color colorRight;
  final IconData iconRight;
  final String labelRight;

  const DismissibleBoardgame({
    super.key,
    required this.bg,
    required this.selectBGId,
    required this.isSelected,
    this.colorLeft = Colors.green,
    this.iconLeft = Icons.edit,
    this.labelLeft = 'Editar',
    this.colorRight = Colors.red,
    this.iconRight = Icons.delete,
    this.labelRight = 'Remover',
    this.saveBg,
    this.deleteBg,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: UniqueKey(),
      background: baseDismissibleContainer(
        context,
        alignment: Alignment.centerLeft,
        color: colorLeft.withOpacity(0.3),
        icon: iconLeft,
        label: labelLeft,
        enable: saveBg != null,
      ),
      secondaryBackground: baseDismissibleContainer(
        context,
        alignment: Alignment.centerRight,
        color: colorRight.withOpacity(0.3),
        icon: iconRight,
        label: labelRight,
        enable: deleteBg != null,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected(bg) ? colorScheme.tertiaryContainer : null,
        ),
        child: ListTile(
          title: Text(bg.name!),
          onTap: () => selectBGId(bg),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          if (saveBg != null) {
            saveBg!(bg);
          }
          return false;
        } else if (direction == DismissDirection.endToStart) {
          if (deleteBg != null) {
            return deleteBg!(bg);
          }
          return false;
        }
        return false;
      },
    );
  }
}
