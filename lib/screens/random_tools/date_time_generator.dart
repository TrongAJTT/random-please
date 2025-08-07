import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/random_services/random_state_service.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/size_utils.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/utils/widget_layout_render_helper.dart';

class DateTimeGeneratorScreen extends StatefulWidget {
  final bool isEmbedded;

  const DateTimeGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  State<DateTimeGeneratorScreen> createState() =>
      _DateTimeGeneratorScreenState();
}

class _DateTimeGeneratorScreenState extends State<DateTimeGeneratorScreen>
    with SingleTickerProviderStateMixin {
  // Static DateFormat instances for better performance
  static final _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');
  static final _dateTimeFormatWithSeconds = DateFormat('yyyy-MM-dd HH:mm:ss');

  DateTime _startDateTime = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDateTime = DateTime.now().add(const Duration(days: 30));
  int _dateTimeCount = 5;
  bool _allowDuplicates = true;
  bool _includeSeconds = false;
  List<DateTime> _generatedDateTimes = [];
  bool _copied = false;
  late AnimationController _animationController;
  List<GenerationHistoryItem> _history = [];
  bool _historyEnabled = false;

  static const String _historyType = 'date_time';

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
      final state = await RandomStateService.getDateTimeGeneratorState();
      if (mounted) {
        setState(() {
          _startDateTime = state.startDateTime;
          _endDateTime = state.endDateTime;
          _dateTimeCount = state.dateTimeCount;
          _allowDuplicates = state.allowDuplicates;
        });
      }
    } catch (e) {
      // Error is already logged in service
    }
  }

  Future<void> _saveState() async {
    try {
      final state = DateTimeGeneratorState(
        startDateTime: _startDateTime,
        endDateTime: _endDateTime,
        dateTimeCount: _dateTimeCount,
        allowDuplicates: _allowDuplicates,
        lastUpdated: DateTime.now(),
      );
      await RandomStateService.saveDateTimeGeneratorState(state);
    } catch (e) {
      // Error is already logged in service
    }
  }

  Future<void> _loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history = await GenerationHistoryService.getHistory(_historyType);
    setState(() {
      _historyEnabled = enabled;
      _history = history;
    });
  }

  void _generateDateTimes() {
    try {
      final generatedDateTimes = RandomGenerator.generateRandomDateTimes(
        startDateTime: _startDateTime,
        endDateTime: _endDateTime,
        count: _dateTimeCount,
        allowDuplicates: _allowDuplicates,
      );

      setState(() {
        _generatedDateTimes = generatedDateTimes;
        _copied = false;
      });
      _animationController.forward(from: 0.0);

      // Save state when generating
      _saveState();

      // Save to history if enabled
      if (_historyEnabled && generatedDateTimes.isNotEmpty) {
        final dateTimeFormat =
            _includeSeconds ? _dateTimeFormatWithSeconds : _dateTimeFormat;
        final dateTimeStrings = generatedDateTimes
            .map((dateTime) => dateTimeFormat.format(dateTime))
            .toList();
        GenerationHistoryService.addHistoryItem(
          dateTimeStrings.join(', '),
          'date_time',
        ).then((_) => _loadHistory());
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
    if (_generatedDateTimes.isEmpty) return;

    final dateTimeFormat =
        _includeSeconds ? _dateTimeFormatWithSeconds : _dateTimeFormat;
    String dateTimesText = _generatedDateTimes.map((dateTime) {
      return dateTimeFormat.format(dateTime);
    }).join('\n');

    Clipboard.setData(ClipboardData(text: dateTimesText));
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
      historyType: _historyType,
      history: _history,
      title: loc.generationHistory,
      onClearAllHistory: () async {
        await GenerationHistoryService.clearHistory(_historyType);
        await _loadHistory();
      },
      onClearPinnedHistory: () async {
        await GenerationHistoryService.clearPinnedHistory(_historyType);
        await _loadHistory();
      },
      onClearUnpinnedHistory: () async {
        await GenerationHistoryService.clearUnpinnedHistory(_historyType);
        await _loadHistory();
      },
      onCopyItem: _copyHistoryItem,
      onDeleteItem: (index) async {
        await GenerationHistoryService.deleteHistoryItem(_historyType, index);
        await _loadHistory();
      },
      onTogglePin: (index) async {
        await GenerationHistoryService.togglePinHistoryItem(
            _historyType, index);
        await _loadHistory();
      },
    );
  }

  Future<void> _selectStartDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      if (mounted) {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(_startDateTime),
        );
        if (time != null) {
          setState(() {
            _startDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            if (_startDateTime.isAfter(_endDateTime)) {
              _endDateTime = _startDateTime.add(const Duration(hours: 1));
            }
          });
          // Don't save state immediately, only save when generating
        }
      }
    }
  }

  Future<void> _selectEndDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      if (mounted) {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(_endDateTime),
        );
        if (time != null) {
          setState(() {
            _endDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            if (_endDateTime.isBefore(_startDateTime)) {
              _startDateTime = _endDateTime.subtract(const Duration(hours: 1));
            }
          });
          // Don't save state immediately, only save when generating
        }
      }
    }
  }

  Widget _buildDateTimeField(
      String label, DateTime dateTime, VoidCallback onTap) {
    final dateTimeFormat =
        _includeSeconds ? _dateTimeFormatWithSeconds : _dateTimeFormat;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  dateTimeFormat.format(dateTime),
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeSelectors(AppLocalizations loc) {
    return WidgetLayoutRenderHelper.twoEqualWidthInRow(
        _buildDateTimeField(
          loc.startDate,
          _startDateTime,
          _selectStartDateTime,
        ),
        _buildDateTimeField(
          loc.endDate,
          _endDateTime,
          _selectEndDateTime,
        ),
        minWidth: 360,
        spacing: TwoDimSpacing.specific(vertical: 8, horizontal: 20));
  }

  Widget _buildCountSlider(AppLocalizations loc) {
    return OptionSlider<int>(
      label: loc.dateCount,
      currentValue: _dateTimeCount,
      options: List.generate(
        20,
        (i) => SliderOption(value: i + 1, label: '${i + 1}'),
      ),
      onChanged: (value) {
        setState(() {
          _dateTimeCount = value;
        });
        // Don't save state immediately, only save when generating
      },
      layout: OptionSliderLayout.none,
      fixedWidth: 60,
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
            // Don't save state immediately, only save when generating
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
            // Don't save state immediately, only save when generating
          },
          decorator: OptionSwitchDecorator.compact(context),
        ),
        minWidth: 350,
        spacing: TwoDimSpacing.specific(vertical: 8, horizontal: 20));
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final dateTimeFormat =
        _includeSeconds ? _dateTimeFormatWithSeconds : _dateTimeFormat;

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
                // Date time selectors (responsive layout)
                _buildDateTimeSelectors(loc),
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
        const SizedBox(height: 16),

        // Results card
        if (_generatedDateTimes.isNotEmpty)
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
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _animationController.value,
                        child: child,
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _generatedDateTimes.map((dateTime) {
                        final formattedDateTime =
                            dateTimeFormat.format(dateTime);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    formattedDateTime,
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
                                        ClipboardData(text: formattedDateTime));
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
                  ),
                ],
              ),
            ),
          ),
      ],
    );

    return RandomGeneratorLayout(
      generatorContent: generatorContent,
      historyWidget: _buildHistoryWidget(loc),
      historyEnabled: _historyEnabled,
      hasHistory: _historyEnabled,
      isEmbedded: widget.isEmbedded,
      title: loc.dateTimeGenerator,
    );
  }
}
