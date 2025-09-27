import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/view_models/password_generator_view_model.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/widgets/history_widget.dart';

class PasswordGeneratorScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const PasswordGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<PasswordGeneratorScreen> createState() =>
      _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState
    extends ConsumerState<PasswordGeneratorScreen> {
  late PasswordGeneratorViewModel _viewModel;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _viewModel = PasswordGeneratorViewModel(ref: ref);
    _initializeViewModel();
  }

  Future<void> _initializeViewModel() async {
    await _viewModel.initHive();
    await _viewModel.loadHistory();

    // Listen to state changes
    _viewModel.addListener(_onViewModelChanged);

    // Update UI after initialization
    if (mounted) {
      setState(() {});
    }
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {
        _copied = false;
      });
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _generatePassword() async {
    try {
      await _viewModel.generatePassword();
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showTyped(context, e.toString(), SnackBarType.error);
      }
    }
  }

  void _copyToClipboard() {
    if (_viewModel.result.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _viewModel.result));
      setState(() {
        _copied = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.copied)),
        );
      }
    }
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return HistoryWidget(
      type: PasswordGeneratorViewModel.historyType,
      title: loc.generationHistory,
    );
  }

  Widget _buildSwitchOptions(BuildContext context, AppLocalizations loc) {
    final switchOptions = [
      {
        'title': loc.includeLowercase,
        'subtitle': loc.includeLowercaseDesc,
        'value': _viewModel.state.includeLowercase,
        'onChanged': (bool value) {
          _viewModel.updateIncludeLowercase(value);
        },
      },
      {
        'title': loc.includeUppercase,
        'subtitle': loc.includeUppercaseDesc,
        'value': _viewModel.state.includeUppercase,
        'onChanged': (bool value) {
          _viewModel.updateIncludeUppercase(value);
        },
      },
      {
        'title': loc.includeNumbers,
        'subtitle': loc.includeNumbersDesc,
        'value': _viewModel.state.includeNumbers,
        'onChanged': (bool value) {
          _viewModel.updateIncludeNumbers(value);
        },
      },
      {
        'title': loc.includeSpecial,
        'subtitle': loc.includeSpecialDesc,
        'value': _viewModel.state.includeSpecial,
        'onChanged': (bool value) {
          _viewModel.updateIncludeSpecial(value);
        },
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate how many items can fit in one row
        final availableWidth = constraints.maxWidth;
        const itemWidth = 220.0; // Minimum width for each switch
        const spacing = 16.0;
        final crossAxisCount =
            ((availableWidth + spacing) / (itemWidth + spacing))
                .floor()
                .clamp(1, 2);

        return Wrap(
          spacing: 16,
          runSpacing: 8,
          children: switchOptions.map((option) {
            return SizedBox(
              width: (availableWidth - (crossAxisCount - 1) * spacing) /
                  crossAxisCount,
              child: OptionSwitch(
                title: option['title'] as String,
                subtitle: option['subtitle'] as String?,
                value: option['value'] as bool,
                onChanged: option['onChanged'] as void Function(bool),
                decorator: OptionSwitchDecorator.compact(context),
              ),
            );
          }).toList(),
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
                // Password length slider
                OptionSlider<int>(
                  label: loc.numCharacters,
                  currentValue: _viewModel.state.passwordLength,
                  options: List.generate(
                    29, // 4 to 32 characters
                    (i) => SliderOption(
                      value: i + 4,
                      label: '${i + 4}',
                    ),
                  ),
                  onChanged: (int value) {
                    _viewModel.updatePasswordLength(value);
                  },
                  fixedWidth: 60,
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
        if (_viewModel.result.isNotEmpty) ...[
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
                    _viewModel.result,
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
      historyEnabled: _viewModel.historyEnabled,
      hasHistory: _viewModel.historyEnabled,
      isEmbedded: widget.isEmbedded,
      title: loc.passwordGenerator,
    );
  }
}
