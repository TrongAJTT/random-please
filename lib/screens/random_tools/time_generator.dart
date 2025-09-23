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
import 'package:random_please/widgets/history_widget.dart';
import 'package:random_please/providers/settings_provider.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _generateTimes() async {
    try {
      final state = ref.read(timeGeneratorProvider);
      final stateManager = ref.read(timeGeneratorStateProvider.notifier);
      final random = Random();
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
          final randomMinutes = fromMinutes + random.nextInt(range + 1);

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

      // Save state after generation
      await stateManager.saveCurrentState();

      // Save to history
      if (_results.isNotEmpty) {
        ref.read(historyProvider.notifier).addHistoryItem(
              _results.join(', '),
              'time_generator',
            );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _copyToClipboard() {
    if (_results.isNotEmpty) {
      String timesText = _results.join('\n');

      Clipboard.setData(ClipboardData(text: timesText));
      setState(() {
        _copied = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.copied)),
        );
      }
    }
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

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return HistoryWidget(
      type: 'time_generator',
      title: loc.generationHistory,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
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
                    10,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        loc.results,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: Icon(_copied ? Icons.check : Icons.copy),
                        onPressed: _copyToClipboard,
                        tooltip: loc.copyToClipboard,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _results.map((timeStr) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  timeStr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                        fontFamily: 'monospace',
                                      ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 18),
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: timeStr));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(loc.copied)),
                                  );
                                },
                                tooltip: loc.copyToClipboard,
                                style: IconButton.styleFrom(
                                  foregroundColor: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
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
      historyWidget: _buildHistoryWidget(loc),
      historyEnabled: ref.watch(settingsProvider).saveRandomToolsState,
      hasHistory: ref.watch(settingsProvider).saveRandomToolsState,
      isEmbedded: widget.isEmbedded,
      title: loc.timeGenerator,
    );
  }
}
