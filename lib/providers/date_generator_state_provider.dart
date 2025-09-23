import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/settings_provider.dart';

class DateGeneratorStateManager extends StateNotifier<DateGeneratorState> {
  static const String _stateKey = 'dateGeneratorState';
  final Ref ref;

  DateGeneratorStateManager(this.ref)
      : super(DateGeneratorState.createDefault()) {
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
          state = DateGeneratorState.fromJson(stateMap);
        } else {
          // Try to load individual fields for backward compatibility
          final startDateStr = prefs.getString('${_stateKey}_startDate');
          final endDateStr = prefs.getString('${_stateKey}_endDate');
          final dateCount = prefs.getInt('${_stateKey}_dateCount') ?? 5;
          final allowDuplicates =
              prefs.getBool('${_stateKey}_allowDuplicates') ?? true;

          final now = DateTime.now();
          final startDate = startDateStr != null
              ? DateTime.parse(startDateStr)
              : now.subtract(const Duration(days: 365));
          final endDate = endDateStr != null
              ? DateTime.parse(endDateStr)
              : now.add(const Duration(days: 365));

          state = state.copyWith(
            startDate: startDate,
            endDate: endDate,
            dateCount: dateCount,
            allowDuplicates: allowDuplicates,
          );
        }
      } catch (e) {
        // If loading fails, use default state
        state = DateGeneratorState.createDefault();
      }
    }
  }

  Future<void> _saveState() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();

      // Save full state as JSON
      final stateJson = jsonEncode(state.toJson());
      await prefs.setString(_stateKey, stateJson);

      // Also save individual fields for backward compatibility
      await prefs.setString(
          '${_stateKey}_startDate', state.startDate.toIso8601String());
      await prefs.setString(
          '${_stateKey}_endDate', state.endDate.toIso8601String());
      await prefs.setInt('${_stateKey}_dateCount', state.dateCount);
      await prefs.setBool(
          '${_stateKey}_allowDuplicates', state.allowDuplicates);
    }
  }

  // Update methods without auto-save
  void updateStartDate(DateTime startDate) {
    state = state.copyWith(startDate: startDate);
  }

  void updateEndDate(DateTime endDate) {
    state = state.copyWith(endDate: endDate);
  }

  void updateDateCount(int dateCount) {
    state = state.copyWith(dateCount: dateCount);
  }

  void updateAllowDuplicates(bool allowDuplicates) {
    state = state.copyWith(allowDuplicates: allowDuplicates);
  }

  // Save state manually when needed (e.g., after generation)
  Future<void> saveCurrentState() async {
    await _saveState();
  }

  void resetState() {
    state = DateGeneratorState.createDefault();
    _saveState();
  }
}

final dateGeneratorStateManagerProvider =
    StateNotifierProvider<DateGeneratorStateManager, DateGeneratorState>((ref) {
  return DateGeneratorStateManager(ref);
});
