import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/services/settings_service.dart';

// Provider for history enabled state
class HistoryEnabledNotifier extends StateNotifier<bool> {
  HistoryEnabledNotifier() : super(false) {
    _loadState();
  }

  Future<void> _loadState() async {
    try {
      final enabled = await GenerationHistoryService.isHistoryEnabled();
      if (mounted) {
        state = enabled;
      }
    } catch (e) {
      // Handle error gracefully, keep default state
    }
  }

  Future<void> loadState() async {
    await _loadState();
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await GenerationHistoryService.setHistoryEnabled(enabled);
  }
}

// Provider for compact tab layout state
class CompactTabLayoutNotifier extends StateNotifier<bool> {
  CompactTabLayoutNotifier() : super(false) {
    _loadState();
  }

  Future<void> _loadState() async {
    try {
      final enabled = await SettingsService.getCompactTabLayout();
      if (mounted) {
        state = enabled;
      }
    } catch (e) {
      // Handle error gracefully, keep default state
    }
  }

  Future<void> loadState() async {
    await _loadState();
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await SettingsService.updateCompactTabLayout(enabled);
  }
}

// Provider instances
final historyEnabledProvider =
    StateNotifierProvider<HistoryEnabledNotifier, bool>((ref) {
  return HistoryEnabledNotifier();
});

final compactTabLayoutProvider =
    StateNotifierProvider<CompactTabLayoutNotifier, bool>((ref) {
  return CompactTabLayoutNotifier();
});
