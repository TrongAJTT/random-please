import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/settings_provider.dart';

// StateManager cho DiceRollGenerator với persistent state
class DiceRollGeneratorStateManager
    extends StateNotifier<DiceRollGeneratorState> {
  static const String _stateKey = 'diceRollGeneratorState';
  final Ref ref;

  DiceRollGeneratorStateManager(this.ref)
      : super(DiceRollGeneratorState.createDefault()) {
    _loadState();
  }

  Future<void> _loadState() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();
      final diceCount = prefs.getInt('${_stateKey}_diceCount') ?? 1;
      final diceSides = prefs.getInt('${_stateKey}_diceSides') ?? 6;

      state = state.copyWith(
        diceCount: diceCount,
        diceSides: diceSides,
      );
    }
  }

  Future<void> _saveState() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('${_stateKey}_diceCount', state.diceCount);
      await prefs.setInt('${_stateKey}_diceSides', state.diceSides);
    }
  }

  // Update methods với auto-save
  Future<void> updateDiceCount(int count) async {
    state = state.copyWith(diceCount: count);
    await _saveState();
  }

  Future<void> updateDiceSides(int sides) async {
    state = state.copyWith(diceSides: sides);
    await _saveState();
  }

  Future<void> increaseDiceCount() async {
    if (state.diceCount < 99) {
      await updateDiceCount(state.diceCount + 1);
    }
  }

  Future<void> decreaseDiceCount() async {
    if (state.diceCount > 1) {
      await updateDiceCount(state.diceCount - 1);
    }
  }

  // Reset về default
  Future<void> resetToDefault() async {
    state = DiceRollGeneratorState.createDefault();
    await _saveState();
  }

  // Force reload state (khi setting thay đổi)
  Future<void> reloadState() async {
    await _loadState();
  }
}

// Provider cho DiceRollGenerator state manager
final diceRollGeneratorStateManagerProvider = StateNotifierProvider<
    DiceRollGeneratorStateManager, DiceRollGeneratorState>((ref) {
  return DiceRollGeneratorStateManager(ref);
});
