import 'package:flutter/material.dart';

/// A button that requires holding for a specified duration to trigger an action
class HoldButton extends StatefulWidget {
  /// The text to display on the button
  final String text;

  /// The icon to display on the button (optional)
  final IconData? icon;

  /// The duration required to hold the button
  final Duration holdDuration;

  /// Callback when the hold action is completed
  final VoidCallback onHoldComplete;

  /// Button style (similar to ElevatedButton.styleFrom)
  final ButtonStyle? style;

  /// Text style for the button text
  final TextStyle? textStyle;

  /// Background color for the button
  final Color? backgroundColor;

  /// Foreground color for text and icon
  final Color? foregroundColor;

  /// Progress color (defaults to foreground color with opacity)
  final Color? progressColor;

  /// Border radius for the button
  final BorderRadius? borderRadius;

  /// Padding inside the button
  final EdgeInsetsGeometry? padding;

  /// Minimum size of the button
  final Size? minimumSize;

  /// Text alignment
  final ContentAlign? contentAlign;

  const HoldButton({
    super.key,
    required this.text,
    required this.onHoldComplete,
    this.icon,
    this.holdDuration = const Duration(seconds: 3),
    this.style,
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.progressColor,
    this.borderRadius,
    this.padding,
    this.minimumSize,
    this.contentAlign,
  });

  @override
  State<HoldButton> createState() => _HoldButtonState();
}

class _HoldButtonState extends State<HoldButton> with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  bool _isHolding = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: widget.holdDuration,
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isCompleted) {
        _isCompleted = true;
        widget.onHoldComplete();
        _resetButton();
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _startHold() {
    if (!_isCompleted) {
      setState(() {
        _isHolding = true;
      });
      _progressController.forward();
    }
  }

  void _stopHold() {
    if (!_isCompleted) {
      setState(() {
        _isHolding = false;
      });
      _progressController.reset();
    }
  }

  void _resetButton() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _isCompleted = false;
          _isHolding = false;
        });
        _progressController.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine effective colors
    final effectiveBackgroundColor = widget.backgroundColor ??
        widget.style?.backgroundColor?.resolve({}) ??
        theme.colorScheme.primary;

    final effectiveForegroundColor = widget.foregroundColor ??
        widget.style?.foregroundColor?.resolve({}) ??
        theme.colorScheme.onPrimary;

    final effectiveProgressColor =
        widget.progressColor ?? effectiveForegroundColor.withValues(alpha: 0.3);

    final effectiveBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(8.0);

    final effectivePadding = widget.padding ??
        const EdgeInsets.symmetric(horizontal: 24, vertical: 12);

    final effectiveMinimumSize = widget.minimumSize ?? const Size(120, 48);

    return GestureDetector(
      onTapDown: (_) => _startHold(),
      onTapUp: (_) => _stopHold(),
      onTapCancel: _stopHold,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            final progress = _progressAnimation.value;

            return Container(
              constraints: BoxConstraints(
                minWidth: effectiveMinimumSize.width,
                minHeight: effectiveMinimumSize.height,
              ),
              decoration: BoxDecoration(
                borderRadius: effectiveBorderRadius,
                color: effectiveBackgroundColor,
              ),
              child: Stack(
                children: [
                  // Progress background (fills from left to right)
                  if (_isHolding && !_isCompleted)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: effectiveBorderRadius,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: progress,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: effectiveBorderRadius,
                                color: effectiveProgressColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Button content
                  Padding(
                    padding: effectivePadding,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: switch (widget.contentAlign) {
                        ContentAlign.center => MainAxisAlignment.center,
                        ContentAlign.start => MainAxisAlignment.start,
                        ContentAlign.end => MainAxisAlignment.end,
                        null => MainAxisAlignment.center,
                      },
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: effectiveForegroundColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.text,
                          style: widget.textStyle?.copyWith(
                                color: effectiveForegroundColor,
                              ) ??
                              TextStyle(
                                color: effectiveForegroundColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

enum ContentAlign {
  center,
  start,
  end,
}
