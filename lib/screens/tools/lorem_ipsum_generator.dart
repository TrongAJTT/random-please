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
import 'package:random_please/widgets/holdable_button.dart';

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
  final TextEditingController _wordController = TextEditingController();

  String _generatedText = '';
  bool _copied = false;

  // Snapshot used for result subtitle (only update on Generate)
  LoremIpsumType? _lastGeneratedType;
  int? _lastGeneratedWordCount;
  int? _lastGeneratedSentenceCount;
  int? _lastGeneratedParagraphCount;

  @override
  void initState() {
    super.initState();
    // Initialize range selectors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = ref.read(loremIpsumGeneratorStateManagerProvider);
      _wordController.text = currentState.wordCount.toString();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _wordController.dispose();
    super.dispose();
  }

  // WORDS: text input with +/- and a help text. Range 40-500
  Widget _buildWordCountInput(AppLocalizations loc) {
    final stateManager =
        ref.read(loremIpsumGeneratorStateManagerProvider.notifier);
    final current = ref.read(loremIpsumGeneratorStateManagerProvider).wordCount;
    if (_wordController.text.isEmpty) {
      _wordController.text = current.toString();
    }

    void setCount(int v) {
      final clamped = v.clamp(40, 500);
      stateManager.updateWordCount(clamped);
      _wordController.text = clamped.toString();
      setState(() {});
    }

    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.wordCount, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _wordController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSubmitted: (v) {
                  final parsed = int.tryParse(v) ?? current;
                  setCount(parsed);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  hintText: '40-500',
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(width: 8),
            HoldableButton(
              tooltip: loc.increase,
              enabled:
                  ref.read(loremIpsumGeneratorStateManagerProvider).wordCount <
                      500,
              onTap: () {
                final cur =
                    ref.read(loremIpsumGeneratorStateManagerProvider).wordCount;
                setCount(cur + 1);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.add, color: colorScheme.onPrimary, size: 40),
              ),
            ),
            const SizedBox(width: 8),
            HoldableButton(
              tooltip: loc.decrease,
              enabled:
                  ref.read(loremIpsumGeneratorStateManagerProvider).wordCount >
                      40,
              onTap: () {
                final cur =
                    ref.read(loremIpsumGeneratorStateManagerProvider).wordCount;
                setCount(cur - 1);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Icon(Icons.remove, color: colorScheme.onPrimary, size: 40),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text('${loc.range}: 40-500',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 8),
      ],
    );
  }

  // removed old word range slider builder

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

      // Take a snapshot for result subtitle (only updates on generate)
      _lastGeneratedType = currentState.generationType;
      _lastGeneratedWordCount = currentState.wordCount;
      _lastGeneratedSentenceCount = currentState.sentenceCount;
      _lastGeneratedParagraphCount = currentState.paragraphCount;

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

    switch (_lastGeneratedType) {
      case LoremIpsumType.words:
        return '${_lastGeneratedWordCount ?? 0} ${loc.words.toLowerCase()}';
      case LoremIpsumType.sentences:
        return '${_lastGeneratedSentenceCount ?? 0} ${loc.sentences.toLowerCase()}';
      case LoremIpsumType.paragraphs:
        return '${_lastGeneratedParagraphCount ?? 0} ${loc.paragraphs.toLowerCase()}';
      default:
        return '';
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

                // Count controls based on type
                if (currentState.generationType == LoremIpsumType.words) ...[
                  _buildWordCountInput(loc),
                ],

                if (currentState.generationType ==
                    LoremIpsumType.sentences) ...[
                  OptionSlider<int>(
                    label: loc.sentenceCount,
                    subtitle: loc.numberOfSentencesToGenerate,
                    icon: Icons.format_list_numbered,
                    currentValue: currentState.sentenceCount,
                    options: List.generate(
                        56,
                        (index) => SliderOption(
                              value: index + 5,
                              label: (index + 5).toString(),
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
                        40,
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
