import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/random_services/random_state_service.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/history_view_dialog.dart';
import 'package:random_please/utils/size_utils.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/utils/widget_layout_render_helper.dart';

class PlayingCardGeneratorScreen extends StatefulWidget {
  final bool isEmbedded;

  const PlayingCardGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  State<PlayingCardGeneratorScreen> createState() =>
      _PlayingCardGeneratorScreenState();
}

class _PlayingCardGeneratorScreenState extends State<PlayingCardGeneratorScreen>
    with SingleTickerProviderStateMixin {
  List<PlayingCard> _generatedCards = [];
  int _cardCount = 5;
  bool _includeJokers = false;
  bool _allowDuplicates = false;
  bool _copied = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  List<GenerationHistoryItem> _history = [];
  bool _historyEnabled = false;

  static const String _historyType = 'playing_cards';

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
    _loadState();
    _loadHistory();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadState() async {
    try {
      final state = await RandomStateService.getPlayingCardGeneratorState();
      if (mounted) {
        setState(() {
          _includeJokers = state.includeJokers;
          _cardCount = state.cardCount;
          _allowDuplicates = state.allowDuplicates;
        });
      }
    } catch (e) {
      // Error is already logged in service
    }
  }

  Future<void> _saveState() async {
    try {
      final state = PlayingCardGeneratorState(
        includeJokers: _includeJokers,
        cardCount: _cardCount,
        allowDuplicates: _allowDuplicates,
        lastUpdated: DateTime.now(),
      );
      await RandomStateService.savePlayingCardGeneratorState(state);
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

  void _generateCards() {
    try {
      final cards = RandomGenerator.generatePlayingCards(
        count: _cardCount,
        includeJokers: _includeJokers,
        allowDuplicates: _allowDuplicates,
      );

      setState(() {
        _generatedCards = cards;
        _copied = false;
      });

      _controller.forward(from: 0);

      // Save state when generating
      _saveState();

      // Save to history if enabled
      if (_historyEnabled && cards.isNotEmpty) {
        final cardStrings = cards.map((card) => card.toString()).toList();
        GenerationHistoryService.addHistoryItem(
          cardStrings.join(', '),
          _historyType,
        ).then((_) => _loadHistory());
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _copyToClipboard() {
    if (_generatedCards.isEmpty) return;

    final cardStrings =
        _generatedCards.map((card) => card.toString()).join(', ');
    Clipboard.setData(ClipboardData(text: cardStrings));
    setState(() {
      _copied = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.copied),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _copyHistoryItem(String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.copied),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Color _getSuitColor(String suit) {
    if (suit == '♥' || suit == '♦') {
      return Colors.red;
    } else if (suit == '♠' || suit == '♣') {
      return Colors.black;
    } else {
      return Colors.purple; // Joker
    }
  }

  Widget _buildControlsCard(AppLocalizations loc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // OptionSlider for card count
            OptionSlider<int>(
              label: loc.cardCount,
              currentValue: _cardCount,
              options: List.generate(
                _includeJokers ? 54 : 52, // max cards
                (i) => SliderOption(value: i + 1, label: '${i + 1}'),
              ),
              onChanged: (value) {
                setState(() {
                  _cardCount = value;
                });
              },
              layout: OptionSliderLayout.none,
            ),
            // Two OptionSwitch widgets in a row
            WidgetLayoutRenderHelper.twoEqualWidthInRow(
                OptionSwitch(
                  title: loc.includeJokers,
                  value: _includeJokers,
                  onChanged: (value) {
                    setState(() {
                      _includeJokers = value;
                      if (!_includeJokers && _cardCount > 52) {
                        _cardCount = 52;
                      }
                    });
                  },
                  decorator: OptionSwitchDecorator.compact(context),
                ),
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
                minWidth: 340,
                spacing: TwoDimSpacing.specific(vertical: 8, horizontal: 16)),
            VerticalSpacingDivider.specific(top: 6, bottom: 12),
            // Generate button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _generateCards,
                icon: const Icon(Icons.casino),
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
    );
  }

  Widget _buildResultCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.randomResult,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (_generatedCards.isNotEmpty)
                  IconButton(
                    icon: Icon(
                      _copied ? Icons.check : Icons.copy,
                      color: _copied ? Colors.green : null,
                    ),
                    onPressed: _copyToClipboard,
                    tooltip: AppLocalizations.of(context)!.copyToClipboard,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (_generatedCards.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.style,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.generate,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              )
            else
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  // Clamp animation value to ensure opacity is between 0.0 and 1.0
                  final clampedValue = _animation.value.clamp(0.0, 1.0);
                  return Opacity(
                    opacity: clampedValue,
                    child: Transform.scale(
                      scale: 0.8 + (0.2 * clampedValue),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
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
    );
  }

  Widget _buildCardWidget(PlayingCard card) {
    return Container(
      width: 80,
      height: 112,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            card.rank,
            style: TextStyle(
              fontSize: card.rank == '10' ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: _getSuitColor(card.suit),
            ),
          ),
          Text(
            card.suit,
            style: TextStyle(
              fontSize: 20,
              color: _getSuitColor(card.suit),
            ),
          ),
          Text(
            card.rank,
            style: TextStyle(
              fontSize: card.rank == '10' ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: _getSuitColor(card.suit),
            ),
          ),
        ],
      ),
    );
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
        _buildControlsCard(loc),
        const SizedBox(height: 16),
        _buildResultCard(),
      ],
    );

    return RandomGeneratorLayout(
      generatorContent: generatorContent,
      historyWidget: _buildHistoryWidget(loc),
      historyEnabled: _historyEnabled,
      hasHistory: _historyEnabled,
      isEmbedded: widget.isEmbedded,
      title: loc.playingCards,
    );
  }
}
