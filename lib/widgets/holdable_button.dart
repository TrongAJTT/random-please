// Press-and-hold IconButton for increment/decrement
import 'package:flutter/material.dart';

class HoldableButton extends StatefulWidget {
  final Widget child;
  final String tooltip;
  final bool enabled;
  final VoidCallback onTap;
  const HoldableButton({
    required this.child,
    required this.tooltip,
    required this.enabled,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<HoldableButton> createState() => _HoldableButtonState();
}

class _HoldableButtonState extends State<HoldableButton> {
  bool _holding = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: Listener(
        onPointerDown: widget.enabled
            ? (_) {
                widget.onTap();
                _holding = true;
                _holdLoop();
              }
            : null,
        onPointerUp: (_) => _holding = false,
        onPointerCancel: (_) => _holding = false,
        child: widget.child,
      ),
    );
  }

  void _holdLoop() async {
    await Future.delayed(const Duration(milliseconds: 200));
    while (_holding && widget.enabled) {
      widget.onTap();
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }
}
