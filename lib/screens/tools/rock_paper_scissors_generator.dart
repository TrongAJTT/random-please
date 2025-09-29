import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/common/history_widget.dart';
import 'package:random_please/widgets/common/counter_statistics_card.dart';
import 'package:random_please/providers/rock_paper_scissors_generator_provider.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/widgets/animations/animations.dart';
import 'package:random_please/constants/history_types.dart';

class RockPaperScissorsGeneratorScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const RockPaperScissorsGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<RockPaperScissorsGeneratorScreen> createState() =>
      _RockPaperScissorsGeneratorScreenState();
}

class _RockPaperScissorsGeneratorScreenState
    extends ConsumerState<RockPaperScissorsGeneratorScreen>
    with TickerProviderStateMixin, RandomGeneratorAnimationMixin {
  RockPaperScissorsCounterStatistics? _displayedStats;

  @override
  void initState() {
    super.initState();
    initializeAnimations();

    // Set ref for provider and initialize displayed stats
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(rockPaperScissorsGeneratorProvider.notifier);
      notifier.setRef(ref);
      // Initialize displayed stats to current counter stats
      setState(() {
        _displayedStats = notifier.counterStats;
      });
    });
  }

  @override
  void dispose() {
    disposeAnimations();
    super.dispose();
  }

  Future<void> _generateChoice() async {
    final notifier = ref.read(rockPaperScissorsGeneratorProvider.notifier);
    final state = ref.read(rockPaperScissorsGeneratorProvider);

    await handleGenerationWithAnimation(
      skipAnimation: state.skipAnimation,
      counterMode: state.counterMode,
      result: notifier.result,
      onGenerate: () async => await notifier.generate(),
      onAnimationComplete: () {
        setState(() {
          _displayedStats = notifier.counterStats;
        });
      },
      getCurrentResult: () => notifier.result,
    );
  }

  void _copyToClipboard() {
    final notifier = ref.read(rockPaperScissorsGeneratorProvider.notifier);

    if (notifier.result.isEmpty) return;

    final loc = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: notifier.result));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.copied)),
    );
  }

  IconData _getResultIcon(String result) {
    switch (result) {
      case 'Rock':
        return Icons.sports_mma; // Rock
      case 'Paper':
        return Icons.article; // Paper
      case 'Scissors':
        return Icons.content_cut; // Scissors
      default:
        return Icons.help_outline;
    }
  }

  String _getResultText(String result, AppLocalizations loc) {
    switch (result) {
      case 'Rock':
        return loc.rock;
      case 'Paper':
        return loc.paper;
      case 'Scissors':
        return loc.scissors;
      default:
        return '?';
    }
  }

  Color _getResultColor(String result) {
    switch (result) {
      case 'Rock':
        return Colors.brown.shade700; // Rock
      case 'Paper':
        return Colors.blue.shade700; // Paper
      case 'Scissors':
        return Colors.red.shade700; // Scissors
      default:
        return Colors.grey.shade400;
    }
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return HistoryWidget(
      type: HistoryTypes.rockPaperScissors,
      title: loc.generationHistory,
    );
  }

  Widget _buildResultDisplay(
      BuildContext context, dynamic notifier, dynamic state) {
    // Don't show anything if no result and not animating
    if (notifier.result.isEmpty && !isAnimating) {
      return const SizedBox.shrink();
    }

    if (state.counterMode) {
      // Counter mode: show staggered results
      return StaggeredResultDisplay(
        results: notifier.result,
        animations: resultAnimations,
        skipAnimation: state.skipAnimation,
        configBuilder: (results) => results.map((result) {
          final trimmedResult = result.trim();
          return AnimatedResultContainerConfig(
            isSmall: true,
            color: _getResultColor(trimmedResult),
            text: _getResultText(trimmedResult, AppLocalizations.of(context)!),
            icon: Icon(
              _getResultIcon(trimmedResult),
              size: 24,
              color: Colors.white,
            ),
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(18),
          );
        }).toList(),
      );
    } else {
      // Single mode: show bounce result
      return BounceResultDisplay(
        result: notifier.result,
        animation: bounceAnimation,
        isLoading: isAnimating || state.isLoading,
        config: AnimatedResultContainerConfig(
          color: _getResultColor(notifier.result),
          text: _getResultText(notifier.result, AppLocalizations.of(context)!),
          icon: Icon(
            _getResultIcon(notifier.result),
            size: 48,
            color: Colors.white,
          ),
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(36),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(rockPaperScissorsGeneratorProvider);
    final notifier = ref.watch(rockPaperScissorsGeneratorProvider.notifier);

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
                        onPressed: (isAnimating || state.isLoading)
                            ? null
                            : _generateChoice,
                        icon: (isAnimating || state.isLoading)
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Icon(Icons.sports_mma),
                        label: Text((isAnimating || state.isLoading)
                            ? 'Loading...'
                            : loc.generate),
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
                      onPressed: () {
                        notifier.updateCounterMode(!state.counterMode);
                        // Update displayed stats immediately when toggling
                        setState(() {
                          _displayedStats = notifier.counterStats;
                        });
                      },
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

        // Result card
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
                        Icons.sports_mma,
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
                            loc.rockPaperScissorsDesc,
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

                // Result display
                _buildResultDisplay(context, notifier, state),
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
            headerColor: Colors.orange,
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
      title: loc.rockPaperScissors,
    );
  }
}
