import 'package:flutter/material.dart';

/// An enum to define the type of snackbar to be shown.
enum SnackBarType { success, info, warning, error }

/// A utility class for showing SnackBars consistently across the app.
///
/// This utility ensures that only one SnackBar is visible at a time by
/// hiding the current one before showing a new one.
class SnackbarUtils {
  /// Shows a SnackBar, immediately clearing any currently displayed SnackBar.
  ///
  /// This is the core method used by other helpers in this class.
  static void show(BuildContext context, SnackBar snackbar) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  /// Shows a SnackBar with a simple text message and custom colors.
  static void showCustom(
    BuildContext context,
    String text, {
    Color? textColor,
    Color? backgroundColor,
    int durationSeconds = 2,
  }) {
    final snackbar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: durationSeconds),
    );
    show(context, snackbar);
  }

  /// Shows a typed SnackBar (success, info, warning, error) with theme-aware colors and icons.
  static void showTyped(
    BuildContext context,
    String text,
    SnackBarType type,
  ) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final Color backgroundColor;
    final IconData iconData;

    switch (type) {
      case SnackBarType.success:
        backgroundColor =
            isDarkMode ? Colors.green.shade700 : Colors.green.shade600;
        iconData = Icons.check_circle_outline;
        break;
      case SnackBarType.info:
        backgroundColor =
            isDarkMode ? Colors.blue.shade700 : Colors.blue.shade600;
        iconData = Icons.info_outline;
        break;
      case SnackBarType.warning:
        backgroundColor =
            isDarkMode ? Colors.orange.shade700 : Colors.orange.shade600;
        iconData = Icons.warning_amber_rounded;
        break;
      case SnackBarType.error:
        backgroundColor =
            isDarkMode ? Colors.red.shade700 : Colors.red.shade600;
        iconData = Icons.error_outline;
        break;
    }

    final snackbar = SnackBar(
      content: Row(
        children: [
          Icon(iconData, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );

    show(context, snackbar);
  }
}
