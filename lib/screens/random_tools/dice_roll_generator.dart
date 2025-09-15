import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/view_models/dice_roll_generator_view_model.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/utils/history_view_dialog.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'dart:math' as math;
import 'package:random_please/widgets/generic/option_slider.dart';

class DiceRollGeneratorScreen extends StatefulWidget {
  final bool isEmbedded;

  const DiceRollGeneratorScreen({super.key, this.isEmbedded = false});

  @override
  State<DiceRollGeneratorScreen> createState() =>
      _DiceRollGeneratorScreenState();
}

class _DiceRollGeneratorScreenState extends State<DiceRollGeneratorScreen>
    with TickerProviderStateMixin {
  late DiceRollGeneratorViewModel _viewModel;
  late AnimationController _rollController;
  late Animation<double> _rollAnimation;
  late AppLocalizations loc;

  final List<int> _availableSides = [
    3,
    4,
    5,
    6,
    7,
    8,
    10,
    12,
    14,
    16,
    20,
    24,
    30,
    48,
    50,
    100
  ];

  @override
  void initState() {
    super.initState();
    _viewModel = DiceRollGeneratorViewModel();
    _rollController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _rollAnimation = CurvedAnimation(
      parent: _rollController,
      curve: Curves.easeOutBack,
    );
    _viewModel.addListener(_onViewModelChanged);
    _initData();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _initData() async {
    await _viewModel.initHive();
    await _viewModel.loadHistory();
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loc = AppLocalizations.of(context)!;
  }

  @override
  void dispose() {
    _rollController.dispose();
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _rollDice() {
    _rollController.reset();
    _rollController.forward();

    _viewModel.rollDice();
    setState(() {});
  }

  void _copyHistoryItem(String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.copied)),
    );
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return RandomGeneratorHistoryWidget(
      historyType: DiceRollGeneratorViewModel.historyType,
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
      onCopyItem: _copyHistoryItem,
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

  int _getTotal() {
    return _viewModel.results.fold(0, (sum, value) => sum + value);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final generatorContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dice count selector
                OptionSlider<int>(
                  label: loc.diceCount,
                  currentValue: _viewModel.state.diceCount,
                  options: List.generate(
                    20,
                    (i) => SliderOption(value: i + 1, label: '${i + 1}'),
                  ),
                  onChanged: (value) {
                    _viewModel.updateDiceCount(value);
                    setState(() {});
                  },
                  fixedWidth: 60,
                  layout: OptionSliderLayout.none,
                ),
                // Dice sides selector
                Text(
                  loc.diceSides,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                // Wrap with dice side options
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableSides.map((sides) {
                    return ChoiceChip(
                      label: Text('d$sides'),
                      selected: _viewModel.state.diceSides == sides,
                      onSelected: (selected) {
                        if (selected) {
                          _viewModel.updateDiceSides(sides);
                          setState(() {});
                        }
                      },
                    );
                  }).toList(),
                ),
                VerticalSpacingDivider.specific(top: 6, bottom: 12),
                // Roll button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _rollDice,
                    icon: const Icon(Icons.casino),
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
        if (_viewModel.results.isNotEmpty) ...[
          const SizedBox(height: 24),
          Card(
            child: AnimatedBuilder(
              animation: _rollAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_rollAnimation.value * 0.1),
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Result heading
                    Text(
                      loc.randomResult,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),

                    // Dice display
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: _viewModel.results.map((result) {
                        return _buildDie(result);
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Total
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        loc.totalANumber(_getTotal()),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
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
      title: loc.rollDice,
    );
  }

  Widget _buildDie(int value) {
    // For d6, show actual dice face
    if (_viewModel.state.diceSides == 6) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: _buildDiceFace(value),
      );
    }
    // For other dice, show number with polygon shape
    else {
      return Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Shape
            _buildDieShape(),

            // Number
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildDiceFace(int value) {
    // Map classic die dots pattern for d6
    switch (value) {
      case 1:
        return const Center(child: _DiceDot());
      case 2:
        return const Stack(
          children: [
            Positioned(top: 10, left: 10, child: _DiceDot()),
            Positioned(bottom: 10, right: 10, child: _DiceDot()),
          ],
        );
      case 3:
        return const Stack(
          children: [
            Positioned(top: 10, left: 10, child: _DiceDot()),
            Center(child: _DiceDot()),
            Positioned(bottom: 10, right: 10, child: _DiceDot()),
          ],
        );
      case 4:
        return const Stack(
          children: [
            Positioned(top: 10, left: 10, child: _DiceDot()),
            Positioned(top: 10, right: 10, child: _DiceDot()),
            Positioned(bottom: 10, left: 10, child: _DiceDot()),
            Positioned(bottom: 10, right: 10, child: _DiceDot()),
          ],
        );
      case 5:
        return const Stack(
          children: [
            Positioned(top: 10, left: 10, child: _DiceDot()),
            Positioned(top: 10, right: 10, child: _DiceDot()),
            Center(child: _DiceDot()),
            Positioned(bottom: 10, left: 10, child: _DiceDot()),
            Positioned(bottom: 10, right: 10, child: _DiceDot()),
          ],
        );
      case 6:
        return const Stack(
          children: [
            Positioned(top: 10, left: 10, child: _DiceDot()),
            Positioned(top: 10, right: 10, child: _DiceDot()),
            Positioned(top: 25, left: 10, child: _DiceDot()),
            Positioned(top: 25, right: 10, child: _DiceDot()),
            Positioned(bottom: 10, left: 10, child: _DiceDot()),
            Positioned(bottom: 10, right: 10, child: _DiceDot()),
          ],
        );
      default:
        return Center(
          child: Text(
            '$value',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }

  Widget _buildDieShape() {
    // Different polygons for different die types
    switch (_viewModel.state.diceSides) {
      case 3: // d3 - triangle
        return _buildPolygon(3, Colors.green);
      case 4: // d4 - tetrahedron (triangle)
        return _buildPolygon(3, Colors.blue);
      case 8: // d8 - octahedron
        return _buildPolygon(8, Colors.orange);
      case 10: // d10 - decagon
      case 100: // d100 (percentile)
        return _buildPolygon(10, Colors.purple);
      case 12: // d12 - dodecahedron
        return _buildPolygon(5, Colors.teal);
      case 20: // d20 - icosahedron
        return _buildPolygon(3, Colors.red);
      case 24: // d24
        return _buildPolygon(8, Colors.indigo);
      case 30: // d30
        return _buildPolygon(5, Colors.brown);
      default: // All others
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            shape: BoxShape.circle,
          ),
        );
    }
  }

  Widget _buildPolygon(int sides, Color color) {
    return SizedBox(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: PolygonPainter(sides: sides, color: color),
      ),
    );
  }
}

class _DiceDot extends StatelessWidget {
  const _DiceDot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}

class PolygonPainter extends CustomPainter {
  final int sides;
  final Color color;

  PolygonPainter({required this.sides, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final angle = 2 * math.pi / sides;

    // Move to the first point
    path.moveTo(
      center.dx + radius * math.cos(0),
      center.dy + radius * math.sin(0),
    );

    // Draw lines to each corner
    for (int i = 1; i <= sides; i++) {
      path.lineTo(
        center.dx + radius * math.cos(angle * i),
        center.dy + radius * math.sin(angle * i),
      );
    }

    // Close the path
    path.close();

    // Draw the polygon
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
