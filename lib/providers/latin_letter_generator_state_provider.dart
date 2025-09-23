import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LatinLetterGeneratorStateManager
    extends StateNotifier<LatinLetterGeneratorState> {
  static const String _stateKey = 'latinLetterGeneratorState';
  final Ref ref;

  LatinLetterGeneratorStateManager(this.ref)
      : super(LatinLetterGeneratorState.createDefault()) {
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
          state = LatinLetterGeneratorState.fromJson(stateMap);
        } else {
          // Try to load individual fields for backward compatibility
          final includeUppercase =
              prefs.getBool('${_stateKey}_includeUppercase') ?? true;
          final includeLowercase =
              prefs.getBool('${_stateKey}_includeLowercase') ?? true;
          final letterCount = prefs.getInt('${_stateKey}_letterCount') ?? 5;
          final allowDuplicates =
              prefs.getBool('${_stateKey}_allowDuplicates') ?? true;
          final skipAnimation =
              prefs.getBool('${_stateKey}_skipAnimation') ?? false;

          state = LatinLetterGeneratorState(
            includeUppercase: includeUppercase,
            includeLowercase: includeLowercase,
            letterCount: letterCount,
            allowDuplicates: allowDuplicates,
            skipAnimation: skipAnimation,
            lastUpdated: DateTime.now(),
          );
        }
      } catch (e) {
        debugPrint('Error loading LatinLetterGenerator state: $e');
        state = LatinLetterGeneratorState.createDefault();
      }
    } else {
      state = LatinLetterGeneratorState.createDefault();
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
  void updateIncludeUppercase(bool value) {
    state = state.copyWith(includeUppercase: value);
  }

  void updateIncludeLowercase(bool value) {
    state = state.copyWith(includeLowercase: value);
  }

  void updateLetterCount(int value) {
    state = state.copyWith(letterCount: value);
  }

  void updateAllowDuplicates(bool value) {
    state = state.copyWith(allowDuplicates: value);
  }

  void updateSkipAnimation(bool value) {
    state = state.copyWith(skipAnimation: value);
  }

  // Save current state explicitly (called after generation)
  Future<void> saveCurrentState() async {
    await _saveState();
  }

  void resetState() {
    state = LatinLetterGeneratorState.createDefault();
    _saveState();
  }

  bool get hasValidSettings {
    return state.includeUppercase || state.includeLowercase;
  }

  int get maxPossibleLetters {
    int total = 0;
    if (state.includeUppercase) total += 26;
    if (state.includeLowercase) total += 26;
    return total;
  }

  bool get canGenerateLetters {
    if (!hasValidSettings) return false;
    if (state.allowDuplicates) return true;
    return state.letterCount <= maxPossibleLetters;
  }
}

final latinLetterGeneratorStateProvider = StateNotifierProvider<
    LatinLetterGeneratorStateManager, LatinLetterGeneratorState>((ref) {
  return LatinLetterGeneratorStateManager(ref);
});

final latinLetterGeneratorProvider = Provider<LatinLetterGeneratorState>((ref) {
  final settingsState = ref.watch(settingsProvider);
  final generatorState = ref.watch(latinLetterGeneratorStateProvider);

  // Only return saved state if persistent state is enabled
  if (settingsState.saveRandomToolsState) {
    return generatorState;
  } else {
    // Return default state when persistence is disabled
    return LatinLetterGeneratorState.createDefault();
  }
});
