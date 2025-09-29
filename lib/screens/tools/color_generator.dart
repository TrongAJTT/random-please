import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/utils/color_util.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/size_utils.dart';
import 'package:random_please/utils/widget_layout_render_helper.dart';
import 'package:random_please/widgets/common/history_widget.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/providers/color_generator_state_provider.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/constants/history_types.dart';

class ColorGeneratorScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const ColorGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<ColorGeneratorScreen> createState() =>
      _ColorGeneratorScreenState();
}

class _ColorGeneratorScreenState extends ConsumerState<ColorGeneratorScreen>
    with SingleTickerProviderStateMixin {
  static const String historyType = HistoryTypes.color;
  late AnimationController _controller;
  late Animation<double> _animation;
  late AppLocalizations loc;
  Color _currentColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loc = AppLocalizations.of(context)!;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _generateColor() async {
    _controller.reset();
    _controller.forward();

    final state = ref.read(colorGeneratorStateManagerProvider);

    // Generate color using RandomGenerator
    _currentColor = RandomGenerator.generateColor(withAlpha: state.withAlpha);

    // Save state after generation
    await ref
        .read(colorGeneratorStateManagerProvider.notifier)
        .saveStateOnGenerate();

    // Save to history if enabled
    final historyEnabled = ref.read(historyEnabledProvider);
    if (historyEnabled) {
      String colorText = _getHexColor();
      await ref
          .read(historyProvider.notifier)
          .addHistoryItem(colorText, historyType);
    }

    setState(() {});
  }

  String _getHexColor() {
    final state = ref.read(colorGeneratorStateManagerProvider);
    final colorValue = _currentColor.toARGB32();
    if (state.withAlpha) {
      return '#${colorValue.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    } else {
      return '#${(colorValue & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
    }
  }

  String _getRgbColor() {
    final state = ref.read(colorGeneratorStateManagerProvider);
    String baseRpg =
        '${_currentColor.getRed255String()}, ${_currentColor.getGreen255String()}, ${_currentColor.getBlue255String()}';
    if (state.withAlpha) {
      return 'rgba($baseRpg, ${_currentColor.getAlphaStringFixed(2)})';
    } else {
      return 'rgb($baseRpg)';
    }
  }

  Widget _buildHistoryWidget() {
    return HistoryWidget(
      type: historyType,
      title: loc.generationHistory,
    );
  }

  void _copyToClipboard(String value) {
    Clipboard.setData(ClipboardData(text: value));
    SnackBarUtils.showTyped(context, loc.copied, SnackBarType.info);
  }

  @override
  Widget build(BuildContext context) {
    final generatorContent = Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Color preview - Full height for immersive color view
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 300,
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        color: _currentColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        boxShadow: [
                          BoxShadow(
                            color: _currentColor.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 4,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _isColorDark(_currentColor)
                                ? Colors.white.withValues(alpha: 0.9)
                                : Colors.black.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getHexColor(),
                            style: TextStyle(
                              color: _isColorDark(_currentColor)
                                  ? Colors.black
                                  : Colors.white,
                              fontFamily: 'monospace',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Color format options
            Text(
              loc.colorFormat,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Consumer(builder: (context, ref, child) {
                  final state = ref.watch(colorGeneratorStateManagerProvider);
                  return ChoiceChip(
                    label: Text(loc.solid),
                    selected: !state.withAlpha,
                    onSelected: (selected) {
                      if (selected) {
                        ref
                            .read(colorGeneratorStateManagerProvider.notifier)
                            .updateWithAlpha(false);
                      }
                    },
                  );
                }),
                const SizedBox(width: 12),
                Consumer(builder: (context, ref, child) {
                  final state = ref.watch(colorGeneratorStateManagerProvider);
                  return ChoiceChip(
                    label: Text(loc.includeAlpha),
                    selected: state.withAlpha,
                    onSelected: (selected) {
                      if (selected) {
                        ref
                            .read(colorGeneratorStateManagerProvider.notifier)
                            .updateWithAlpha(true);
                      }
                    },
                  );
                }),
              ],
            ),

            const SizedBox(height: 32),

            // Generate button
            FilledButton.icon(
              onPressed: _generateColor,
              icon: const Icon(Icons.refresh),
              label: Text(loc.generate),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Color info
            Text(
              loc.randomResult,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            WidgetLayoutRenderHelper.twoEqualWidthInRow(
              _buildColorInfoCard(
                'HEX',
                _getHexColor(),
                onTap: () => _copyToClipboard(_getHexColor()),
              ),
              _buildColorInfoCard(
                'RGB',
                _getRgbColor(),
                onTap: () => _copyToClipboard(_getRgbColor()),
              ),
              minWidth: 300,
              spacing: TwoDimSpacing.specific(vertical: 8, horizontal: 16),
            ),
          ],
        ),
      ),
    );

    return RandomGeneratorLayout(
      generatorContent: generatorContent,
      historyWidget: _buildHistoryWidget(),
      historyEnabled: ref.watch(historyEnabledProvider),
      hasHistory: ref.watch(historyEnabledProvider),
      isEmbedded: widget.isEmbedded,
      title: loc.colorGenerator,
    );
  }

  Widget _buildColorInfoCard(String title, String value,
      {VoidCallback? onTap}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                loc.copyToClipboard,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isColorDark(Color color) {
    // Calculate luminance of the color
    double luminance =
        (0.299 * color.r + 0.587 * color.g + 0.114 * color.b) / 255;
    return luminance < 0.5;
  }
}
