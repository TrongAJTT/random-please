import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/services/random_services/random_state_service.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/size_utils.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/utils/widget_layout_render_helper.dart';
import 'package:random_please/widgets/generic/option_grid_picker.dart' as grid;
import 'package:random_please/widgets/generic/option_item.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/option_switch.dart';

class NumberGeneratorScreen extends StatefulWidget {
  final bool isEmbedded;

  const NumberGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  State<NumberGeneratorScreen> createState() => _NumberGeneratorScreenState();
}

class _NumberGeneratorScreenState extends State<NumberGeneratorScreen> {
  bool _isInteger = true;
  double _minValue = 1.0;
  double _maxValue = 100.0;
  int _quantity = 5;
  bool _allowDuplicates = true;
  List<num> _generatedNumbers = [];
  bool _copied = false;
  List<GenerationHistoryItem> _history = [];
  bool _historyEnabled = false;

  static const String _historyType = 'number';

  final TextEditingController _minValueController =
      TextEditingController(text: '1');
  final TextEditingController _maxValueController =
      TextEditingController(text: '100');

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _loadState(); // Load saved state
  }

  Future<void> _loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history = await GenerationHistoryService.getHistory(_historyType);
    if (!mounted) return;
    setState(() {
      _historyEnabled = enabled;
      _history = history;
    });
  }

  // Load saved state from storage
  Future<void> _loadState() async {
    try {
      final state = await RandomStateService.getNumberGeneratorState();
      if (!mounted) return;
      setState(() {
        _isInteger = state.isInteger;
        _minValue = state.minValue;
        _maxValue = state.maxValue;
        _quantity = state.quantity;
        _allowDuplicates = state.allowDuplicates;

        // Update text controllers
        _minValueController.text = _minValue.toString();
        _maxValueController.text = _maxValue.toString();
      });
    } catch (e) {
      // Error loading state, use defaults
      debugPrint('Error loading number generator state: $e');
    }
  }

  // Save current state to storage
  Future<void> _saveState() async {
    try {
      final state = NumberGeneratorState(
        isInteger: _isInteger,
        minValue: _minValue,
        maxValue: _maxValue,
        quantity: _quantity,
        allowDuplicates: _allowDuplicates,
        lastUpdated: DateTime.now(),
      );
      await RandomStateService.saveNumberGeneratorState(state);
    } catch (e) {
      // Error saving state
      debugPrint('Error saving number generator state: $e');
    }
  }

  @override
  void dispose() {
    _minValueController.dispose();
    _maxValueController.dispose();
    super.dispose();
  }

  void _generateNumbers() async {
    try {
      // Parse values from text controllers
      double min = double.tryParse(_minValueController.text) ?? _minValue;
      double max = double.tryParse(_maxValueController.text) ?? _maxValue;

      // Ensure min is less than max
      if (min >= max) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Min must be less than max'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _minValue = min;
        _maxValue = max;
        _generatedNumbers = RandomGenerator.generateNumbers(
          isInteger: _isInteger,
          min: _minValue,
          max: _maxValue,
          count: _quantity,
          allowDuplicates: _allowDuplicates,
        );
        _copied = false;
      });

      // Save state after generating
      await _saveState();

      // Save to history if enabled
      if (_historyEnabled && _generatedNumbers.isNotEmpty) {
        String numbersText = _generatedNumbers.map((number) {
          if (_isInteger) {
            return number.toInt().toString();
          } else {
            return number.toStringAsFixed(2);
          }
        }).join(', ');

        GenerationHistoryService.addHistoryItem(
          numbersText,
          _historyType,
        ).then((_) => _loadHistory()); // Refresh history
      }
    } catch (e) {
      if (!mounted) return; // Check mounted before using context
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _copyToClipboard() {
    String numbersText = _generatedNumbers.map((number) {
      if (_isInteger) {
        return number.toInt().toString();
      } else {
        return number.toStringAsFixed(2);
      }
    }).join(', ');

    Clipboard.setData(ClipboardData(text: numbersText));
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

  String _formatNumber(num number) {
    if (_isInteger) {
      return number.toInt().toString();
    } else {
      return number.toStringAsFixed(2);
    }
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
                grid.AutoScaleOptionGridPicker<bool>(
                  title: loc.numberType,
                  options: [
                    OptionItem(value: true, label: loc.integers),
                    OptionItem(value: false, label: loc.floatingPoint),
                  ],
                  selectedValue: _isInteger,
                  onSelectionChanged: (value) {
                    setState(() {
                      _isInteger = value;
                    });
                  },
                  minCellWidth: 150,
                  maxCellWidth: 400,
                  fixedCellHeight: 50,
                  decorator: const grid.OptionGridDecorator(
                    labelAlign: grid.LabelAlign.center,
                  ),
                ),
                VerticalSpacingDivider.specific(top: 6, bottom: 12),
                // 2. Min/Max Inputs
                WidgetLayoutRenderHelper.twoEqualWidthInRow(
                  TextFormField(
                    controller: _minValueController,
                    decoration: InputDecoration(
                      labelText: loc.minValue,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      _isInteger
                          ? FilteringTextInputFormatter.digitsOnly
                          : FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.-]')),
                    ],
                    onChanged: (value) {
                      _minValue = double.tryParse(value) ?? _minValue;
                    },
                  ),
                  TextFormField(
                    controller: _maxValueController,
                    decoration: InputDecoration(
                      labelText: loc.maxValue,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      _isInteger
                          ? FilteringTextInputFormatter.digitsOnly
                          : FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.-]')),
                    ],
                    onChanged: (value) {
                      _maxValue = double.tryParse(value) ?? _maxValue;
                    },
                  ),
                  spacing: TwoDimSpacing.specific(vertical: 8, horizontal: 16),
                  minWidth: 300,
                ),
                const SizedBox(height: 8),
                // 3. Quantity Slider
                OptionSlider<int>(
                  label: loc.quantity,
                  currentValue: _quantity,
                  options: List.generate(
                    30,
                    (i) => SliderOption(value: i + 1, label: '${i + 1}'),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _quantity = value;
                    });
                  },
                  layout: OptionSliderLayout.none,
                ),
                // 4. Allow Duplicates Switch
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
                VerticalSpacingDivider.specific(top: 6, bottom: 12),
                // Generate button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    onPressed: _generateNumbers,
                    icon: const Icon(Icons.refresh),
                    label: Text(loc.generate),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Result card
        if (_generatedNumbers.isNotEmpty) ...[
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        loc.generatedNumbers,
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
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _generatedNumbers.map((number) {
                      return Chip(
                        label: Text(_formatNumber(number)),
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        labelStyle: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
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
      title: loc.numberGenerator,
    );
  }
}
