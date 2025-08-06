import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/random_services/random_state_service.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/widgets/generic/option_switch.dart';

class RockPaperScissorsGeneratorScreen extends StatefulWidget {
  final bool isEmbedded;

  const RockPaperScissorsGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  State<RockPaperScissorsGeneratorScreen> createState() =>
      _RockPaperScissorsGeneratorScreenState();
}

class _RockPaperScissorsGeneratorScreenState
    extends State<RockPaperScissorsGeneratorScreen>
    with SingleTickerProviderStateMixin {
  int? _result;
  bool _skipAnimation = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  List<GenerationHistoryItem> _history = [];
  bool _historyEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 1,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _loadState();
    _loadHistory();
  }

  Future<void> _loadState() async {
    try {
      final state =
          await RandomStateService.getRockPaperScissorsGeneratorState();
      if (mounted) {
        setState(() {
          _skipAnimation = state.skipAnimation;
        });
      }
    } catch (e) {
      // Error is already logged in service
    }
  }

  Future<void> _saveState() async {
    try {
      final state = SimpleGeneratorState(
        skipAnimation: _skipAnimation,
        lastUpdated: DateTime.now(),
      );
      await RandomStateService.saveRockPaperScissorsGeneratorState(state);
    } catch (e) {
      // Error is already logged in service
    }
  }

  Future<void> _loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history =
        await GenerationHistoryService.getHistory('rock_paper_scissors');
    setState(() {
      _historyEnabled = enabled;
      _history = history;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _generateResult() async {
    // Generate result first for better UX
    final newResult = RandomGenerator.generateRockPaperScissors();

    setState(() {
      _result = newResult;
    });

    // Then run animation if not skipped
    if (!_skipAnimation) {
      _controller.reset();
      await _controller.forward();
    }

    // Save state when generating
    await _saveState();

    // Save to history if enabled
    if (_historyEnabled && _result != null) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      String resultText = _getResultText(_result!, loc);
      GenerationHistoryService.addHistoryItem(
        resultText,
        'rock_paper_scissors',
      ).then((_) => _loadHistory());
    }
  }

  void _copyHistoryItem(String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.copied)),
    );
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return RandomGeneratorHistoryWidget(
      historyType: 'rock_paper_scissors',
      history: _history,
      title: loc.generationHistory,
      onClearHistory: () async {
        await GenerationHistoryService.clearHistory('rock_paper_scissors');
        await _loadHistory();
      },
      onCopyItem: _copyHistoryItem,
    );
  }

  IconData _getResultIcon(int result) {
    switch (result) {
      case 0:
        return Icons.sports_mma; // Rock
      case 1:
        return Icons.article; // Paper
      case 2:
        return Icons.content_cut; // Scissors
      default:
        return Icons.help_outline;
    }
  }

  String _getResultText(int result, AppLocalizations loc) {
    switch (result) {
      case 0:
        return loc.rock;
      case 1:
        return loc.paper;
      case 2:
        return loc.scissors;
      default:
        return '?';
    }
  }

  Color _getResultColor(int result) {
    switch (result) {
      case 0:
        return Colors.brown.shade700; // Rock
      case 1:
        return Colors.blue.shade700; // Paper
      case 2:
        return Colors.red.shade700; // Scissors
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final generatorContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Skip animation option
        Card(
          child: OptionSwitch(
            title: loc.skipAnimation,
            subtitle: loc.skipAnimationDesc,
            value: _skipAnimation,
            onChanged: (value) {
              setState(() {
                _skipAnimation = value;
              });
            },
            decorator: OptionSwitchDecorator.compact(context).copyWith(
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Result display
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _skipAnimation ? 1.0 : _scaleAnimation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _result == null
                            ? Colors.grey.withValues(alpha: 0.3)
                            : _getResultColor(_result!).withValues(alpha: 0.8),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _result == null
                                  ? Icons.help_outline
                                  : _getResultIcon(_result!),
                              size: 80,
                              color: _result == null
                                  ? Colors.grey[600]
                                  : Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _result == null
                                  ? '?'
                                  : _getResultText(_result!, loc),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _result == null
                                    ? Colors.grey[600]
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 200,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _generateResult,
                  icon: const Icon(Icons.sports_mma),
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
      ],
    );

    return RandomGeneratorLayout(
      generatorContent: generatorContent,
      historyWidget: _buildHistoryWidget(loc),
      historyEnabled: _historyEnabled,
      hasHistory: _historyEnabled,
      isEmbedded: widget.isEmbedded,
      title: loc.rockPaperScissors,
    );
  }
}
