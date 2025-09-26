import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/view_models/number_generator_view_model.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/widgets/history_widget.dart';
import 'package:random_please/utils/size_utils.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/utils/widget_layout_render_helper.dart';
import 'package:random_please/utils/number_formatter.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/option_switch.dart';

class NumberGeneratorScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const NumberGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<NumberGeneratorScreen> createState() =>
      _NumberGeneratorScreenState();
}

class _NumberGeneratorScreenState extends ConsumerState<NumberGeneratorScreen> {
  late NumberGeneratorViewModel _viewModel;
  bool _copied = false;

  final TextEditingController _minValueController = TextEditingController();
  final TextEditingController _maxValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = NumberGeneratorViewModel(ref: ref);
    _initializeViewModel();
  }

  Future<void> _initializeViewModel() async {
    await _viewModel.initHive();
    await _viewModel.loadHistory();

    // Initialize text controllers with state values
    _minValueController.text = _viewModel.state.minValue.toString();
    _maxValueController.text = _viewModel.state.maxValue.toString();

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
        // Update text controllers if values changed
        if (_minValueController.text != _viewModel.state.minValue.toString()) {
          _minValueController.text = _viewModel.state.minValue.toString();
        }
        if (_maxValueController.text != _viewModel.state.maxValue.toString()) {
          _maxValueController.text = _viewModel.state.maxValue.toString();
        }
      });
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _minValueController.dispose();
    _maxValueController.dispose();
    super.dispose();
  }

  void _generateNumbers() async {
    try {
      // Parse values from text controllers and update view model
      double min = double.tryParse(_minValueController.text) ??
          _viewModel.state.minValue;
      double max = double.tryParse(_maxValueController.text) ??
          _viewModel.state.maxValue;

      // Update view model with new values
      if (min != _viewModel.state.minValue) {
        _viewModel.updateMinValue(min);
      }
      if (max != _viewModel.state.maxValue) {
        _viewModel.updateMaxValue(max);
      }

      // Generate numbers
      await _viewModel.generateNumbers();
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
      String numbersText = _viewModel.results.join('\n');

      Clipboard.setData(ClipboardData(text: numbersText));
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

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return HistoryWidget(
      type: NumberGeneratorViewModel.historyType,
      title: loc.generationHistory,
    );
  }

  Widget _buildRangeDisplay(AppLocalizations loc) {
    final locale = NumberFormatter.getCurrentLocale(context);
    return Text(
      loc.numberRangeFromTo(
        NumberFormatter.formatNumber(_viewModel.state.minValue, locale,
            isInteger: _viewModel.state.isInteger, decimalPlaces: 2),
        NumberFormatter.formatNumber(_viewModel.state.maxValue, locale,
            isInteger: _viewModel.state.isInteger, decimalPlaces: 2),
      ),
      style: Theme.of(context).textTheme.titleMedium,
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
                // 1. Number Type Picker
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.numberType,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ChoiceChip(
                            label: Text(loc.integers),
                            selected: _viewModel.state.isInteger,
                            onSelected: (selected) {
                              if (!(_viewModel.state.isInteger)) {
                                _viewModel.updateIsInteger(true);
                              }
                            },
                          ),
                          const SizedBox(width: 12),
                          ChoiceChip(
                            label: Text(loc.floatingPoint),
                            selected: !_viewModel.state.isInteger,
                            onSelected: (selected) {
                              if (_viewModel.state.isInteger) {
                                _viewModel.updateIsInteger(false);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // 2. Min/Max Inputs
                _buildRangeDisplay(loc),
                const SizedBox(height: 16),
                WidgetLayoutRenderHelper.twoEqualWidthInRow(
                  TextField(
                    controller: _minValueController,
                    decoration: InputDecoration(
                      labelText: loc.minValue,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final newValue =
                          double.tryParse(value) ?? _viewModel.state.minValue;
                      _viewModel.updateMinValue(newValue);
                    },
                  ),
                  TextField(
                    controller: _maxValueController,
                    decoration: InputDecoration(
                      labelText: loc.maxValue,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final newValue =
                          double.tryParse(value) ?? _viewModel.state.maxValue;
                      _viewModel.updateMaxValue(newValue);
                    },
                  ),
                  minWidth: 120,
                  spacing: TwoDimSpacing.specific(horizontal: 16, vertical: 8),
                ),
                const SizedBox(height: 8),

                // 3. Quantity Slider
                OptionSlider<int>(
                  label: loc.quantity,
                  currentValue: _viewModel.state.quantity,
                  options: List.generate(
                    10,
                    (i) => SliderOption(value: i + 1, label: '${i + 1}'),
                  ),
                  onChanged: (value) {
                    _viewModel.updateQuantity(value);
                  },
                  layout: OptionSliderLayout.none,
                ),

                // 4. Allow Duplicates Switch
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
                    onPressed: _generateNumbers,
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
                    children: _viewModel.results.map((numberStr) {
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
                                  numberStr,
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
                                      ClipboardData(text: numberStr));
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
      title: loc.numberGenerator,
    );
  }
}
