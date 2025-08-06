import 'package:flutter/material.dart';
import 'package:random_please/l10n/app_localizations.dart';

class ToolConfig {
  final String id;
  final String fixName;
  final String nameKey;
  final String descKey;
  final String icon;
  final String iconColor;
  final bool isVisible;
  final int order;

  const ToolConfig({
    required this.id,
    required this.nameKey,
    required this.descKey,
    required this.icon,
    required this.iconColor,
    required this.isVisible,
    required this.order,
    this.fixName = '',
  });

  static ToolConfig empty() {
    return const ToolConfig(
      id: '',
      fixName: '',
      nameKey: '',
      descKey: '',
      icon: '',
      iconColor: '',
      isVisible: false,
      order: 0,
    );
  }

  ToolConfig copyWith({
    String? id,
    String? nameKey,
    String? descKey,
    String? icon,
    String? iconColor,
    bool? isVisible,
    int? order,
  }) {
    return ToolConfig(
      id: id ?? this.id,
      nameKey: nameKey ?? this.nameKey,
      descKey: descKey ?? this.descKey,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      isVisible: isVisible ?? this.isVisible,
      order: order ?? this.order,
    );
  }

  IconData get iconData {
    switch (icon) {
      case 'description':
        return Icons.description;
      case 'casino':
        return Icons.casino;
      case 'swap_horiz':
        return Icons.swap_horiz;
      case 'calculate':
        return Icons.calculate;
      case 'share':
        return Icons.share;
      default:
        return Icons.extension; // Fallback icon
    }
  }

  Color get iconColorData {
    switch (iconColor) {
      case 'blue800':
        return Colors.blue[800]!;
      case 'purple':
        return Colors.purple;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'grey':
        return Colors.grey[700]!;
      case 'teal':
        return Colors.teal;
      default:
        return Colors.grey; // Fallback color
    }
  }

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (nameKey) {
      case 'textTemplateGen':
        return l10n.textTemplateGen;
      case 'random':
        return l10n.random;
      case 'converterTools':
        return l10n.converterTools;
      case 'calculatorTools':
        return l10n.calculatorTools;
      case 'p2pDataTransfer':
        return l10n.p2pDataTransfer;
      default:
        return nameKey;
    }
  }

  String get quickActionIcon {
    switch (id) {
      case 'textTemplate':
        return 'ic_text_template';
      case 'randomTools':
        return 'ic_random_generator';
      case 'converterTools':
        return 'ic_converter_tools';
      case 'calculatorTools':
        return 'ic_calculator_tools';
      case 'p2pDataTransfer':
        return 'ic_p2lan_active';
      default:
        return 'ic_default_tool';
    }
  }

  String getLocalizedDesc(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (descKey) {
      case 'textTemplateGenDesc':
        return l10n.textTemplateGenDesc;
      case 'randomDesc':
        return l10n.randomDesc;
      case 'converterToolsDesc':
        return l10n.converterToolsDesc;
      case 'calculatorToolsDesc':
        return l10n.calculatorToolsDesc;
      case 'p2pDataTransferDesc':
        return l10n.p2pDataTransferDesc;
      default:
        return descKey;
    }
  }
}
