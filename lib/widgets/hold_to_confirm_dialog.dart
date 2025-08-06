import 'package:flutter/material.dart';
import 'package:random_please/l10n/app_localizations.dart';

// Hold-to-confirm dialog widget - reusable for any confirmation action
class HoldToConfirmDialog extends StatefulWidget {
  final String title;
  final String content;
  final String actionText;
  final String holdText;
  final String processingText;
  final String? instructionText;
  final VoidCallback onConfirmed;
  final Duration holdDuration;
  final IconData actionIcon;
  final AppLocalizations l10n;

  const HoldToConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actionText,
    required this.holdText,
    required this.processingText,
    required this.onConfirmed,
    required this.holdDuration,
    required this.actionIcon,
    required this.l10n,
    this.instructionText,
  });

  @override
  State<HoldToConfirmDialog> createState() => _HoldToConfirmDialogState();
}

class _HoldToConfirmDialogState extends State<HoldToConfirmDialog>
    with TickerProviderStateMixin {
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
        widget.onConfirmed();
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

  @override
  Widget build(BuildContext context) {
    final holdSeconds = widget.holdDuration.inSeconds;
    final defaultInstruction =
        'Hold the button for $holdSeconds seconds to confirm';

    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.content),
          const SizedBox(height: 16),
          Text(
            widget.instructionText ?? defaultInstruction,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.l10n.cancel),
        ),
        const SizedBox(width: 8),
        // Hold-to-confirm button
        SizedBox(
          height: 48,
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              final progress = _progressAnimation.value;
              final backgroundColor =
                  _isCompleted ? Colors.red : Colors.transparent;
              final progressColor =
                  Colors.red.withValues(alpha: 0.2 + (progress * 0.6));

              return GestureDetector(
                onTapDown: (_) => _startHold(),
                onTapUp: (_) => _stopHold(),
                onTapCancel: _stopHold,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.red,
                      width: 2,
                    ),
                    color: backgroundColor,
                  ),
                  child: Stack(
                    children: [
                      // Progress background
                      if (!_isCompleted)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                progressColor,
                              ),
                            ),
                          ),
                        ),
                      // Button content
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                widget.actionIcon,
                                color: _isCompleted ? Colors.white : Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isCompleted
                                    ? widget.processingText
                                    : _isHolding
                                        ? widget.holdText
                                        : widget.actionText,
                                style: TextStyle(
                                  color:
                                      _isCompleted ? Colors.white : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
