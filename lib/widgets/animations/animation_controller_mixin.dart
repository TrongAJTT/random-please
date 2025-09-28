import 'package:flutter/material.dart';

/// Mixin providing common animation functionality for random generator screens
mixin RandomGeneratorAnimationMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  // Common animation controllers
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late List<AnimationController> _resultControllers;
  late List<Animation<double>> _resultAnimations;

  // Animation state
  bool _isAnimating = false;

  // Getters for accessing animation state
  bool get isAnimating => _isAnimating;
  Animation<double> get bounceAnimation => _bounceAnimation;
  List<Animation<double>> get resultAnimations => _resultAnimations;

  /// Initialize all animation controllers
  void initializeAnimations() {
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceAnimation = CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    );

    _resultControllers = [];
    _resultAnimations = [];
  }

  /// Dispose all animation controllers
  void disposeAnimations() {
    _bounceController.dispose();
    for (final controller in _resultControllers) {
      controller.dispose();
    }
  }

  /// Start bounce animation for single result mode
  Future<void> startBounceAnimation() async {
    if (!mounted) return;

    _bounceController.reset();
    await _bounceController.forward();
  }

  /// Setup staggered animations for counter mode results
  Future<void> setupStaggeredAnimations(List<String> results) async {
    // Dispose existing controllers
    for (final controller in _resultControllers) {
      controller.dispose();
    }

    _resultControllers.clear();
    _resultAnimations.clear();

    // Create animation controllers for each result
    for (int i = 0; i < results.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      );
      final animation = CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      );

      _resultControllers.add(controller);
      _resultAnimations.add(animation);

      // Start animation with delay
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          controller.forward();
        }
      });
    }

    // Calculate total animation duration
    final totalDuration =
        Duration(milliseconds: (results.length - 1) * 100 + 400);
    return Future.delayed(totalDuration);
  }

  /// Set animation state
  void setAnimatingState(bool animating) {
    if (mounted) {
      setState(() {
        _isAnimating = animating;
      });
    }
  }

  /// Handle generation with animation
  Future<void> handleGenerationWithAnimation({
    required bool skipAnimation,
    required bool counterMode,
    required String result,
    required Future<void> Function() onGenerate,
    required VoidCallback onAnimationComplete,
    required String Function() getCurrentResult,
  }) async {
    // Set loading state
    setAnimatingState(true);

    // Start appropriate animation
    if (!skipAnimation) {
      if (counterMode) {
        // Don't start bounce animation for counter mode
      } else {
        startBounceAnimation();
      }
    }

    // Execute generation
    await onGenerate();

    // Setup animations for counter mode or complete immediately
    // Use getCurrentResult() to get the updated result after generation
    if (counterMode && !skipAnimation) {
      final newResult = getCurrentResult();
      if (newResult.isNotEmpty) {
        final results = newResult.split(', ');
        await setupStaggeredAnimations(results);
      }
    }

    // Complete animation
    setAnimatingState(false);
    onAnimationComplete();
  }
}
