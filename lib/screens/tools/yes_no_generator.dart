import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/common/history_widget.dart';
import 'package:random_please/providers/yes_no_generator_provider.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';

class YesNoGeneratorScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const YesNoGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<YesNoGeneratorScreen> createState() =>
      _YesNoGeneratorScreenState();
}

class _YesNoGeneratorScreenState extends ConsumerState<YesNoGeneratorScreen>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late List<AnimationController> _resultControllers;
  late List<Animation<double>> _resultAnimations;
  bool _isAnimating = false;
  CounterStatistics? _displayedStats;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceAnimation = CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    );

    // Initialize result animation controllers
    _resultControllers = [];
    _resultAnimations = [];

    // Set ref for provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(yesNoGeneratorProvider.notifier).setRef(ref);
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    // Dispose all result animation controllers
    for (final controller in _resultControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _generateAnswer() async {
    final notifier = ref.read(yesNoGeneratorProvider.notifier);
    final state = ref.read(yesNoGeneratorProvider);

    // Set loading state
    setState(() {
      _isAnimating = true;
    });

    if (!state.skipAnimation) {
      _bounceController.reset();
      _bounceController.forward();
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

  Widget _buildCounterStats(AppLocalizations loc, CounterStatistics stats) {
    return Column(
      children: [
        // Start time
        _buildStatRow(
          icon: Icons.access_time,
          label: loc.startTime,
          value: _formatTime(stats.startTime),
        ),
        const SizedBox(height: 12),

        // Total generations
        _buildStatRow(
          icon: Icons.repeat,
          label: loc.totalGenerations,
          value: stats.totalGenerations.toString(),
        ),
        const SizedBox(height: 12),

        // Yes count
        _buildStatRow(
          icon: Icons.check_circle,
          label: loc.yesCount,
          value:
              '${stats.yesCount} (${stats.yesPercentage.toStringAsFixed(1)}%)',
          valueColor: Colors.green,
        ),
        const SizedBox(height: 12),

        // No count
        _buildStatRow(
          icon: Icons.cancel,
          label: loc.noCount,
          value: '${stats.noCount} (${stats.noPercentage.toStringAsFixed(1)}%)',
          valueColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
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
              ref.read(yesNoGeneratorProvider.notifier).counterStats;
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
      // Counter mode: show individual containers
      return _buildMultiResultDisplay(context, notifier.result);
    } else {
      // Single mode: show single container with bounce animation
      return _buildSingleResultDisplay(context, notifier.result);
    }
  }

  Widget _buildSingleResultDisplay(BuildContext context, String result) {
    // If no result yet, show a placeholder or loading state
    if (result.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade300, Colors.grey.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Loading...',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      );
    }

    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (_bounceAnimation.value * 0.2),
          child: _buildResultContainer(context, result, Colors.green),
        );
      },
    );
  }

  Widget _buildMultiResultDisplay(BuildContext context, String result) {
    final results = result.split(', ');
    final state = ref.read(yesNoGeneratorProvider);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: results.asMap().entries.map((entry) {
        final index = entry.key;
        final resultText = entry.value.trim();

        // If skip animation, show static containers immediately
        if (state.skipAnimation) {
          return _buildResultContainer(
            context,
            resultText,
            resultText == 'Yes' ? Colors.green : Colors.red,
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
                child: _buildResultContainer(
                  context,
                  resultText,
                  resultText == 'Yes' ? Colors.green : Colors.red,
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

  Widget _buildResultContainer(BuildContext context, String text, Color color,
      {bool isSmall = false}) {
    // Determine gradient colors based on color type
    List<Color> gradientColors;
    if (color == Colors.green) {
      gradientColors = [Colors.green.shade400, Colors.green.shade600];
    } else if (color == Colors.red) {
      gradientColors = [Colors.red.shade400, Colors.red.shade600];
    } else {
      gradientColors = [color, color];
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 16 : 32,
        vertical: isSmall ? 12 : 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isSmall ? 12 : 16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: isSmall ? 8 : 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: isSmall ? 16 : null,
            ),
        textAlign: TextAlign.center,
      ),
    );
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
                        onPressed: (_isAnimating || state.isLoading)
                            ? null
                            : _generateAnswer,
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
                            : const Icon(Icons.refresh),
                        label: Text((_isAnimating || state.isLoading)
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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.analytics,
                          color: Colors.green.shade700,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          loc.counterStatistics,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () {
                            notifier.resetCounter();
                            setState(() {
                              _displayedStats = notifier.counterStats;
                            });
                          },
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.red,
                          ),
                          tooltip: 'Reset Counter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCounterStats(
                      loc, _displayedStats ?? notifier.counterStats),
                ],
              ),
            ),
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
      title: loc.yesNoGenerator,
    );
  }
}
