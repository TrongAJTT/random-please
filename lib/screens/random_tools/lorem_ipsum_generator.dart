import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:faker/faker.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/services/random_services/random_state_service.dart';
import 'package:random_please/utils/history_view_dialog.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/option_switch.dart';

class LoremIpsumGeneratorScreen extends StatefulWidget {
  final bool isEmbedded;

  const LoremIpsumGeneratorScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  State<LoremIpsumGeneratorScreen> createState() =>
      _LoremIpsumGeneratorScreenState();
}

class _LoremIpsumGeneratorScreenState extends State<LoremIpsumGeneratorScreen> {
  final faker = Faker();
  LoremIpsumGeneratorState _state = LoremIpsumGeneratorState.createDefault();
  late OptionSwitchDecorator switchDecorator;
  bool _isDecoratorInitialized = false;

  String _generatedText = '';
  bool _copied = false;
  List<GenerationHistoryItem> _history = [];
  bool _historyEnabled = false;

  static const String _historyType = 'lorem_ipsum';

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
    {'min': 1, 'max': 20, 'label': '1-20'},
    {'min': 21, 'max': 40, 'label': '21-40'},
    {'min': 41, 'max': 60, 'label': '41-60'},
    {'min': 61, 'max': 80, 'label': '61-80'},
    {'min': 81, 'max': 100, 'label': '81-100'},
  ];

  final List<Map<String, dynamic>> _paragraphRanges = [
    {'min': 1, 'max': 20, 'label': '1-20'},
    {'min': 21, 'max': 40, 'label': '21-40'},
  ];

  int _selectedWordRangeIndex = 0;
  int _selectedSentenceRangeIndex = 0;
  int _selectedParagraphRangeIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadState();
    _loadHistory();
    _initializeRangeIndexes();
  }

  void _initializeRangeIndexes() {
    // Initialize range indexes based on current values
    _selectedWordRangeIndex =
        _getRangeIndexForValue(_state.wordCount, _wordRanges);
    _selectedSentenceRangeIndex =
        _getRangeIndexForValue(_state.sentenceCount, _sentenceRanges);
    _selectedParagraphRangeIndex =
        _getRangeIndexForValue(_state.paragraphCount, _paragraphRanges);
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
    setState(() {
      List<Map<String, dynamic>> currentRanges;
      int currentValue;

      switch (type) {
        case LoremIpsumType.words:
          _selectedWordRangeIndex = rangeIndex;
          currentRanges = _wordRanges;
          currentValue = _state.wordCount;
          break;
        case LoremIpsumType.sentences:
          _selectedSentenceRangeIndex = rangeIndex;
          currentRanges = _sentenceRanges;
          currentValue = _state.sentenceCount;
          break;
        case LoremIpsumType.paragraphs:
          _selectedParagraphRangeIndex = rangeIndex;
          currentRanges = _paragraphRanges;
          currentValue = _state.paragraphCount;
          break;
      }

      // Ensure current value is within the new range
      final newRange = currentRanges[rangeIndex];
      final minValue = newRange['min'] as int;
      final maxValue = newRange['max'] as int;

      if (currentValue < minValue || currentValue > maxValue) {
        // Set to the middle of the new range
        final newValue = ((minValue + maxValue) / 2).round();
        switch (type) {
          case LoremIpsumType.words:
            _state = _state.copyWith(wordCount: newValue);
            break;
          case LoremIpsumType.sentences:
            _state = _state.copyWith(sentenceCount: newValue);
            break;
          case LoremIpsumType.paragraphs:
            _state = _state.copyWith(paragraphCount: newValue);
            break;
        }
      }
    });
  }

  Widget _buildRangeSelector(LoremIpsumType type, AppLocalizations loc) {
    List<Map<String, dynamic>> ranges;
    int selectedIndex;
    String title;

    switch (type) {
      case LoremIpsumType.words:
        ranges = _wordRanges;
        selectedIndex = _selectedWordRangeIndex;
        title = loc.letterCountRange; // Reusing existing localization
        break;
      case LoremIpsumType.sentences:
        ranges = _sentenceRanges;
        selectedIndex = _selectedSentenceRangeIndex;
        title = "Sentence Range"; // You might want to add this to localization
        break;
      case LoremIpsumType.paragraphs:
        ranges = _paragraphRanges;
        selectedIndex = _selectedParagraphRangeIndex;
        title = "Paragraph Range"; // You might want to add this to localization
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: ranges.asMap().entries.map((entry) {
            final index = entry.key;
            final range = entry.value;
            final isSelected = index == selectedIndex;

            return FilterChip(
              label: Text(range['label'] as String),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  _onRangeChanged(index, type);
                }
              },
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.3),
              labelStyle: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  List<SliderOption<int>> _buildSliderOptions(Map<String, dynamic> range) {
    final minValue = range['min'] as int;
    final maxValue = range['max'] as int;

    return List.generate(
      maxValue - minValue + 1,
      (index) => SliderOption(
        value: minValue + index,
        label: '${minValue + index}',
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDecoratorInitialized) {
      switchDecorator = OptionSwitchDecorator.compact(context);
      _isDecoratorInitialized = true;
    }
  }

  Future<void> _loadState() async {
    try {
      final state = await RandomStateService.getLoremIpsumGeneratorState();
      if (mounted) {
        setState(() {
          _state = state;
        });
      }
    } catch (e) {
      // Error is already logged in service
    }
  }

  Future<void> _saveState() async {
    try {
      await RandomStateService.saveLoremIpsumGeneratorState(_state);
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

  String _generateLoremIpsum() {
    String result = '';

    if (_state.generationType == LoremIpsumType.words) {
      List<String> words = [];

      // Add "Lorem ipsum..." start if enabled
      if (_state.startWithLorem) {
        words.addAll(['Lorem', 'ipsum', 'dolor', 'sit', 'amet']);
        // Generate remaining words
        if (_state.wordCount > 5) {
          for (int i = 0; i < _state.wordCount - 5; i++) {
            words.add(faker.lorem.word());
          }
        }
      } else {
        // Generate all words randomly
        for (int i = 0; i < _state.wordCount; i++) {
          words.add(faker.lorem.word());
        }
      }

      result = words.join(' ');
    } else if (_state.generationType == LoremIpsumType.sentences) {
      List<String> sentences = [];

      if (_state.startWithLorem) {
        sentences
            .add('Lorem ipsum dolor sit amet, consectetur adipiscing elit.');
        // Generate remaining sentences
        if (_state.sentenceCount > 1) {
          for (int i = 0; i < _state.sentenceCount - 1; i++) {
            sentences.add(faker.lorem.sentence());
          }
        }
      } else {
        // Generate all sentences randomly
        for (int i = 0; i < _state.sentenceCount; i++) {
          sentences.add(faker.lorem.sentence());
        }
      }

      result = sentences.join(' ');
    } else {
      // Paragraphs
      List<String> paragraphs = [];

      if (_state.startWithLorem) {
        paragraphs.add(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.');
        // Generate remaining paragraphs
        if (_state.paragraphCount > 1) {
          for (int i = 0; i < _state.paragraphCount - 1; i++) {
            paragraphs.add(faker.lorem
                .sentences(3 + faker.randomGenerator.integer(4))
                .join(' '));
          }
        }
      } else {
        // Generate all paragraphs randomly
        for (int i = 0; i < _state.paragraphCount; i++) {
          paragraphs.add(faker.lorem
              .sentences(3 + faker.randomGenerator.integer(4))
              .join(' '));
        }
      }

      result = paragraphs.join('\n\n');
    }

    return result;
  }

  void _generate() async {
    setState(() {
      _generatedText = _generateLoremIpsum();
      _copied = false;
    });

    // Save state after generating
    await _saveState();

    // Save to history if enabled
    if (_historyEnabled && _generatedText.isNotEmpty) {
      await GenerationHistoryService.addHistoryItem(
        _generatedText,
        _historyType,
      );
      await _loadHistory(); // Refresh history
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _generatedText));
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

  String _getResultSummary() {
    final loc = AppLocalizations.of(context)!;
    if (_generatedText.isEmpty) return '';

    switch (_state.generationType) {
      case LoremIpsumType.words:
        final wordCount = _generatedText.split(' ').length;
        return '$wordCount ${loc.words.toLowerCase()}';
      case LoremIpsumType.sentences:
        final sentenceCount =
            _generatedText.split('.').where((s) => s.trim().isNotEmpty).length;
        return '$sentenceCount ${loc.sentences.toLowerCase()}';
      case LoremIpsumType.paragraphs:
        final paragraphCount = _generatedText.split('\n\n').length;
        return '$paragraphCount ${loc.paragraphs.toLowerCase()}';
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
                // Generation type selector
                Text(
                  loc.generationType,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
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
                        selected: {_state.generationType},
                        onSelectionChanged: (Set<LoremIpsumType> selection) {
                          setState(() {
                            _state = _state.copyWith(
                                generationType: selection.first);
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Range selector and Count slider based on type
                if (_state.generationType == LoremIpsumType.words) ...[
                  _buildRangeSelector(LoremIpsumType.words, loc),
                  const SizedBox(height: 12),
                  OptionSlider<int>(
                    label: loc.wordCount,
                    subtitle: loc.numberOfWordsToGenerate,
                    icon: Icons.short_text,
                    currentValue: _state.wordCount,
                    options: _buildSliderOptions(
                        _wordRanges[_selectedWordRangeIndex]),
                    onChanged: (value) {
                      setState(() {
                        _state = _state.copyWith(wordCount: value);
                      });
                    },
                    layout: OptionSliderLayout.none,
                  ),
                ],

                if (_state.generationType == LoremIpsumType.sentences) ...[
                  _buildRangeSelector(LoremIpsumType.sentences, loc),
                  const SizedBox(height: 12),
                  OptionSlider<int>(
                    label: loc.sentenceCount,
                    subtitle: loc.numberOfSentencesToGenerate,
                    icon: Icons.format_list_numbered,
                    currentValue: _state.sentenceCount,
                    options: _buildSliderOptions(
                        _sentenceRanges[_selectedSentenceRangeIndex]),
                    onChanged: (value) {
                      setState(() {
                        _state = _state.copyWith(sentenceCount: value);
                      });
                    },
                    layout: OptionSliderLayout.none,
                  ),
                ],

                if (_state.generationType == LoremIpsumType.paragraphs) ...[
                  _buildRangeSelector(LoremIpsumType.paragraphs, loc),
                  const SizedBox(height: 12),
                  OptionSlider<int>(
                    label: loc.paragraphCount,
                    subtitle: loc.numberOfParagraphsToGenerate,
                    icon: Icons.subject,
                    currentValue: _state.paragraphCount,
                    options: _buildSliderOptions(
                        _paragraphRanges[_selectedParagraphRangeIndex]),
                    onChanged: (value) {
                      setState(() {
                        _state = _state.copyWith(paragraphCount: value);
                      });
                    },
                    layout: OptionSliderLayout.none,
                  ),
                ],

                VerticalSpacingDivider.onlyBottom(6),

                // Start with Lorem option
                OptionSwitch(
                  title: loc.startWithLorem,
                  subtitle: loc.startWithLoremDesc,
                  value: _state.startWithLorem,
                  onChanged: (value) {
                    setState(() {
                      _state = _state.copyWith(startWithLorem: value);
                    });
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
                          .surfaceVariant
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
      historyEnabled: _historyEnabled,
      hasHistory: _historyEnabled,
      isEmbedded: widget.isEmbedded,
      title: loc.loremIpsumGenerator,
    );
  }
}
