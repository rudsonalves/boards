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

class CustomFilledButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomFilledButton({
    super.key,
    this.onPressed,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          backgroundColor?.withValues(alpha: 0.45),
        ),
        foregroundColor: WidgetStatePropertyAll(foregroundColor),
      ),
    );
  }
}
