import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/services/cache_service.dart';

import 'package:random_please/layouts/section_sidebar_scrolling_layout.dart';
import 'package:random_please/widgets/generic/section_item.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/widgets/security/security_settings_widget.dart';
import 'package:random_please/widgets/generic/uni_route.dart';
import 'package:random_please/screens/settings/tool_ordering_screen.dart';
import 'package:random_please/screens/settings/settings_screen.dart';
import 'package:random_please/screens/settings/remote_list_template_screen.dart';
import 'package:random_please/services/tool_order_service.dart';
import 'package:random_please/providers/settings_provider.dart';
import 'package:random_please/providers/cache_provider.dart';
import 'package:random_please/providers/ui_settings_provider.dart';

class MainSettingsScreen extends ConsumerStatefulWidget {
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
  ConsumerState<MainSettingsScreen> createState() => _MainSettingsScreenState();
}

class _MainSettingsScreenState extends ConsumerState<MainSettingsScreen> {
  bool _loading = true;

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
    // Settings are now loaded via providers, so we can just trigger loading
    await Future.wait([
      ref.read(historyEnabledProvider.notifier).loadState(),
      ref.read(compactTabLayoutProvider.notifier).loadState(),
      ref.read(autoScrollToResultsProvider.notifier).loadState(),
      ref.read(cacheProvider.notifier).refreshCacheInfo(),
    ]);

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _clearCache() async {
    final l10n = AppLocalizations.of(context)!;
    await CacheService.confirmAndClearAllCache(context, l10n: l10n);
    // Refresh cache info via provider
    ref.read(cacheProvider.notifier).refreshCacheInfo();
  }

  void _onHistoryEnabledChanged(bool enabled) async {
    ref.read(historyEnabledProvider.notifier).setEnabled(enabled);
  }

  void _onSaveRandomToolsStateChanged(bool enabled) async {
    ref.read(settingsProvider.notifier).setSaveRandomToolsState(enabled);
  }

  void _onResetCounterOnToggleChanged(bool enabled) async {
    ref.read(settingsProvider.notifier).setResetCounterOnToggle(enabled);
  }

  void _onCompactTabLayoutChanged(bool enabled) async {
    ref.read(compactTabLayoutProvider.notifier).setEnabled(enabled);
  }

  void _onAutoScrollToResultsChanged(bool enabled) async {
    ref.read(autoScrollToResultsProvider.notifier).setEnabled(enabled);
  }

  void _onAutoCleanupHistoryLimitChanged(int? limit) async {
    ref.read(settingsProvider.notifier).setAutoCleanupHistoryLimit(limit);
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
      title: loc.settings,
      theme: Theme.of(context),
      darkTheme: Theme.of(context),
      themeMode: Theme.of(context).brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      // ✅ Add localization support
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('vi'), // Vietnamese
      ],
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
        VerticalSpacingDivider.both(6),
        _buildAutoScrollToResultsSettings(loc),
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
        _buildResetCounterOnToggleSettings(loc),
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
        _buildAutoCleanupHistorySettings(loc),
        const SizedBox(height: 24),
        SecuritySettingsWidget(loc: loc),
        const SizedBox(height: 24),
        _buildCacheManagement(loc),
        // const SizedBox(height: 24),
        // _buildExpandableLogSection(loc),
      ],
    );
  }

  Widget _buildHistorySettings(AppLocalizations loc) {
    final historyEnabled = ref.watch(historyEnabledProvider);
    return OptionSwitch(
      title: loc.saveGenerationHistory,
      subtitle: loc.saveGenerationHistoryDesc,
      value: historyEnabled,
      onChanged: _onHistoryEnabledChanged,
      decorator: switchDecorator,
    );
  }

  Widget _buildSaveRandomToolsStateSettings(AppLocalizations loc) {
    final settings = ref.watch(settingsProvider);
    return OptionSwitch(
      title: loc.saveRandomToolsState,
      subtitle: loc.saveRandomToolsStateDesc,
      value: settings.saveRandomToolsState,
      onChanged: _onSaveRandomToolsStateChanged,
      decorator: switchDecorator,
    );
  }

  Widget _buildResetCounterOnToggleSettings(AppLocalizations loc) {
    final settings = ref.watch(settingsProvider);
    return OptionSwitch(
      title: loc.resetCounterOnToggle,
      subtitle: loc.resetCounterOnToggleDesc,
      value: settings.resetCounterOnToggle,
      onChanged: _onResetCounterOnToggleChanged,
      decorator: switchDecorator,
    );
  }

  Widget _buildCompactTabLayoutSettings(AppLocalizations loc) {
    final compactTabLayout = ref.watch(compactTabLayoutProvider);
    return OptionSwitch(
      title: loc.compactTabLayout,
      subtitle: loc.compactTabLayoutDesc,
      value: compactTabLayout,
      onChanged: _onCompactTabLayoutChanged,
      decorator: switchDecorator,
    );
  }

  Widget _buildAutoScrollToResultsSettings(AppLocalizations loc) {
    final autoScrollToResults = ref.watch(autoScrollToResultsProvider);
    return OptionSwitch(
      title: loc.autoScrollToResults,
      subtitle: loc.autoScrollToResultsDesc,
      value: autoScrollToResults,
      onChanged: _onAutoScrollToResultsChanged,
      decorator: switchDecorator,
    );
  }

  Widget _buildAutoCleanupHistorySettings(AppLocalizations loc) {
    final autoCleanupHistoryLimit = ref.watch(autoCleanupHistoryLimitProvider);

    // Define the options with proper localization
    final options = <int?>[20, 30, 40, 50, 60, 70, 80, 90, 100, null];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              loc.autoCleanupHistoryLimit,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            subtitle: Text(
              loc.autoCleanupHistoryLimitDesc,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 150,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int?>(
              value: autoCleanupHistoryLimit,
              isExpanded: true,
              onChanged: _onAutoCleanupHistoryLimitChanged,
              items: options.map<DropdownMenuItem<int?>>((int? value) {
                return DropdownMenuItem<int?>(
                  value: value,
                  child: Text(
                    value == null ? loc.noLimit : value.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
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
      UniRoute.navigate(
        context,
        UniRouteModel(
          title: loc.arrangeTools,
          content: const ToolOrderingScreen(isEmbedded: true),
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
        loc.remoteListTemplateSource,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      subtitle: Text(
        loc.remoteListTemplateSourceDesc,
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
      UniRoute.navigate(
        context,
        UniRouteModel(
          title: loc.remoteListTemplateSource,
          content: const RemoteListTemplateScreen(isEmbedded: true),
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
            Text('${loc.cache}: ${ref.watch(cacheProvider)}'),
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
}
