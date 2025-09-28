import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/common/history_widget.dart';
import 'package:random_please/widgets/common/counter_statistics_card.dart';
import 'package:random_please/providers/coin_flip_generator_provider.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';

class CoinFlipGeneratorScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const CoinFlipGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<CoinFlipGeneratorScreen> createState() =>
      _CoinFlipGeneratorScreenState();
}

class _CoinFlipGeneratorScreenState
    extends ConsumerState<CoinFlipGeneratorScreen>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late AnimationController _scaleController;
  late List<AnimationController> _resultControllers;
  late List<Animation<double>> _resultAnimations;
  bool _isAnimating = false;
  CoinFlipCounterStatistics? _displayedStats;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration:
          const Duration(milliseconds: 1000), // Reduced from 2000ms to 1000ms
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

    // Initialize result animation controllers for counter mode
    _resultControllers = [];
    _resultAnimations = [];

    // Set ref for provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(coinFlipGeneratorProvider.notifier).setRef(ref);
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    _scaleController.dispose();
    // Dispose all result animation controllers
    for (final controller in _resultControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _flipCoin() async {
    final notifier = ref.read(coinFlipGeneratorProvider.notifier);
    final state = ref.read(coinFlipGeneratorProvider);

    // Set loading state
    setState(() {
      _isAnimating = true;
    });

    if (!state.skipAnimation) {
      _flipController.reset();
      _flipController.forward();
    }

    await notifier.generate();

    // Setup animations for individual results if in counter mode
    if (state.counterMode && !state.skipAnimation) {
      await _setupResultAnimations(notifier.result);
    } else {
      // If no animation or single mode, update stats immediately
      setState(() {
        _isAnimating = false;
        _displayedStats = notifier.counterStats;
      });
    }
  }

  void _copyToClipboard() {
    final notifier = ref.read(coinFlipGeneratorProvider.notifier);

    if (notifier.result.isEmpty) return;

    final loc = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: notifier.result));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.copied)),
    );
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return HistoryWidget(
      type: 'coin_flip',
      title: loc.generationHistory,
    );
  }

  Future<void> _setupResultAnimations(String result) async {
    // Dispose existing controllers
    for (final controller in _resultControllers) {
      controller.dispose();
    }

    final results = result.split(', ');
    _resultControllers.clear();
    _resultAnimations.clear();

    // Create animation controllers for each result
    for (int i = 0; i < results.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      );
      final animation = CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      );

      _resultControllers.add(controller);
      _resultAnimations.add(animation);

      // Start animation with delay
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          controller.forward();
        }
      });
    }

    // Calculate total animation duration and update stats when done
    final totalDuration =
        Duration(milliseconds: (results.length - 1) * 100 + 400);
    Future.delayed(totalDuration, () {
      if (mounted) {
        setState(() {
          _isAnimating = false;
          _displayedStats =
              ref.read(coinFlipGeneratorProvider.notifier).counterStats;
        });
      }
    });
  }

  Widget _buildResultDisplay(
      BuildContext context, dynamic notifier, dynamic state) {
    // Always show result display if we have a result or if we're animating/loading
    if (notifier.result.isEmpty && !_isAnimating && !state.isLoading) {
      return const SizedBox.shrink();
    }

    if (state.counterMode) {
      // Counter mode: show individual coin containers
      return _buildMultiResultDisplay(context, notifier.result);
    } else {
      // Single mode: show single coin with flip animation
      return _buildSingleResultDisplay(context, notifier.result);
    }
  }

  Widget _buildSingleResultDisplay(BuildContext context, String result) {
    // If no result yet, show a placeholder or loading state
    if (result.isEmpty) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade300,
          border: Border.all(color: Colors.grey.shade400, width: 2),
        ),
        child: const Center(
          child: Icon(
            Icons.sync,
            color: Colors.grey,
            size: 20,
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.95 + (_flipAnimation.value * 0.05), // Very subtle scale
          child: _buildCoin(context, result.contains('Heads')),
        );
      },
    );
  }

  Widget _buildMultiResultDisplay(BuildContext context, String result) {
    final results = result.split(', ');
    final state = ref.read(coinFlipGeneratorProvider);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: results.asMap().entries.map((entry) {
        final index = entry.key;
        final resultText = entry.value.trim();

        // If skip animation, show static coins immediately
        if (state.skipAnimation) {
          return _buildCoin(
            context,
            resultText.contains('Heads'),
            isSmall: true,
          );
        }

        // With animation, use AnimatedBuilder
        if (index < _resultAnimations.length) {
          return AnimatedBuilder(
            animation: _resultAnimations[index],
            builder: (context, child) {
              // Hide elements that haven't started animating yet
              if (_resultAnimations[index].value == 0.0) {
                return const SizedBox.shrink();
              }

              return Transform.scale(
                scale: 0.3 + (_resultAnimations[index].value * 0.7),
                child: _buildCoin(
                  context,
                  resultText.contains('Heads'),
                  isSmall: true,
                ),
              );
            },
          );
        } else {
          // Fallback for when animations aren't ready - hide them
          return const SizedBox.shrink();
        }
      }).toList(),
    );
  }

  Widget _buildCoin(BuildContext context, bool isHeads,
      {bool isSmall = false}) {
    const size = 48.0; // Increased by 20% from 40.0 to 48.0

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isHeads
              ? [Colors.amber.shade400, Colors.amber.shade600]
              : [Colors.grey.shade400, Colors.grey.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color:
                (isHeads ? Colors.amber : Colors.grey).withValues(alpha: 0.3),
            blurRadius: isSmall ? 6 : 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          isHeads ? 'H' : 'T',
          style: const TextStyle(
            fontSize: 20, // Increased proportionally with coin size
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(coinFlipGeneratorProvider);
    final notifier = ref.watch(coinFlipGeneratorProvider.notifier);

    // Watch history provider to trigger rebuilds when history changes
    ref.watch(historyProvider);

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
                  value: state.skipAnimation,
                  onChanged: (value) => notifier.updateSkipAnimation(value),
                  decorator: OptionSwitchDecorator.compact(context),
                ),

                // Batch count slider (only show in counter mode)
                if (state.counterMode) ...[
                  const SizedBox(height: 8),
                  OptionSlider<int>(
                    label: loc.batchCount,
                    icon: Icons.analytics_outlined,
                    currentValue: state.batchCount,
                    layout: OptionSliderLayout.none,
                    fixedWidth: 60,
                    options: List.generate(
                        20,
                        (index) => SliderOption(
                              value: index + 1,
                              label: (index + 1).toString(),
                            )),
                    onChanged: (value) => notifier.updateBatchCount(value),
                  ),
                ],

                VerticalSpacingDivider.onlyBottom(8),

                // Generate button row
                Row(
                  children: [
                    // Generate button (expanded)
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: (_isAnimating || state.isLoading)
                            ? null
                            : _flipCoin,
                        icon: (_isAnimating || state.isLoading)
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Icon(Icons.sync),
                        label: Text((_isAnimating || state.isLoading)
                            ? 'Loading...'
                            : loc.flipCoin),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Counter mode toggle button
                    OutlinedButton.icon(
                      onPressed: () =>
                          notifier.updateCounterMode(!state.counterMode),
                      icon: Icon(state.counterMode
                          ? Icons.analytics
                          : Icons.analytics_outlined),
                      label: Text(state.counterMode
                          ? loc.counterMode
                          : loc.counterMode),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: state.counterMode
                            ? Theme.of(context).colorScheme.primaryContainer
                            : null,
                        foregroundColor: state.counterMode
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Result card (Coin Flip style)
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
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
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

                // Result display with padding
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildResultDisplay(context, notifier, state),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Counter statistics card (only show in counter mode)
        if (state.counterMode) ...[
          CounterStatisticsCard(
            stats: _displayedStats ?? notifier.counterStats,
            title: loc.counterStatistics,
            headerIcon: Icons.analytics,
            headerColor: Colors.amber,
            onReset: () {
              notifier.resetCounter();
              setState(() {
                _displayedStats = notifier.counterStats;
              });
            },
            resetTooltip: 'Reset Counter',
          ),
          const SizedBox(height: 24),
        ],
      ],
    );

    return RandomGeneratorLayout(
      generatorContent: generatorContent,
      historyWidget: _buildHistoryWidget(loc),
      historyEnabled: true,
      hasHistory: true,
      isEmbedded: widget.isEmbedded,
      title: loc.flipCoin,
    );
  }
}
