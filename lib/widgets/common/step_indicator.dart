import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> stepLabels;
  final bool showCheckIcon;
  final double stepSize;
  final double lineHeight;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool useContainer;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.stepLabels,
    this.showCheckIcon = true,
    this.stepSize = 32,
    this.lineHeight = 2,
    this.activeColor,
    this.inactiveColor,
    this.useContainer = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = activeColor ?? theme.colorScheme.primary;
    final inactive = inactiveColor ?? theme.colorScheme.surfaceContainerHighest;

    Widget stepIndicator = Row(
      children: [
        for (int index = 0; index < stepLabels.length; index++) ...[
          // Step circle
          Container(
            width: stepSize,
            height: stepSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index <= currentStep ? primary : inactive,
              border: Border.all(
                color: index <= currentStep
                    ? primary
                    : theme.colorScheme.outline.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Center(
              child: showCheckIcon && index < currentStep
                  ? Icon(
                      Icons.check,
                      size: stepSize * 0.6,
                      color: theme.colorScheme.onPrimary,
                    )
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: index <= currentStep
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                        fontSize: stepSize * 0.4,
                      ),
                    ),
            ),
          ),

          // Line between steps
          if (index < stepLabels.length - 1)
            Expanded(
              child: Container(
                height: lineHeight,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: index < currentStep ? primary : inactive,
              ),
            ),
        ],
      ],
    );

    // Add step labels below
    Widget labelRow = Row(
      children: List.generate(stepLabels.length, (index) {
        return Expanded(
          child: Text(
            stepLabels[index],
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: index <= currentStep
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight:
                  index <= currentStep ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        );
      }),
    );

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        stepIndicator,
        const SizedBox(height: 8),
        labelRow,
      ],
    );

    if (useContainer) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          border: Border(
            bottom: BorderSide(color: theme.dividerColor, width: 1),
          ),
        ),
        child: content,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: content,
    );
  }
}
