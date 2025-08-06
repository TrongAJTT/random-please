import 'package:flutter/material.dart';

/// A generic dialog to inform the user about a required permission and provide an action.
class PermissionInfoDialog extends StatelessWidget {
  final String title;
  final String content;
  final String actionText;
  final VoidCallback onActionPressed;
  final VoidCallback? onCancel;

  const PermissionInfoDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actionText,
    required this.onActionPressed,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            onActionPressed();
            Navigator.of(context).pop();
          },
          child: Text(actionText),
        ),
      ],
    );
  }
}
