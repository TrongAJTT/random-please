import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/random_services/random_state_service.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/history_view_dialog.dart';
import 'package:random_please/widgets/generic/option_switch.dart';

class CoinFlipGeneratorScreen extends StatefulWidget {
  final bool isEmbedded;

  const CoinFlipGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  State<CoinFlipGeneratorScreen> createState() =>
      _CoinFlipGeneratorScreenState();
}

class _CoinFlipGeneratorScreenState extends State<CoinFlipGeneratorScreen>
    with TickerProviderStateMixin {
  bool _currentSide = true; // true = heads, false = tails
  bool? _finalResult;
  bool _isFlipping = false;
  bool _skipAnimation = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late AnimationController _scaleController;
  List<GenerationHistoryItem> _history = [];
  bool _historyEnabled = false;

  static const String _historyType = 'coin_flip';

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _flipAnimation = Tween<double>(
      begin: 0,
      end: 6 * math.pi,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeOut,
    ));

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Optimize animation listener to reduce unnecessary rebuilds
    _flipAnimation.addListener(() {
      if (_isFlipping) {
        int halfRotations = (_flipAnimation.value / math.pi).floor();
        bool newSide = halfRotations.isEven;
        if (newSide != _currentSide) {
          // Only setState if the side actually changed
          if (mounted) {
            setState(() {
              _currentSide = newSide;
            });
          }
        }
      }
    });
    _loadState();
    _loadHistory();
  }

  Future<void> _loadState() async {
    try {
      final state = await RandomStateService.getCoinFlipGeneratorState();
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
      await RandomStateService.saveCoinFlipGeneratorState(state);
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

  @override
  void dispose() {
    _flipController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _flipCoin() async {
    if (_isFlipping) return;

    // Generate result first for better UX
    final result = RandomGenerator.generateCoinFlip();

    setState(() {
      _finalResult = result;
    });

    if (_skipAnimation) {
      // Show result immediately if animation is skipped
      setState(() {
        _currentSide = result;
      });
    } else {
      // Run flip animation
      setState(() {
        _isFlipping = true;
      });

      _scaleController.reset();
      _scaleController.forward().then((_) => _scaleController.reverse());

      _flipController.reset();
      await _flipController.forward();

      setState(() {
        _isFlipping = false;
        _currentSide = result;
      });
    }

    // Save state when generating
    await _saveState();

    // Save to history if enabled
    if (_historyEnabled && _finalResult != null) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      String resultText = _finalResult! ? loc.heads : loc.tails;
      GenerationHistoryService.addHistoryItem(
        resultText,
        _historyType,
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
              // Don't save state immediately, only save when generating
            },
            decorator: OptionSwitchDecorator.compact(context).copyWith(
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Coin display
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _flipAnimation,
                builder: (context, child) {
                  // Improved coin display with better circular shape and text orientation
                  final rotationY = _skipAnimation ? 0.0 : _flipAnimation.value;
                  final isBackside = (rotationY / math.pi) % 2 >= 1;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(rotationY),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          center: const Alignment(-0.3, -0.3),
                          radius: 1.2,
                          colors: [
                            Colors.amber.shade200,
                            Colors.amber.shade400,
                            Colors.amber.shade600,
                            Colors.amber.shade800,
                          ],
                          stops: const [0.0, 0.3, 0.7, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.amber.shade900,
                          width: 3,
                        ),
                      ),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..rotateY(isBackside ? math.pi : 0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _finalResult == null
                                    ? Icons.help_outline
                                    : (_isFlipping
                                            ? _currentSide
                                            : _finalResult!)
                                        ? Icons.person
                                        : Icons.stars,
                                size: 60,
                                color: Colors.amber.shade900,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _finalResult == null
                                    ? '?'
                                    : (_isFlipping
                                            ? _currentSide
                                            : _finalResult!)
                                        ? loc.heads
                                        : loc.tails,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber.shade900,
                                ),
                              ),
                            ],
                          ),
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
                  onPressed:
                      (_isFlipping && !_skipAnimation) ? null : _flipCoin,
                  icon: const Icon(Icons.monetization_on),
                  label: Text(loc.flipCoin),
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
      title: loc.flipCoin,
    );
  }
}
