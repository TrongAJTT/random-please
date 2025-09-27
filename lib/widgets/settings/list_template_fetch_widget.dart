import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'dart:io';
import 'package:random_please/models/cloud_template.dart';
import 'package:random_please/services/list_template_source_service.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/utils/url_utils.dart';

// ViewModel for fetch layout
class ListTemplateFetchNotifier extends StateNotifier<ListTemplateFetchState> {
  ListTemplateFetchNotifier(List<FetchSourceRequest> sources)
      : super(ListTemplateFetchState.initial(sources)) {
    _fetchAllSources();
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> _fetchAllSources() async {
    // Check internet connection first
    final hasInternet = await _checkInternetConnection();
    if (!hasInternet) {
      state = state.copyWith(
        isLoading: false,
        error:
            'Please connect to the internet to download network data', // Will be localized in UI
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    final results = <String, FetchResult>{};
    int completed = 0;

    for (final sourceRequest in state.sources) {
      try {
        // Use direct URL fetch to avoid Hive issues
        final result = await ListTemplateSourceService.fetchFromUrl(
          url: sourceRequest.url,
          sourceName: sourceRequest.name,
        );
        results[sourceRequest.name] = result;

        completed++;
        state = state.copyWith(
          progress: completed / state.sources.length,
          fetchResults: results,
        );
      } catch (e) {
        results[sourceRequest.name] = FetchResult.error(e.toString());
        completed++;
        state = state.copyWith(
          progress: completed / state.sources.length,
          fetchResults: results,
        );
      }
    }

    // Check if all successful
    final hasErrors = results.values.any((result) => !result.isSuccess);

    state = state.copyWith(
      isLoading: false,
      isCompleted: true,
      hasErrors: hasErrors,
    );
  }

  void selectSource(String sourceName) {
    state = state.copyWith(selectedSource: sourceName);
  }

  Map<String, List<CloudTemplate>> getSuccessfulResults() {
    final successful = <String, List<CloudTemplate>>{};

    for (final entry in state.fetchResults.entries) {
      if (entry.value.isSuccess && entry.value.templates != null) {
        successful[entry.key] = entry.value.templates!;
      }
    }

    return successful;
  }
}

// State class for fetch layout
class ListTemplateFetchState {
  final List<FetchSourceRequest> sources;
  final bool isLoading;
  final bool isCompleted;
  final bool hasErrors;
  final double progress;
  final Map<String, FetchResult> fetchResults;
  final String? selectedSource;
  final String? error;

  const ListTemplateFetchState({
    required this.sources,
    this.isLoading = false,
    this.isCompleted = false,
    this.hasErrors = false,
    this.progress = 0.0,
    this.fetchResults = const {},
    this.selectedSource,
    this.error,
  });

  factory ListTemplateFetchState.initial(List<FetchSourceRequest> sources) {
    return ListTemplateFetchState(
      sources: sources,
      selectedSource: sources.isNotEmpty ? sources.first.name : null,
    );
  }

  ListTemplateFetchState copyWith({
    List<FetchSourceRequest>? sources,
    bool? isLoading,
    bool? isCompleted,
    bool? hasErrors,
    double? progress,
    Map<String, FetchResult>? fetchResults,
    String? selectedSource,
    String? error,
  }) {
    return ListTemplateFetchState(
      sources: sources ?? this.sources,
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
      hasErrors: hasErrors ?? this.hasErrors,
      progress: progress ?? this.progress,
      fetchResults: fetchResults ?? this.fetchResults,
      selectedSource: selectedSource ?? this.selectedSource,
      error: error ?? this.error,
    );
  }
}

// Request class for sources to fetch
class FetchSourceRequest {
  final String name;
  final String url;

  const FetchSourceRequest({
    required this.name,
    required this.url,
  });

  @override
  String toString() => 'FetchSourceRequest(name: $name, url: $url)';
}

class ListTemplateFetchLayout extends ConsumerStatefulWidget {
  final List<FetchSourceRequest> sources;
  final Function(Map<String, List<CloudTemplate>>)? onContinue;
  final bool isEmbedded;

  const ListTemplateFetchLayout({
    super.key,
    required this.sources,
    this.onContinue,
    this.isEmbedded = false,
  });

  @override
  ConsumerState<ListTemplateFetchLayout> createState() =>
      _ListTemplateFetchLayoutState();
}

class _ListTemplateFetchLayoutState
    extends ConsumerState<ListTemplateFetchLayout> {
  late final StateNotifierProvider<ListTemplateFetchNotifier,
      ListTemplateFetchState> _fetchProvider;

  @override
  void initState() {
    super.initState();
    _fetchProvider = StateNotifierProvider<ListTemplateFetchNotifier,
        ListTemplateFetchState>(
      (ref) => ListTemplateFetchNotifier(widget.sources),
    );
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  void _onContinue() {
    final notifier = ref.read(_fetchProvider.notifier);
    final results = notifier.getSuccessfulResults();

    if (widget.onContinue != null) {
      widget.onContinue!(results);
    }

    Navigator.of(context).pop(results);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(_fetchProvider);
    final theme = Theme.of(context);

    Widget content = Scaffold(
      appBar: widget.isEmbedded
          ? null
          : AppBar(
              title: Text(loc.fetchListTemplates),
              elevation: 0,
            ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Progress section
          if (state.isLoading || !state.isCompleted) ...[
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      state.isLoading ? loc.fetchingData : loc.preparing,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: state.progress,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        strokeWidth: 6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(state.progress * 100).toInt()}% completed',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Results section
          if (state.isCompleted) ...[
            // Source chips - wrapped
            _buildSourceSelector(context, state),
            VerticalSpacingDivider.both(4),
            // Content area
            _buildSourceContent(context, state),
          ],

          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: .3),
              border: Border(
                top: BorderSide(color: theme.dividerColor),
              ),
            ),
            child: Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: _onCancel,
                  child: Text(loc.cancel),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: state.isCompleted && !state.hasErrors
                      ? _onContinue
                      : null,
                  child: Text(loc.ccontinue),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return content;
  }

  Widget _buildSourceSelector(
      BuildContext context, ListTemplateFetchState state) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.25,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: widget.sources.map((source) {
                  final result = state.fetchResults[source.name];
                  final isSelected = state.selectedSource == source.name;
                  final hasError = result != null && !result.isSuccess;

                  return FilterChip(
                    label: Text(source.name),
                    selected: isSelected,
                    avatar: hasError
                        ? Icon(Icons.error,
                            size: 16, color: theme.colorScheme.error)
                        : result?.isSuccess == true
                            ? Icon(Icons.check_circle,
                                size: 16, color: theme.colorScheme.primary)
                            : const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                    onSelected: (selected) {
                      if (selected) {
                        ref
                            .read(_fetchProvider.notifier)
                            .selectSource(source.name);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSourceContent(
      BuildContext context, ListTemplateFetchState state) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    if (state.selectedSource == null) {
      return Center(child: Text(loc.noSourceSelected));
    }

    final result = state.fetchResults[state.selectedSource];
    final sourceRequest = widget.sources.firstWhere(
      (s) => s.name == state.selectedSource,
      orElse: () => widget.sources.first,
    );

    if (result == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!result.isSuccess) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              loc.failedToFetchData,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              result.error ?? loc.unknownError,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final templates = result.templates!;

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Source info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            sourceRequest.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.open_in_browser),
                          onPressed: () => UriUtils.viewUniUrl(
                            context: context,
                            url: sourceRequest.url,
                          ),
                          tooltip: loc.viewSourceUrl,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      sourceRequest.url,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildStatsRow(context, templates),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Templates list
            Text(
              loc.templatesCount(templates.length),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            ...templates
                .map((template) => _buildTemplateCard(context, template)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, List<CloudTemplate> templates) {
    final loc = AppLocalizations.of(context)!;

    // Calculate language stats
    final langStats = <String, int>{};
    for (final template in templates) {
      langStats[template.lang] =
          (langStats[template.lang] ?? 0) + template.values.length;
    }

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildStatChip(context, loc.templates, templates.length.toString()),
        ...langStats.entries.map(
          (entry) => _buildStatChip(
              context, entry.key.toUpperCase(), '${entry.value} items'),
        ),
      ],
    );
  }

  Widget _buildStatChip(BuildContext context, String label, String value) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(BuildContext context, CloudTemplate template) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(template.name),
        subtitle: Text(
            '${template.lang.toUpperCase()} • ${template.values.length} items'),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${loc.items}:',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: template.values
                      .take(20)
                      .map((value) => Chip(
                            label: Text(
                              value,
                              style: theme.textTheme.bodySmall,
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ))
                      .toList(),
                ),
                if (template.values.length > 20) ...[
                  const SizedBox(height: 8),
                  Text(
                    loc.andMoreItems(template.values.length - 20),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
