import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/view_models/yes_no_generator_view_model.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/history_view_dialog.dart';
import 'package:random_please/widgets/generic/option_switch.dart';

class YesNoGeneratorScreen extends StatefulWidget {
  final bool isEmbedded;

  const YesNoGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  State<YesNoGeneratorScreen> createState() => _YesNoGeneratorScreenState();
}

class _YesNoGeneratorScreenState extends State<YesNoGeneratorScreen>
    with SingleTickerProviderStateMixin {
  late YesNoGeneratorViewModel _viewModel;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _viewModel = YesNoGeneratorViewModel();
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

  Future<void> _initData() async {
    await _viewModel.initHive();
    await _viewModel.loadHistory();
    setState(() {});
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _generateAnswer() async {
    if (!_viewModel.state.skipAnimation) {
      _bounceController.reset();
      _bounceController.forward();
    }

    await _viewModel.generateAnswer();
    setState(() {});
  }

  void _copyToClipboard() {
    if (_viewModel.result == null) return;

    final loc = AppLocalizations.of(context)!;
    final text = _viewModel.result! ? loc.yes : loc.no;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.copied)),
    );
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return RandomGeneratorHistoryWidget(
      historyType: 'yes_no',
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

                // Generate button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _generateAnswer,
                    icon: const Icon(Icons.help_outline),
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

                  // Answer display
                  Center(
                    child: ScaleTransition(
                      scale: _viewModel.state.skipAnimation
                          ? const AlwaysStoppedAnimation(1.0)
                          : _bounceAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _viewModel.result!
                                ? [Colors.green.shade400, Colors.green.shade600]
                                : [Colors.red.shade400, Colors.red.shade600],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: (_viewModel.result!
                                      ? Colors.green
                                      : Colors.red)
                                  .withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          _viewModel.result! ? loc.yes : loc.no,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                          textAlign: TextAlign.center,
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
      historyEnabled: _viewModel.historyEnabled,
      hasHistory: _viewModel.historyEnabled,
      isEmbedded: widget.isEmbedded,
      title: loc.yesNo,
    );
  }
}
