import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/settings_provider.dart';
import 'package:random_please/services/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// StateManager for TimeGenerator
class TimeGeneratorStateManager extends StateNotifier<TimeGeneratorState> {
  static const String _stateKey = 'time_generator_state';

  TimeGeneratorStateManager() : super(TimeGeneratorState.createDefault()) {
    _loadState();
  }

  // Load state from SharedPreferences if enabled
  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stateJson = prefs.getString(_stateKey);

      if (stateJson != null) {
        final stateMap = json.decode(stateJson) as Map<String, dynamic>;
        state = TimeGeneratorState.fromJson(stateMap);
      }
    } catch (e) {
      // If loading fails, keep default state
      logError('Failed to load TimeGenerator state: $e');
    }
  }

  // Save state to SharedPreferences if enabled
  Future<void> saveCurrentState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stateJson = json.encode(state.toJson());
      await prefs.setString(_stateKey, stateJson);
    } catch (e) {
      logError('Failed to save TimeGenerator state: $e');
    }
  }

  // Update start hour
  void updateStartHour(int value) {
    state = state.copyWith(startHour: value);
  }

  // Update start minute
  void updateStartMinute(int value) {
    state = state.copyWith(startMinute: value);
  }

  // Update end hour
  void updateEndHour(int value) {
    state = state.copyWith(endHour: value);
  }

  // Update end minute
  void updateEndMinute(int value) {
    state = state.copyWith(endMinute: value);
  }

  // Update time count
  void updateTimeCount(int value) {
    state = state.copyWith(timeCount: value);
  }

  // Update allow duplicates
  void updateAllowDuplicates(bool value) {
    state = state.copyWith(allowDuplicates: value);
  }

  // Reset to default state
  void resetToDefault() {
    state = TimeGeneratorState.createDefault();
  }
}

// Provider for TimeGenerator state
final timeGeneratorStateProvider =
    StateNotifierProvider<TimeGeneratorStateManager, TimeGeneratorState>((ref) {
  return TimeGeneratorStateManager();
});

// Provider that respects settings for persistent state
final timeGeneratorProvider = Provider<TimeGeneratorState>((ref) {
  final settingsState = ref.watch(settingsProvider);
  final generatorState = ref.watch(timeGeneratorStateProvider);

  // Only return saved state if persistent state is enabled
  if (settingsState.saveRandomToolsState) {
    return generatorState;
  } else {
    // Return default state when persistence is disabled
    return TimeGeneratorState.createDefault();
  }
});
