import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Generic data model for a radial menu item.
class RadialMenuItem<T> {
  final T value;
  final String label;
  final IconData icon;
  final Color? color;

  const RadialMenuItem({
    required this.value,
    required this.label,
    required this.icon,
    this.color,
  });
}

/// A generic, theme-aware radial menu widget that manages its own overlay and gestures.
class RadialMenu<T> extends StatefulWidget {
  final List<RadialMenuItem<T>> items;
  final VoidCallback? onCancel;
  final Function(T? value)? onItemSelected;
  final double radius;
  final Offset initialPosition;

  const RadialMenu({
    super.key,
    required this.items,
    this.onCancel,
    this.onItemSelected,
    this.radius = 130.0,
    required this.initialPosition,
  });

  @override
  RadialMenuState<T> createState() => RadialMenuState<T>();
}

class RadialMenuState<T> extends State<RadialMenu<T>>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _pulseAnimation;

  final GlobalKey _menuKey = GlobalKey();
  Offset? _panStartPoint;

  RadialMenuItem<T>? _hoveredItem;
  bool _isDragging = false;
  bool _dragFromCenter = false;

  void _resetDragState() {
    if (mounted) {
      setState(() {
        _isDragging = false;
        _dragFromCenter = false;
        _panStartPoint = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Offset? _globalToLocal(Offset global) {
    if (_menuKey.currentContext == null) return null;
    final renderBox = _menuKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.globalToLocal(global);
  }

  RadialMenuItem<T>? _getItemAtPosition(Offset position,
      {bool checkOuterBounds = true}) {
    if (widget.items.isEmpty) return null;
    final center = Offset(widget.radius, widget.radius);
    final distance = (position - center).distance;

    // If in center area (within 50px), no item is selected
    if (distance < 50) {
      return null;
    }

    // If outside the menu area, no item is selected (for taps)
    if (checkOuterBounds && distance > widget.radius - 10) {
      return null;
    }

    // Calculate which sector the position is in
    final angle = math.atan2(position.dy - center.dy, position.dx - center.dx);
    final normalizedAngle = (angle + math.pi * 2) % (math.pi * 2);
    final sectorAngle = (math.pi * 2) / widget.items.length;
    final adjustedAngle = (normalizedAngle + math.pi / 2) % (math.pi * 2);
    final sectorIndex = (adjustedAngle / sectorAngle).floor();

    if (sectorIndex >= 0 && sectorIndex < widget.items.length) {
      return widget.items[sectorIndex];
    }
    return null;
  }

  void _handleGlobalPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
      _dragFromCenter = true;
      _panStartPoint = details.globalPosition;
      _hoveredItem = null;
    });
  }

  void _handleGlobalPanUpdate(DragUpdateDetails details) {
    if (!_isDragging || _panStartPoint == null) return;

    final panDelta = details.globalPosition - _panStartPoint!;
    final menuCenter = Offset(widget.radius, widget.radius);
    final virtualPosition = menuCenter + panDelta;

    setState(() {
      _hoveredItem =
          _getItemAtPosition(virtualPosition, checkOuterBounds: false);
    });
  }

  void _handleGlobalPanEnd(DragEndDetails details) {
    if (!_isDragging) return;

    if (_hoveredItem != null) {
      widget.onItemSelected?.call(_hoveredItem!.value);
    } else {
      widget.onCancel?.call();
    }
    _resetDragState();
  }

  void _handleGlobalTapUp(TapUpDetails details) {
    if (_isDragging) return;

    final localPosition = _globalToLocal(details.globalPosition);
    if (localPosition == null) {
      widget.onCancel?.call();
      return;
    }

    final center = Offset(widget.radius, widget.radius);
    final distance = (localPosition - center).distance;

    if (distance > widget.radius) {
      widget.onCancel?.call();
      return;
    }

    final selectedItem = _getItemAtPosition(localPosition);

    if (selectedItem != null) {
      setState(() {
        _hoveredItem = selectedItem;
      });
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) widget.onItemSelected?.call(selectedItem.value);
      });
    } else {
      widget.onCancel?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const screenPadding = 16.0;

    double left = widget.initialPosition.dx - widget.radius;
    double top = widget.initialPosition.dy - widget.radius;

    left = left.clamp(
        screenPadding, screenSize.width - (widget.radius * 2) - screenPadding);
    top = top.clamp(
        screenPadding, screenSize.height - (widget.radius * 2) - screenPadding);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: _handleGlobalPanStart,
      onPanUpdate: _handleGlobalPanUpdate,
      onPanEnd: _handleGlobalPanEnd,
      onTapUp: _handleGlobalTapUp,
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        child: Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              child: AnimatedBuilder(
                animation:
                    Listenable.merge([_animationController, _pulseController]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Container(
                        key: _menuKey,
                        width: widget.radius * 2,
                        height: widget.radius * 2,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: CustomPaint(
                          painter: _RadialMenuPainter<T>(
                            items: widget.items,
                            hoveredItem: _hoveredItem,
                            radius: widget.radius,
                            pulseScale: _pulseAnimation.value,
                            isDragging: _isDragging,
                            dragFromCenter: _dragFromCenter,
                            theme: Theme.of(context),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadialMenuPainter<T> extends CustomPainter {
  final List<RadialMenuItem<T>> items;
  final RadialMenuItem<T>? hoveredItem;
  final double radius;
  final double pulseScale;
  final bool isDragging;
  final bool dragFromCenter;
  final ThemeData theme;

  _RadialMenuPainter({
    required this.items,
    this.hoveredItem,
    required this.radius,
    required this.pulseScale,
    required this.isDragging,
    required this.dragFromCenter,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(radius, radius);
    final paint = Paint();
    final colorScheme = theme.colorScheme;
    const centerRadius = 45.0;

    // 1. Draw background elements
    final shadowPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius - 10));
    canvas.drawShadow(shadowPath, Colors.black, 15, false);
    paint.color = colorScheme.surface;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 10, paint);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.5;
    paint.color = colorScheme.outline.withValues(alpha: 0.5);
    canvas.drawCircle(center, radius - 10, paint);

    // 2. Draw sectors, highlights, and items
    if (items.isNotEmpty) {
      final sectorAngle = (math.pi * 2) / items.length;

      // Draw highlights first, so they are behind dividers
      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        final startAngle = i * sectorAngle - math.pi / 2;
        if (item == hoveredItem) {
          _drawSectorHighlight(canvas, center, startAngle, sectorAngle,
              item.color ?? colorScheme.primary);
        }
      }

      // Draw item icons and text
      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        final startAngle = i * sectorAngle - math.pi / 2;
        final isHovered = item == hoveredItem;
        final iconAngle = startAngle + sectorAngle / 2;
        final iconRadius = radius * 0.65;
        final iconPosition = Offset(
          center.dx + math.cos(iconAngle) * iconRadius,
          center.dy + math.sin(iconAngle) * iconRadius,
        );
        _drawItemIcon(canvas, iconPosition, item, isHovered, colorScheme);
        _drawItemText(canvas, iconPosition, item, isHovered, colorScheme);
      }

      // Draw dividers on top of highlights
      _drawSectorDividers(
          canvas, center, sectorAngle, colorScheme, centerRadius);
    }

    // 3. Draw the central hub on top of everything
    paint.style = PaintingStyle.fill;
    paint.color = isDragging && dragFromCenter
        ? colorScheme.primary.withValues(alpha: 0.3)
        : colorScheme.surfaceContainerHighest;
    final dynamicCenterRadius =
        isDragging ? (centerRadius * pulseScale) : centerRadius;
    canvas.drawCircle(center, dynamicCenterRadius, paint);

    // 4. Draw content inside the central hub
    if (hoveredItem != null) {
      // When an item is selected, show only its text
      _drawSelectionText(canvas, center, hoveredItem!, colorScheme);
    } else {
      // When no item is selected, show icon and instruction/drag text
      _drawCenterIcon(canvas, center, colorScheme);
      if (isDragging) {
        _drawCenterDragText(canvas, center, colorScheme);
      } else {
        _drawInstructionText(canvas, center, colorScheme);
      }
    }
  }

  void _drawCenterIcon(Canvas canvas, Offset center, ColorScheme colorScheme) {
    _drawIcon(
      canvas,
      center,
      isDragging ? Icons.open_with : Icons.touch_app,
      isDragging ? 22 : 18,
      isDragging ? colorScheme.primary : colorScheme.onSurfaceVariant,
    );
  }

  void _drawSectorHighlight(Canvas canvas, Offset center, double startAngle,
      double sectorAngle, Color color) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withValues(alpha: 0.25);
    final path = Path();
    path.moveTo(center.dx, center.dy);
    path.arcTo(
      Rect.fromCircle(center: center, radius: radius - 10),
      startAngle,
      sectorAngle,
      false,
    );
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawItemIcon(Canvas canvas, Offset position, RadialMenuItem<T> item,
      bool isHovered, ColorScheme colorScheme) {
    _drawIcon(
      canvas,
      position,
      item.icon,
      isHovered ? 32.0 : 26.0,
      item.color ?? (isHovered ? colorScheme.primary : colorScheme.onSurface),
    );
  }

  void _drawItemText(Canvas canvas, Offset iconPosition, RadialMenuItem<T> item,
      bool isHovered, ColorScheme colorScheme) {
    final textPosition = Offset(iconPosition.dx, iconPosition.dy + 24.0);
    _drawText(
      canvas,
      textPosition,
      item.label,
      isHovered ? 13.0 : 11.0,
      item.color ??
          (isHovered ? colorScheme.primary : colorScheme.onSurfaceVariant),
      isHovered ? FontWeight.bold : FontWeight.w500,
    );
  }

  void _drawInstructionText(
      Canvas canvas, Offset center, ColorScheme colorScheme) {
    _drawText(
      canvas,
      center + const Offset(0, 12),
      'Pan or tap',
      10.0,
      colorScheme.onSurfaceVariant,
      FontWeight.normal,
    );
  }

  void _drawSelectionText(Canvas canvas, Offset center, RadialMenuItem<T> item,
      ColorScheme colorScheme) {
    _drawText(
      canvas,
      center + const Offset(0, 12),
      item.label,
      11.0,
      item.color ?? colorScheme.primary,
      FontWeight.bold,
    );
  }

  void _drawCenterDragText(
      Canvas canvas, Offset center, ColorScheme colorScheme) {
    final text = dragFromCenter ? 'Drag to category' : 'Drag to select';
    _drawText(
      canvas,
      center + const Offset(0, 12),
      text,
      10.0,
      colorScheme.primary,
      FontWeight.w500,
    );
  }

  void _drawSectorDividers(Canvas canvas, Offset center, double sectorAngle,
      ColorScheme colorScheme, double centerRadius) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = colorScheme.outline.withValues(alpha: 0.5);
    for (int i = 0; i < items.length; i++) {
      final angle = i * sectorAngle - math.pi / 2;
      final p1 = center + Offset.fromDirection(angle, centerRadius);
      final p2 = center + Offset.fromDirection(angle, radius - 10.0);
      canvas.drawLine(p1, p2, paint);
    }
  }

  void _drawText(Canvas canvas, Offset position, String text, double fontSize,
      Color color, FontWeight fontWeight) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style:
            TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(canvas,
        position - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  void _drawIcon(
      Canvas canvas, Offset position, IconData icon, double size, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: size, fontFamily: icon.fontFamily, color: color),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas,
        position - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(_RadialMenuPainter<T> oldDelegate) {
    return oldDelegate.hoveredItem != hoveredItem ||
        oldDelegate.pulseScale != pulseScale ||
        oldDelegate.isDragging != isDragging ||
        oldDelegate.dragFromCenter != dragFromCenter ||
        oldDelegate.theme != theme;
  }
}
