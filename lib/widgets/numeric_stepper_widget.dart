import 'package:flutter/material.dart';
import 'dart:async';

class NumericStepper extends StatefulWidget {
  final double min;
  final double max;
  final double step;
  final double initialValue;
  final bool enableLongPress;
  final Duration longPressRepeatInterval;
  final VoidCallback? onWrapAroundMin;
  final VoidCallback? onWrapAroundMax;
  final ValueChanged<double>? onChanged;
  final String? label;
  final IconData? icon;

  const NumericStepper({
    super.key,
    required this.min,
    required this.max,
    this.step = 1.0,
    double? initialValue,
    this.enableLongPress = true,
    this.longPressRepeatInterval = const Duration(milliseconds: 150),
    this.onWrapAroundMin,
    this.onWrapAroundMax,
    this.onChanged,
    this.label,
    this.icon,
  }) : initialValue = initialValue ?? min;

  @override
  State<NumericStepper> createState() => _NumericStepperState();
}

class _NumericStepperState extends State<NumericStepper> {
  late double _currentValue;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue.clamp(widget.min, widget.max);
  }

  @override
  void didUpdateWidget(NumericStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _currentValue = widget.initialValue.clamp(widget.min, widget.max);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get isDecrementDisabled =>
      _currentValue <= widget.min && widget.onWrapAroundMin == null;
  bool get isIncrementDisabled =>
      widget.max != double.infinity &&
      _currentValue >= widget.max &&
      widget.onWrapAroundMax == null;

  void _increment() {
    double newValue = _currentValue + widget.step;

    if (widget.max != double.infinity && newValue > widget.max) {
      if (widget.onWrapAroundMax != null) {
        newValue = widget.min;
        widget.onWrapAroundMax!();
      } else {
        newValue = widget.max;
      }
    }

    _updateValue(newValue);
  }

  void _decrement() {
    double newValue = _currentValue - widget.step;

    if (newValue < widget.min) {
      if (widget.onWrapAroundMin != null) {
        newValue = widget.max;
        widget.onWrapAroundMin!();
      } else {
        newValue = widget.min;
      }
    }

    _updateValue(newValue);
  }

  void _updateValue(double newValue) {
    if (_currentValue != newValue) {
      setState(() {
        _currentValue = newValue;
      });
      widget.onChanged?.call(_currentValue);
    }
  }

  void _startIncrementing() {
    if (isIncrementDisabled) return;

    _increment(); // Execute immediately

    if (widget.enableLongPress) {
      _timer = Timer.periodic(widget.longPressRepeatInterval, (timer) {
        if (!isIncrementDisabled) {
          _increment();
        } else {
          _stopIncrementing();
        }
      });
    }
  }

  void _stopIncrementing() {
    _timer?.cancel();
    _timer = null;
  }

  void _startDecrementing() {
    if (isDecrementDisabled) return;

    _decrement(); // Execute immediately

    if (widget.enableLongPress) {
      _timer = Timer.periodic(widget.longPressRepeatInterval, (timer) {
        if (!isDecrementDisabled) {
          _decrement();
        } else {
          _stopDecrementing();
        }
      });
    }
  }

  void _stopDecrementing() {
    _timer?.cancel();
    _timer = null;
  }

  String _formatValue(double value) {
    // Remove trailing zeros and decimal point if not needed
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Switch to a column layout on narrow screens to prevent text wrapping issues
      bool useColumnLayout = constraints.maxWidth < 250;

      final stepperControl = Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MouseRegion(
              cursor: isDecrementDisabled
                  ? SystemMouseCursors.forbidden
                  : SystemMouseCursors.click,
              child: Listener(
                onPointerDown:
                    isDecrementDisabled ? null : (_) => _startDecrementing(),
                onPointerUp:
                    isDecrementDisabled ? null : (_) => _stopDecrementing(),
                onPointerCancel:
                    isDecrementDisabled ? null : (_) => _stopDecrementing(),
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                    ),
                    color: isDecrementDisabled
                        ? Theme.of(context).disabledColor.withValues(alpha: 0.1)
                        : null,
                  ),
                  child: Icon(
                    Icons.remove,
                    size: 18,
                    color: isDecrementDisabled
                        ? Theme.of(context).disabledColor
                        : Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            ),
            Container(
              width: 70,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  _formatValue(_currentValue),
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            MouseRegion(
              cursor: isIncrementDisabled
                  ? SystemMouseCursors.forbidden
                  : SystemMouseCursors.click,
              child: Listener(
                onPointerDown:
                    isIncrementDisabled ? null : (_) => _startIncrementing(),
                onPointerUp:
                    isIncrementDisabled ? null : (_) => _stopIncrementing(),
                onPointerCancel:
                    isIncrementDisabled ? null : (_) => _stopIncrementing(),
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                    color: isIncrementDisabled
                        ? Theme.of(context).disabledColor.withValues(alpha: 0.1)
                        : null,
                  ),
                  child: Icon(
                    Icons.add,
                    size: 18,
                    color: isIncrementDisabled
                        ? Theme.of(context).disabledColor
                        : Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      final labelContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(
                widget.icon!,
                size: 22,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
          ],
          if (widget.label != null)
            Flexible(
              child: Text(
                widget.label!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
        ],
      );

      if (useColumnLayout) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null || widget.icon != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 4.0, bottom: 12),
                child: labelContent,
              ),
            ],
            Center(child: stepperControl),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: labelContent),
            const SizedBox(width: 16),
            stepperControl,
          ],
        );
      }
    });
  }
}
