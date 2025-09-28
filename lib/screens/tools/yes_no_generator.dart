import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/common/history_widget.dart';
import 'package:random_please/widgets/common/counter_statistics_card.dart';
import 'package:random_please/providers/yes_no_generator_provider.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/widgets/animations/animations.dart';

class YesNoGeneratorScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const YesNoGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<YesNoGeneratorScreen> createState() =>
      _YesNoGeneratorScreenState();
}

class _YesNoGeneratorScreenState extends ConsumerState<YesNoGeneratorScreen>
    with TickerProviderStateMixin, RandomGeneratorAnimationMixin {
  CounterStatistics? _displayedStats;

  @override
  void initState() {
    super.initState();
    initializeAnimations();

    // Set ref for provider and initialize displayed stats
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(yesNoGeneratorProvider.notifier);
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

  Future<void> _generateAnswer() async {
    final notifier = ref.read(yesNoGeneratorProvider.notifier);
    final state = ref.read(yesNoGeneratorProvider);

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
    final notifier = ref.read(yesNoGeneratorProvider.notifier);

    if (notifier.result.isEmpty) return;

    final loc = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: notifier.result));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.copied)),
    );
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return HistoryWidget(
      type: 'yesno',
      title: loc.generationHistory,
    );
  }

  Widget _buildResultDisplay(
      BuildContext context, dynamic notifier, dynamic state) {
    // Always show result display if we have a result or if we're animating/loading
    if (notifier.result.isEmpty && !isAnimating && !state.isLoading) {
      return const SizedBox.shrink();
    }

    if (state.counterMode) {
      // Counter mode: show staggered results
      return StaggeredResultDisplay(
        results: notifier.result,
        animations: resultAnimations,
        skipAnimation: state.skipAnimation,
        configBuilder: (results) => results
            .map(
              (result) => AnimatedResultContainerConfig(
                isSmall: true,
                color: result.trim() == 'Yes' ? Colors.green : Colors.red,
                text: result.trim(),
              ),
            )
            .toList(),
      );
    } else {
      // Single mode: show bounce result
      return BounceResultDisplay(
        result: notifier.result,
        animation: bounceAnimation,
        isLoading: isAnimating || state.isLoading,
        config: AnimatedResultContainerConfig(
          color: notifier.result == 'Yes' ? Colors.green : Colors.red,
          text: notifier.result,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(yesNoGeneratorProvider);
    final notifier = ref.watch(yesNoGeneratorProvider.notifier);

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
                            : _generateAnswer,
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
                            : const Icon(Icons.help_outline),
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
                        Icons.help_outline,
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
                            loc.yesNoDesc,
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
            headerColor: Colors.blue,
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
      title: loc.yesNo,
    );
  }
}
