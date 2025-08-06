import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/random_services/random_state_service.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
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

class _TimeGeneratorScreenState extends State<TimeGeneratorScreen>
    with SingleTickerProviderStateMixin {
  TimeOfDay _startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 23, minute: 59);
  int _timeCount = 5;
  bool _allowDuplicates = true;
  List<TimeOfDay> _generatedTimes = [];
  List<int> _generatedSeconds = []; // Store seconds separately
  bool _copied = false;
  late AnimationController _animationController;
  List<GenerationHistoryItem> _history = [];
  bool _historyEnabled = false;
  bool _includeSeconds = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _loadState();
    _loadHistory();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadState() async {
    try {
      final state = await RandomStateService.getTimeGeneratorState();
      if (mounted) {
        setState(() {
          _startTime =
              TimeOfDay(hour: state.startHour, minute: state.startMinute);
          _endTime = TimeOfDay(hour: state.endHour, minute: state.endMinute);
          _timeCount = state.timeCount;
          _allowDuplicates = state.allowDuplicates;
        });
      }
    } catch (e) {
      // Error is already logged in service
    }
  }

  Future<void> _saveState() async {
    try {
      final state = TimeGeneratorState(
        startHour: _startTime.hour,
        startMinute: _startTime.minute,
        endHour: _endTime.hour,
        endMinute: _endTime.minute,
        timeCount: _timeCount,
        allowDuplicates: _allowDuplicates,
        lastUpdated: DateTime.now(),
      );
      await RandomStateService.saveTimeGeneratorState(state);
    } catch (e) {
      // Error is already logged in service
    }
  }

  Future<void> _loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history = await GenerationHistoryService.getHistory('time');
    setState(() {
      _historyEnabled = enabled;
      _history = history;
    });
  }

  void _generateTimes() {
    try {
      setState(() {
        _generatedTimes = RandomGenerator.generateRandomTimes(
          startTime: _startTime,
          endTime: _endTime,
          count: _timeCount,
          allowDuplicates: _allowDuplicates,
        );
        // Generate random seconds if needed
        if (_includeSeconds) {
          final random = DateTime.now().millisecondsSinceEpoch;
          _generatedSeconds = List.generate(
              _generatedTimes.length,
              (index) =>
                  (random + index * 17) % 60); // Use different seed for each
        } else {
          _generatedSeconds = List.filled(_generatedTimes.length, 0);
        }
        _copied = false;
      });
      _animationController.forward(from: 0.0);

      // Save state when generating
      _saveState();

      // Save to history if enabled
      if (_historyEnabled && _generatedTimes.isNotEmpty) {
        final timesText = _generatedTimes
            .asMap()
            .entries
            .map((entry) => _formatTimeWithSeconds(
                _generatedTimes[entry.key], _generatedSeconds[entry.key]))
            .join(', ');
        GenerationHistoryService.addHistoryItem(
          timesText,
          'time',
        ).then((_) => _loadHistory()); // Refresh history
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _copyToClipboard() {
    String timesText = _generatedTimes.asMap().entries.map((entry) {
      return _includeSeconds
          ? _formatTimeWithSeconds(
              _generatedTimes[entry.key], _generatedSeconds[entry.key])
          : _formatTimeOfDay(_generatedTimes[entry.key]);
    }).join('\n');

    Clipboard.setData(ClipboardData(text: timesText));
    setState(() {
      _copied = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.copied)),
    );
  }

  void _copyHistoryItem(String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.copied)),
    );
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return RandomGeneratorHistoryWidget(
      historyType: 'time',
      history: _history,
      title: loc.generationHistory,
      onClearHistory: () async {
        await GenerationHistoryService.clearHistory('time');
        await _loadHistory();
      },
      onCopyItem: _copyHistoryItem,
    );
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final hours = tod.hour.toString().padLeft(2, '0');
    final minutes = tod.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  String _formatTimeWithSeconds(TimeOfDay time, int seconds) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    final secs = seconds.toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  Widget _buildTimeField(String label, TimeOfDay time, bool isStartTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (picked != null) {
              setState(() {
                if (isStartTime) {
                  _startTime = picked;
                } else {
                  _endTime = picked;
                }
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  _formatTimeOfDay(time),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelectors(AppLocalizations loc) {
    return WidgetLayoutRenderHelper.twoEqualWidthInRow(
      _buildTimeField(loc.startTime, _startTime, true),
      _buildTimeField(loc.endTime, _endTime, false),
      minWidth: 250,
      horizontalSpacing: 20,
      verticalSpacing: 8,
    );
  }

  Widget _buildCountSlider(AppLocalizations loc) {
    return OptionSlider<int>(
      label: loc.timeCount,
      currentValue: _timeCount,
      options: List.generate(
        10,
        (i) => SliderOption(value: i + 1, label: '${i + 1}'),
      ),
      onChanged: (value) {
        setState(() {
          _timeCount = value;
        });
      },
      fixedWidth: 60,
      layout: OptionSliderLayout.none,
    );
  }

  Widget _buildOptionsSection(AppLocalizations loc) {
    return WidgetLayoutRenderHelper.twoEqualWidthInRow(
      OptionSwitch(
        title: loc.includeSeconds,
        value: _includeSeconds,
        onChanged: (value) {
          setState(() {
            _includeSeconds = value;
          });
        },
        decorator: OptionSwitchDecorator.compact(context),
      ),
      OptionSwitch(
        title: loc.allowDuplicates,
        value: _allowDuplicates,
        onChanged: (value) {
          setState(() {
            _allowDuplicates = value;
          });
        },
        decorator: OptionSwitchDecorator.compact(context),
      ),
      minWidth: 350,
      horizontalSpacing: 20,
      verticalSpacing: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

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
                // Time range (responsive layout)
                _buildTimeSelectors(loc),
                VerticalSpacingDivider.onlyTop(12),
                // Count slider
                _buildCountSlider(loc),
                // Options section
                _buildOptionsSection(loc),
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
        if (_generatedTimes.isNotEmpty) ...[
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
                        loc.randomResult,
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
                    children: _generatedTimes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final time = entry.value;
                      final formattedTime = _includeSeconds
                          ? _formatTimeWithSeconds(
                              time, _generatedSeconds[index])
                          : _formatTimeOfDay(time);
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
                                  formattedTime,
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
                                      ClipboardData(text: formattedTime));
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
      historyEnabled: _historyEnabled,
      hasHistory: _historyEnabled,
      isEmbedded: widget.isEmbedded,
      title: loc.timeGenerator,
    );
  }
}
