import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/providers/latin_letter_generator_state_provider.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/providers/settings_provider.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/history_widget.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/utils/auto_scroll_helper.dart';
import 'dart:math';

class LatinLetterGeneratorScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const LatinLetterGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<LatinLetterGeneratorScreen> createState() =>
      _LatinLetterGeneratorScreenState();
}

class _LatinLetterGeneratorScreenState
    extends ConsumerState<LatinLetterGeneratorScreen>
    with SingleTickerProviderStateMixin {
  bool _copied = false;
  List<String> _results = [];
  late AnimationController _controller;
  late Animation<double> _animation;
  final ScrollController _scrollController = ScrollController();

  // New variables for range selection
  int _selectedRangeIndex = 0; // Default to 1-30 range

  List<Map<String, dynamic>> get _ranges {
    return [
      {
        'min': 1,
        'max': 30,
        'label': '1-30',
      },
      {'min': 31, 'max': 60, 'label': '31-60'},
      {'min': 61, 'max': 90, 'label': '61-90'},
      {'min': 91, 'max': 120, 'label': '91-120'},
    ];
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeRangeIndex();
    });
  }

  void _initializeRangeIndex() {
    final state = ref.read(latinLetterGeneratorProvider);
    _selectedRangeIndex = _getRangeIndexForValue(state.letterCount);
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
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _generateLetters() async {
    try {
      final state = ref.read(latinLetterGeneratorProvider);
      final stateManager = ref.read(latinLetterGeneratorStateProvider.notifier);

      if (!stateManager.hasValidSettings) {
        setState(() {
          _results = [];
        });
        return;
      }

      // Calculate maximum possible letters based on selected cases
      int maxPossibleLetters = 0;
      if (state.includeUppercase) maxPossibleLetters += 26;
      if (state.includeLowercase) maxPossibleLetters += 26;

      // If no cases selected, default to 26
      if (maxPossibleLetters == 0) maxPossibleLetters = 26;

      // Check if we can generate the requested number of letters
      if (!state.allowDuplicates && state.letterCount > maxPossibleLetters) {
        final loc = AppLocalizations.of(context)!;
        SnackBarUtils.showTyped(
          context,
          loc.latinLetterGenerationError(state.letterCount, maxPossibleLetters),
          SnackBarType.error,
        );
        return;
      }

      if (!state.skipAnimation) {
        _controller.reset();
        _controller.forward();
      }

      // Generate letters
      String availableLetters = '';
      if (state.includeUppercase) {
        availableLetters += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      }
      if (state.includeLowercase) {
        availableLetters += 'abcdefghijklmnopqrstuvwxyz';
      }

      final random = Random();
      final Set<String> generatedSet = {};
      final List<String> resultList = [];

      for (int i = 0; i < state.letterCount; i++) {
        String letter;
        int attempts = 0;
        const maxAttempts = 1000;

        do {
          letter = availableLetters[random.nextInt(availableLetters.length)];
          attempts++;
        } while (!state.allowDuplicates &&
            generatedSet.contains(letter) &&
            attempts < maxAttempts);

        if (!state.allowDuplicates) {
          generatedSet.add(letter);
        }
        resultList.add(letter);
      }

      setState(() {
        _results = resultList;
        _copied = false;
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
        await ref.read(historyProvider.notifier).addHistoryItem(
              _results.join(''),
              'latin_letter',
            );
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showTyped(context, e.toString(), SnackBarType.error);
      }
    }
  }

  void _copyToClipboard() {
    if (_results.isNotEmpty) {
      final formattedResults = _results.join(' ');
      Clipboard.setData(ClipboardData(text: formattedResults));
      setState(() {
        _copied = true;
      });
      if (mounted) {
        SnackBarUtils.showTyped(
            context, AppLocalizations.of(context)!.copied, SnackBarType.info);
      }
    }
  }

  String _getResultSubtitle() {
    if (_results.isEmpty) return '';
    return '${_results.length} ${AppLocalizations.of(context)!.letters.toLowerCase()}';
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return HistoryWidget(
      type: 'latin_letter',
      title: loc.generationHistory,
    );
  }

  Widget _buildSwitchOptions(AppLocalizations loc) {
    final state = ref.watch(latinLetterGeneratorProvider);
    final stateNotifier = ref.read(latinLetterGeneratorStateProvider.notifier);

    final switchOptions = [
      {
        'title': loc.includeUppercase,
        'subtitle': loc.includeUppercaseDesc,
        'value': state.includeUppercase,
        'onChanged': (bool value) {
          stateNotifier.updateIncludeUppercase(value);
          setState(() {});
        },
      },
      {
        'title': loc.includeLowercase,
        'subtitle': loc.includeLowercaseDesc,
        'value': state.includeLowercase,
        'onChanged': (bool value) {
          stateNotifier.updateIncludeLowercase(value);
          setState(() {});
        },
      },
      {
        'title': loc.allowDuplicates,
        'subtitle': loc.allowDuplicatesDesc,
        'value': state.allowDuplicates,
        'onChanged': (bool value) {
          stateNotifier.updateAllowDuplicates(value);
          setState(() {});
        },
      },
      {
        'title': loc.skipAnimation,
        'subtitle': loc.skipAnimationDesc,
        'value': state.skipAnimation,
        'onChanged': (bool value) {
          stateNotifier.updateSkipAnimation(value);
          setState(() {});
        },
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate how many items can fit in one row
        final availableWidth = constraints.maxWidth;
        const itemWidth = 220.0; // Minimum width for each switch
        const spacing = 16.0;
        final crossAxisCount =
            ((availableWidth + spacing) / (itemWidth + spacing))
                .floor()
                .clamp(1, 2);

        return Wrap(
          spacing: 16,
          runSpacing: 8,
          children: switchOptions.map((option) {
            return SizedBox(
              width: (availableWidth - (crossAxisCount - 1) * spacing) /
                  crossAxisCount,
              child: OptionSwitch(
                title: option['title'] as String,
                subtitle: option['subtitle'] as String?,
                value: option['value'] as bool,
                onChanged: option['onChanged'] as void Function(bool),
                decorator: OptionSwitchDecorator.compact(context),
              ),
            );
          }).toList(),
        );
      },
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
                    final state = ref.read(latinLetterGeneratorProvider);
                    if (state.letterCount < min || state.letterCount > max) {
                      ref
                          .read(latinLetterGeneratorStateProvider.notifier)
                          .updateLetterCount(
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
    final state = ref.watch(latinLetterGeneratorProvider);
    final stateNotifier = ref.read(latinLetterGeneratorStateProvider.notifier);
    int validLetterCount = state.letterCount;
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
    if (validLetterCount != state.letterCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        stateNotifier.updateLetterCount(validLetterCount);
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
            stateNotifier.updateLetterCount(value);
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
        if (_results.isNotEmpty) ...[
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final state = ref.watch(latinLetterGeneratorProvider);
              if (state.skipAnimation) return child!;
              return Transform.scale(
                scale: 0.9 + (_animation.value * 0.1),
                child: child,
              );
            },
            child: Card(
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
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.abc,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
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
                      children: _results.map((letter) {
                        return Tooltip(
                          message: loc.clickToCopy,
                          child: InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: letter));
                              SnackBarUtils.showTyped(
                                  context, loc.copied, SnackBarType.info);
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Chip(
                              label: Text(
                                letter,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
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

                    // Concatenated result in a container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.1),
                        ),
                      ),
                      child: SelectableText(
                        _results.join(''),
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'monospace',
                          letterSpacing: 2,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
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
      historyEnabled: ref.watch(settingsProvider).saveRandomToolsState,
      hasHistory: ref.watch(settingsProvider).saveRandomToolsState,
      isEmbedded: widget.isEmbedded,
      title: loc.latinLetters,
      scrollController: _scrollController,
    );
  }
}
