import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/providers/ui_settings_provider.dart';

/// Helper class for auto-scrolling functionality with settings check
class AutoScrollHelper {
  /// Automatically scroll to the bottom of the scroll controller if auto-scroll is enabled in settings
  ///
  /// Parameters:
  /// - [ref]: Riverpod ref for accessing settings
  /// - [scrollController]: The ScrollController to animate
  /// - [mounted]: Whether the widget is still mounted
  /// - [hasResults]: Whether there are results to show (optional check)
  /// - [duration]: Animation duration (default: 500ms)
  /// - [curve]: Animation curve (default: Curves.easeOut)
  static void scrollToResults({
    required WidgetRef ref,
    required ScrollController scrollController,
    required bool mounted,
    bool hasResults = true,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeOut,
  }) {
    // Check if auto-scroll is enabled in settings
    final autoScrollEnabled = ref.read(autoScrollToResultsProvider);

    // Only scroll if:
    // 1. Widget is still mounted
    // 2. Auto-scroll is enabled in settings
    // 3. There are results to show
    if (mounted && autoScrollEnabled && hasResults) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: duration,
            curve: curve,
          );
        }
      });
    }
  }

  /// Check if auto-scroll is currently enabled in settings
  static bool isAutoScrollEnabled(WidgetRef ref) {
    return ref.read(autoScrollToResultsProvider);
  }

  /// Watch auto-scroll setting changes
  static bool watchAutoScrollEnabled(WidgetRef ref) {
    return ref.watch(autoScrollToResultsProvider);
  }
}
