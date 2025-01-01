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

import '/core/theme/app_text_style.dart';

class AppSnackbar {
  /// Displays a standard SnackBar in the active context and executes a callback
  /// after it closes.
  ///
  /// [context] - The current BuildContext where the SnackBar will be displayed.
  /// [message] - The main message to display.
  /// [duration] - Duration for which the SnackBar will be visible (optional).
  /// [actionLabel] - Optional label for the SnackBar's action button.
  /// [onActionPressed] - Callback executed when the action button is pressed.
  /// [onClosed] - Callback executed after the SnackBar is closed (optional).
  static void show(
    BuildContext context, {
    String? title,
    IconData? iconTitle,
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
    VoidCallback? onClosed,
  }) {
    final scaffoldMessager = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    // Remove any existing Snackbar
    scaffoldMessager.hideCurrentSnackBar();
    final snackBar = SnackBar(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (title != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (iconTitle != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      iconTitle,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                Text(
                  title,
                  style: AppTextStyle.font18SemiBold,
                ),
              ],
            ),
          Text(
            message,
            style: AppTextStyle.font14SemiBold,
          ),
        ],
      ),
      duration: duration,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      backgroundColor: colorScheme.onSecondaryContainer,
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onActionPressed ?? () {},
            )
          : null,
    );

    scaffoldMessager.showSnackBar(snackBar).closed.then((reason) {
      if (onClosed != null) onClosed();
    });
  }
}
