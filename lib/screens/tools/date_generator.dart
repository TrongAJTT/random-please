import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/providers/date_generator_state_provider.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/size_utils.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/utils/widget_layout_render_helper.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/widgets/common/history_widget.dart';
import 'package:random_please/widgets/statistics/datetime_statistics_widget.dart';
import 'package:random_please/utils/auto_scroll_helper.dart';
import 'dart:math';

class DateGeneratorScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const DateGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<DateGeneratorScreen> createState() =>
      _DateGeneratorScreenState();
}

class _DateGeneratorScreenState extends ConsumerState<DateGeneratorScreen> {
  bool _copied = false;
  List<String> _results = [];
  final ScrollController _scrollController = ScrollController();

  late AppLocalizations loc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    loc = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _generateDates() async {
    try {
      final state = ref.read(dateGeneratorStateManagerProvider);
      final random = Random();
      final Set<DateTime> generatedSet = {};
      final List<String> resultList = [];

      // Normalize dates to ensure proper from/to relationship
      final date1 = DateTime(
          state.startDate.year, state.startDate.month, state.startDate.day);
      final date2 =
          DateTime(state.endDate.year, state.endDate.month, state.endDate.day);

      // Determine which date is earlier (from) and which is later (to)
      final DateTime fromDate;
      final DateTime toDate;

      if (date1.isBefore(date2) || date1.isAtSameMomentAs(date2)) {
        fromDate = date1;
        toDate = date2;
      } else {
        fromDate = date2;
        toDate = date1;
      }

      final totalDays = toDate.difference(fromDate).inDays;

      if (totalDays < 0) {
        setState(() {
          _results = [];
        });
        return;
      }

      for (int i = 0; i < state.dateCount; i++) {
        DateTime date;
        int attempts = 0;
        const maxAttempts = 1000;

        do {
          final randomDay = random.nextInt(totalDays + 1);
          date = fromDate.add(Duration(days: randomDay));
          attempts++;
        } while (!state.allowDuplicates &&
            generatedSet.contains(date) &&
            attempts < maxAttempts);

        if (!state.allowDuplicates) {
          generatedSet.add(date);
        }

        // Format date as YYYY-MM-DD
        final dateStr = "${date.year.toString().padLeft(4, '0')}-"
            "${date.month.toString().padLeft(2, '0')}-"
            "${date.day.toString().padLeft(2, '0')}";
        resultList.add(dateStr);
      }

      setState(() {
        _results = resultList;
      });

      // Auto-scroll to results after generation
      AutoScrollHelper.scrollToResults(
        ref: ref,
        scrollController: _scrollController,
        mounted: mounted,
        hasResults: _results.isNotEmpty,
      );

      // Save state after generation
      await ref
          .read(dateGeneratorStateManagerProvider.notifier)
          .saveCurrentState();

      // Save to history
      if (_results.isNotEmpty) {
        await ref.read(historyProvider.notifier).addHistoryItem(
              _results.join(', '),
              'date_generator',
            );
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showTyped(context, e.toString(), SnackBarType.error);
      }
    }
  }

  void _copyToClipboard() {
    if (_results.isNotEmpty) {
      String datesText = _results.join('\n');

      Clipboard.setData(ClipboardData(text: datesText));
      setState(() {
        _copied = true;
      });
      if (mounted) {
        SnackBarUtils.showTyped(context, loc.copied, SnackBarType.info);
      }
    }
  }

  String _getResultSubtitle() {
    if (_results.isEmpty) return '';
    return '${_results.length} ${loc.items.toLowerCase()}';
  }

  Widget _buildDateSelector(String label, DateTime date, VoidCallback onTap) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dateFormat.format(date)),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelectors() {
    final state = ref.watch(dateGeneratorStateManagerProvider);

    final startDateSelector = _buildDateSelector(
      loc.between,
      state.startDate,
      () async {
        final date = await showDatePicker(
          context: context,
          initialDate: state.startDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          ref
              .read(dateGeneratorStateManagerProvider.notifier)
              .updateStartDate(date);
          // Auto-adjust end date if needed to maintain between-and relationship
          final newState = ref.read(dateGeneratorStateManagerProvider);
          if (newState.startDate.isAfter(newState.endDate) ||
              newState.startDate.isAtSameMomentAs(newState.endDate)) {
            ref
                .read(dateGeneratorStateManagerProvider.notifier)
                .updateEndDate(newState.startDate.add(const Duration(days: 1)));
          }
        }
      },
    );

    final endDateSelector = _buildDateSelector(
      loc.and,
      state.endDate,
      () async {
        final date = await showDatePicker(
          context: context,
          initialDate: state.endDate,
          firstDate: state.startDate,
          lastDate: DateTime(2100),
        );
        if (date != null) {
          // Ensure end date is not before start date
          final currentState = ref.read(dateGeneratorStateManagerProvider);
          if (date.isBefore(currentState.startDate)) {
            // If selected end date is before start date, adjust start date
            ref
                .read(dateGeneratorStateManagerProvider.notifier)
                .updateStartDate(date.subtract(const Duration(days: 1)));
          }
          ref
              .read(dateGeneratorStateManagerProvider.notifier)
              .updateEndDate(date);
        }
      },
    );
    return WidgetLayoutRenderHelper.twoEqualWidthInRow(
      startDateSelector,
      endDateSelector,
      minWidth: 300,
      spacing: TwoDimSpacing.specific(vertical: 8, horizontal: 16),
    );
  }

  Widget _buildHistoryWidget() {
    return HistoryWidget(
      type: 'date_generator',
      title: loc.generationHistory,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dateGeneratorStateManagerProvider);

    final numberSlider = OptionSlider<int>(
      label: loc.dateCount,
      currentValue: state.dateCount,
      options: List.generate(
        40,
        (i) => SliderOption(value: i + 1, label: '${i + 1}'),
      ),
      fixedWidth: 60,
      onChanged: (value) {
        ref
            .read(dateGeneratorStateManagerProvider.notifier)
            .updateDateCount(value);
      },
      layout: OptionSliderLayout.none,
    );

    final duplicatesSwitch = OptionSwitch(
      title: loc.allowDuplicates,
      subtitle: loc.allowDuplicatesDesc,
      value: state.allowDuplicates,
      onChanged: (value) {
        ref
            .read(dateGeneratorStateManagerProvider.notifier)
            .updateAllowDuplicates(value);
      },
      decorator: OptionSwitchDecorator.compact(context),
    );

    // Build main content widget
    final generatorContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Configuration card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date selectors (responsive layout)
                _buildDateSelectors(),
                VerticalSpacingDivider.onlyTop(12),
                numberSlider,
                duplicatesSwitch,
                VerticalSpacingDivider.specific(top: 6, bottom: 12),
                // Generate button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _generateDates,
                    icon: const Icon(Icons.refresh),
                    label: Text(loc.generate),
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
        ),

        const SizedBox(height: 24),

        // Results
        if (_results.isNotEmpty) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with better design (similar to Number Generator)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.calendar_today,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.results,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              _getResultSubtitle(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _copyToClipboard,
                        icon: Icon(_copied ? Icons.check : Icons.copy),
                        tooltip: loc.copyToClipboard,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Results as Chips (similar to Number Generator)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _results.map((dateStr) {
                      return Tooltip(
                        message: loc.clickToCopy,
                        child: InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: dateStr));
                            SnackBarUtils.showTyped(
                                context, loc.copied, SnackBarType.info);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Chip(
                            label: Text(
                              dateStr,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            side: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Statistics
                  DateTimeStatisticsWidget(
                    values: _results.map((dateStr) {
                      final parts = dateStr.split('-');
                      return DateTime(
                        int.parse(parts[0]),
                        int.parse(parts[1]),
                        int.parse(parts[2]),
                      );
                    }).toList(),
                    type: DateTimeStatisticsType.date,
                    locale: loc.localeName,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );

    return RandomGeneratorLayout(
      generatorContent: generatorContent,
      historyWidget: _buildHistoryWidget(),
      historyEnabled: ref.watch(historyEnabledProvider),
      hasHistory: ref.watch(historyEnabledProvider),
      isEmbedded: widget.isEmbedded,
      title: loc.dateGenerator,
      scrollController: _scrollController,
    );
  }
}
