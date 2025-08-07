import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/random_services/random_state_service.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/widgets/generic/option_switch.dart';

class YesNoGeneratorScreen extends StatefulWidget {
  final bool isEmbedded;

  const YesNoGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  State<YesNoGeneratorScreen> createState() => _YesNoGeneratorScreenState();
}

class _YesNoGeneratorScreenState extends State<YesNoGeneratorScreen>
    with SingleTickerProviderStateMixin {
  String _result = '';
  bool _skipAnimation = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  List<GenerationHistoryItem> _history = [];
  bool _historyEnabled = false;

  static const String _historyType = 'yes_no';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
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
    ]).animate(_controller);
    _loadState();
    _loadHistory();
  }

  Future<void> _loadState() async {
    try {
      final state = await RandomStateService.getYesNoGeneratorState();
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
      await RandomStateService.saveYesNoGeneratorState(state);
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
    _controller.dispose();
    super.dispose();
  }

  void _generateResult() async {
    setState(() {
      _result = RandomGenerator.generateYesNo() ? 'YES' : 'NO';
    });

    if (!_skipAnimation) {
      _controller.reset();
      _controller.forward();
    }

    // Save state when generating
    await _saveState();

    // Save to history if enabled
    if (_historyEnabled && _result.isNotEmpty) {
      await GenerationHistoryService.addHistoryItem(
        _result,
        _historyType,
      );
      await _loadHistory(); // Refresh history
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final generatorContent = Column(
      mainAxisSize: MainAxisSize.min,
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
        Flexible(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_result.isNotEmpty)
                  AnimatedBuilder(
                    animation: _skipAnimation
                        ? const AlwaysStoppedAnimation(1.0)
                        : _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _skipAnimation ? 1.0 : _scaleAnimation.value,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _result == 'YES'
                                ? Colors.green.withValues(alpha: 0.8)
                                : Colors.red.withValues(alpha: 0.8),
                          ),
                          child: Center(
                            child: Text(
                              _result,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                else
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                    child: Center(
                      child: Text(
                        '?',
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 48),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: _generateResult,
                    icon: const Icon(Icons.help_outline),
                    label: Text(loc.randomResult),
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
      ],
    );

    return RandomGeneratorLayout(
      generatorContent: generatorContent,
      historyWidget: _buildHistoryWidget(loc),
      historyEnabled: _historyEnabled,
      hasHistory: _historyEnabled,
      isEmbedded: widget.isEmbedded,
      title: loc.yesNo,
    );
  }
}
