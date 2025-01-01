// Copyright (C) 2025 Rudson Alves
// 
// This file is part of boards.
// 
// boards is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// boards is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with boards.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';

import '../../../core/theme/app_text_style.dart';

Container baseDismissibleContainer(
  BuildContext context, {
  required AlignmentGeometry alignment,
  Color? color,
  IconData? icon,
  String? label,
  bool enable = true,
}) {
  List<Alignment> alignLeft = [
    Alignment.bottomLeft,
    Alignment.topLeft,
    Alignment.centerLeft
  ];

  final colorScheme = Theme.of(context).colorScheme;
  late Widget rowIcon;

  if (label != null) {
    if (alignLeft.contains(alignment)) {
      rowIcon = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color:
                enable ? colorScheme.onPrimaryContainer : colorScheme.outline,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyle.font14SemiBold.copyWith(
                color: enable
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.outline),
          ),
        ],
      );
    } else {
      rowIcon = Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            label,
            style: AppTextStyle.font14SemiBold.copyWith(
                color: enable
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.outline),
          ),
          const SizedBox(width: 8),
          Icon(icon,
              color: enable
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.outline),
        ],
      );
    }
  } else {
    rowIcon = Icon(icon);
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 18),
    alignment: alignment,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
    ),
    child: rowIcon,
  );
}
