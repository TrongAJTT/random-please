import 'package:flutter/material.dart';

/// Specialized coin widget for coin flip animation
class AnimatedCoin extends StatelessWidget {
  final bool isHeads;
  final Animation<double>? flipAnimation;
  final bool isSmall;
  final VoidCallback? onTap;

  const AnimatedCoin({
    super.key,
    required this.isHeads,
    this.flipAnimation,
    this.isSmall = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget coin = _buildCoin(context);

    if (flipAnimation != null) {
      return AnimatedBuilder(
        animation: flipAnimation!,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.95 + (flipAnimation!.value * 0.05), // Very subtle scale
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(flipAnimation!.value),
              child: coin,
            ),
          );
        },
      );
    }

    return coin;
  }

  Widget _buildCoin(BuildContext context) {
    const size = 48.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: isHeads
                ? [Colors.amber.shade400, Colors.amber.shade600]
                : [Colors.grey.shade400, Colors.grey.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  (isHeads ? Colors.amber : Colors.grey).withValues(alpha: 0.3),
              blurRadius: isSmall ? 6 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            isHeads ? 'H' : 'T',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget that displays a single coin result with flip animation
class CoinFlipResultDisplay extends StatelessWidget {
  final String result;
  final Animation<double>? flipAnimation;
  final bool isLoading;
  final VoidCallback? onTap;

  const CoinFlipResultDisplay({
    super.key,
    required this.result,
    this.flipAnimation,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (result.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    if (isLoading) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade300,
          border: Border.all(color: Colors.grey.shade400, width: 2),
        ),
        child: const Center(
          child: Icon(
            Icons.sync,
            color: Colors.grey,
            size: 20,
          ),
        ),
      );
    }

    return AnimatedCoin(
      isHeads: result.contains('Heads'),
      flipAnimation: flipAnimation,
      onTap: onTap,
    );
  }
}

/// Widget for fast flip animation in counter mode
class FastFlipCoin extends StatefulWidget {
  final bool isHeads;
  final bool isSmall;
  final VoidCallback? onTap;
  final Animation<double>? staggerAnimation;

  const FastFlipCoin({
    super.key,
    required this.isHeads,
    this.isSmall = false,
    this.onTap,
    this.staggerAnimation,
  });

  @override
  State<FastFlipCoin> createState() => _FastFlipCoinState();
}

class _FastFlipCoinState extends State<FastFlipCoin>
    with SingleTickerProviderStateMixin {
  late AnimationController _fastFlipController;
  late Animation<double> _fastFlipAnimation;

  @override
  void initState() {
    super.initState();
    _fastFlipController = AnimationController(
      duration: const Duration(milliseconds: 300), // Faster than normal flip
      vsync: this,
    );
    _fastFlipAnimation = Tween<double>(
      begin: 0,
      end: 4 * 3.14159, // 2 full rotations instead of 3
    ).animate(CurvedAnimation(
      parent: _fastFlipController,
      curve: Curves.easeInOut,
    ));

    // Start animation when stagger animation reaches certain point
    if (widget.staggerAnimation != null) {
      widget.staggerAnimation!.addListener(() {
        if (widget.staggerAnimation!.value > 0.1 &&
            !_fastFlipController.isAnimating) {
          _fastFlipController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _fastFlipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.staggerAnimation != null) {
      return AnimatedBuilder(
        animation: widget.staggerAnimation!,
        builder: (context, child) {
          if (widget.staggerAnimation!.value == 0.0) {
            return const SizedBox.shrink();
          }

          return Transform.scale(
            scale: 0.3 + (widget.staggerAnimation!.value * 0.7),
            child: AnimatedBuilder(
              animation: _fastFlipAnimation,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(_fastFlipAnimation.value),
                  child: _buildCoin(context),
                );
              },
            ),
          );
        },
      );
    }

    return AnimatedBuilder(
      animation: _fastFlipAnimation,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_fastFlipAnimation.value),
          child: _buildCoin(context),
        );
      },
    );
  }

  Widget _buildCoin(BuildContext context) {
    const size = 48.0;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: widget.isHeads
                ? [Colors.amber.shade400, Colors.amber.shade600]
                : [Colors.grey.shade400, Colors.grey.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: (widget.isHeads ? Colors.amber : Colors.grey)
                  .withValues(alpha: 0.3),
              blurRadius: widget.isSmall ? 6 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.isHeads ? 'H' : 'T',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget that displays multiple coin results with staggered animations
class StaggeredCoinDisplay extends StatelessWidget {
  final String results;
  final List<Animation<double>> animations;
  final bool skipAnimation;
  final void Function(String, int)? onItemTap;

  const StaggeredCoinDisplay({
    super.key,
    required this.results,
    required this.animations,
    required this.skipAnimation,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const SizedBox.shrink();
    }

    final resultList = results.split(', ');

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: resultList.asMap().entries.map((entry) {
        final index = entry.key;
        final resultText = entry.value.trim();

        // If skip animation, show static coins immediately
        if (skipAnimation) {
          return AnimatedCoin(
            isHeads: resultText.contains('Heads'),
            isSmall: true,
            onTap:
                onItemTap != null ? () => onItemTap!(resultText, index) : null,
          );
        }

        // With animation, use FastFlipCoin for better flip effect
        if (index < animations.length) {
          return FastFlipCoin(
            isHeads: resultText.contains('Heads'),
            isSmall: true,
            staggerAnimation: animations[index],
            onTap:
                onItemTap != null ? () => onItemTap!(resultText, index) : null,
          );
        } else {
          // Fallback for when animations aren't ready - hide them
          return const SizedBox.shrink();
        }
      }).toList(),
    );
  }
}
