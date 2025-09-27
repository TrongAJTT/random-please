import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'dart:math';

// Combined view state for DiceRollGenerator
@immutable
class DiceRollGeneratorViewState {
  final DiceRollGeneratorState generatorState;
  final bool isBoxOpen;
  final bool historyEnabled;
  final List<GenerationHistoryItem> historyItems;
  final List<int> results;

  const DiceRollGeneratorViewState({
    required this.generatorState,
    required this.isBoxOpen,
    required this.historyEnabled,
    required this.historyItems,
    required this.results,
  });

  DiceRollGeneratorViewState copyWith({
    DiceRollGeneratorState? generatorState,
    bool? isBoxOpen,
    bool? historyEnabled,
    List<GenerationHistoryItem>? historyItems,
    List<int>? results,
  }) {
    return DiceRollGeneratorViewState(
      generatorState: generatorState ?? this.generatorState,
      isBoxOpen: isBoxOpen ?? this.isBoxOpen,
      historyEnabled: historyEnabled ?? this.historyEnabled,
      historyItems: historyItems ?? this.historyItems,
      results: results ?? this.results,
    );
  }

  int get total => results.fold(0, (sum, value) => sum + value);
}

// Notifier for DiceRollGenerator
class DiceRollGeneratorNotifier
    extends StateNotifier<DiceRollGeneratorViewState> {
  static const String boxName = 'diceRollGeneratorBox';
  static const String historyType = 'dice_roll';

  late Box<DiceRollGeneratorState> _box;

  // Available dice sides from original screen
  final List<int> availableSides = [
    3,
    4,
    5,
    6,
    7,
    8,
    10,
    12,
    14,
    16,
    20,
    24,
    30,
    48,
    50,
    100
  ];

  DiceRollGeneratorNotifier()
      : super(DiceRollGeneratorViewState(
          generatorState: DiceRollGeneratorState.createDefault(),
          isBoxOpen: false,
          historyEnabled: false,
          historyItems: const [],
          results: const [],
        ));

  Future<void> initHive() async {
    _box = await Hive.openBox<DiceRollGeneratorState>(boxName);
    final savedState =
        _box.get('state') ?? DiceRollGeneratorState.createDefault();

    state = state.copyWith(
      generatorState: savedState,
      isBoxOpen: true,
    );
  }

  Future<void> loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history = await GenerationHistoryService.getHistory(historyType);

    state = state.copyWith(
      historyEnabled: enabled,
      historyItems: history,
    );
  }

  void saveState() {
    if (state.isBoxOpen) {
      _box.put('state', state.generatorState);
    }
  }

  void updateSides(int value) {
    final newState = state.generatorState.copyWith(diceSides: value);
    state = state.copyWith(generatorState: newState);
    saveState();
  }

  void updateQuantity(int value) {
    final newState = state.generatorState.copyWith(diceCount: value);
    state = state.copyWith(generatorState: newState);
    saveState();
  }

  Future<void> rollDice() async {
    final random = Random();
    final List<int> results = [];

    for (int i = 0; i < state.generatorState.diceCount; i++) {
      final result = random.nextInt(state.generatorState.diceSides) + 1;
      results.add(result);
    }

    state = state.copyWith(results: results);

    // Save to history if enabled using new standardized encoding
    if (state.historyEnabled) {
      final total = results.fold(0, (sum, value) => sum + value);
      final resultString = results.length == 1
          ? results.first.toString()
          : '${results.join(' + ')} = $total';

      await GenerationHistoryService.addHistoryItems(
          [resultString], historyType);
      await loadHistory(); // Refresh history
    }
  }

  @override
  void dispose() {
    // Close box if needed
    super.dispose();
  }
}

// Provider for DiceRollGenerator
final diceRollGeneratorProvider = StateNotifierProvider<
    DiceRollGeneratorNotifier, DiceRollGeneratorViewState>((ref) {
  return DiceRollGeneratorNotifier();
});
