import 'package:flutter/material.dart';
import 'animated_result_container.dart';

/// Widget that displays a single result with bounce animation
class BounceResultDisplay extends StatelessWidget {
  final String result;
  final Animation<double> animation;
  final bool isLoading;
  final AnimatedResultContainerConfig config;
  final VoidCallback? onTap;

  const BounceResultDisplay({
    super.key,
    required this.result,
    required this.animation,
    this.isLoading = false,
    required this.config,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Only show loading if we have a result or specifically in loading state with result expected
    if (result.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    // Show loading container only if isLoading is true and we expect a result
    if (isLoading && result.isEmpty) {
      return const SizedBox.shrink(); // Don't show loading for brief moments
    }

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (animation.value * 0.2),
          child: Center(
            child: AnimatedResultContainer(
              config: config,
              onTap: onTap,
            ),
          ),
        );
      },
    );
  }
}
