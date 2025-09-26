import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/providers/playing_cards_generator_state_provider.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/widgets/history_widget.dart';

class PlayingCardGeneratorScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const PlayingCardGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<PlayingCardGeneratorScreen> createState() =>
      _PlayingCardGeneratorScreenState();
}

class _PlayingCardGeneratorScreenState
    extends ConsumerState<PlayingCardGeneratorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _copied = false;
  List<PlayingCard> _generatedCards = [];
  static const String historyType = 'playing_cards';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _generateCards() async {
    _controller.reset();
    _controller.forward();

    final stateManager =
        ref.read(playingCardsGeneratorStateManagerProvider.notifier);
    final currentState = ref.read(playingCardsGeneratorStateManagerProvider);

    // Generate cards using RandomGenerator
    _generatedCards = RandomGenerator.generatePlayingCards(
      count: currentState.cardCount,
      includeJokers: currentState.includeJokers,
      allowDuplicates: currentState.allowDuplicates,
    );

    // Save state only on generate
    await stateManager.saveStateOnGenerate();

    // Add to history if enabled
    final historyEnabled = ref.read(historyEnabledProvider);
    if (historyEnabled && _generatedCards.isNotEmpty) {
      final cardStrings =
          _generatedCards.map((card) => card.toString()).toList();
      await ref.read(historyProvider.notifier).addHistoryItem(
            cardStrings.join(', '),
            historyType,
          );
    }

    setState(() {
      _copied = false;
    });
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return HistoryWidget(
      type: historyType,
      title: loc.generationHistory,
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
    if (_generatedCards.isEmpty) return;

    final cardTexts =
        _generatedCards.map((card) => '${card.rank} of ${card.suit}').toList();
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
    // Watch state changes to trigger rebuilds
    final currentState = ref.watch(playingCardsGeneratorStateManagerProvider);
    final stateManager =
        ref.read(playingCardsGeneratorStateManagerProvider.notifier);
    final historyEnabled = ref.watch(historyEnabledProvider);

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
                  currentValue: currentState.cardCount,
                  layout: OptionSliderLayout.none,
                  fixedWidth: 60,
                  options: List.generate(
                      20,
                      (index) => SliderOption(
                            value: index + 1,
                            label: (index + 1).toString(),
                          )),
                  onChanged: (value) {
                    stateManager.updateCardCount(value);
                  },
                ),

                // Include jokers switch
                OptionSwitch(
                  title: loc.includeJokers,
                  subtitle: loc.includeJokersDesc,
                  value: currentState.includeJokers,
                  onChanged: (value) {
                    stateManager.updateIncludeJokers(value);
                  },
                  decorator: OptionSwitchDecorator.compact(context),
                ),

                const SizedBox(height: 8),

                // Allow duplicates switch
                OptionSwitch(
                  title: loc.allowDuplicates,
                  subtitle: loc.allowDuplicatesDesc,
                  value: currentState.allowDuplicates,
                  onChanged: (value) {
                    stateManager.updateAllowDuplicates(value);
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
        if (_generatedCards.isNotEmpty) ...[
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
                              '${_generatedCards.length} ${loc.playingCards.toLowerCase()}',
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
                            children: _generatedCards
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
      historyEnabled: historyEnabled,
      hasHistory: historyEnabled,
      isEmbedded: widget.isEmbedded,
      title: loc.playingCards,
    );
  }
}
