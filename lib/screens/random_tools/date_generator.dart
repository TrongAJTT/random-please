import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/random_services/random_state_service.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/history_view_dialog.dart';
import 'package:random_please/utils/size_utils.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/utils/widget_layout_render_helper.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/option_switch.dart';

class DateGeneratorScreen extends StatefulWidget {
  final bool isEmbedded;

  const DateGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  State<DateGeneratorScreen> createState() => _DateGeneratorScreenState();
}

class _DateGeneratorScreenState extends State<DateGeneratorScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 365));
  DateTime _endDate = DateTime.now().add(const Duration(days: 365));
  int _dateCount = 5;
  bool _allowDuplicates = true;
  List<DateTime> _generatedDates = [];
  bool _copied = false;
  List<GenerationHistoryItem> _history = [];
  bool _historyEnabled = false;
  final _dateFormat = DateFormat('yyyy-MM-dd');

  late AppLocalizations loc;

  static const String _historyType = 'date';

  @override
  void initState() {
    super.initState();
    _loadState();
    _loadHistory();
  }

  Future<void> _loadState() async {
    try {
      final state = await RandomStateService.getDateGeneratorState();
      if (mounted) {
        setState(() {
          _startDate = state.startDate;
          _endDate = state.endDate;
          _dateCount = state.dateCount;
          _allowDuplicates = state.allowDuplicates;
        });
      }
    } catch (e) {
      // Error is already logged in service
    }
  }

  Future<void> _saveState() async {
    try {
      final state = DateGeneratorState(
        startDate: _startDate,
        endDate: _endDate,
        dateCount: _dateCount,
        allowDuplicates: _allowDuplicates,
        lastUpdated: DateTime.now(),
      );
      await RandomStateService.saveDateGeneratorState(state);
    } catch (e) {
      // Error is already logged in service
    }
  }

  Future<void> _loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history = await GenerationHistoryService.getHistory('date');
    setState(() {
      _historyEnabled = enabled;
      _history = history;
    });
  }

  void _generateDates() {
    try {
      if (_startDate.isAfter(_endDate)) {
        SnackBarUtils.showTyped(
            context, loc.dateErrStartEndConflict, SnackBarType.error);
        return;
      }

      setState(() {
        _generatedDates = RandomGenerator.generateRandomDates(
          startDate: _startDate,
          endDate: _endDate,
          count: _dateCount,
          allowDuplicates: _allowDuplicates,
        );
        _copied = false;
      });

      // Save state when generating
      _saveState();

      // Save to history if enabled
      if (_historyEnabled && _generatedDates.isNotEmpty) {
        final datesText =
            _generatedDates.map((date) => _dateFormat.format(date)).join(', ');
        GenerationHistoryService.addHistoryItem(
          datesText,
          _historyType,
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
    final formatter = DateFormat('yyyy-MM-dd');
    String datesText = _generatedDates.map((date) {
      return formatter.format(date);
    }).join('\n');

    Clipboard.setData(ClipboardData(text: datesText));
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

  Widget _buildDateSelectors(AppLocalizations loc) {
    final startDateSelector = _buildDateSelector(
      loc.startDate,
      _startDate,
      () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _startDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          setState(() {
            _startDate = date;
            // Ensure start date is before end date
            if (_startDate.isAfter(_endDate)) {
              _endDate = _startDate.add(const Duration(days: 1));
            }
          });
          // Don't save state immediately, only save when generating
        }
      },
    );

    final endDateSelector = _buildDateSelector(
      loc.endDate,
      _endDate,
      () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _endDate,
          firstDate: _startDate,
          lastDate: DateTime(2100),
        );
        if (date != null) {
          setState(() {
            _endDate = date;
          });
          // Don't save state immediately, only save when generating
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
    final dateFormat = DateFormat('yyyy-MM-dd');

    final numberSlider = OptionSlider<int>(
      label: loc.dateCount,
      currentValue: _dateCount,
      options: List.generate(
        10,
        (i) => SliderOption(value: i + 1, label: '${i + 1}'),
      ),
      onChanged: (value) {
        setState(() {
          _dateCount = value;
        });
        // Don't save state immediately, only save when generating
      },
      layout: OptionSliderLayout.none,
    );

    final duplicatesSwitch = OptionSwitch(
      title: loc.allowDuplicates,
      value: _allowDuplicates,
      onChanged: (value) {
        setState(() {
          _allowDuplicates = value;
        });
        // Don't save state immediately, only save when generating
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
                _buildDateSelectors(loc),
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
        if (_generatedDates.isNotEmpty) ...[
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
                    children: _generatedDates.map((date) {
                      final formattedDate = dateFormat.format(date);
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
                                  formattedDate,
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
                                      ClipboardData(text: formattedDate));
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
      title: loc.dateGenerator,
    );
  }
}
