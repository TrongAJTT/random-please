import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/providers/date_time_generator_state_provider.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/size_utils.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/utils/widget_layout_render_helper.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/widgets/history_widget.dart';
import 'package:random_please/widgets/statistics/datetime_statistics_widget.dart';
import 'package:random_please/utils/auto_scroll_helper.dart';
import 'package:random_please/providers/settings_provider.dart';
import 'dart:math';

class DateTimeGeneratorScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const DateTimeGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<DateTimeGeneratorScreen> createState() =>
      _DateTimeGeneratorScreenState();
}

class _DateTimeGeneratorScreenState
    extends ConsumerState<DateTimeGeneratorScreen> {
  static const String historyType = 'datetime';
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

  Future<void> _generateDateTimes() async {
    try {
      final state = ref.read(dateTimeGeneratorProvider);
      final stateManager =
          ref.read(dateTimeGeneratorStateManagerProvider.notifier);
      final historyManager = ref.read(historyProvider.notifier);
      final random = Random();
      final Set<String> generatedSet = {};
      final List<String> resultList = [];

      // Normalize datetime range to ensure proper from/to relationship
      final dateTime1 = state.startDateTime;
      final dateTime2 = state.endDateTime;

      // Determine which datetime is earlier (from) and which is later (to)
      final DateTime fromDateTime;
      final DateTime toDateTime;

      if (dateTime1.isBefore(dateTime2)) {
        fromDateTime = dateTime1;
        toDateTime = dateTime2;
      } else {
        fromDateTime = dateTime2;
        toDateTime = dateTime1;
      }

      final totalDays = toDateTime.difference(fromDateTime).inDays;
      if (totalDays < 0) {
        setState(() {
          _results = [];
          _copied = false;
        });
        return;
      }

      final dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

      for (int i = 0; i < state.dateTimeCount; i++) {
        DateTime randomDateTime;
        String formattedDateTime;

        do {
          // Random day offset
          final randomDay = totalDays == 0 ? 0 : random.nextInt(totalDays + 1);
          final day = fromDateTime.add(Duration(days: randomDay));
          // Random ms in day
          final msInDay = 24 * 60 * 60 * 1000;
          int randomMs = 0;
          if (randomDay == 0 && totalDays == 0) {
            // Only one day, restrict ms to between from and to
            final startMs = fromDateTime.millisecond +
                fromDateTime.second * 1000 +
                fromDateTime.minute * 60000 +
                fromDateTime.hour * 3600000;
            final endMs = toDateTime.millisecond +
                toDateTime.second * 1000 +
                toDateTime.minute * 60000 +
                toDateTime.hour * 3600000;
            final msRange = endMs - startMs;
            randomMs =
                msRange > 0 ? random.nextInt(msRange + 1) + startMs : startMs;
          } else if (randomDay == 0) {
            // First day, restrict ms >= fromDateTime
            final startMs = fromDateTime.millisecond +
                fromDateTime.second * 1000 +
                fromDateTime.minute * 60000 +
                fromDateTime.hour * 3600000;
            randomMs = startMs + random.nextInt(msInDay - startMs);
          } else if (randomDay == totalDays) {
            // Last day, restrict ms <= toDateTime
            final endMs = toDateTime.millisecond +
                toDateTime.second * 1000 +
                toDateTime.minute * 60000 +
                toDateTime.hour * 3600000;
            randomMs = random.nextInt(endMs + 1);
          } else {
            // Any full day
            randomMs = random.nextInt(msInDay);
          }
          final hours = randomMs ~/ 3600000;
          final minutes = (randomMs % 3600000) ~/ 60000;
          final seconds = (randomMs % 60000) ~/ 1000;
          final milliseconds = randomMs % 1000;
          randomDateTime = DateTime(day.year, day.month, day.day, hours,
              minutes, seconds, milliseconds);
          formattedDateTime = dateTimeFormat.format(randomDateTime);
        } while (
            !state.allowDuplicates && generatedSet.contains(formattedDateTime));

        if (!state.allowDuplicates) {
          generatedSet.add(formattedDateTime);
        }
        resultList.add(formattedDateTime);
      }

      // Save state only after generation
      await stateManager.saveCurrentState();

      // Add to history
      await historyManager.addHistoryItem(
        resultList.join(', '),
        historyType,
      );

      setState(() {
        _results = resultList;
        _copied = false;
      });

      // Auto-scroll to results after generation
      AutoScrollHelper.scrollToResults(
        ref: ref,
        scrollController: _scrollController,
        mounted: mounted,
        hasResults: _results.isNotEmpty,
      );
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showTyped(context, e.toString(), SnackBarType.error);
      }
    }
  }

  void _copyToClipboard() {
    if (_results.isNotEmpty) {
      String dateTimesText = _results.join('\n');

      Clipboard.setData(ClipboardData(text: dateTimesText));
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

  Future<void> _selectStartDateTime() async {
    final state = ref.read(dateTimeGeneratorProvider);
    final stateManager =
        ref.read(dateTimeGeneratorStateManagerProvider.notifier);

    final date = await showDatePicker(
      context: context,
      initialDate: state.startDateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(state.startDateTime),
      );
      if (time != null) {
        final newDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        stateManager.updateStartDateTime(newDateTime);
        // Auto-adjust end datetime if needed
        final updatedState = ref.read(dateTimeGeneratorProvider);
        if (updatedState.startDateTime.isAfter(updatedState.endDateTime)) {
          stateManager.updateEndDateTime(
              updatedState.startDateTime.add(const Duration(hours: 1)));
        }
      }
    }
  }

  Future<void> _selectEndDateTime() async {
    final state = ref.read(dateTimeGeneratorProvider);
    final stateManager =
        ref.read(dateTimeGeneratorStateManagerProvider.notifier);

    final date = await showDatePicker(
      context: context,
      initialDate: state.endDateTime,
      firstDate: state.startDateTime,
      lastDate: DateTime(2100),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(state.endDateTime),
      );
      if (time != null) {
        final newDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        stateManager.updateEndDateTime(newDateTime);
      }
    }
  }

  Widget _buildDateTimeSelector(
      String label, DateTime dateTime, VoidCallback onTap) {
    final dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');

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
                Text(dateTimeFormat.format(dateTime)),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeSelectors(AppLocalizations loc) {
    final state = ref.watch(dateTimeGeneratorProvider);

    final startDateTimeSelector = _buildDateTimeSelector(
      loc.between,
      state.startDateTime,
      _selectStartDateTime,
    );

    final endDateTimeSelector = _buildDateTimeSelector(
      loc.and,
      state.endDateTime,
      _selectEndDateTime,
    );

    return WidgetLayoutRenderHelper.twoEqualWidthInRow(
      startDateTimeSelector,
      endDateTimeSelector,
      minWidth: 300,
      spacing: TwoDimSpacing.specific(vertical: 8, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(dateTimeGeneratorProvider);
    final stateManager =
        ref.read(dateTimeGeneratorStateManagerProvider.notifier);

    final generatorContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Settings card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DateTime selectors
                _buildDateTimeSelectors(loc),
                VerticalSpacingDivider.onlyTop(12),

                // DateTime count slider
                OptionSlider<int>(
                  label: loc.dateCount,
                  currentValue: state.dateTimeCount,
                  options: List.generate(
                    40,
                    (i) => SliderOption(value: i + 1, label: '${i + 1}'),
                  ),
                  onChanged: (value) {
                    stateManager.updateDateTimeCount(value);
                  },
                  fixedWidth: 60,
                  layout: OptionSliderLayout.none,
                ),

                // Allow duplicates switch
                OptionSwitch(
                  title: loc.allowDuplicates,
                  subtitle: loc.allowDuplicatesDesc,
                  value: state.allowDuplicates,
                  onChanged: (value) {
                    stateManager.updateAllowDuplicates(value);
                  },
                  decorator: OptionSwitchDecorator.compact(context),
                ),

                VerticalSpacingDivider.specific(top: 6, bottom: 12),

                // Generate button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _generateDateTimes,
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
                          Icons.schedule,
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
                    children: _results.map((dateTimeStr) {
                      return Tooltip(
                        message: loc.clickToCopy,
                        child: InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: dateTimeStr));
                            SnackBarUtils.showTyped(
                                context, loc.copied, SnackBarType.info);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Chip(
                            label: Text(
                              dateTimeStr,
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
                    values: _results.map((dateTimeStr) {
                      // Parse "yyyy-MM-dd HH:mm:ss" format
                      final parts = dateTimeStr.split(' ');
                      final dateParts = parts[0].split('-');
                      final timeParts = parts[1].split(':');
                      return DateTime(
                        int.parse(dateParts[0]),
                        int.parse(dateParts[1]),
                        int.parse(dateParts[2]),
                        int.parse(timeParts[0]),
                        int.parse(timeParts[1]),
                        int.parse(timeParts[2]),
                      );
                    }).toList(),
                    type: DateTimeStatisticsType.dateTime,
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
      historyWidget: HistoryWidget(
        type: historyType,
        title: loc.generationHistory,
      ),
      historyEnabled: ref.watch(settingsProvider).saveRandomToolsState,
      hasHistory: ref.watch(settingsProvider).saveRandomToolsState,
      isEmbedded: widget.isEmbedded,
      title: loc.dateTimeGenerator,
      scrollController: _scrollController,
    );
  }
}
