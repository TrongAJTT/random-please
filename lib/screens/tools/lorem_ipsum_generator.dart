import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/lorem_ipsum_generator_state_provider.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/widgets/common/history_widget.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/utils/auto_scroll_helper.dart';
import 'package:faker/faker.dart';
import 'package:random_please/constants/history_types.dart';
import 'package:random_please/utils/enhanced_random.dart';

class LoremIpsumGeneratorScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const LoremIpsumGeneratorScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  ConsumerState<LoremIpsumGeneratorScreen> createState() =>
      _LoremIpsumGeneratorScreenState();
}

class _LoremIpsumGeneratorScreenState
    extends ConsumerState<LoremIpsumGeneratorScreen> {
  late OptionSwitchDecorator switchDecorator;
  bool _isDecoratorInitialized = false;
  static const String historyType = HistoryTypes.loremIpsum;
  final faker = Faker();
  final ScrollController _scrollController = ScrollController();

  String _generatedText = '';
  bool _copied = false;

  // Range definitions for different types
  final List<Map<String, dynamic>> _wordRanges = [
    {'min': 1, 'max': 80, 'label': '1-80'},
    {'min': 81, 'max': 160, 'label': '81-160'},
    {'min': 161, 'max': 240, 'label': '161-240'},
    {'min': 241, 'max': 320, 'label': '241-320'},
    {'min': 321, 'max': 400, 'label': '321-400'},
    {'min': 401, 'max': 480, 'label': '401-480'},
  ];

  final List<Map<String, dynamic>> _sentenceRanges = [
    {'min': 1, 'max': 10, 'label': '1-10'},
    {'min': 11, 'max': 20, 'label': '11-20'},
    {'min': 21, 'max': 30, 'label': '21-30'},
    {'min': 31, 'max': 40, 'label': '31-40'},
    {'min': 41, 'max': 50, 'label': '41-50'},
  ];

  final List<Map<String, dynamic>> _paragraphRanges = [
    {'min': 1, 'max': 5, 'label': '1-5'},
    {'min': 6, 'max': 10, 'label': '6-10'},
    {'min': 11, 'max': 15, 'label': '11-15'},
    {'min': 16, 'max': 20, 'label': '16-20'},
  ];

  int _selectedWordRangeIndex = 0;
  int _selectedSentenceRangeIndex = 0;
  int _selectedParagraphRangeIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize range selectors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = ref.read(loremIpsumGeneratorStateManagerProvider);
      _selectedWordRangeIndex =
          _getRangeIndexForValue(currentState.wordCount, _wordRanges);
      _selectedSentenceRangeIndex =
          _getRangeIndexForValue(currentState.sentenceCount, _sentenceRanges);
      _selectedParagraphRangeIndex =
          _getRangeIndexForValue(currentState.paragraphCount, _paragraphRanges);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int _getRangeIndexForValue(int value, List<Map<String, dynamic>> ranges) {
    for (int i = 0; i < ranges.length; i++) {
      if (value >= ranges[i]['min'] && value <= ranges[i]['max']) {
        return i;
      }
    }
    return 0; // Default to first range if not found
  }

  void _onRangeChanged(int rangeIndex, LoremIpsumType type) {
    late List<Map<String, dynamic>> currentRanges;
    late int currentValue;

    switch (type) {
      case LoremIpsumType.words:
        currentRanges = _wordRanges;
        currentValue =
            ref.read(loremIpsumGeneratorStateManagerProvider).wordCount;
        break;
      case LoremIpsumType.sentences:
        currentRanges = _sentenceRanges;
        currentValue =
            ref.read(loremIpsumGeneratorStateManagerProvider).sentenceCount;
        break;
      case LoremIpsumType.paragraphs:
        currentRanges = _paragraphRanges;
        currentValue =
            ref.read(loremIpsumGeneratorStateManagerProvider).paragraphCount;
        break;
    }

    final newRange = currentRanges[rangeIndex];
    final minValue = newRange['min'] as int;
    final maxValue = newRange['max'] as int;

    if (currentValue < minValue || currentValue > maxValue) {
      final newValue = minValue;
      final stateManager =
          ref.read(loremIpsumGeneratorStateManagerProvider.notifier);
      switch (type) {
        case LoremIpsumType.words:
          stateManager.updateWordCount(newValue);
          break;
        case LoremIpsumType.sentences:
          stateManager.updateSentenceCount(newValue);
          break;
        case LoremIpsumType.paragraphs:
          stateManager.updateParagraphCount(newValue);
          break;
      }
      setState(() {});
    }

    switch (type) {
      case LoremIpsumType.words:
        _selectedWordRangeIndex = rangeIndex;
        break;
      case LoremIpsumType.sentences:
        _selectedSentenceRangeIndex = rangeIndex;
        break;
      case LoremIpsumType.paragraphs:
        _selectedParagraphRangeIndex = rangeIndex;
        break;
    }
  }

  Widget _buildRangeSelector(LoremIpsumType type, AppLocalizations loc) {
    late List<Map<String, dynamic>> ranges;
    late int selectedIndex;
    late String title;

    switch (type) {
      case LoremIpsumType.words:
        ranges = _wordRanges;
        selectedIndex = _selectedWordRangeIndex;
        title = 'Word Range';
        break;
      case LoremIpsumType.sentences:
        ranges = _sentenceRanges;
        selectedIndex = _selectedSentenceRangeIndex;
        title = 'Sentence Range';
        break;
      case LoremIpsumType.paragraphs:
        ranges = _paragraphRanges;
        selectedIndex = _selectedParagraphRangeIndex;
        title = 'Paragraph Range';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ranges.length,
            itemBuilder: (context, index) {
              final range = ranges[index];
              final isSelected = index == selectedIndex;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(range['label']),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      _onRangeChanged(index, type);
                      setState(() {});
                    }
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<SliderOption<int>> _buildSliderOptions(Map<String, dynamic> range) {
    final min = range['min'] as int;
    final max = range['max'] as int;
    List<SliderOption<int>> options = [];

    for (int i = min; i <= max; i += 1) {
      options.add(SliderOption(value: i, label: i.toString()));
    }

    return options;
  }

  void _generate() async {
    setState(() {
      _copied = false;
    });

    final stateManager =
        ref.read(loremIpsumGeneratorStateManagerProvider.notifier);
    final currentState = ref.read(loremIpsumGeneratorStateManagerProvider);

    // Generate text using faker
    List<String> generatedContent = [];

    try {
      switch (currentState.generationType) {
        case LoremIpsumType.words:
          // Generate specific number of words
          for (int i = 0; i < currentState.wordCount; i++) {
            generatedContent.add(faker.lorem.word());
          }
          _generatedText = generatedContent.join(' ');
          break;

        case LoremIpsumType.sentences:
          // Generate specific number of sentences
          for (int i = 0; i < currentState.sentenceCount; i++) {
            generatedContent.add(faker.lorem.sentence());
          }
          _generatedText = generatedContent.join(' ');
          break;

        case LoremIpsumType.paragraphs:
          // Generate specific number of paragraphs using faker
          for (int i = 0; i < currentState.paragraphCount; i++) {
            // Generate 3-7 sentences per paragraph using enhanced randomness
            final sentencesPerParagraph = 3 + EnhancedRandom.nextInt(5);
            final sentences = faker.lorem.sentences(sentencesPerParagraph);
            generatedContent.add(sentences.join(' '));
          }
          _generatedText = generatedContent.join('\n\n');
          break;
      }

      // Apply Lorem ipsum prefix if enabled
      if (currentState.startWithLorem && generatedContent.isNotEmpty) {
        const loremPrefix =
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';
        switch (currentState.generationType) {
          case LoremIpsumType.words:
            // For words, we need to adjust the count to include prefix words
            final prefixWords = loremPrefix.split(' ').length;
            final adjustedWordCount = currentState.wordCount - prefixWords;
            if (adjustedWordCount > 0) {
              List<String> adjustedWords = [];
              for (int i = 0; i < adjustedWordCount; i++) {
                adjustedWords.add(faker.lorem.word());
              }
              _generatedText = '$loremPrefix ${adjustedWords.join(' ')}';
            } else {
              _generatedText = loremPrefix;
            }
            break;
          case LoremIpsumType.sentences:
            _generatedText = '$loremPrefix $_generatedText';
            break;
          case LoremIpsumType.paragraphs:
            _generatedText = '$loremPrefix\n\n$_generatedText';
            break;
        }
      }

      // Save state only on generate
      await stateManager.saveStateOnGenerate();

      // Add to history if enabled
      final historyEnabled = ref.read(historyEnabledProvider);
      if (historyEnabled && _generatedText.isNotEmpty) {
        await ref.read(historyProvider.notifier).addHistoryItem(
              _generatedText,
              historyType,
            );
      }
    } catch (e) {
      _generatedText = '';
      rethrow;
    }
    setState(() {});

    // Auto-scroll to results after generation
    AutoScrollHelper.scrollToResults(
      ref: ref,
      scrollController: _scrollController,
      mounted: mounted,
      hasResults: _generatedText.isNotEmpty,
    );
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _generatedText));
    setState(() {
      _copied = true;
    });
    if (mounted) {
      SnackBarUtils.showTyped(
          context, AppLocalizations.of(context)!.copied, SnackBarType.info);
    }
  }

  String _getResultSummary() {
    final loc = AppLocalizations.of(context)!;
    if (_generatedText.isEmpty) return '';

    final currentState = ref.read(loremIpsumGeneratorStateManagerProvider);
    switch (currentState.generationType) {
      case LoremIpsumType.words:
        // Show the requested word count, not the actual count
        return '${currentState.wordCount} ${loc.words.toLowerCase()}';
      case LoremIpsumType.sentences:
        // Show the requested sentence count, not the actual count
        return '${currentState.sentenceCount} ${loc.sentences.toLowerCase()}';
      case LoremIpsumType.paragraphs:
        // Show the requested paragraph count, not the actual count
        return '${currentState.paragraphCount} ${loc.paragraphs.toLowerCase()}';
    }
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return HistoryWidget(
      type: historyType,
      title: loc.generationHistory,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // Watch state changes to trigger rebuilds
    final currentState = ref.watch(loremIpsumGeneratorStateManagerProvider);

    if (!_isDecoratorInitialized) {
      switchDecorator = OptionSwitchDecorator.compact(context);
      _isDecoratorInitialized = true;
    }

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
                Text(
                  loc.generatorOptions,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<LoremIpsumType>(
                        segments: [
                          ButtonSegment(
                            value: LoremIpsumType.words,
                            label: Text(loc.words),
                          ),
                          ButtonSegment(
                            value: LoremIpsumType.sentences,
                            label: Text(loc.sentences),
                          ),
                          ButtonSegment(
                            value: LoremIpsumType.paragraphs,
                            label: Text(loc.paragraphs),
                          ),
                        ],
                        selected: {currentState.generationType},
                        onSelectionChanged: (Set<LoremIpsumType> selection) {
                          ref
                              .read(loremIpsumGeneratorStateManagerProvider
                                  .notifier)
                              .updateGenerationType(selection.first);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Range selector and Count slider based on type
                if (currentState.generationType == LoremIpsumType.words) ...[
                  _buildRangeSelector(LoremIpsumType.words, loc),
                  const SizedBox(height: 12),
                  OptionSlider<int>(
                    label: loc.wordCount,
                    subtitle: loc.numberOfWordsToGenerate,
                    icon: Icons.short_text,
                    currentValue: currentState.wordCount,
                    options: _buildSliderOptions(
                        _wordRanges[_selectedWordRangeIndex]),
                    onChanged: (value) {
                      ref
                          .read(
                              loremIpsumGeneratorStateManagerProvider.notifier)
                          .updateWordCount(value);
                      setState(() {});
                    },
                    fixedWidth: 60,
                    layout: OptionSliderLayout.none,
                  ),
                ],

                if (currentState.generationType ==
                    LoremIpsumType.sentences) ...[
                  OptionSlider<int>(
                    label: loc.sentenceCount,
                    subtitle: loc.numberOfSentencesToGenerate,
                    icon: Icons.format_list_numbered,
                    currentValue: currentState.sentenceCount,
                    options: List.generate(
                        50,
                        (index) => SliderOption(
                              value: index + 1,
                              label: (index + 1).toString(),
                            )),
                    onChanged: (value) {
                      ref
                          .read(
                              loremIpsumGeneratorStateManagerProvider.notifier)
                          .updateSentenceCount(value);
                      setState(() {});
                    },
                    fixedWidth: 60,
                    layout: OptionSliderLayout.none,
                  ),
                ],

                if (currentState.generationType ==
                    LoremIpsumType.paragraphs) ...[
                  OptionSlider<int>(
                    label: loc.paragraphCount,
                    subtitle: loc.numberOfParagraphsToGenerate,
                    icon: Icons.subject,
                    currentValue: currentState.paragraphCount,
                    options: List.generate(
                        30,
                        (index) => SliderOption(
                              value: index + 1,
                              label: (index + 1).toString(),
                            )),
                    onChanged: (value) {
                      ref
                          .read(
                              loremIpsumGeneratorStateManagerProvider.notifier)
                          .updateParagraphCount(value);
                      setState(() {});
                    },
                    fixedWidth: 60,
                    layout: OptionSliderLayout.none,
                  ),
                ],

                // Start with Lorem option
                OptionSwitch(
                  title: loc.startWithLorem,
                  subtitle: loc.startWithLoremDesc,
                  value: currentState.startWithLorem,
                  onChanged: (value) {
                    ref
                        .read(loremIpsumGeneratorStateManagerProvider.notifier)
                        .updateStartWithLorem(value);
                    setState(() {});
                  },
                  decorator: switchDecorator,
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
                    onPressed: _generate,
                    icon: const Icon(Icons.refresh),
                    label: Text(loc.generate),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Result card
        if (_generatedText.isNotEmpty) ...[
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header with better design
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Icon and title
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade700.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.text_fields,
                            color: Colors.teal.shade700,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.randomResult,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _getResultSummary(),
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
                        // Copy button with better styling
                        Container(
                          decoration: BoxDecoration(
                            color: _copied
                                ? Colors.green.withValues(alpha: 0.1)
                                : Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: Icon(
                              _copied ? Icons.check : Icons.copy,
                              color: _copied
                                  ? Colors.green
                                  : Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: _copyToClipboard,
                            tooltip: loc.copyToClipboard,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: SelectableText(
                      _generatedText,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
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
      historyEnabled: ref.watch(historyEnabledProvider),
      hasHistory: ref.watch(historyEnabledProvider),
      isEmbedded: widget.isEmbedded,
      title: loc.loremIpsumGenerator,
      scrollController: _scrollController,
    );
  }
}
