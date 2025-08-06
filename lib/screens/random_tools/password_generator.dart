import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/random_services/random_state_service.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/utils/widget_layout_render_helper.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  final bool isEmbedded;

  const PasswordGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  State<PasswordGeneratorScreen> createState() =>
      _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  int _passwordLength = 12;
  bool _includeLowercase = true;
  bool _includeUppercase = true;
  bool _includeNumbers = true;
  bool _includeSpecial = true;
  String _generatedPassword = '';
  bool _copied = false;
  List<GenerationHistoryItem> _history = [];
  bool _historyEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadState();
    _loadHistory();
  }

  Future<void> _loadState() async {
    try {
      final state = await RandomStateService.getPasswordGeneratorState();
      if (mounted) {
        setState(() {
          _passwordLength = state.passwordLength;
          _includeLowercase = state.includeLowercase;
          _includeUppercase = state.includeUppercase;
          _includeNumbers = state.includeNumbers;
          _includeSpecial = state.includeSpecial;
        });
      }
    } catch (e) {
      // Error is already logged in service
    }
  }

  Future<void> _saveState() async {
    try {
      final state = PasswordGeneratorState(
        passwordLength: _passwordLength,
        includeLowercase: _includeLowercase,
        includeUppercase: _includeUppercase,
        includeNumbers: _includeNumbers,
        includeSpecial: _includeSpecial,
        lastUpdated: DateTime.now(),
      );
      await RandomStateService.savePasswordGeneratorState(state);
    } catch (e) {
      // Error is already logged in service
    }
  }

  Future<void> _loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history = await GenerationHistoryService.getHistory('password');
    setState(() {
      _historyEnabled = enabled;
      _history = history;
    });
  }

  void _generatePassword() async {
    setState(() {
      try {
        _generatedPassword = RandomGenerator.generatePassword(
          length: _passwordLength,
          includeLowercase: _includeLowercase,
          includeUppercase: _includeUppercase,
          includeNumbers: _includeNumbers,
          includeSpecial: _includeSpecial,
        );
        _copied = false;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    });

    // Save state when generating
    await _saveState();

    // Save to history if enabled
    if (_historyEnabled && _generatedPassword.isNotEmpty) {
      await GenerationHistoryService.addHistoryItem(
        _generatedPassword,
        'password',
      );
      await _loadHistory(); // Refresh history
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _generatedPassword));
    setState(() {
      _copied = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.copied)),
    );
  }

  void _copyHistoryItem(String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.copied)),
    );
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return RandomGeneratorHistoryWidget(
      historyType: 'password',
      history: _history,
      title: loc.generationHistory,
      onClearHistory: () async {
        await GenerationHistoryService.clearHistory('password');
        await _loadHistory();
      },
      onCopyItem: _copyHistoryItem,
    );
  }

  Widget _buildSwitchOptions(BuildContext context, AppLocalizations loc) {
    final switchOptions = [
      {
        'title': loc.includeLowercase,
        'value': _includeLowercase,
        'onChanged': (bool value) {
          setState(() {
            _includeLowercase = value;
          });
          // Don't save state immediately, only save when generating
        },
      },
      {
        'title': loc.includeUppercase,
        'value': _includeUppercase,
        'onChanged': (bool value) {
          setState(() {
            _includeUppercase = value;
          });
          // Don't save state immediately, only save when generating
        },
      },
      {
        'title': loc.includeNumbers,
        'value': _includeNumbers,
        'onChanged': (bool value) {
          setState(() {
            _includeNumbers = value;
          });
          // Don't save state immediately, only save when generating
        },
      },
      {
        'title': loc.includeSpecial,
        'value': _includeSpecial,
        'onChanged': (bool value) {
          setState(() {
            _includeSpecial = value;
          });
          // Don't save state immediately, only save when generating
        },
      },
    ];

    return GridBuilderHelper.responsive(
      builder: (context, index) {
        final option = switchOptions[index];
        return OptionSwitch(
          title: option['title'] as String,
          value: option['value'] as bool,
          onChanged: option['onChanged'] as void Function(bool),
          decorator: OptionSwitchDecorator.compact(context),
        );
      },
      itemCount: switchOptions.length,
      minItemWidth: 400,
      maxColumns: 2,
      decorator: const GridBuilderDecorator(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 16,
        maxChildHeight: 60, // Control the height of each switch row
      ),
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
                // Password length slider
                OptionSlider<int>(
                  label: loc.numCharacters,
                  currentValue: _passwordLength,
                  options: List.generate(
                    29, // 4 to 32 characters
                    (i) => SliderOption(
                      value: i + 4,
                      label: '${i + 4}',
                    ),
                  ),
                  onChanged: (int value) {
                    setState(() {
                      _passwordLength = value;
                    });
                    // Don't save state immediately, only save when generating
                  },
                  layout: OptionSliderLayout.none,
                ),
                VerticalSpacingDivider.specific(top: 0, bottom: 6),
                // Switch options
                _buildSwitchOptions(context, loc),
                VerticalSpacingDivider.specific(top: 6, bottom: 12),
                // Generate button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    onPressed: _generatePassword,
                    icon: const Icon(Icons.refresh),
                    label: Text(loc.generate),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Result card
        if (_generatedPassword.isNotEmpty) ...[
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        loc.generatedPassword,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: Icon(_copied ? Icons.check : Icons.copy),
                        onPressed: _copyToClipboard,
                        tooltip: loc.copyToClipboard,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SelectableText(
                    _generatedPassword,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 20,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
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
      historyEnabled: _historyEnabled,
      hasHistory: _historyEnabled,
      isEmbedded: widget.isEmbedded,
      title: loc.passwordGenerator,
    );
  }
}
