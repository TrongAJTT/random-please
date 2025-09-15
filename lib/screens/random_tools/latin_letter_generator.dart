import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/view_models/latin_letter_generator_view_model.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/history_view_dialog.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/utils/widget_layout_render_helper.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/utils/snackbar_utils.dart';

class LatinLetterGeneratorScreen extends StatefulWidget {
  final bool isEmbedded;

  const LatinLetterGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  State<LatinLetterGeneratorScreen> createState() =>
      _LatinLetterGeneratorScreenState();
}

class _LatinLetterGeneratorScreenState extends State<LatinLetterGeneratorScreen>
    with SingleTickerProviderStateMixin {
  late LatinLetterGeneratorViewModel _viewModel;
  bool _copied = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  // New variables for range selection
  int _selectedRangeIndex = 0; // Default to 1-20 range

  List<Map<String, dynamic>> get _ranges {
    final bothCases =
        _viewModel.state.includeUppercase && _viewModel.state.includeLowercase;
    return [
      {
        'min': bothCases ? 2 : 1,
        'max': 20,
        'label': bothCases ? '2-20' : '1-20',
      },
      {'min': 21, 'max': 40, 'label': '21-40'},
      {'min': 41, 'max': 60, 'label': '41-60'},
      {'min': 61, 'max': 80, 'label': '61-80'},
      {'min': 81, 'max': 100, 'label': '81-100'},
    ];
  }

  @override
  void initState() {
    super.initState();
    _viewModel = LatinLetterGeneratorViewModel();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _viewModel.addListener(_onViewModelChanged);
    _initData();
  }

  void _onViewModelChanged() {
    if (mounted) {
      // Recalculate range index if toggling upper/lowercase changes the first range min
      final newRangeIndex =
          _getRangeIndexForValue(_viewModel.state.letterCount);
      if (newRangeIndex != _selectedRangeIndex) {
        _selectedRangeIndex = newRangeIndex;
      }
      setState(() {});
    }
  }

  Future<void> _initData() async {
    await _viewModel.initHive();
    await _viewModel.loadHistory();

    // Set the appropriate range index based on letterCount
    _selectedRangeIndex = _getRangeIndexForValue(_viewModel.state.letterCount);
    setState(() {});
  }

  // Helper method to get range index for a given value
  int _getRangeIndexForValue(int value) {
    final ranges = _ranges;
    for (int i = 0; i < ranges.length; i++) {
      if (value >= ranges[i]['min'] && value <= ranges[i]['max']) {
        return i;
      }
    }
    return 0; // Default to first range if not found
  }

  @override
  void dispose() {
    _controller.dispose();
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _generateLetters() {
    if (!_viewModel.state.skipAnimation) {
      _controller.reset();
      _controller.forward();
    }

    try {
      _viewModel.generateLetters();
      setState(() {
        _copied = false;
      });
    } on ArgumentError {
      final loc = AppLocalizations.of(context)!;
      SnackBarUtils.showTyped(
        context,
        loc.latinLetterGenerationError(_viewModel.state.letterCount),
        SnackBarType.error,
      );
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _viewModel.formattedResults));
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
      historyType: LatinLetterGeneratorViewModel.historyType,
      history: _viewModel.historyItems,
      title: loc.generationHistory,
      onClearAllHistory: () async {
        await _viewModel.clearAllHistory();
      },
      onClearPinnedHistory: () async {
        await _viewModel.clearPinnedHistory();
      },
      onClearUnpinnedHistory: () async {
        await _viewModel.clearUnpinnedHistory();
      },
      onCopyItem: _copyHistoryItem,
      onDeleteItem: (index) async {
        await _viewModel.deleteHistoryItem(index);
      },
      onTogglePin: (index) async {
        await _viewModel.togglePinHistoryItem(index);
      },
      onTapItem: (item) {
        HistoryViewDialog.show(
          context: context,
          item: item,
        );
      },
    );
  }

  Widget _buildSwitchOptions(AppLocalizations loc) {
    final switchOptions = [
      {
        'title': loc.includeUppercase,
        'subtitle': loc.includeUppercaseDesc,
        'value': _viewModel.state.includeUppercase,
        'onChanged': (bool value) {
          _viewModel.updateIncludeUppercase(value);
          setState(() {});
        },
      },
      {
        'title': loc.includeLowercase,
        'subtitle': loc.includeLowercaseDesc,
        'value': _viewModel.state.includeLowercase,
        'onChanged': (bool value) {
          _viewModel.updateIncludeLowercase(value);
          setState(() {});
        },
      },
      {
        'title': loc.allowDuplicates,
        'subtitle': loc.allowDuplicatesDesc,
        'value': _viewModel.state.allowDuplicates,
        'onChanged': (bool value) {
          _viewModel.updateAllowDuplicates(value);
          setState(() {});
        },
      },
      {
        'title': loc.skipAnimation,
        'subtitle': loc.skipAnimationDesc,
        'value': _viewModel.state.skipAnimation,
        'onChanged': (bool value) {
          _viewModel.updateSkipAnimation(value);
          setState(() {});
        },
      },
    ];

    return GridBuilderHelper.responsive(
      builder: (context, index) {
        final option = switchOptions[index];
        return OptionSwitch(
          title: option['title'] as String,
          subtitle: option['subtitle'] as String?,
          value: option['value'] as bool,
          onChanged: option['onChanged'] as void Function(bool),
          decorator: OptionSwitchDecorator.compact(context),
        );
      },
      itemCount: switchOptions.length,
      minItemWidth: 350,
      maxColumns: 2,
      decorator: const GridBuilderDecorator(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 16,
        maxChildHeight: 60,
      ),
    );
  }

  Widget _buildRangeChips(AppLocalizations loc) {
    final ranges = _ranges;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.letterCountRange,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ranges.asMap().entries.map((entry) {
            final index = entry.key;
            final range = entry.value;
            final isSelected = index == _selectedRangeIndex;

            return FilterChip(
              label: Text(range['label']),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedRangeIndex = index;
                    // Update letter count to be within the new range
                    final min = range['min'] as int;
                    final max = range['max'] as int;
                    if (_viewModel.state.letterCount < min ||
                        _viewModel.state.letterCount > max) {
                      _viewModel.updateLetterCount(
                          min); // Set to minimum of new range
                    }
                  });
                }
              },
              backgroundColor: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLetterCountSlider(AppLocalizations loc) {
    final ranges = _ranges;
    final selectedRange = ranges[_selectedRangeIndex];
    final min = selectedRange['min'] as int;
    final max = selectedRange['max'] as int;

    // Create 20 meaningful options within the range
    final List<SliderOption<int>> options = [];
    final totalValues = max - min + 1;

    if (totalValues <= 20) {
      // If range has 20 or fewer values, include all
      for (int i = min; i <= max; i++) {
        options.add(SliderOption<int>(
          value: i,
          label: i.toString(),
        ));
      }
    } else {
      // Create 20 evenly distributed meaningful values
      final step = (max - min) / 19.0;
      final Set<int> uniqueValues = <int>{};

      for (int i = 0; i < 20; i++) {
        final value = (min + (step * i)).round();
        uniqueValues.add(value);
      }

      // Ensure min and max are included
      uniqueValues.add(min);
      uniqueValues.add(max);

      // Sort and create options
      final sortedValues = uniqueValues.toList()..sort();
      for (final value in sortedValues.take(20)) {
        options.add(SliderOption<int>(
          value: value,
          label: value.toString(),
        ));
      }
    }

    // Ensure current letterCount is valid for this range
    int validLetterCount = _viewModel.state.letterCount;
    if (validLetterCount < min || validLetterCount > max) {
      validLetterCount = min;
    }

    // Find the closest option value
    final optionValues = options.map((o) => o.value).toList();
    validLetterCount = optionValues.reduce((curr, next) =>
        (curr - validLetterCount).abs() < (next - validLetterCount).abs()
            ? curr
            : next);

    // Update letterCount if it changed
    if (validLetterCount != _viewModel.state.letterCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _viewModel.updateLetterCount(validLetterCount);
        setState(() {});
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        OptionSlider<int>(
          label: loc.letterCount,
          currentValue: validLetterCount,
          options: options,
          onChanged: (value) {
            _viewModel.updateLetterCount(value);
            setState(() {});
          },
          fixedWidth: 60,
          layout: OptionSliderLayout.none,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final generatorContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Options card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRangeChips(loc),
                _buildLetterCountSlider(loc),
                VerticalSpacingDivider.onlyBottom(6),
                _buildSwitchOptions(loc),
                VerticalSpacingDivider.specific(top: 6, bottom: 12),
                // Generate button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _generateLetters,
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

        // Result card
        if (_viewModel.results.isNotEmpty) ...[
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              if (_viewModel.state.skipAnimation) return child!;
              return Transform.scale(
                scale: 0.9 + (_animation.value * 0.1),
                child: child,
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: _viewModel.results.map((letter) {
                        return Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            letter,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SelectableText(
                          _viewModel.formattedResults,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'monospace',
                            letterSpacing: 2,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
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
      title: loc.latinLetters,
    );
  }
}
