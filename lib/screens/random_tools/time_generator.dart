import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/view_models/time_generator_view_model.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/history_view_dialog.dart';
import 'package:random_please/utils/size_utils.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/utils/widget_layout_render_helper.dart';

class TimeGeneratorScreen extends StatefulWidget {
  final bool isEmbedded;

  const TimeGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  State<TimeGeneratorScreen> createState() => _TimeGeneratorScreenState();
}

class _TimeGeneratorScreenState extends State<TimeGeneratorScreen> {
  late TimeGeneratorViewModel _viewModel;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _viewModel = TimeGeneratorViewModel();
    _initializeViewModel();
  }

  Future<void> _initializeViewModel() async {
    await _viewModel.initHive();
    await _viewModel.loadHistory();

    // Listen to state changes
    _viewModel.addListener(_onViewModelChanged);

    // Update UI after initialization
    if (mounted) {
      setState(() {});
    }
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {
        _copied = false;
      });
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _generateTimes() async {
    try {
      await _viewModel.generateTimes();
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
    if (_viewModel.results.isNotEmpty) {
      String timesText = _viewModel.results.join('\n');

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

  void _copyHistoryItem(String value) {
    Clipboard.setData(ClipboardData(text: value));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.copied)),
      );
    }
  }

  Future<void> _selectStartTime() async {
    final startHour = _viewModel.state.startHour;
    final startMinute = _viewModel.state.startMinute;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: startHour, minute: startMinute),
    );

    if (time != null) {
      _viewModel.updateStartHour(time.hour);
      _viewModel.updateStartMinute(time.minute);

      // Auto-adjust end time if needed
      final endTimeInMinutes =
          _viewModel.state.endHour * 60 + _viewModel.state.endMinute;
      final startTimeInMinutes = time.hour * 60 + time.minute;

      if (startTimeInMinutes >= endTimeInMinutes) {
        final newEndHour = (time.hour + 1) % 24;
        _viewModel.updateEndHour(newEndHour);
        if (newEndHour == 0) {
          _viewModel.updateEndMinute(0);
        }
      }
    }
  }

  Future<void> _selectEndTime() async {
    final endHour = _viewModel.state.endHour;
    final endMinute = _viewModel.state.endMinute;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: endHour, minute: endMinute),
    );

    if (time != null) {
      _viewModel.updateEndHour(time.hour);
      _viewModel.updateEndMinute(time.minute);
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
    final startTime = TimeOfDay(
      hour: _viewModel.state.startHour,
      minute: _viewModel.state.startMinute,
    );

    final endTime = TimeOfDay(
      hour: _viewModel.state.endHour,
      minute: _viewModel.state.endMinute,
    );

    final startTimeSelector = _buildTimeSelector(
      loc.startTime,
      startTime,
      _selectStartTime,
    );

    final endTimeSelector = _buildTimeSelector(
      loc.endTime,
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
    return RandomGeneratorHistoryWidget(
      historyType: TimeGeneratorViewModel.historyType,
      history: _viewModel.historyItems,
      title: loc.generationHistory,
      onClearAllHistory: () async {
        await GenerationHistoryService.clearHistory(
            TimeGeneratorViewModel.historyType);
        await _viewModel.loadHistory();
      },
      onClearPinnedHistory: () async {
        await GenerationHistoryService.clearPinnedHistory(
            TimeGeneratorViewModel.historyType);
        await _viewModel.loadHistory();
      },
      onClearUnpinnedHistory: () async {
        await GenerationHistoryService.clearUnpinnedHistory(
            TimeGeneratorViewModel.historyType);
        await _viewModel.loadHistory();
      },
      onCopyItem: _copyHistoryItem,
      onDeleteItem: (index) async {
        await GenerationHistoryService.deleteHistoryItem(
            TimeGeneratorViewModel.historyType, index);
        await _viewModel.loadHistory();
      },
      onTogglePin: (index) async {
        await GenerationHistoryService.togglePinHistoryItem(
            TimeGeneratorViewModel.historyType, index);
        await _viewModel.loadHistory();
      },
      onTapItem: (item) {
        HistoryViewDialog.show(
          context: context,
          item: item,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

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
                  currentValue: _viewModel.state.timeCount,
                  options: List.generate(
                    10,
                    (i) => SliderOption(value: i + 1, label: '${i + 1}'),
                  ),
                  onChanged: (value) {
                    _viewModel.updateTimeCount(value);
                  },
                  fixedWidth: 60,
                  layout: OptionSliderLayout.none,
                ),

                // Allow duplicates switch
                OptionSwitch(
                  title: loc.allowDuplicates,
                  subtitle: loc.allowDuplicatesDesc,
                  value: _viewModel.state.allowDuplicates,
                  onChanged: (value) {
                    _viewModel.updateAllowDuplicates(value);
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
        if (_viewModel.results.isNotEmpty) ...[
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
                    children: _viewModel.results.map((timeStr) {
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
      historyEnabled: _viewModel.historyEnabled,
      hasHistory: _viewModel.historyEnabled,
      isEmbedded: widget.isEmbedded,
      title: loc.timeGenerator,
    );
  }
}
