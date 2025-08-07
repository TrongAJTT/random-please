import 'package:flutter/widgets.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/variables.dart';

extension VersionTypeExtension on VersionType {
  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case VersionType.release:
        return l10n.versionTypeReleaseDisplay;
      case VersionType.beta:
        return l10n.versionTypeBetaDisplay;
      case VersionType.dev:
        return l10n.versionTypeDevDisplay;
    }
  }

  String getShortName(AppLocalizations l10n) {
    switch (this) {
      case VersionType.release:
        return l10n.versionTypeRelease;
      case VersionType.beta:
        return l10n.versionTypeBeta;
      case VersionType.dev:
        return l10n.versionTypeDev;
    }
  }
}

String getScreenTitle(String? title) {
  return title ?? appName;
}

bool isDesktopContext(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width > 600; // Desktop threshold
}
