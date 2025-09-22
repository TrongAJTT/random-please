import 'package:flutter/material.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/services/cache_service.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/services/settings_service.dart';

import 'package:random_please/layouts/section_sidebar_scrolling_layout.dart';
import 'package:random_please/widgets/generic/section_item.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/widgets/security/security_settings_widget.dart';
import 'package:random_please/widgets/generic/generic_settings_helper.dart';
import 'package:random_please/screens/settings/tool_ordering_screen.dart';
import 'package:random_please/screens/settings/settings_screen.dart';
import 'package:random_please/screens/settings/remote_list_template_screen.dart';
import 'package:random_please/services/tool_order_service.dart';

class MainSettingsScreen extends StatefulWidget {
  final bool isEmbedded;
  final VoidCallback? onToolVisibilityChanged;
  final String? initialSectionId;

  const MainSettingsScreen({
    super.key,
    this.isEmbedded = false,
    this.onToolVisibilityChanged,
    this.initialSectionId,
  });

  @override
  State<MainSettingsScreen> createState() => _MainSettingsScreenState();
}

class _MainSettingsScreenState extends State<MainSettingsScreen> {
  bool _loading = true;
  bool _historyEnabled = false;
  bool _saveRandomToolsState = true;
  bool _compactTabLayout = false;
  String _cacheInfo = '...';

  // Static decorator for settings
  late final OptionSwitchDecorator switchDecorator;
  bool _isDecoratorInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDecoratorInitialized) {
      switchDecorator = OptionSwitchDecorator.compact(context);
      _isDecoratorInitialized = true;
    }
  }

  Future<void> _loadSettings() async {
    final historyEnabled = await GenerationHistoryService.isHistoryEnabled();
    final saveRandomToolsState =
        await SettingsService.getSaveRandomToolsState();
    final compactTabLayout = await SettingsService.getCompactTabLayout();
    final totalSize = await CacheService.getTotalCacheSize();

    setState(() {
      _historyEnabled = historyEnabled;
      _saveRandomToolsState = saveRandomToolsState;
      _compactTabLayout = compactTabLayout;
      _cacheInfo = CacheService.formatCacheSize(totalSize);
      _loading = false;
    });
  }

  Future<void> _clearCache() async {
    final l10n = AppLocalizations.of(context)!;
    await CacheService.confirmAndClearAllCache(context, l10n: l10n);
    // Refresh info after dialog closes
    await _loadSettings();
  }

  void _onHistoryEnabledChanged(bool enabled) async {
    setState(() => _historyEnabled = enabled);
    await GenerationHistoryService.setHistoryEnabled(enabled);
  }

  void _onSaveRandomToolsStateChanged(bool enabled) async {
    setState(() => _saveRandomToolsState = enabled);
    await SettingsService.updateSaveRandomToolsState(enabled);
  }

  void _onCompactTabLayoutChanged(bool enabled) async {
    setState(() => _compactTabLayout = enabled);
    await SettingsService.updateCompactTabLayout(enabled);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    Widget content;

    if (_loading) {
      content = widget.isEmbedded
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              appBar: AppBar(title: Text(loc.settings)),
              body: const Center(child: CircularProgressIndicator()),
            );
    } else {
      content = SectionSidebarScrollingLayout(
        title: loc.settings,
        sections: _buildSections(loc),
        isEmbedded: widget.isEmbedded,
        selectedSectionId: widget.initialSectionId ?? 'user_interface',
      );
    }

    // If embedded, return the content directly (parent will provide Material context)
    if (widget.isEmbedded) {
      return content;
    }

    // If not embedded, wrap with MaterialApp to ensure Material context
    return MaterialApp(
      title: 'Settings',
      theme: Theme.of(context),
      darkTheme: Theme.of(context),
      themeMode: Theme.of(context).brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      home: content,
      debugShowCheckedModeBanner: false,
    );
  }

  List<SectionItem> _buildSections(AppLocalizations loc) {
    return [
      SectionItem(
        id: 'user_interface',
        title: loc.userInterface,
        subtitle: loc.userInterfaceDesc,
        icon: Icons.palette,
        iconColor: Colors.blue,
        content: _buildUserInterfaceSection(loc),
      ),
      SectionItem(
        id: 'random_tools',
        title: loc.randomTools,
        subtitle: loc.randomToolsDesc,
        icon: Icons.casino,
        iconColor: Colors.purple,
        content: _buildRandomToolsSection(loc),
      ),
      SectionItem(
        id: 'data_management',
        title: loc.dataManager,
        subtitle: loc.dataManagerDesc,
        icon: Icons.storage,
        iconColor: Colors.red,
        content: _buildDataSection(loc),
      ),
    ];
  }

  Widget _buildUserInterfaceSection(AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Theme & Language (from MVVM SettingsScreen) without cache controls
        const SettingsScreen(isEmbedded: true, showCacheSection: false),
        const SizedBox(height: 16),
        _buildCompactTabLayoutSettings(loc),
      ],
    );
  }

  Widget _buildRandomToolsSection(AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHistorySettings(loc),
        VerticalSpacingDivider.both(6),
        _buildSaveRandomToolsStateSettings(loc),
        VerticalSpacingDivider.both(6),
        _buildToolOrderingSettings(loc),
        VerticalSpacingDivider.both(6),
        _buildRemoteListTemplateSettings(loc),
      ],
    );
  }

  Widget _buildDataSection(AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SecuritySettingsWidget(loc: loc),
        const SizedBox(height: 24),
        _buildCacheManagement(loc),
        // const SizedBox(height: 24),
        // _buildExpandableLogSection(loc),
      ],
    );
  }

  Widget _buildHistorySettings(AppLocalizations loc) {
    return OptionSwitch(
      title: loc.saveGenerationHistory,
      subtitle: loc.saveGenerationHistoryDesc,
      value: _historyEnabled,
      onChanged: _onHistoryEnabledChanged,
      decorator: switchDecorator,
    );
  }

  Widget _buildSaveRandomToolsStateSettings(AppLocalizations loc) {
    return OptionSwitch(
      title: loc.saveRandomToolsState,
      subtitle: loc.saveRandomToolsStateDesc,
      value: _saveRandomToolsState,
      onChanged: _onSaveRandomToolsStateChanged,
      decorator: switchDecorator,
    );
  }

  Widget _buildCompactTabLayoutSettings(AppLocalizations loc) {
    return OptionSwitch(
      title: loc.compactTabLayout,
      subtitle: loc.compactTabLayoutDesc,
      value: _compactTabLayout,
      onChanged: _onCompactTabLayoutChanged,
      decorator: switchDecorator,
    );
  }

  Widget _buildToolOrderingSettings(AppLocalizations loc) {
    return ListTile(
      leading: Icon(
        Icons.reorder,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        loc.arrangeTools,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      subtitle: Text(
        loc.arrangeToolsDesc,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: () => _showToolOrderingScreen(loc),
      contentPadding: EdgeInsets.zero,
    );
  }

  Future<void> _showToolOrderingScreen(AppLocalizations loc) async {
    // Check the current custom order status
    final hadCustomOrderBefore = await ToolOrderService.isCustomOrder();

    // Show the tool ordering screen
    if (mounted) {
      GenericSettingsHelper.showSettings(
        context,
        GenericSettingsConfig(
          title: loc.arrangeTools,
          settingsLayout: const ToolOrderingScreen(isEmbedded: true),
          onSettingsChanged: (newSettings) {
            // Empty lambda as requested
          },
        ),
      );
    }

    // Check if order changed after the screen closes
    // Note: This is a simplified approach - in a real app you might want
    // to use a more sophisticated state management solution
    Future.delayed(const Duration(milliseconds: 500), () async {
      final hasCustomOrderAfter = await ToolOrderService.isCustomOrder();
      if (hadCustomOrderBefore != hasCustomOrderAfter &&
          widget.onToolVisibilityChanged != null) {
        widget.onToolVisibilityChanged!();
      }
    });
  }

  Widget _buildRemoteListTemplateSettings(AppLocalizations loc) {
    return ListTile(
      leading: Icon(
        Icons.cloud,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        'Remote List Template Source',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      subtitle: Text(
        'Manage cloud template sources for Pick From List',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: () => _showRemoteListTemplateScreen(loc),
      contentPadding: EdgeInsets.zero,
    );
  }

  Future<void> _showRemoteListTemplateScreen(AppLocalizations loc) async {
    if (mounted) {
      GenericSettingsHelper.showSettings(
        context,
        GenericSettingsConfig(
          title: 'Remote List Template Source',
          settingsLayout: const RemoteListTemplateScreen(isEmbedded: true),
          onSettingsChanged: (newSettings) {
            // Empty lambda as requested
          },
        ),
      );
    }
  }

  Widget _buildCacheManagement(AppLocalizations loc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.storage,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  loc.dataAndStorage,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(loc.historyManager,
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            Text('${loc.cache}: $_cacheInfo'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _clearCache,
                    icon: const Icon(Icons.delete_forever),
                    label: Text(loc.clearCache),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget _buildExpandableLogSection(AppLocalizations loc) {
  //   return ExpandableOptionCard(
  //     initialExpanded: _logSectionExpanded,
  //     onExpansionChanged: (isExpanded) {
  //       setState(() => _logSectionExpanded = isExpanded);
  //       if (isExpanded) {
  //         _loadLogInfo();
  //       }
  //     },
  //     option: OptionItem.withIcon(
  //       value: null,
  //       label: loc.logApplication,
  //       subtitle: loc.logsManagement,
  //       iconData: Icons.description_outlined,
  //       iconSize: 20,
  //       iconColor: Theme.of(context).colorScheme.primary,
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Log info
  //         Row(
  //           children: [
  //             Icon(
  //               Icons.info_outline,
  //               size: 16,
  //               color: Theme.of(context).colorScheme.onSurfaceVariant,
  //             ),
  //             const SizedBox(width: 8),
  //             Text(
  //               loc.statusInfo(_logInfo),
  //               style: Theme.of(context).textTheme.bodySmall?.copyWith(
  //                     color: Theme.of(context).colorScheme.onSurfaceVariant,
  //                   ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         _buildLogRetentionSettings(loc),
  //         const SizedBox(height: 16),
  //         _buildLogManagementButtons(loc),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildLogRetentionSettings(AppLocalizations loc) {
  //   // Map retention days to slider index
  //   final List<SliderOption<int>> logOptions = [
  //     SliderOption(value: 5, label: loc.logRetentionDays(5)),
  //     SliderOption(value: 10, label: loc.logRetentionDays(10)),
  //     SliderOption(value: 15, label: loc.logRetentionDays(15)),
  //     SliderOption(value: 20, label: loc.logRetentionDays(20)),
  //     SliderOption(value: 25, label: loc.logRetentionDays(25)),
  //     SliderOption(value: 30, label: loc.logRetentionDays(30)),
  //     SliderOption(value: -1, label: loc.logRetentionForever),
  //   ];

  //   return OptionSlider<int>(
  //     label: loc.logRetention,
  //     subtitle: loc.logRetentionDescDetail,
  //     icon: Icons.history,
  //     currentValue: _logRetentionDays,
  //     options: logOptions,
  //     onChanged: (days) async {
  //       setState(() => _logRetentionDays = days);
  //       await _updateLogRetention(days);
  //     },
  //     layout: OptionSliderLayout.none,
  //   );
  // }

  // Widget _buildLogManagementButtons(AppLocalizations loc) {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: OutlinedButton.icon(
  //           icon: const Icon(Icons.visibility_outlined),
  //           label: Text(loc.viewLogs),
  //           style: OutlinedButton.styleFrom(
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8)),
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //           ),
  //           onPressed: _showLogViewer,
  //         ),
  //       ),
  //       const SizedBox(width: 12),
  //       Expanded(
  //         child: OutlinedButton.icon(
  //           icon: const Icon(Icons.delete_sweep_outlined),
  //           label: Text(loc.clearLogs),
  //           style: OutlinedButton.styleFrom(
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8)),
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //           ),
  //           onPressed: _forceCleanupLogs,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // void _showLogViewer() async {
  //   final screenWidth = MediaQuery.of(context).size.width;

  //   if (widget.isEmbedded && screenWidth >= 900) {
  //     // If embedded in desktop view, show as dialog
  //     await showDialog(
  //       context: context,
  //       builder: (context) => Dialog(
  //         child: SizedBox(
  //           width: MediaQuery.of(context).size.width * 0.8,
  //           height: MediaQuery.of(context).size.height * 0.8,
  //           child: const LogViewerScreen(isEmbedded: true),
  //         ),
  //       ),
  //     );
  //   } else {
  //     // Mobile or standalone - navigate to full screen
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) => const LogViewerScreen(),
  //       ),
  //     );
  //   }
  // }

  // Future<void> _loadLogInfo() async {
  //   if (!mounted) return;

  //   final l10n = AppLocalizations.of(context)!;
  //   if (mounted) {
  //     setState(() {
  //       _logInfo = l10n.calculating;
  //     });
  //   }

  //   // Simulate loading time
  //   await Future.delayed(const Duration(milliseconds: 500));

  //   // This would load actual log information
  //   // For now, just set some placeholder data
  //   if (mounted) {
  //     setState(() {
  //       _logInfo = l10n.logsAvailable;
  //     });
  //   }
  // }

  // Future<void> _updateLogRetention(int days) async {
  //   setState(() {
  //     _logRetentionDays = days;
  //   });
  //   await SettingsService.updateLogRetentionDays(days);
  // }

  // Future<void> _forceCleanupLogs() async {
  //   final l10n = AppLocalizations.of(context)!;

  //   try {
  //     // Show loading indicator
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => AlertDialog(
  //         content: Row(
  //           children: [
  //             const CircularProgressIndicator(),
  //             const SizedBox(width: 16),
  //             Expanded(child: Text(l10n.deletingOldLogs)),
  //           ],
  //         ),
  //       ),
  //     );

  //     // Force cleanup
  //     final deletedCount = await AppLogger.instance.forceCleanupNow();

  //     // Close loading dialog
  //     if (mounted) Navigator.of(context).pop();

  //     // Pre-compute message
  //     final message = deletedCount > 0
  //         ? l10n.deletedOldLogFiles(deletedCount)
  //         : l10n.noOldLogFilesToDelete;

  //     // Show result
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(message),
  //           duration: const Duration(seconds: 3),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     // Close loading dialog
  //     if (mounted) Navigator.of(context).pop();

  //     // Show error
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(l10n.errorDeletingLogs(e.toString())),
  //           backgroundColor: Theme.of(context).colorScheme.error,
  //           duration: const Duration(seconds: 3),
  //         ),
  //       );
  //     }
  //   }
  // }
}
