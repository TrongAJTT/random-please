import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/view_models/rock_paper_scissors_generator_view_model.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/widgets/common/history_widget.dart';
import 'package:random_please/providers/rock_paper_scissors_generator_state_provider.dart';
import 'package:random_please/providers/history_provider.dart';

class RockPaperScissorsGeneratorScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const RockPaperScissorsGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<RockPaperScissorsGeneratorScreen> createState() =>
      _RockPaperScissorsGeneratorScreenState();
}

class _RockPaperScissorsGeneratorScreenState
    extends ConsumerState<RockPaperScissorsGeneratorScreen>
    with SingleTickerProviderStateMixin {
  late RockPaperScissorsGeneratorViewModel _viewModel;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _viewModel = RockPaperScissorsGeneratorViewModel();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceAnimation = CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    );
    _initData();
  }

  void _initData() {
    _viewModel.setRef(ref);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _generateChoice() async {
    if (!_viewModel.state.skipAnimation) {
      _bounceController.reset();
      _bounceController.forward();
    }

    await _viewModel.generateChoice();
    setState(() {});
  }

  void _copyToClipboard() {
    if (_viewModel.result == null) return;

    final loc = AppLocalizations.of(context)!;
    String text;
    switch (_viewModel.result!) {
      case 0:
        text = loc.rock;
        break;
      case 1:
        text = loc.paper;
        break;
      case 2:
        text = loc.scissors;
        break;
      default:
        text = '';
    }

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.copied)),
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

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return HistoryWidget(
      type: RockPaperScissorsGeneratorViewModel.historyType,
      title: loc.generationHistory,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // Watch state changes to trigger rebuilds
    ref.watch(rockPaperScissorsGeneratorStateManagerProvider);

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

                // Generate button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _generateChoice,
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

                  // Choice display
                  Center(
                    child: ScaleTransition(
                      scale: _viewModel.state.skipAnimation
                          ? const AlwaysStoppedAnimation(1.0)
                          : _bounceAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getResultColor(_viewModel.result!),
                          boxShadow: [
                            BoxShadow(
                              color: _getResultColor(_viewModel.result!)
                                  .withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getResultIcon(_viewModel.result!),
                              size: 48,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getResultText(_viewModel.result!, loc),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
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
      historyEnabled: ref.watch(historyEnabledProvider),
      hasHistory: ref.watch(historyEnabledProvider),
      isEmbedded: widget.isEmbedded,
      title: loc.rockPaperScissors,
    );
  }
}
