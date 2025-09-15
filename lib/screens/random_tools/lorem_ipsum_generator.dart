import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/view_models/lorem_ipsum_generator_view_model.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/history_view_dialog.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/models/random_models/random_state_models.dart';

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
  late LoremIpsumGeneratorViewModel _viewModel;
  late OptionSwitchDecorator switchDecorator;
  bool _isDecoratorInitialized = false;

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
    _viewModel = LoremIpsumGeneratorViewModel();
    _initData();
  }

  Future<void> _initData() async {
    await _viewModel.initHive();
    await _viewModel.loadHistory();
    _selectedWordRangeIndex =
        _getRangeIndexForValue(_viewModel.state.wordCount, _wordRanges);
    _selectedSentenceRangeIndex =
        _getRangeIndexForValue(_viewModel.state.sentenceCount, _sentenceRanges);
    _selectedParagraphRangeIndex = _getRangeIndexForValue(
        _viewModel.state.paragraphCount, _paragraphRanges);
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.dispose();
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
        currentValue = _viewModel.state.wordCount;
        break;
      case LoremIpsumType.sentences:
        currentRanges = _sentenceRanges;
        currentValue = _viewModel.state.sentenceCount;
        break;
      case LoremIpsumType.paragraphs:
        currentRanges = _paragraphRanges;
        currentValue = _viewModel.state.paragraphCount;
        break;
    }

    final newRange = currentRanges[rangeIndex];
    final minValue = newRange['min'] as int;
    final maxValue = newRange['max'] as int;

    if (currentValue < minValue || currentValue > maxValue) {
      final newValue = minValue;
      switch (type) {
        case LoremIpsumType.words:
          _viewModel.updateWordCount(newValue);
          break;
        case LoremIpsumType.sentences:
          _viewModel.updateSentenceCount(newValue);
          break;
        case LoremIpsumType.paragraphs:
          _viewModel.updateParagraphCount(newValue);
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

    await _viewModel.generateText();
    _generatedText = _viewModel.result;
    setState(() {});
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

    switch (_viewModel.state.generationType) {
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
      historyType: LoremIpsumGeneratorViewModel.historyType,
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

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
                        selected: {_viewModel.state.generationType},
                        onSelectionChanged: (Set<LoremIpsumType> selection) {
                          _viewModel.updateLoremIpsumType(selection.first);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Range selector and Count slider based on type
                if (_viewModel.state.generationType ==
                    LoremIpsumType.words) ...[
                  _buildRangeSelector(LoremIpsumType.words, loc),
                  const SizedBox(height: 12),
                  OptionSlider<int>(
                    label: loc.wordCount,
                    subtitle: loc.numberOfWordsToGenerate,
                    icon: Icons.short_text,
                    currentValue: _viewModel.state.wordCount,
                    options: _buildSliderOptions(
                        _wordRanges[_selectedWordRangeIndex]),
                    onChanged: (value) {
                      _viewModel.updateWordCount(value);
                      setState(() {});
                    },
                    fixedWidth: 60,
                    layout: OptionSliderLayout.none,
                  ),
                ],

                if (_viewModel.state.generationType ==
                    LoremIpsumType.sentences) ...[
                  _buildRangeSelector(LoremIpsumType.sentences, loc),
                  const SizedBox(height: 12),
                  OptionSlider<int>(
                    label: loc.sentenceCount,
                    subtitle: loc.numberOfSentencesToGenerate,
                    icon: Icons.format_list_numbered,
                    currentValue: _viewModel.state.sentenceCount,
                    options: _buildSliderOptions(
                        _sentenceRanges[_selectedSentenceRangeIndex]),
                    onChanged: (value) {
                      _viewModel.updateSentenceCount(value);
                      setState(() {});
                    },
                    fixedWidth: 60,
                    layout: OptionSliderLayout.none,
                  ),
                ],

                if (_viewModel.state.generationType ==
                    LoremIpsumType.paragraphs) ...[
                  _buildRangeSelector(LoremIpsumType.paragraphs, loc),
                  const SizedBox(height: 12),
                  OptionSlider<int>(
                    label: loc.paragraphCount,
                    subtitle: loc.numberOfParagraphsToGenerate,
                    icon: Icons.subject,
                    currentValue: _viewModel.state.paragraphCount,
                    options: _buildSliderOptions(
                        _paragraphRanges[_selectedParagraphRangeIndex]),
                    onChanged: (value) {
                      _viewModel.updateParagraphCount(value);
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
                  value: _viewModel.state.startWithLorem,
                  onChanged: (value) {
                    _viewModel.updateStartWithLorem(value);
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
      historyEnabled: _viewModel.historyEnabled,
      hasHistory: _viewModel.historyEnabled,
      isEmbedded: widget.isEmbedded,
      title: loc.loremIpsumGenerator,
    );
  }
}
