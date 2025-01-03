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

class BigButton extends StatelessWidget {
  final Color color;
  final String label;
  final VoidCallback onPressed;
  final FocusNode? focusNode;
  final Widget? icon;

  const BigButton({
    super.key,
    required this.color,
    required this.label,
    required this.onPressed,
    this.focusNode,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.tonal(
              focusNode: focusNode,
              onPressed: onPressed,
              style: ButtonStyle(
                shape: ButtonStyleButton.allOrNull(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all(
                  color.withValues(alpha: .3),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: icon,
                      ),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
