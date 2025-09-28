import 'package:flutter/material.dart';

/// Configuration for animated result container
class AnimatedResultContainerConfig {
  final bool isSmall;
  final Color color;
  final String text;
  final Widget? icon;
  final ShapeBorder? shape;
  final EdgeInsets? padding;

  const AnimatedResultContainerConfig({
    this.isSmall = false,
    required this.color,
    required this.text,
    this.icon,
    this.shape,
    this.padding,
  });
}

/// Reusable animated result container widget
class AnimatedResultContainer extends StatelessWidget {
  final AnimatedResultContainerConfig config;
  final Animation<double>? animation;
  final bool isLoading;
  final VoidCallback? onTap;

  const AnimatedResultContainer({
    super.key,
    required this.config,
    this.animation,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingContainer(context);
    }

    Widget container = _buildContainer(context);

    if (animation != null) {
      return AnimatedBuilder(
        animation: animation!,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.3 + (animation!.value * 0.7),
            child: container,
          );
        },
      );
    }

    return container;
  }

  Widget _buildContainer(BuildContext context) {
    List<Color> gradientColors = _getGradientColors();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: config.padding ??
            EdgeInsets.symmetric(
              horizontal: config.isSmall ? 16 : 32,
              vertical: config.isSmall ? 12 : 20,
            ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: config.shape == null
              ? BorderRadius.circular(config.isSmall ? 12 : 16)
              : null,
          shape: config.shape == null ? BoxShape.rectangle : BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: config.color.withValues(alpha: 0.3),
              blurRadius: config.isSmall ? 8 : 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (config.icon != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          config.icon!,
          if (!config.isSmall) ...[
            const SizedBox(height: 8),
            _buildText(context),
          ],
        ],
      );
    }

    return _buildText(context);
  }

  Widget _buildText(BuildContext context) {
    return Text(
      config.text,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: config.isSmall ? 16 : null,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoadingContainer(BuildContext context) {
    List<Color> gradientColors = [Colors.grey.shade300, Colors.grey.shade400];

    return Container(
      padding: config.padding ??
          EdgeInsets.symmetric(
            horizontal: config.isSmall ? 16 : 32,
            vertical: config.isSmall ? 12 : 20,
          ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: config.shape == null
            ? BorderRadius.circular(config.isSmall ? 12 : 16)
            : null,
        shape: config.shape == null ? BoxShape.rectangle : BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            blurRadius: config.isSmall ? 8 : 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading...',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: config.isSmall ? 16 : null,
                ),
          ),
        ],
      ),
    );
  }

  List<Color> _getGradientColors() {
    if (config.color == Colors.green) {
      return [Colors.green.shade400, Colors.green.shade600];
    } else if (config.color == Colors.red) {
      return [Colors.red.shade400, Colors.red.shade600];
    } else if (config.color == Colors.amber) {
      return [Colors.amber.shade400, Colors.amber.shade600];
    } else if (config.color == Colors.blue) {
      return [Colors.blue.shade400, Colors.blue.shade600];
    } else if (config.color == Colors.brown) {
      return [Colors.brown.shade400, Colors.brown.shade600];
    } else if (config.color == Colors.grey) {
      return [Colors.grey.shade400, Colors.grey.shade600];
    }
    return [config.color, config.color];
  }
}
