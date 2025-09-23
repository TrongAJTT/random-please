import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/settings_provider.dart';

class DateTimeGeneratorStateManager
    extends StateNotifier<DateTimeGeneratorState> {
  static const String _stateKey = 'dateTimeGeneratorState';
  final Ref ref;

  DateTimeGeneratorStateManager(this.ref)
      : super(DateTimeGeneratorState.createDefault()) {
    _loadState();
  }

  Future<void> _loadState() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();

      try {
        // Try to load full state from JSON
        final stateJson = prefs.getString(_stateKey);
        if (stateJson != null) {
          final stateMap = jsonDecode(stateJson) as Map<String, dynamic>;
          state = DateTimeGeneratorState.fromJson(stateMap);
        } else {
          // Try to load individual fields for backward compatibility
          final startDateTimeStr =
              prefs.getString('${_stateKey}_startDateTime');
          final endDateTimeStr = prefs.getString('${_stateKey}_endDateTime');
          final dateTimeCount = prefs.getInt('${_stateKey}_dateTimeCount') ?? 5;
          final allowDuplicates =
              prefs.getBool('${_stateKey}_allowDuplicates') ?? true;

          final now = DateTime.now();
          final startDateTime = startDateTimeStr != null
              ? DateTime.parse(startDateTimeStr)
              : now.subtract(const Duration(days: 365));
          final endDateTime = endDateTimeStr != null
              ? DateTime.parse(endDateTimeStr)
              : now.add(const Duration(days: 365));

          state = DateTimeGeneratorState(
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            dateTimeCount: dateTimeCount,
            allowDuplicates: allowDuplicates,
            lastUpdated: DateTime.now(),
          );
        }
      } catch (e) {
        print('Error loading DateTimeGenerator state: $e');
        state = DateTimeGeneratorState.createDefault();
      }
    } else {
      state = DateTimeGeneratorState.createDefault();
    }
  }

  Future<void> _saveState() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();
      final stateJson = jsonEncode(state.toJson());
      await prefs.setString(_stateKey, stateJson);
    }
  }

  // Update methods - don't save state automatically
  void updateStartDateTime(DateTime value) {
    state = state.copyWith(startDateTime: value);
  }

  void updateEndDateTime(DateTime value) {
    state = state.copyWith(endDateTime: value);
  }

  void updateDateTimeCount(int value) {
    state = state.copyWith(dateTimeCount: value);
  }

  void updateAllowDuplicates(bool value) {
    state = state.copyWith(allowDuplicates: value);
  }

  // Save current state explicitly (called after generation)
  Future<void> saveCurrentState() async {
    await _saveState();
  }

  void resetState() {
    state = DateTimeGeneratorState.createDefault();
    _saveState();
  }
}

final dateTimeGeneratorStateManagerProvider = StateNotifierProvider<
    DateTimeGeneratorStateManager, DateTimeGeneratorState>((ref) {
  return DateTimeGeneratorStateManager(ref);
});

// Provider that respects settings for persistent state
final dateTimeGeneratorProvider = Provider<DateTimeGeneratorState>((ref) {
  final settingsState = ref.watch(settingsProvider);
  final generatorState = ref.watch(dateTimeGeneratorStateManagerProvider);

  // Only return saved state if persistent state is enabled
  if (settingsState.saveRandomToolsState) {
    return generatorState;
  } else {
    // Return default state when persistence is disabled
    return DateTimeGeneratorState.createDefault();
  }
});
