import 'package:flutter/material.dart';
import 'dart:async';

/// A customizable quantity selector widget with increment/decrement buttons
class QuantitySelector extends StatefulWidget {
  final int value;
  final int minValue;
  final int maxValue;
  final int smallStep;
  final int largeStep;
  final ValueChanged<int> onChanged;
  final String? label;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final Color? buttonColor;
  final Color? disabledButtonColor;
  final double buttonSize;
  final EdgeInsets padding;
  final bool showBorder;
  final bool highlightValue;

  const QuantitySelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.minValue = 1,
    this.maxValue = 100,
    this.smallStep = 1,
    this.largeStep = 10,
    this.label,
    this.labelStyle,
    this.valueStyle,
    this.buttonColor,
    this.disabledButtonColor,
    this.buttonSize = 40.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.showBorder = true,
    this.highlightValue = false,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  Timer? _longPressTimer;

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }

  void _updateValue(int newValue) {
    final clampedValue = newValue.clamp(widget.minValue, widget.maxValue);
    if (clampedValue != widget.value) {
      widget.onChanged(clampedValue);
    }
  }

  void _startLongPress(VoidCallback action) {
    _longPressTimer?.cancel();
    _longPressTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      action();
    });
  }

  void _stopLongPress() {
    _longPressTimer?.cancel();
    _longPressTimer = null;
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isEnabled,
  }) {
    return SizedBox(
      width: widget.buttonSize,
      height: widget.buttonSize,
      child: GestureDetector(
        onTap: isEnabled ? onPressed : null,
        onLongPressStart: isEnabled && onPressed != null
            ? (_) {
                onPressed(); // Execute immediately on long press start
                _startLongPress(onPressed); // Start repeating
              }
            : null,
        onLongPressEnd: (_) => _stopLongPress(),
        onLongPressCancel: _stopLongPress,
        child: Container(
          decoration: BoxDecoration(
            color: isEnabled
                ? (widget.buttonColor ??
                    Theme.of(context).colorScheme.primaryContainer)
                : (widget.disabledButtonColor ?? Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isEnabled
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canDecreaseLarge =
        widget.value > widget.minValue + widget.largeStep - 1;
    final canDecreaseSmall = widget.value > widget.minValue;
    final canIncreaseSmall = widget.value < widget.maxValue;
    final canIncreaseLarge =
        widget.value < widget.maxValue - widget.largeStep + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: widget.labelStyle ?? Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
        ],
        Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            border: widget.showBorder
                ? Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.5),
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Large decrease (<<)
              _buildButton(
                context,
                icon: Icons.keyboard_double_arrow_left,
                onPressed: canDecreaseLarge
                    ? () => _updateValue(widget.value - widget.largeStep)
                    : null,
                isEnabled: canDecreaseLarge,
              ),

              const SizedBox(width: 8),

              // Small decrease (<)
              _buildButton(
                context,
                icon: Icons.keyboard_arrow_left,
                onPressed: canDecreaseSmall
                    ? () => _updateValue(widget.value - widget.smallStep)
                    : null,
                isEnabled: canDecreaseSmall,
              ),

              const SizedBox(width: 16),

              // Value display
              Container(
                constraints: const BoxConstraints(minWidth: 60),
                padding: widget.highlightValue
                    ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                    : null,
                decoration: widget.highlightValue
                    ? BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      )
                    : null,
                child: Text(
                  widget.value.toString(),
                  textAlign: TextAlign.center,
                  style: widget.highlightValue
                      ? Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          )
                      : (widget.valueStyle ??
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              )),
                ),
              ),

              const SizedBox(width: 16),

              // Small increase (>)
              _buildButton(
                context,
                icon: Icons.keyboard_arrow_right,
                onPressed: canIncreaseSmall
                    ? () => _updateValue(widget.value + widget.smallStep)
                    : null,
                isEnabled: canIncreaseSmall,
              ),

              const SizedBox(width: 8),

              // Large increase (>>)
              _buildButton(
                context,
                icon: Icons.keyboard_double_arrow_right,
                onPressed: canIncreaseLarge
                    ? () => _updateValue(widget.value + widget.largeStep)
                    : null,
                isEnabled: canIncreaseLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
