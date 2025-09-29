import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/widgets/common/history_widget.dart';
import 'package:random_please/utils/size_utils.dart';
import 'package:random_please/widgets/statistics/number_statistics_widget.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/utils/widget_layout_render_helper.dart';
import 'package:random_please/utils/number_formatter.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/utils/auto_scroll_helper.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/providers/number_generator_state_provider.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/constants/history_types.dart';

class NumberGeneratorScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const NumberGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<NumberGeneratorScreen> createState() =>
      _NumberGeneratorScreenState();
}

class _NumberGeneratorScreenState extends ConsumerState<NumberGeneratorScreen> {
  static const String historyType = HistoryTypes.number;
  bool _copied = false;
  List<String> _results = [];

  final TextEditingController _minValueController = TextEditingController();
  final TextEditingController _maxValueController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Khởi tạo controllers với giá trị từ state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(numberGeneratorStateManagerProvider);
      _minValueController.text = state.minValue.toString();
      _maxValueController.text = state.maxValue.toString();
    });
  }

  @override
  void dispose() {
    _minValueController.dispose();
    _maxValueController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _generateNumbers() async {
    try {
      final state = ref.read(numberGeneratorStateManagerProvider);

      // Parse values from text controllers
      double min = double.tryParse(_minValueController.text) ?? state.minValue;
      double max = double.tryParse(_maxValueController.text) ?? state.maxValue;

      // Update state with new values
      if (min != state.minValue) {
        ref
            .read(numberGeneratorStateManagerProvider.notifier)
            .updateMinValue(min);
      }
      if (max != state.maxValue) {
        ref
            .read(numberGeneratorStateManagerProvider.notifier)
            .updateMaxValue(max);
      }

      // Generate numbers using RandomGenerator
      final currentState = ref.read(numberGeneratorStateManagerProvider);
      final numResults = RandomGenerator.generateNumbers(
        min: currentState.minValue,
        max: currentState.maxValue,
        count: currentState.quantity,
        isInteger: currentState.isInteger,
        allowDuplicates: currentState.allowDuplicates,
      );

      // Convert numbers to strings
      _results = numResults.map((number) => number.toString()).toList();

      // Update UI to show results
      if (mounted) {
        setState(() {});
      }

      // Save state after generation
      await ref
          .read(numberGeneratorStateManagerProvider.notifier)
          .saveStateOnGenerate();

      // Save to history if enabled
      final historyEnabled = ref.read(historyEnabledProvider);
      if (historyEnabled && _results.isNotEmpty) {
        String numbersText = _results.join(', ');
        await ref
            .read(historyProvider.notifier)
            .addHistoryItem(numbersText, historyType);
      }

      // Auto-scroll to results after generation
      AutoScrollHelper.scrollToResults(
        ref: ref,
        scrollController: _scrollController,
        mounted: mounted,
        hasResults: _results.isNotEmpty,
      );
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showTyped(context, e.toString(), SnackBarType.error);
      }
    }
  }

  void _copyToClipboard() {
    if (_results.isNotEmpty) {
      String numbersText = _results.join('\n');

      Clipboard.setData(ClipboardData(text: numbersText));
      setState(() {
        _copied = true;
      });
      if (mounted) {
        SnackBarUtils.showTyped(
            context, AppLocalizations.of(context)!.copied, SnackBarType.info);
      }
    }
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return HistoryWidget(
      type: historyType,
      title: loc.generationHistory,
    );
  }

  String _getResultSubtitle() {
    if (_results.isEmpty) return '';
    return '${_results.length} ${AppLocalizations.of(context)!.items.toLowerCase()}';
  }

  Widget _buildRangeDisplay(AppLocalizations loc) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(numberGeneratorStateManagerProvider);
      final locale = NumberFormatter.getCurrentLocale(context);
      return Text(
        loc.numberRangeFromTo(
          NumberFormatter.formatNumber(state.minValue, locale,
              isInteger: state.isInteger, decimalPlaces: 2),
          NumberFormatter.formatNumber(state.maxValue, locale,
              isInteger: state.isInteger, decimalPlaces: 2),
        ),
        style: Theme.of(context).textTheme.titleMedium,
      );
    });
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
                      Consumer(builder: (context, ref, child) {
                        final state =
                            ref.watch(numberGeneratorStateManagerProvider);
                        return Row(
                          children: [
                            ChoiceChip(
                              label: Text(loc.integers),
                              selected: state.isInteger,
                              onSelected: (selected) {
                                if (!(state.isInteger)) {
                                  ref
                                      .read(numberGeneratorStateManagerProvider
                                          .notifier)
                                      .updateIsInteger(true);
                                }
                              },
                            ),
                            const SizedBox(width: 12),
                            ChoiceChip(
                              label: Text(loc.floatingPoint),
                              selected: !state.isInteger,
                              onSelected: (selected) {
                                if (state.isInteger) {
                                  ref
                                      .read(numberGeneratorStateManagerProvider
                                          .notifier)
                                      .updateIsInteger(false);
                                }
                              },
                            ),
                          ],
                        );
                      }),
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
                      final state =
                          ref.read(numberGeneratorStateManagerProvider);
                      final newValue = double.tryParse(value) ?? state.minValue;
                      ref
                          .read(numberGeneratorStateManagerProvider.notifier)
                          .updateMinValue(newValue);
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
                      final state =
                          ref.read(numberGeneratorStateManagerProvider);
                      final newValue = double.tryParse(value) ?? state.maxValue;
                      ref
                          .read(numberGeneratorStateManagerProvider.notifier)
                          .updateMaxValue(newValue);
                    },
                  ),
                  minWidth: 120,
                  spacing: TwoDimSpacing.specific(horizontal: 16, vertical: 8),
                ),
                const SizedBox(height: 8),

                // 3. Quantity Slider
                Consumer(builder: (context, ref, child) {
                  final state = ref.watch(numberGeneratorStateManagerProvider);
                  return OptionSlider<int>(
                    label: loc.quantity,
                    currentValue: state.quantity,
                    options: List.generate(
                      40,
                      (i) => SliderOption(value: i + 1, label: '${i + 1}'),
                    ),
                    onChanged: (value) {
                      ref
                          .read(numberGeneratorStateManagerProvider.notifier)
                          .updateQuantity(value);
                    },
                    layout: OptionSliderLayout.none,
                  );
                }),

                // 4. Allow Duplicates Switch
                Consumer(builder: (context, ref, child) {
                  final state = ref.watch(numberGeneratorStateManagerProvider);
                  return OptionSwitch(
                    title: loc.allowDuplicates,
                    subtitle: loc.allowDuplicatesDesc,
                    value: state.allowDuplicates,
                    onChanged: (value) {
                      ref
                          .read(numberGeneratorStateManagerProvider.notifier)
                          .updateAllowDuplicates(value);
                    },
                    decorator: OptionSwitchDecorator.compact(context),
                  );
                }),
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
        if (_results.isNotEmpty) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with better design
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.numbers,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
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
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _results.map((numberStr) {
                        return Tooltip(
                          message: loc.clickToCopy,
                          child: InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: numberStr));
                              SnackBarUtils.showTyped(
                                  context, loc.copied, SnackBarType.info);
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Chip(
                              label: Text(
                                numberStr,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              labelStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                              side: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Statistics section
                  Consumer(builder: (context, ref, child) {
                    final state =
                        ref.watch(numberGeneratorStateManagerProvider);
                    return StatisticsWidget(
                      values: _results
                          .map((str) => int.tryParse(str) ?? 0)
                          .toList(),
                      isInteger: state.isInteger,
                      decimalPlaces: state.isInteger ? 0 : 2,
                    );
                  }),
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
      historyEnabled: ref.watch(historyEnabledProvider),
      hasHistory: ref.watch(historyEnabledProvider),
      isEmbedded: widget.isEmbedded,
      title: loc.numberGenerator,
      scrollController: _scrollController,
    );
  }
}
