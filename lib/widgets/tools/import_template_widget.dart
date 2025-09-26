import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/models/cloud_template.dart';
import 'package:random_please/models/list_template_source.dart';
import 'package:random_please/providers/list_template_source_provider.dart';
import 'package:random_please/screens/settings/remote_list_template_screen.dart';
import 'package:random_please/widgets/common/step_indicator.dart';
import 'package:random_please/widgets/generic/uni_route.dart';

class ImportTemplateWidget extends ConsumerStatefulWidget {
  final bool isEmbedded;
  final Function(List<String> items, String listName)? onImport;

  const ImportTemplateWidget({
    super.key,
    this.isEmbedded = false,
    this.onImport,
  });

  @override
  ConsumerState<ImportTemplateWidget> createState() =>
      _ImportTemplateWidgetState();
}

class _ImportTemplateWidgetState extends ConsumerState<ImportTemplateWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AppLocalizations loc;

  // Step management
  int _currentStep = 0; // 0: Select Template, 1: Confirm, 2: Set Name
  CloudTemplate? _selectedTemplate;
  final TextEditingController _nameController = TextEditingController();
  bool _isImporting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loc = AppLocalizations.of(context)!;
  }

  void _selectTemplate(CloudTemplate template) {
    setState(() {
      _selectedTemplate = template;
      _currentStep = 1;
    });
  }

  void _confirmTemplate() {
    setState(() {
      _currentStep = 2;
      // Pre-fill the name with selected template name
      _nameController.text = _selectedTemplate?.name ?? '';
    });

    // Add listener to update preview when user types
    _nameController.addListener(() {
      setState(() {});
    });
  }

  void _goBack() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
        if (_currentStep == 0) {
          _selectedTemplate = null;
          _nameController.clear();
        }
      }
    });
  }

  Future<void> _confirmImport() async {
    if (_selectedTemplate != null &&
        widget.onImport != null &&
        _nameController.text.trim().isNotEmpty) {
      setState(() {
        _isImporting = true;
      });

      try {
        // Add some delay to show loading indicator
        await Future.delayed(const Duration(milliseconds: 500));

        // Import in background to avoid blocking UI
        await Future.microtask(() {
          widget.onImport!(
              _selectedTemplate!.values, _nameController.text.trim());
        });

        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isImporting = false;
          });
          // Show error if needed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${loc.error}: $e')),
          );
        }
      }
    }
  }

  void _refreshData() {
    ref.invalidate(listTemplateSourceProvider);
  }

  void _navigateToSettings() {
    UniRoute.navigate(
      context,
      UniRouteModel(
        title: loc.remoteListTemplateTitle,
        content: const RemoteListTemplateScreen(isEmbedded: true),
      ),
    );
    // Refresh data when returning from settings - schedule for next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  Widget _buildStepIndicator() {
    final l10n = AppLocalizations.of(context)!;
    return StepIndicator(
      currentStep: _currentStep,
      stepLabels: [
        l10n.selectTemplate,
        l10n.selectList,
        l10n.confirm,
      ],
      showCheckIcon: true,
      useContainer: true,
    );
  }

  Widget _buildSelectTemplateStep(List<ListTemplateSource> sources) {
    final theme = Theme.of(context);
    final customSources =
        sources.where((s) => !s.isDefault && s.hasData).toList();
    final defaultSources =
        sources.where((s) => s.isDefault && s.hasData).toList();

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
              Tab(text: '${loc.customSources} (${customSources.length})'),
              Tab(text: '${loc.defaultSources} (${defaultSources.length})'),
            ],
          ),
        ),

        // TabBarView
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTemplatesList(customSources),
              _buildTemplatesList(defaultSources),
            ],
          ),
        ),

        // Action buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                theme.colorScheme.surfaceContainerHighest.withValues(alpha: .3),
            border: Border(
              top: BorderSide(color: theme.dividerColor, width: 1),
            ),
          ),
          child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: _refreshData,
                icon: const Icon(Icons.refresh),
                label: Text(loc.refresh),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _navigateToSettings,
                  icon: const Icon(Icons.settings),
                  label: Text(loc.customizeData),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTemplatesList(List<ListTemplateSource> sources) {
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
              loc.noTemplatesAvailable,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              loc.fetchTemplatesFirst,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Flatten all templates from all sources
    final allTemplates = <CloudTemplate>[];
    for (final source in sources) {
      if (source.fetchedData != null) {
        allTemplates.addAll(source.fetchedData!);
      }
    }

    if (allTemplates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt,
                size: 64, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              loc.noTemplatesAvailable,
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: allTemplates
            .map((template) => _buildTemplateCard(template))
            .toList(),
      ),
    );
  }

  Widget _buildTemplateCard(CloudTemplate template) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.list_alt, color: theme.colorScheme.primary),
        title: Text(
          template.name,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(
          '${template.values.length} ${loc.items}',
          style: theme.textTheme.bodyMedium,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _selectTemplate(template),
      ),
    );
  }

  Widget _buildConfirmStep() {
    final theme = Theme.of(context);

    if (_selectedTemplate == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Template info header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                theme.colorScheme.surfaceContainerHighest.withValues(alpha: .3),
            border: Border(
              bottom: BorderSide(color: theme.dividerColor, width: 1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedTemplate!.name,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                '${_selectedTemplate!.values.length} ${loc.items}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),

        // Items list
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.templateItems,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ..._selectedTemplate!.values.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: .5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: .3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),

        // Action buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                theme.colorScheme.surfaceContainerHighest.withValues(alpha: .3),
            border: Border(
              top: BorderSide(color: theme.dividerColor, width: 1),
            ),
          ),
          child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: _goBack,
                icon: const Icon(Icons.arrow_back),
                label: Text(loc.back),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _confirmTemplate,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(loc.continueText),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSetNameStep() {
    final theme = Theme.of(context);

    if (_selectedTemplate == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Template info header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                theme.colorScheme.surfaceContainerHighest.withValues(alpha: .3),
            border: Border(
              bottom: BorderSide(color: theme.dividerColor, width: 1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.setListName,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                '${loc.template}: ${_selectedTemplate!.name}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${_selectedTemplate!.values.length} ${loc.items}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Name input form
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.listName,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: loc.listName,
                    hintText: _selectedTemplate!.name,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.list),
                  ),
                  maxLength: 30,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _confirmImport();
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Preview info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: .5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: .3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 16, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            loc.preview,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${loc.listName}: ${_nameController.text.trim().isEmpty ? _selectedTemplate!.name : _nameController.text.trim()}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        '${loc.items}: ${_selectedTemplate!.values.length}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Action buttons with loading indicator
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                theme.colorScheme.surfaceContainerHighest.withValues(alpha: .3),
            border: Border(
              top: BorderSide(color: theme.dividerColor, width: 1),
            ),
          ),
          child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: _goBack,
                icon: const Icon(Icons.arrow_back),
                label: Text(loc.back),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _nameController.text.trim().isNotEmpty
                      ? _confirmImport
                      : null,
                  icon: const Icon(Icons.download),
                  label: Text(loc.importTemplate),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sourcesAsync = ref.watch(listTemplateSourceProvider);

    return Scaffold(
      appBar: widget.isEmbedded
          ? null
          : AppBar(
              title: Text(loc.importTemplate),
              elevation: 0,
            ),
      body: Stack(
        children: [
          Column(
            children: [
              // Step indicator
              _buildStepIndicator(),

              // Content
              Expanded(
                child: sourcesAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error,
                            size: 64, color: theme.colorScheme.error),
                        const SizedBox(height: 16),
                        Text(loc.errorLoadingSources),
                        const SizedBox(height: 8),
                        Text(error.toString(),
                            style: theme.textTheme.bodySmall),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () =>
                              ref.invalidate(listTemplateSourceProvider),
                          child: Text(loc.retry),
                        ),
                      ],
                    ),
                  ),
                  data: (sources) {
                    switch (_currentStep) {
                      case 0:
                        return _buildSelectTemplateStep(sources);
                      case 1:
                        return _buildConfirmStep();
                      case 2:
                        return _buildSetNameStep();
                      default:
                        return _buildSelectTemplateStep(sources);
                    }
                  },
                ),
              ),
            ],
          ),

          // Loading overlay when importing
          if (_isImporting)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        loc.importing,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${loc.pleaseWait}...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
