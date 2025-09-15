import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/view_models/playing_card_generator_view_model.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/history_view_dialog.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/models/random_generator.dart';

class PlayingCardGeneratorScreen extends StatefulWidget {
  final bool isEmbedded;

  const PlayingCardGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  State<PlayingCardGeneratorScreen> createState() =>
      _PlayingCardGeneratorScreenState();
}

class _PlayingCardGeneratorScreenState extends State<PlayingCardGeneratorScreen>
    with SingleTickerProviderStateMixin {
  late PlayingCardGeneratorViewModel _viewModel;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _viewModel = PlayingCardGeneratorViewModel();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _viewModel.addListener(_onViewModelChanged);
    _initData();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _initData() async {
    await _viewModel.initHive();
    await _viewModel.loadHistory();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _generateCards() {
    _controller.reset();
    _controller.forward();

    _viewModel.generateCards();
    setState(() {
      _copied = false;
    });
  }

  void _copyHistoryItem(String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.copied)),
    );
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return RandomGeneratorHistoryWidget(
      historyType: PlayingCardGeneratorViewModel.historyType,
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

  Widget _buildCardWidget(PlayingCard card) {
    Color cardColor = card.isRed ? Colors.red : Colors.black;

    return Container(
      width: 70,
      height: 100,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            card.suit,
            style: TextStyle(
              fontSize: 24,
              color: cardColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            card.rank,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: cardColor,
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard() {
    if (_viewModel.generatedCards.isEmpty) return;

    final cardTexts = _viewModel.generatedCards
        .map((card) => '${card.rank} of ${card.suit}')
        .toList();
    final text = cardTexts.join(', ');

    Clipboard.setData(ClipboardData(text: text));
    setState(() {
      _copied = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.copied)),
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
                // Card count slider
                OptionSlider<int>(
                  label: loc.cardCount,
                  icon: Icons.style,
                  currentValue: _viewModel.state.cardCount,
                  layout: OptionSliderLayout.none,
                  fixedWidth: 60,
                  options: List.generate(
                      20,
                      (index) => SliderOption(
                            value: index + 1,
                            label: (index + 1).toString(),
                          )),
                  onChanged: (value) {
                    _viewModel.updateCardCount(value);
                    setState(() {});
                  },
                ),

                // Include jokers switch
                OptionSwitch(
                  title: loc.includeJokers,
                  subtitle: loc.includeJokersDesc,
                  value: _viewModel.state.includeJokers,
                  onChanged: (value) {
                    _viewModel.updateIncludeJokers(value);
                    setState(() {});
                  },
                  decorator: OptionSwitchDecorator.compact(context),
                ),

                const SizedBox(height: 8),

                // Allow duplicates switch
                OptionSwitch(
                  title: loc.allowDuplicates,
                  subtitle: loc.allowDuplicatesDesc,
                  value: _viewModel.state.allowDuplicates,
                  onChanged: (value) {
                    _viewModel.updateAllowDuplicates(value);
                    setState(() {});
                  },
                  decorator: OptionSwitchDecorator.compact(context),
                ),

                VerticalSpacingDivider.specific(top: 6, bottom: 12),

                // Generate button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _generateCards,
                    icon: const Icon(Icons.shuffle),
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

        // Results card
        if (_viewModel.generatedCards.isNotEmpty) ...[
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.style,
                          color: Colors.blue.shade700,
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
                              '${_viewModel.generatedCards.length} ${loc.playingCards.toLowerCase()}',
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

                  const SizedBox(height: 16),

                  // Cards display
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.5 + (_animation.value * 0.5),
                        child: Opacity(
                          opacity: _animation.value.clamp(0.0, 1.0),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: _viewModel.generatedCards
                                .map((card) => _buildCardWidget(card))
                                .toList(),
                          ),
                        ),
                      );
                    },
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
      title: loc.playingCards,
    );
  }
}
