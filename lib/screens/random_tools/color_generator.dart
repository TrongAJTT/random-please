import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/utils/color_util.dart';
import 'package:random_please/view_models/color_generator_view_model.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/size_utils.dart';
import 'package:random_please/utils/widget_layout_render_helper.dart';
import 'package:random_please/widgets/history_widget.dart';

class ColorGeneratorScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const ColorGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<ColorGeneratorScreen> createState() =>
      _ColorGeneratorScreenState();
}

class _ColorGeneratorScreenState extends ConsumerState<ColorGeneratorScreen>
    with SingleTickerProviderStateMixin {
  late ColorGeneratorViewModel _viewModel;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _viewModel = ColorGeneratorViewModel(ref: ref);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
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
    _controller.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _generateColor() {
    _controller.reset();
    _controller.forward();

    _viewModel.generateColor();
    setState(() {});
  }

  String _getHexColor() {
    final color = _viewModel.currentColor;
    if (_viewModel.state.withAlpha) {
      return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    } else {
      return '#${(color.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
    }
  }

  String _getRgbColor() {
    final color = _viewModel.currentColor;
    String baseRpg =
        '${color.getRed255String()}, ${color.getGreen255String()}, ${color.getBlue255String()}';
    if (_viewModel.state.withAlpha) {
      return 'rgba($baseRpg, ${color.getAlphaStringFixed(2)})';
    } else {
      return 'rpg($baseRpg)';
    }
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return HistoryWidget(
      type: ColorGeneratorViewModel.historyType,
      title: loc.generationHistory,
    );
  }

  void _copyToClipboard(String value) {
    _viewModel.copyColor(value);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final generatorContent = Column(
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
                    color: _viewModel.currentColor,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                        color: _viewModel.currentColor.withValues(alpha: 0.4),
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
                        color: _isColorDark(_viewModel.currentColor)
                            ? Colors.white.withValues(alpha: 0.9)
                            : Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getHexColor(),
                        style: TextStyle(
                          color: _isColorDark(_viewModel.currentColor)
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
            ChoiceChip(
              label: Text(AppLocalizations.of(context)!.solid),
              selected: !_viewModel.state.withAlpha,
              onSelected: (selected) {
                if (selected) {
                  _viewModel.updateWithAlpha(false);
                  setState(() {});
                }
              },
            ),
            const SizedBox(width: 12),
            ChoiceChip(
              label: Text(AppLocalizations.of(context)!.includeAlpha),
              selected: _viewModel.state.withAlpha,
              onSelected: (selected) {
                if (selected) {
                  _viewModel.updateWithAlpha(true);
                  setState(() {});
                }
              },
            ),
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
    );

    return RandomGeneratorLayout(
      generatorContent: generatorContent,
      historyWidget: _buildHistoryWidget(loc),
      historyEnabled: _viewModel.historyEnabled,
      hasHistory: _viewModel.historyEnabled,
      isEmbedded: widget.isEmbedded,
      title: loc.colorGenerator,
    );
  }

  Widget _buildColorInfoCard(String title, String value,
      {VoidCallback? onTap}) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.copyToClipboard,
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
