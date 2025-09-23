import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/settings_provider.dart';

class YesNoGeneratorStateManager extends StateNotifier<SimpleGeneratorState> {
  static const String _stateKey = 'yesNoGeneratorState';
  final Ref ref;

  YesNoGeneratorStateManager(this.ref)
      : super(SimpleGeneratorState.createDefault()) {
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
          state = SimpleGeneratorState.fromJson(stateMap);
        } else {
          // Try to load individual fields for backward compatibility
          final skipAnimation =
              prefs.getBool('${_stateKey}_skipAnimation') ?? false;

          state = state.copyWith(
            skipAnimation: skipAnimation,
          );
        }
      } catch (e) {
        // If loading fails, use default state
        state = SimpleGeneratorState.createDefault();
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
      await prefs.setBool('${_stateKey}_skipAnimation', state.skipAnimation);
    }
  }

  // Update methods với auto-save
  void updateSkipAnimation(bool skipAnimation) {
    state = state.copyWith(skipAnimation: skipAnimation);
    _saveState();
  }

  void resetState() {
    state = SimpleGeneratorState.createDefault();
    _saveState();
  }
}

final yesNoGeneratorStateManagerProvider =
    StateNotifierProvider<YesNoGeneratorStateManager, SimpleGeneratorState>(
        (ref) {
  return YesNoGeneratorStateManager(ref);
});
