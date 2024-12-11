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
            Text(
              title,
              style: AppTextStyle.font18SemiBold,
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
