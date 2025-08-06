import 'package:flutter/material.dart';

class GenericSettingsDialog extends StatelessWidget {
  final String title;
  final Widget settingsLayout;
  final Size? preferredSize;
  final EdgeInsets? padding;

  const GenericSettingsDialog({
    super.key,
    required this.title,
    required this.settingsLayout,
    this.preferredSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 1200;

    // Calculate optimal size
    final defaultWidth = isLargeScreen ? 800.0 : 700.0;
    final defaultHeight = isLargeScreen ? 900.0 : 850.0;

    final dialogWidth = preferredSize?.width ??
        (screenSize.width * (isLargeScreen ? 0.5 : 0.8))
            .clamp(400.0, defaultWidth);
    final dialogHeight = preferredSize?.height ??
        (screenSize.height * 0.8).clamp(300.0, defaultHeight);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: (screenSize.width - dialogWidth) / 2,
        vertical: (screenSize.height - dialogHeight) / 2,
      ),
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: padding ?? EdgeInsets.zero,
                child: settingsLayout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
