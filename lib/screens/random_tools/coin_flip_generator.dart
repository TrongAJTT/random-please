import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/view_models/coin_flip_generator_view_model.dart';
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
  late CoinFlipGeneratorViewModel _viewModel;
  bool _currentSide = true; // true = heads, false = tails
  bool _isFlipping = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _viewModel = CoinFlipGeneratorViewModel();
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
    _initData();
  }

  Future<void> _initData() async {
    await _viewModel.initHive();
    await _viewModel.loadHistory();
    setState(() {});
  }

  @override
  void dispose() {
    _flipController.dispose();
    _scaleController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _flipCoin() async {
    if (_isFlipping) return;

    if (_viewModel.state.skipAnimation) {
      // Generate result immediately if animation is skipped
      await _viewModel.flipCoin();
      if (_viewModel.result != null) {
        setState(() {
          _currentSide = _viewModel.result!;
        });
      }
    } else {
      // Run flip animation
      setState(() {
        _isFlipping = true;
      });

      _scaleController.reset();
      _scaleController.forward().then((_) => _scaleController.reverse());

      _flipController.reset();
      await _flipController.forward();

      // Generate result after animation
      await _viewModel.flipCoin();

      setState(() {
        _isFlipping = false;
        if (_viewModel.result != null) {
          _currentSide = _viewModel.result!;
        }
      });
    }
  }

  void _copyToClipboard() {
    if (_viewModel.result == null) return;

    final loc = AppLocalizations.of(context)!;
    final text = _viewModel.result! ? loc.heads : loc.tails;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.copied)),
    );
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return RandomGeneratorHistoryWidget(
      historyType: 'coin_flip',
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
      onCopyItem: (value) {
        Clipboard.setData(ClipboardData(text: value));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.copied)),
        );
      },
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
                // Skip animation switch
                OptionSwitch(
                  title: loc.skipAnimation,
                  subtitle: loc.skipAnimationDesc,
                  value: _viewModel.state.skipAnimation,
                  onChanged: (value) {
                    _viewModel.updateSkipAnimation(value);
                    setState(() {});
                  },
                  decorator: OptionSwitchDecorator.compact(context),
                ),

                const SizedBox(height: 16),

                // Flip button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isFlipping ? null : _flipCoin,
                    icon: const Icon(Icons.sync),
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
        ),

        // Results card
        if (_viewModel.result != null) ...[
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
                          Icons.sync,
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
                              loc.flipCoinDesc,
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
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.copy,
                            color: Colors.green,
                          ),
                          onPressed: _copyToClipboard,
                          tooltip: loc.copyToClipboard,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Coin display
                  AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateX(_flipAnimation.value),
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 1.0, end: 1.1).animate(
                            CurvedAnimation(
                              parent: _scaleController,
                              curve: Curves.elasticOut,
                            ),
                          ),
                          child: Container(
                            width: 120,
                            height: 120,
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: _currentSide
                                    ? [
                                        Colors.amber.shade300,
                                        Colors.amber.shade600
                                      ]
                                    : [
                                        Colors.grey.shade300,
                                        Colors.grey.shade600
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: _currentSide
                                    ? Colors.amber.shade700
                                    : Colors.grey.shade700,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _currentSide ? loc.heads : loc.tails,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: _currentSide
                                          ? Colors.amber.shade900
                                          : Colors.grey.shade800,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
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
      title: loc.flipCoin,
    );
  }
}
