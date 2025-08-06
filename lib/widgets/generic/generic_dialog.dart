import 'package:flutter/material.dart';
import 'package:random_please/utils/icon_utils.dart';
import 'package:random_please/utils/size_utils.dart';

/// A decorator class to customize the appearance of a [GenericDialog].
@immutable
class GenericDialogDecorator {
  final DynamicDimension width;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? headerPadding;
  final EdgeInsetsGeometry? bodyPadding;
  final EdgeInsetsGeometry? footerPadding;
  final Color? headerBackColor;
  final Color? bodyBackColor;
  final Color? footerBackColor;
  final bool displayTopDivider;
  final bool displayBottomDivider;

  const GenericDialogDecorator({
    required this.width,
    this.borderRadius,
    this.headerPadding,
    this.bodyPadding,
    this.footerPadding,
    this.headerBackColor,
    this.bodyBackColor,
    this.footerBackColor,
    this.displayTopDivider = false,
    this.displayBottomDivider = false,
  });
}

/// A generic, customizable dialog header.
class GenericDialogHeader extends StatelessWidget {
  final GenericIcon? icon;
  final String title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final TextStyle? subtitleStyle;
  final bool displayExitButton;
  final GenericIcon? customExitIcon;

  const GenericDialogHeader({
    super.key,
    this.icon,
    required this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.displayExitButton = false,
    this.customExitIcon,
  }) : assert(customExitIcon == null || displayExitButton,
            'customExitIcon can only be used when displayExitButton is true.');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          icon!,
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: titleStyle ??
                    theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: subtitleStyle ??
                      theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ],
          ),
        ),
        if (displayExitButton)
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: customExitIcon ?? GenericIcon.icon(Icons.close),
            splashRadius: 20,
          ),
      ],
    );
  }
}

/// A generic dialog footer with preset button layouts.
class GenericDialogFooter extends StatelessWidget {
  final Widget child;

  const GenericDialogFooter({super.key, required this.child});

  /// Layout: [Reset to Default]...[Cancel][Save]
  factory GenericDialogFooter.defaultCancelSave({
    required VoidCallback onReset,
    required VoidCallback onCancel,
    required VoidCallback onSave,
    String? resetText,
    String? cancelText,
    String? saveText,
  }) {
    return GenericDialogFooter(
      child: Builder(builder: (context) {
        final l10n = MaterialLocalizations.of(context);
        return LayoutBuilder(
          builder: (context, constraints) {
            // Use a breakpoint to decide between wide and narrow layout
            final isWide = constraints.maxWidth > 380;

            if (isWide) {
              // WIDE LAYOUT: [Reset]......[Cancel][Save]
              return Row(
                children: [
                  TextButton.icon(
                    onPressed: onReset,
                    icon: const Icon(Icons.refresh),
                    label: Text(resetText ?? "Reset to Default"),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: onCancel,
                    child: Text(cancelText ?? l10n.cancelButtonLabel),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: onSave,
                    child: Text(saveText ?? l10n.okButtonLabel),
                  ),
                ],
              );
            } else {
              // NARROW LAYOUT:
              // [    Reset     ]
              // [Cancel] [Save]
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton.icon(
                    onPressed: onReset,
                    icon: const Icon(Icons.refresh),
                    label: Text(resetText ?? "Reset to Default"),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onCancel,
                          child: Text(cancelText ?? l10n.cancelButtonLabel),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onSave,
                          child: Text(saveText ?? l10n.okButtonLabel),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        );
      }),
    );
  }

  /// Layout: [Clear]...[Cancel][Save]
  factory GenericDialogFooter.clearCancelSave({
    required VoidCallback onClear,
    required VoidCallback onCancel,
    required VoidCallback onSave,
    String? clearText,
    String? cancelText,
    String? saveText,
  }) {
    return GenericDialogFooter(
      child: Builder(builder: (context) {
        final l10n = MaterialLocalizations.of(context);
        return Row(
          children: [
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.clear_all),
              label: Text(clearText ?? "Clear"),
            ),
            const Spacer(),
            TextButton(
              onPressed: onCancel,
              child: Text(cancelText ?? l10n.cancelButtonLabel),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onSave,
              child: Text(saveText ?? l10n.okButtonLabel),
            ),
          ],
        );
      }),
    );
  }

  /// Layout: [Cancel] [Save] (with configurable flex)
  factory GenericDialogFooter.cancelSave({
    required VoidCallback onCancel,
    required VoidCallback onSave,
    String? cancelText,
    String? saveText,
    int cancelFlex = 1,
    int saveFlex = 1,
  }) {
    return GenericDialogFooter(
      child: Builder(builder: (context) {
        final l10n = MaterialLocalizations.of(context);
        return Row(
          children: [
            Expanded(
              flex: cancelFlex,
              child: OutlinedButton(
                onPressed: onCancel,
                child: Text(cancelText ?? l10n.cancelButtonLabel),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: saveFlex,
              child: ElevatedButton(
                onPressed: onSave,
                child: Text(saveText ?? l10n.okButtonLabel),
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Layout for a single button (e.g., Save, OK, I Know, Close)
  factory GenericDialogFooter.singleButton({
    required String text,
    required VoidCallback onPressed,
    MainAxisAlignment alignment = MainAxisAlignment.end,
  }) {
    return GenericDialogFooter(
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          ElevatedButton(
            onPressed: onPressed,
            child: Text(text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// A generic dialog that combines a header, body, and footer.
class GenericDialog extends StatelessWidget {
  final GenericDialogHeader header;
  final Widget body;
  final GenericDialogFooter footer;
  final GenericDialogDecorator? decorator;

  const GenericDialog({
    super.key,
    required this.header,
    required this.body,
    required this.footer,
    this.decorator,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Use provided decorator or default values
    final effectiveDecorator = decorator ??
        GenericDialogDecorator(
          width: DynamicDimension.flexibility(90, 600),
        );

    final dialogWidth = effectiveDecorator.width.calculate(screenSize.width);

    final dialogShape = RoundedRectangleBorder(
      borderRadius:
          effectiveDecorator.borderRadius ?? BorderRadius.circular(12.0),
    );

    return AlertDialog(
      shape: dialogShape,
      title: null, // Title is handled inside content
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero, // All padding handled internally
      actions: null,
      actionsPadding: EdgeInsets.zero,
      // backgroundColor: Colors.transparent, // Avoid default background
      elevation: 0,

      content: SizedBox(
        width: dialogWidth,
        child: ClipRRect(
          borderRadius:
              effectiveDecorator.borderRadius ?? BorderRadius.circular(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: effectiveDecorator.headerPadding ??
                    const EdgeInsets.fromLTRB(24, 24, 12, 12),
                color: effectiveDecorator.headerBackColor ??
                    Theme.of(context).colorScheme.surface,
                child: header,
              ),

              if (effectiveDecorator.displayTopDivider)
                const Divider(height: 1),

              // Body
              Flexible(
                child: Container(
                  padding: effectiveDecorator.bodyPadding ??
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  color: effectiveDecorator.bodyBackColor ??
                      Theme.of(context).colorScheme.surface,
                  child: body,
                ),
              ),

              if (effectiveDecorator.displayBottomDivider)
                const Divider(height: 1),

              // Footer
              Container(
                padding: effectiveDecorator.footerPadding ??
                    const EdgeInsets.fromLTRB(24, 12, 24, 24),
                color: effectiveDecorator.footerBackColor ??
                    Theme.of(context).colorScheme.surface,
                child: footer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
