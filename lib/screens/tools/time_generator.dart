import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/providers/time_generator_state_provider.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/size_utils.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/utils/widget_layout_render_helper.dart';
import 'package:random_please/widgets/common/history_widget.dart';
import 'package:random_please/widgets/statistics/datetime_statistics_widget.dart';
import 'package:random_please/utils/auto_scroll_helper.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/constants/history_types.dart';
import 'package:random_please/utils/standard_random_utils.dart';
// ignore_for_file: unused_import
import 'dart:math';

class TimeGeneratorScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const TimeGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<TimeGeneratorScreen> createState() =>
      _TimeGeneratorScreenState();
}

class _TimeGeneratorScreenState extends ConsumerState<TimeGeneratorScreen> {
  bool _copied = false;
  List<String> _results = [];
  final ScrollController _scrollController = ScrollController();
  late AppLocalizations loc;

  // Uses standard high-quality PRNG for time generation

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

  Future<void> _generateTimes() async {
    try {
      final state = ref.read(timeGeneratorProvider);
      final stateManager = ref.read(timeGeneratorStateProvider.notifier);
      final Set<String> generatedSet = {};
      final List<String> resultList = [];

      // Convert time range to minutes since midnight
      final time1Minutes = state.startHour * 60 + state.startMinute;
      final time2Minutes = state.endHour * 60 + state.endMinute;

      // Determine which time is earlier (from) and which is later (to)
      final int fromMinutes;
      final int toMinutes;

      if (time1Minutes <= time2Minutes) {
        fromMinutes = time1Minutes;
        toMinutes = time2Minutes;
      } else {
        fromMinutes = time2Minutes;
        toMinutes = time1Minutes;
      }

      final range = toMinutes - fromMinutes;

      if (range < 0) {
        setState(() {
          _results = [];
        });
        return;
      }

      for (int i = 0; i < state.timeCount; i++) {
        String timeStr;
        int attempts = 0;
        const maxAttempts = 1000;

        do {
          // Enhanced random minute selection using multiple sources
          final randomMinutes = fromMinutes + _getEnhancedRandomMinutes(range);

          final hour = randomMinutes ~/ 60;
          final minute = randomMinutes % 60;

          timeStr = "${hour.toString().padLeft(2, '0')}:"
              "${minute.toString().padLeft(2, '0')}";
          attempts++;
        } while (!state.allowDuplicates &&
            generatedSet.contains(timeStr) &&
            attempts < maxAttempts);

        if (!state.allowDuplicates) {
          generatedSet.add(timeStr);
        }

        resultList.add(timeStr);
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
      await stateManager.saveCurrentState();

      // Save to history
      if (_results.isNotEmpty) {
        final historyEnabled = ref.read(historyEnabledProvider);
        if (historyEnabled) {
          await ref.read(historyProvider.notifier).addHistoryItem(
                _results.join(', '),
                HistoryTypes.time,
              );
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showTyped(context, e.toString(), SnackBarType.error);
      }
    }
  }

  // Enhanced random minute generator combining multiple sources
  int _getEnhancedRandomMinutes(int maxMinutes) {
    return StandardRandomUtils.nextInt(0, maxMinutes);
  }

  void _copyToClipboard() {
    if (_results.isNotEmpty) {
      String timesText = _results.join('\n');

      Clipboard.setData(ClipboardData(text: timesText));
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

  Future<void> _selectStartTime() async {
    final state = ref.read(timeGeneratorProvider);
    final stateManager = ref.read(timeGeneratorStateProvider.notifier);
    final startHour = state.startHour;
    final startMinute = state.startMinute;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: startHour, minute: startMinute),
    );

    if (time != null) {
      stateManager.updateStartHour(time.hour);
      stateManager.updateStartMinute(time.minute);
    }
  }

  Future<void> _selectEndTime() async {
    final state = ref.read(timeGeneratorProvider);
    final stateManager = ref.read(timeGeneratorStateProvider.notifier);
    final endHour = state.endHour;
    final endMinute = state.endMinute;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: endHour, minute: endMinute),
    );

    if (time != null) {
      stateManager.updateEndHour(time.hour);
      stateManager.updateEndMinute(time.minute);
    }
  }

  Widget _buildTimeSelector(String label, TimeOfDay time, VoidCallback onTap) {
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
                Text(time.format(context)),
                const Icon(Icons.access_time),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelectors(AppLocalizations loc) {
    final state = ref.watch(timeGeneratorProvider);

    final startTime = TimeOfDay(
      hour: state.startHour,
      minute: state.startMinute,
    );

    final endTime = TimeOfDay(
      hour: state.endHour,
      minute: state.endMinute,
    );

    final startTimeSelector = _buildTimeSelector(
      loc.between,
      startTime,
      _selectStartTime,
    );

    final endTimeSelector = _buildTimeSelector(
      loc.and,
      endTime,
      _selectEndTime,
    );

    return WidgetLayoutRenderHelper.twoEqualWidthInRow(
      startTimeSelector,
      endTimeSelector,
      minWidth: 250,
      spacing: TwoDimSpacing.specific(vertical: 8, horizontal: 16),
    );
  }

  Widget _buildHistoryWidget() {
    return HistoryWidget(
      type: HistoryTypes.time,
      title: loc.generationHistory,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(timeGeneratorProvider);
    final stateManager = ref.read(timeGeneratorStateProvider.notifier);

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
                // Time selectors
                _buildTimeSelectors(loc),
                VerticalSpacingDivider.onlyTop(12),

                // Time count slider
                OptionSlider<int>(
                  label: loc.timeCount,
                  currentValue: state.timeCount,
                  options: List.generate(
                    40,
                    (i) => SliderOption(value: i + 1, label: '${i + 1}'),
                  ),
                  onChanged: (value) {
                    stateManager.updateTimeCount(value);
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
                    onPressed: _generateTimes,
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
                          Icons.access_time,
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
                    children: _results.map((timeStr) {
                      return Tooltip(
                        message: loc.clickToCopy,
                        child: InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: timeStr));
                            SnackBarUtils.showTyped(
                                context, loc.copied, SnackBarType.info);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Chip(
                            label: Text(
                              timeStr,
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
                    values: _results.map((timeStr) {
                      final parts = timeStr.split(':');
                      final now = DateTime.now();
                      return DateTime(
                        now.year,
                        now.month,
                        now.day,
                        int.parse(parts[0]),
                        int.parse(parts[1]),
                      );
                    }).toList(),
                    type: DateTimeStatisticsType.time,
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
      title: loc.timeGenerator,
      scrollController: _scrollController,
    );
  }
}
