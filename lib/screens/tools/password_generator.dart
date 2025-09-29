import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/providers/password_generator_state_provider.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/option_switch.dart';
import 'package:random_please/widgets/common/history_widget.dart';
import 'package:random_please/utils/auto_scroll_helper.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/constants/history_types.dart';
import 'package:random_please/models/random_generator.dart';

class PasswordGeneratorScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const PasswordGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<PasswordGeneratorScreen> createState() =>
      _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState
    extends ConsumerState<PasswordGeneratorScreen> {
  bool _copied = false;
  final ScrollController _scrollController = ScrollController();
  String _currentResult = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _generatePassword() async {
    try {
      final currentState = ref.read(passwordGeneratorStateManagerProvider);
      final password = _generatePasswordFromState(currentState);

      setState(() {
        _currentResult = password;
      });

      // Save state on generate
      await ref
          .read(passwordGeneratorStateManagerProvider.notifier)
          .saveStateOnGenerate();

      // Save to history if enabled
      if (password.isNotEmpty) {
        final historyEnabled = ref.read(historyEnabledProvider);
        if (historyEnabled) {
          await ref
              .read(historyProvider.notifier)
              .addHistoryItem(password, HistoryTypes.password);
        }
      }

      // Auto-scroll to results after generation
      AutoScrollHelper.scrollToResults(
        ref: ref,
        scrollController: _scrollController,
        mounted: mounted,
        hasResults: password.isNotEmpty,
      );
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showTyped(context, e.toString(), SnackBarType.error);
      }
    }
  }

  String _generatePasswordFromState(PasswordGeneratorState state) {
    // Use cryptographically secure RandomGenerator for password generation
    return RandomGenerator.generatePassword(
      length: state.passwordLength,
      includeLowercase: state.includeLowercase,
      includeUppercase: state.includeUppercase,
      includeNumbers: state.includeNumbers,
      includeSpecial: state.includeSpecial,
    );
  }

  void _copyToClipboard() {
    if (_currentResult.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _currentResult));
      setState(() {
        _copied = true;
      });
      if (mounted) {
        SnackBarUtils.showTyped(
            context, AppLocalizations.of(context)!.copied, SnackBarType.info);
      }
    }
  }

  String _maskPassword(String password) {
    if (password.length == 4) {
      return '${password[0]}**${password[3]}';
    } else if (password.length == 5) {
      return '${password[0]}${'*' * (password.length - 3)}${password[password.length - 1]}';
    } else if (password.length <= 8) {
      return '${password[0]}${'*' * (password.length - 3)}${password.substring(password.length - 2)}';
    } else {
      return '${password.substring(0, 2)}${'*' * (password.length - 4)}${password.substring(password.length - 2)}';
    }
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return HistoryWidget(
      type: HistoryTypes.password,
      title: loc.generationHistory,
      maskFunction: _maskPassword,
    );
  }

  String _getPasswordSubtitle() {
    if (_currentResult.isEmpty) return '';
    return '${_currentResult.length} ${AppLocalizations.of(context)!.characters.toLowerCase()}';
  }

  Map<String, dynamic> _evaluatePasswordStrength(String password) {
    if (password.isEmpty) {
      return {'level': 0, 'label': 'strengthWeak', 'color': Colors.red};
    }

    int score = 0;
    final length = password.length;

    // Length scoring (NIST recommends ≥15 characters)
    if (length >= 15) {
      score += 3;
    } else if (length >= 12) {
      score += 2;
    } else if (length >= 8) {
      score += 1;
    }

    // Character variety scoring
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasNumbers = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    int varietyCount = [hasLowercase, hasUppercase, hasNumbers, hasSpecial]
        .where((b) => b)
        .length;
    score += varietyCount;

    // Entropy bonus for random patterns
    if (length >= 12 && varietyCount >= 3) score += 1;
    if (length >= 15 && varietyCount >= 4) score += 1;

    // Determine strength level
    if (score >= 8) {
      return {'level': 5, 'label': 'strengthVeryStrong', 'color': Colors.green};
    } else if (score >= 6) {
      return {
        'level': 4,
        'label': 'strengthStrong',
        'color': Colors.lightGreen
      };
    } else if (score >= 4) {
      return {'level': 3, 'label': 'strengthGood', 'color': Colors.orange};
    } else if (score >= 2) {
      return {'level': 2, 'label': 'strengthFair', 'color': Colors.deepOrange};
    } else {
      return {'level': 1, 'label': 'strengthWeak', 'color': Colors.red};
    }
  }

  Widget _buildPasswordStrengthSection(AppLocalizations loc) {
    final strength = _evaluatePasswordStrength(_currentResult);
    final level = strength['level'] as int;
    final label = strength['label'] as String;
    final color = strength['color'] as Color;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                loc.passwordStrength,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Strength level indicator
              Expanded(
                child: Row(
                  children: List.generate(5, (index) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: index < 4 ? 4 : 0),
                        height: 4,
                        decoration: BoxDecoration(
                          color: index < level
                              ? color
                              : Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _getStrengthLabel(loc, label),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStrengthLabel(AppLocalizations loc, String label) {
    switch (label) {
      case 'strengthWeak':
        return loc.strengthWeak;
      case 'strengthFair':
        return loc.strengthFair;
      case 'strengthGood':
        return loc.strengthGood;
      case 'strengthStrong':
        return loc.strengthStrong;
      case 'strengthVeryStrong':
        return loc.strengthVeryStrong;
      default:
        return loc.strengthWeak;
    }
  }

  Widget _buildSwitchOptions(BuildContext context, AppLocalizations loc) {
    final switchOptions = [
      {
        'title': loc.includeLowercase,
        'subtitle': loc.includeLowercaseDesc,
        'value':
            ref.watch(passwordGeneratorStateManagerProvider).includeLowercase,
        'onChanged': (bool value) {
          ref
              .read(passwordGeneratorStateManagerProvider.notifier)
              .updateIncludeLowercase(value);
        },
      },
      {
        'title': loc.includeUppercase,
        'subtitle': loc.includeUppercaseDesc,
        'value':
            ref.watch(passwordGeneratorStateManagerProvider).includeUppercase,
        'onChanged': (bool value) {
          ref
              .read(passwordGeneratorStateManagerProvider.notifier)
              .updateIncludeUppercase(value);
        },
      },
      {
        'title': loc.includeNumbers,
        'subtitle': loc.includeNumbersDesc,
        'value':
            ref.watch(passwordGeneratorStateManagerProvider).includeNumbers,
        'onChanged': (bool value) {
          ref
              .read(passwordGeneratorStateManagerProvider.notifier)
              .updateIncludeNumbers(value);
        },
      },
      {
        'title': loc.includeSpecial,
        'subtitle': loc.includeSpecialDesc,
        'value':
            ref.watch(passwordGeneratorStateManagerProvider).includeSpecial,
        'onChanged': (bool value) {
          ref
              .read(passwordGeneratorStateManagerProvider.notifier)
              .updateIncludeSpecial(value);
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
                  currentValue: ref
                      .watch(passwordGeneratorStateManagerProvider)
                      .passwordLength,
                  options: List.generate(
                    29, // 4 to 32 characters
                    (i) => SliderOption(
                      value: i + 4,
                      label: '${i + 4}',
                    ),
                  ),
                  onChanged: (int value) {
                    ref
                        .read(passwordGeneratorStateManagerProvider.notifier)
                        .updatePasswordLength(value);
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
        if (_currentResult.isNotEmpty) ...[
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header with better design
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.lock,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.generatedPassword,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              _getPasswordSubtitle(),
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
                      IconButton(
                        onPressed: _copyToClipboard,
                        icon: Icon(_copied ? Icons.check : Icons.copy),
                        tooltip: loc.copyToClipboard,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: SelectableText(
                      _currentResult,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontFamily: 'monospace',
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w500,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Password strength section
                  _buildPasswordStrengthSection(loc),
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
      title: loc.passwordGenerator,
      scrollController: _scrollController,
    );
  }
}
