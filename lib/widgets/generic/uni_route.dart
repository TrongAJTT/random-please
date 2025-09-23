import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:random_please/l10n/app_localizations.dart';

/// Generic settings configuration
class UniRouteModel<T> {
  /// Title for the settings screen/dialog
  final String title;

  /// Settings layout widget
  final Widget content;

  /// Preferred size for dialog (only used on desktop)
  final Size? preferredSize;

  /// Whether dialog is dismissible
  final bool barrierDismissible;

  /// Padding for the content container
  final EdgeInsets? padding;

  const UniRouteModel({
    required this.title,
    required this.content,
    this.preferredSize,
    this.barrierDismissible = false,
    this.padding,
  });
}

/// Generic settings helper for navigating to different settings screens
class UniRoute {
  static void navigate<T>(
    BuildContext context,
    UniRouteModel<T> config,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 800;

    if (isDesktop) {
      // Desktop: Use dialog
      showDialog(
        context: context,
        barrierDismissible: config.barrierDismissible,
        builder: (context) => UniDialog(
          title: config.title,
          preferredSize: config.preferredSize,
          content: config.content,
          padding: config.padding,
          closeTooltip: AppLocalizations.of(context)!.close,
        ),
      );
    } else {
      // Mobile/Tablet: Use full screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UniScreen(
            title: config.title,
            content: config.content,
          ),
        ),
      );
    }
  }
}

class UniDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final Size? preferredSize;
  final EdgeInsets? padding;
  final String closeTooltip;

  const UniDialog({
    super.key,
    required this.title,
    required this.content,
    this.preferredSize,
    this.padding,
    this.closeTooltip = 'Close',
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
                    tooltip: closeTooltip,
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: padding ?? EdgeInsets.zero,
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UniScreen extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const UniScreen({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    // Get the current locale and theme from the parent context
    final currentLocale = Localizations.localeOf(context);
    final currentTheme = Theme.of(context);

    // For full-screen settings on mobile, we need to provide proper localization context
    return MaterialApp(
      title: title,
      theme: currentTheme,
      locale: currentLocale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null,
          centerTitle: false,
          actions: actions,
          bottom: bottom,
          elevation: 0,
          backgroundColor: currentTheme.colorScheme.surface,
          foregroundColor: currentTheme.colorScheme.onSurface,
        ),
        body: content,
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  // Helper method to create and push this screen
  static void show(
    BuildContext context, {
    required String title,
    required Widget settingsLayout,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UniScreen(
          title: title,
          content: settingsLayout,
          actions: actions,
          bottom: bottom,
        ),
      ),
    );
  }
}
