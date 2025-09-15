import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/view_models/date_time_generator_view_model.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/history_view_dialog.dart';
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

class _DateTimeGeneratorScreenState extends State<DateTimeGeneratorScreen> {
  late DateTimeGeneratorViewModel _viewModel;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _viewModel = DateTimeGeneratorViewModel();
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

  void _generateDateTimes() async {
    try {
      await _viewModel.generateDateTimes();
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showTyped(context, e.toString(), SnackBarType.error);
      }
    }
  }

  void _copyToClipboard() {
    if (_viewModel.results.isNotEmpty) {
      String dateTimesText = _viewModel.results.join('\n');

      Clipboard.setData(ClipboardData(text: dateTimesText));
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
    final startDateTimeSelector = _buildDateTimeSelector(
      loc.startDate,
      _viewModel.state.startDateTime,
      () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _viewModel.state.startDateTime,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (date != null && mounted) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(_viewModel.state.startDateTime),
          );
          if (time != null) {
            final newDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            _viewModel.updateStartDateTime(newDateTime);
            // Auto-adjust end datetime if needed
            if (_viewModel.state.startDateTime
                .isAfter(_viewModel.state.endDateTime)) {
              _viewModel.updateEndDateTime(
                  _viewModel.state.startDateTime.add(const Duration(hours: 1)));
            }
          }
        }
      },
    );

    final endDateTimeSelector = _buildDateTimeSelector(
      loc.endDate,
      _viewModel.state.endDateTime,
      () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _viewModel.state.endDateTime,
          firstDate: _viewModel.state.startDateTime,
          lastDate: DateTime(2100),
        );
        if (date != null && mounted) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(_viewModel.state.endDateTime),
          );
          if (time != null) {
            final newDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            _viewModel.updateEndDateTime(newDateTime);
          }
        }
      },
    );

    return WidgetLayoutRenderHelper.twoEqualWidthInRow(
      startDateTimeSelector,
      endDateTimeSelector,
      minWidth: 300,
      spacing: TwoDimSpacing.specific(vertical: 8, horizontal: 16),
    );
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return RandomGeneratorHistoryWidget(
      historyType: DateTimeGeneratorViewModel.historyType,
      history: _viewModel.historyItems,
      title: loc.generationHistory,
      onClearAllHistory: () async {
        await GenerationHistoryService.clearHistory(
            DateTimeGeneratorViewModel.historyType);
        await _viewModel.loadHistory();
      },
      onClearPinnedHistory: () async {
        await GenerationHistoryService.clearPinnedHistory(
            DateTimeGeneratorViewModel.historyType);
        await _viewModel.loadHistory();
      },
      onClearUnpinnedHistory: () async {
        await GenerationHistoryService.clearUnpinnedHistory(
            DateTimeGeneratorViewModel.historyType);
        await _viewModel.loadHistory();
      },
      onCopyItem: _copyHistoryItem,
      onDeleteItem: (index) async {
        await GenerationHistoryService.deleteHistoryItem(
            DateTimeGeneratorViewModel.historyType, index);
        await _viewModel.loadHistory();
      },
      onTogglePin: (index) async {
        await GenerationHistoryService.togglePinHistoryItem(
            DateTimeGeneratorViewModel.historyType, index);
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
                // DateTime selectors
                _buildDateTimeSelectors(loc),
                VerticalSpacingDivider.onlyTop(12),

                // DateTime count slider
                OptionSlider<int>(
                  label: loc.dateCount,
                  currentValue: _viewModel.state.dateTimeCount,
                  options: List.generate(
                    10,
                    (i) => SliderOption(value: i + 1, label: '${i + 1}'),
                  ),
                  onChanged: (value) {
                    _viewModel.updateDateTimeCount(value);
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
                    children: _viewModel.results.map((dateTimeStr) {
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
                                  dateTimeStr,
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
                                      ClipboardData(text: dateTimeStr));
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
      title: loc.dateTimeGenerator,
    );
  }
}
