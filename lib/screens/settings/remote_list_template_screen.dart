import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/models/list_template_source.dart';
import 'package:random_please/models/cloud_template.dart';
import 'package:random_please/providers/list_template_source_provider.dart';
import 'package:random_please/widgets/settings/list_template_fetch_widget.dart';
import 'package:random_please/services/list_template_source_service.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/utils/url_utils.dart';
import 'package:random_please/variables.dart';
import 'package:random_please/widgets/generic/icon_button_list.dart';
import 'package:random_please/widgets/generic/uni_route.dart';

class RemoteListTemplateScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const RemoteListTemplateScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  ConsumerState<RemoteListTemplateScreen> createState() =>
      _RemoteListTemplateScreenState();
}

class _RemoteListTemplateScreenState
    extends ConsumerState<RemoteListTemplateScreen>
    with TickerProviderStateMixin {
  bool _hasChanges = false;
  late TabController _tabController;
  late AppLocalizations loc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: 0); // Start with Custom tab
    // Auto-fetch default sources if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndFetchDefaultSources();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loc = AppLocalizations.of(context)!;
  }

  Future<void> _checkAndFetchDefaultSources() async {
    final sources = ListTemplateSourceService.getAllSources();
    final defaultSources = sources.where((s) => s.isDefault).toList();

    // Only auto-fetch if no default template has any data
    final hasAnyDefaultData = defaultSources.any((s) => s.hasData);

    if (!hasAnyDefaultData && defaultSources.isNotEmpty) {
      await _fetchSources(defaultSources);
    }
  }

  Future<void> _fetchSources(List<ListTemplateSource> sources) async {
    final requests = sources
        .map((s) => FetchSourceRequest(
              name: s.name,
              url: s.url,
            ))
        .toList();
    UniRoute.navigate(
      context,
      UniRouteModel(
        title: loc.fetchTemplate,
        content: ListTemplateFetchLayout(
          isEmbedded: widget.isEmbedded,
          sources: requests,
          onContinue: _onFetchComplete,
        ),
      ),
    );

    // Refresh the sources list
    ref.invalidate(listTemplateSourceProvider);
  }

  // Fetch sources with overwrite logic (for Fetch Latest Defaults)
  Future<void> _fetchSourcesWithOverwrite(
      List<ListTemplateSource> sources) async {
    final requests = sources
        .map((s) => FetchSourceRequest(
              name: s.name,
              url: s.url,
            ))
        .toList();
    UniRoute.navigate(
      context,
      UniRouteModel(
        title: loc.fetchTemplate,
        content: ListTemplateFetchLayout(
          isEmbedded: widget.isEmbedded,
          sources: requests,
          onContinue: (fetchResults) =>
              _onFetchCompleteWithOverwrite(fetchResults),
        ),
      ),
    );

    // Refresh the sources list
    ref.invalidate(listTemplateSourceProvider);
  }

  // Handle fetch completion - save fetched data to sources
  void _onFetchComplete(Map<String, List<CloudTemplate>> fetchResults) async {
    try {
      final sources = ListTemplateSourceService.getAllSources();

      // Update each source with its fetched data
      for (final source in sources) {
        final templates = fetchResults[source.name];
        if (templates != null && templates.isNotEmpty) {
          source.fetchedData = templates;
          source.lastFetchDate = DateTime.now();
          source.lastError = null;
          await source.save();
        }
      }

      setState(() => _hasChanges = true);

      // Refresh the provider to update UI
      ref.invalidate(listTemplateSourceProvider);
    } catch (e) {
      // Handle error
      if (mounted) {
        SnackBarUtils.showTyped(
            context, '${loc.errorSavingData}: $e', SnackBarType.error);
      }
    }
  }

  // Handle fetch completion with overwrite logic - for Fetch Latest Defaults
  void _onFetchCompleteWithOverwrite(
      Map<String, List<CloudTemplate>> fetchResults) async {
    try {
      final sources = ListTemplateSourceService.getAllSources();

      // Update each source with its fetched data (with overwrite logic)
      for (final source in sources) {
        final templates = fetchResults[source.name];
        if (templates != null && templates.isNotEmpty) {
          // Always overwrite existing data (even if it exists)
          source.fetchedData = templates;
          source.lastFetchDate = DateTime.now();
          source.lastError = null;
          await source.save();
        }
      }

      setState(() => _hasChanges = true);

      // Refresh the provider to update UI
      ref.invalidate(listTemplateSourceProvider);
    } catch (e) {
      // Handle error
      if (mounted) {
        SnackBarUtils.showTyped(
            context, '${loc.errorSavingData}: $e', SnackBarType.error);
      }
    }
  }

  void _toggleVisibility(ListTemplateSource source) async {
    final success = await ref
        .read(listTemplateSourceProvider.notifier)
        .toggleSourceEnabled(source);
    if (success) {
      setState(() => _hasChanges = true);
      // Force refresh provider to update UI
      ref.invalidate(listTemplateSourceProvider);
    }
  }

  void _addCustomSource() {
    showDialog(
      context: context,
      builder: (context) => _AddSourceDialog(
        onAdd: (name, url) async {
          final success = await ref
              .read(listTemplateSourceProvider.notifier)
              .addCustomSource(name: name, url: url);
          if (success) {
            setState(() => _hasChanges = true);
            // Force refresh provider to update UI
            ref.invalidate(listTemplateSourceProvider);
          }
        },
      ),
    );
  }

  void _editSource(ListTemplateSource source) {
    if (source.isDefault) return;

    showDialog(
      context: context,
      builder: (context) => _EditSourceDialog(
        initialName: source.name,
        initialUrl: source.url,
        onSave: (name, url) async {
          final updatedSource = source.copyWith(name: name, url: url);
          final success = await ref
              .read(listTemplateSourceProvider.notifier)
              .updateSource(updatedSource);
          if (success) {
            setState(() => _hasChanges = true);
            // Force refresh provider to update UI
            ref.invalidate(listTemplateSourceProvider);
          }
        },
      ),
    );
  }

  void _removeSource(ListTemplateSource source) async {
    if (source.isDefault) return;

    final success = await ref
        .read(listTemplateSourceProvider.notifier)
        .deleteSource(source);
    if (success) {
      setState(() => _hasChanges = true);
      // Force refresh provider to update UI
      ref.invalidate(listTemplateSourceProvider);
    }
  }

  void _viewSource(ListTemplateSource source) async {
    await UriUtils.viewUniUrl(
      context,
      source.url,
    );
  }

  void _fetchSource(ListTemplateSource source) async {
    await _fetchSources([source]);
  }

  void _fetchAllSources(List<ListTemplateSource> allSources) async {
    final enabledSources = allSources.where((s) => s.isEnabled).toList();
    if (enabledSources.isNotEmpty) {
      await _fetchSources(enabledSources);
    }
  }

  void _fetchLatestDefaults() async {
    try {
      // Step 1: Refresh default sources metadata from remote index
      await ListTemplateSourceService.refreshDefaultSources();

      // Step 2: Get updated default sources and fetch their data (with overwrite)
      final sources = ListTemplateSourceService.getAllSources();
      final defaultSources = sources.where((s) => s.isDefault).toList();

      if (defaultSources.isNotEmpty) {
        // Force fetch with overwrite - similar to initial fetch but always overwrite existing data
        await _fetchSourcesWithOverwrite(defaultSources);
      }

      // Force refresh provider to update UI
      ref.invalidate(listTemplateSourceProvider);

      setState(() => _hasChanges = true);
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showTyped(
            context, '${loc.errorUpdatingDefaults}: $e', SnackBarType.error);
      }
    }
  }

  Widget _buildSourcesList(
      BuildContext context, List<ListTemplateSource> sources) {
    final theme = Theme.of(context);
    final defaultSources = sources.where((s) => s.isDefault).toList();
    final customSources = sources.where((s) => !s.isDefault).toList();

    final defaultEnabled = defaultSources.where((s) => s.isEnabled).length;
    final customEnabled = customSources.where((s) => s.isEnabled).length;

    return Column(
      children: [
        // TabBar
        Container(
          decoration: BoxDecoration(
            color:
                theme.colorScheme.surfaceContainerHighest.withValues(alpha: .3),
            border: Border(
              bottom: BorderSide(color: theme.dividerColor, width: 1),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                  text:
                      '${loc.customSources} ($customEnabled/${customSources.length})'),
              Tab(
                  text:
                      '${loc.defaultSources} ($defaultEnabled/${defaultSources.length})'),
            ],
          ),
        ),

        // TabBarView with sources list
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Custom sources tab
              _buildSourcesTabContent(context, customSources),
              // Default sources tab
              _buildSourcesTabContent(context, defaultSources),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSourcesTabContent(
      BuildContext context, List<ListTemplateSource> sources) {
    final theme = Theme.of(context);

    if (sources.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off,
                size: 64, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              loc.noSourcesToDisplay,
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children:
          sources.map((source) => _buildSourceCard(context, source)).toList(),
    );
  }

  Widget _buildTabActionButtons(
      BuildContext context, List<ListTemplateSource> sources) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AnimatedBuilder(
        animation: _tabController,
        builder: (context, child) {
          final currentTab = _tabController.index;

          return Row(
            children: [
              // Left button - Fetch All (always available)
              OutlinedButton.icon(
                onPressed: () => _fetchAllSources(sources),
                icon: const Icon(Icons.cloud_download),
                label: Text(loc.fetchAll),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child:
                    // Right button - depends on tab
                    (currentTab == 1)
                        ? // Default Sources tab
                        OutlinedButton.icon(
                            onPressed: _fetchLatestDefaults,
                            icon: const Icon(Icons.refresh),
                            label: Text(loc.fetchLatestDefaults),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          )
                        : // Custom Sources tab
                        OutlinedButton.icon(
                            onPressed: _addCustomSource,
                            icon: const Icon(Icons.add),
                            label: Text(loc.addCustomSource),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSourceCard(BuildContext context, ListTemplateSource source) {
    final theme = Theme.of(context);

    final trailingActions = [
      IconButtonListItem(
          icon: Icons.open_in_browser,
          label: loc.viewSourceUrl,
          onPressed: () => _viewSource(source)),
      IconButtonListItem(
          icon: source.isEnabled ? Icons.visibility : Icons.visibility_off,
          label: source.isEnabled ? loc.disable : loc.enable,
          onPressed: () => _toggleVisibility(source)),
      if (!source.isDefault)
        IconButtonListItem(
            icon: Icons.edit,
            label: loc.edit,
            onPressed: () => _editSource(source)),
      if (!source.isDefault)
        IconButtonListItem(
            icon: Icons.delete,
            label: loc.remove,
            onPressed: () => _removeSource(source)),
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              source.isEnabled ? Icons.visibility : Icons.visibility_off,
              color: source.isEnabled
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            title: Text(
              source.name,
              style: TextStyle(
                fontWeight:
                    source.isDefault ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              source.url,
              style: TextStyle(
                color: source.isEnabled
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.onSurfaceVariant.withValues(alpha: .6),
              ),
            ),
            trailing: IconButtonList(
              buttons: trailingActions,
              visibleCount: IconButtonList.getVisibleContext(context),
            ),
          ),

          // Status and fetch section
          if (source.isEnabled) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: .3),
                border: Border(
                  top: BorderSide(color: theme.dividerColor, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${loc.lastFetch}: ${source.lastFetchDescription}',
                          style: theme.textTheme.bodySmall,
                        ),
                        if (source.hasData) ...[
                          const SizedBox(height: 2),
                          Text(
                            source.statusDescription,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => _fetchSource(source),
                    icon: const Icon(Icons.refresh),
                    label: Text(loc.fetch),
                    style: FilledButton.styleFrom(
                      textStyle: theme.textTheme.bodySmall,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  void _showHelp() async {
    await UriUtils.viewUniUrl(
      context,
      listPickerTemplateHelpUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sourcesAsync = ref.watch(listTemplateSourceProvider);

    Widget content = Scaffold(
      appBar: widget.isEmbedded
          ? null
          : AppBar(
              title: Text(loc.remoteListTemplateTitle),
              elevation: 0,
            ),
      body: sourcesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(loc.errorLoadingSources),
              const SizedBox(height: 8),
              Text(error.toString(), style: theme.textTheme.bodySmall),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(listTemplateSourceProvider),
                child: Text(loc.retry),
              ),
            ],
          ),
        ),
        data: (sources) => Column(
          children: [
            // Sources list
            Expanded(
              child: _buildSourcesList(context, sources),
            ),

            // Action buttons row - dynamic based on current tab
            _buildTabActionButtons(context, sources),

            // Action buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: .3),
                border: Border(
                  top: BorderSide(color: theme.dividerColor, width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Help button
                  TextButton.icon(
                    onPressed: _showHelp,
                    icon: const Icon(Icons.help_outline),
                    label: Text(loc.whatIsThis),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  // Save
                  FilledButton.icon(
                    onPressed: _hasChanges ? _saveChanges : null,
                    icon: const Icon(Icons.save),
                    label: Text(loc.save),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return content;
  }
}

class _AddSourceDialog extends StatefulWidget {
  final Function(String, String) onAdd;

  const _AddSourceDialog({required this.onAdd});

  @override
  State<_AddSourceDialog> createState() => _AddSourceDialogState();
}

class _AddSourceDialogState extends State<_AddSourceDialog> {
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AppLocalizations loc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loc = AppLocalizations.of(context)!;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth * 0.9 > 600 ? 600.0 : screenWidth * 0.9;

    return AlertDialog(
      title: Text(loc.addCustomSource),
      content: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: dialogWidth, minWidth: dialogWidth),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: loc.name,
                  hintText: loc.myCustomSource,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return loc.pleaseEnterName;
                  }
                  return null;
                },
                autofocus: true,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: loc.url,
                  hintText: loc.urlHintText,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return loc.pleaseEnterUrl;
                  }
                  final uri = Uri.tryParse(value.trim());
                  if (uri == null || !uri.hasAbsolutePath) {
                    return loc.pleaseEnterValidUrl;
                  }
                  return null;
                },
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(loc.cancel),
        ),
        FilledButton(
          onPressed: () async {
            if (_formKey.currentState?.validate() == true) {
              await widget.onAdd(
                  _nameController.text.trim(), _urlController.text.trim());
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            }
          },
          child: Text(loc.fetch),
        ),
      ],
    );
  }
}

class _EditSourceDialog extends StatefulWidget {
  final String initialName;
  final String initialUrl;
  final Function(String, String) onSave;

  const _EditSourceDialog({
    required this.initialName,
    required this.initialUrl,
    required this.onSave,
  });

  @override
  State<_EditSourceDialog> createState() => _EditSourceDialogState();
}

class _EditSourceDialogState extends State<_EditSourceDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _urlController;
  final _formKey = GlobalKey<FormState>();
  late AppLocalizations loc;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _urlController = TextEditingController(text: widget.initialUrl);
  }

  @override
  void didChangeDependencies() {
    loc = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(loc.editSource),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: loc.name,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return loc.pleaseEnterName;
                }
                return null;
              },
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: loc.url,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return loc.pleaseEnterUrl;
                }
                final uri = Uri.tryParse(value.trim());
                if (uri == null || !uri.hasAbsolutePath) {
                  return loc.pleaseEnterValidUrl;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(loc.cancel),
        ),
        FilledButton(
          onPressed: () async {
            if (_formKey.currentState?.validate() == true) {
              await widget.onSave(
                  _nameController.text.trim(), _urlController.text.trim());
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            }
          },
          child: Text(loc.save),
        ),
      ],
    );
  }
}
