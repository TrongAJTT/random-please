import 'package:flutter/material.dart';
import 'animated_result_container.dart';

/// Widget that displays multiple results with staggered animations
class StaggeredResultDisplay extends StatelessWidget {
  final String results;
  final List<Animation<double>> animations;
  final bool skipAnimation;
  final List<AnimatedResultContainerConfig> Function(List<String>)
      configBuilder;
  final void Function(String, int)? onItemTap;

  const StaggeredResultDisplay({
    super.key,
    required this.results,
    required this.animations,
    required this.skipAnimation,
    required this.configBuilder,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const SizedBox.shrink();
    }

    final resultList = results.split(', ');
    final configs = configBuilder(resultList);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: resultList.asMap().entries.map((entry) {
        final index = entry.key;
        final resultText = entry.value.trim();
        final config = index < configs.length ? configs[index] : configs.first;

        // If skip animation, show static containers immediately
        if (skipAnimation) {
          return AnimatedResultContainer(
            config: config,
            onTap:
                onItemTap != null ? () => onItemTap!(resultText, index) : null,
          );
        }

        // With animation, use AnimatedBuilder
        if (index < animations.length) {
          return AnimatedBuilder(
            animation: animations[index],
            builder: (context, child) {
              // Hide elements that haven't started animating yet
              if (animations[index].value == 0.0) {
                return const SizedBox.shrink();
              }

              return AnimatedResultContainer(
                config: config,
                animation: animations[index],
                onTap: onItemTap != null
                    ? () => onItemTap!(resultText, index)
                    : null,
              );
            },
          );
        } else {
          // Fallback for when animations aren't ready - hide them
          return const SizedBox.shrink();
        }
      }).toList(),
    );
  }
}
