import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Mixin providing coin flip specific animation functionality
mixin CoinFlipAnimationMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  // Common animation controllers
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late List<AnimationController> _resultControllers;
  late List<Animation<double>> _resultAnimations;

  // Coin flip specific controllers
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late AnimationController _scaleController;

  // Animation state
  bool _isAnimating = false;

  // Getters for accessing animation state
  bool get isAnimating => _isAnimating;
  Animation<double> get bounceAnimation => _bounceAnimation;
  Animation<double> get flipAnimation => _flipAnimation;
  List<Animation<double>> get resultAnimations => _resultAnimations;

  /// Initialize coin flip animations
  void initializeCoinFlipAnimations() {
    // Initialize common animations
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

    // Initialize coin flip specific animations
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _flipAnimation = Tween<double>(
      begin: 0,
      end: 6 * math.pi,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeOut,
    ));

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  /// Dispose coin flip animations
  void disposeCoinFlipAnimations() {
    _bounceController.dispose();
    for (final controller in _resultControllers) {
      controller.dispose();
    }
    _flipController.dispose();
    _scaleController.dispose();
  }

  /// Start coin flip animation
  Future<void> startCoinFlipAnimation() async {
    if (!mounted) return;

    _flipController.reset();
    await _flipController.forward();
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

  /// Handle coin flip generation with animation
  Future<void> handleCoinFlipGeneration({
    required bool skipAnimation,
    required bool counterMode,
    required String result,
    required Future<void> Function() onGenerate,
    required VoidCallback onAnimationComplete,
  }) async {
    // Set loading state
    setAnimatingState(true);

    // Start appropriate animation
    if (!skipAnimation) {
      if (counterMode) {
        // Don't start flip animation for counter mode
      } else {
        startCoinFlipAnimation();
      }
    }

    // Execute generation
    await onGenerate();

    // Get the actual result after generation
    final notifier = result; // This will be updated by the caller

    // Setup animations for counter mode or complete immediately
    if (counterMode && !skipAnimation && notifier.isNotEmpty) {
      final results = notifier.split(', ');
      await setupStaggeredAnimations(results);
    }

    // Complete animation
    setAnimatingState(false);
    onAnimationComplete();
  }
}
