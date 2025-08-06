import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/random_services/random_state_service.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/widget_layout_render_helper.dart';
import 'package:random_please/widgets/generic/option_grid_picker.dart' as grid;
import 'package:random_please/widgets/generic/option_item.dart';

class ColorGeneratorScreen extends StatefulWidget {
  final bool isEmbedded;

  const ColorGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  State<ColorGeneratorScreen> createState() => _ColorGeneratorScreenState();
}

class _ColorGeneratorScreenState extends State<ColorGeneratorScreen>
    with SingleTickerProviderStateMixin {
  Color _currentColor = Colors.blue;
  bool _withAlpha = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  List<GenerationHistoryItem> _history = [];
  bool _historyEnabled = false;

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
    _loadState();
    _loadHistory();
  }

  Future<void> _loadState() async {
    try {
      final state = await RandomStateService.getColorGeneratorState();
      if (mounted) {
        setState(() {
          _withAlpha = state.withAlpha;
        });
      }
    } catch (e) {
      // Error is already logged in service
    }
  }

  Future<void> _saveState() async {
    try {
      final state = ColorGeneratorState(
        withAlpha: _withAlpha,
        lastUpdated: DateTime.now(),
      );
      await RandomStateService.saveColorGeneratorState(state);
    } catch (e) {
      // Error is already logged in service
    }
  }

  Future<void> _loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history = await GenerationHistoryService.getHistory('color');
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

  void _generateColor() {
    _controller.reset();
    _controller.forward();

    setState(() {
      _currentColor = RandomGenerator.generateColor(withAlpha: _withAlpha);
    });

    // Save state when generating
    _saveState();

    // Save to history if enabled
    if (_historyEnabled) {
      String colorText = _getHexColor();
      GenerationHistoryService.addHistoryItem(
        colorText,
        'color',
      ).then((_) => _loadHistory());
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
      historyType: 'color',
      history: _history,
      title: loc.generationHistory,
      onClearHistory: () async {
        await GenerationHistoryService.clearHistory('color');
        await _loadHistory();
      },
      onCopyItem: _copyHistoryItem,
      customItemBuilder: (item, context) {
        final color = _parseColorFromHex(item.value);
        return ListTile(
          dense: true,
          leading: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          title: Text(
            item.value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            'Generated at: ${item.timestamp.toString().substring(0, 19)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.copy, size: 18),
            onPressed: () => _copyHistoryItem(item.value),
            tooltip: 'Copy to Clipboard',
          ),
        );
      },
    );
  }

  Color _parseColorFromHex(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (e) {
      // If parsing fails, return a default color
    }
    return Colors.grey;
  }

  String _getHexColor() {
    if (_withAlpha) {
      return '#${_currentColor.toARGB32().toRadixString(16).padLeft(8, '0')}';
    } else {
      return '#${_currentColor.toARGB32().toRadixString(16).substring(2).padLeft(6, '0')}';
    }
  }

  String _getRgbColor() {
    if (_withAlpha) {
      return 'rgba(${(_currentColor.r).toStringAsFixed(2)}, ${(_currentColor.g).toStringAsFixed(2)}, ${(_currentColor.b).toStringAsFixed(2)}, ${(_currentColor.a / 255).toStringAsFixed(2)})';
    } else {
      return 'rgb(${(_currentColor.r).toStringAsFixed(2)}, ${(_currentColor.g).toStringAsFixed(2)}, ${(_currentColor.b).toStringAsFixed(2)})';
    }
  }

  void _copyToClipboard(String value) {
    Clipboard.setData(ClipboardData(text: value));
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.copied)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final generatorContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Color preview - Full height for immersive color view
        AspectRatio(
          aspectRatio: 16 / 9,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  color: _currentColor,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
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

        const SizedBox(height: 24),

        // Format selection
        // Text(
        //   loc.colorFormat,
        //   style: Theme.of(context).textTheme.titleMedium,
        // ),
        // const SizedBox(height: 8),
        LayoutBuilder(builder: (context, constraints) {
          return grid.OptionGridPicker<bool>(
            title: loc.colorFormat,
            options: const [
              OptionItem(
                value: false,
                label: 'Solid',
              ),
              OptionItem(
                value: true,
                label: 'Include Alpha',
              ),
            ],
            aspectRatio: constraints.maxWidth < 600 ? 4 : 5,
            selectedValue: _withAlpha,
            onSelectionChanged: (value) {
              setState(() {
                _withAlpha = value;
              });
              // Don't save state immediately, only save when generating
            },
            crossAxisCount: constraints.maxWidth < 300 ? 1 : 2,
            decorator: const grid.OptionGridDecorator(
                labelAlign: grid.LabelAlign.center),
          );
        }),

        const SizedBox(height: 16),

        // Color info
        Text(
          loc.generatedColor,
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
            horizontalSpacing: 16,
            verticalSpacing: 8),

        const SizedBox(height: 16),

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
      ],
    );

    return RandomGeneratorLayout(
      generatorContent: generatorContent,
      historyWidget: _buildHistoryWidget(loc),
      historyEnabled: _historyEnabled,
      hasHistory: _historyEnabled,
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
