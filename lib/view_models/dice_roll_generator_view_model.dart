import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/providers/dice_roll_generator_state_provider.dart';
import 'package:random_please/constants/history_types.dart';

/// ViewModel wrapper for DiceRollGenerator using Riverpod StateManager
class DiceRollGeneratorViewModel extends ChangeNotifier {
  final WidgetRef _ref;
  static const String historyType = HistoryTypes.diceRoll;

  bool _historyEnabled = true;
  List<int> _results = [];

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

  DiceRollGeneratorViewModel(this._ref) {
    _loadSettings();
  }

  // Getters - delegate to StateManager
  DiceRollGeneratorState get state =>
      _ref.watch(diceRollGeneratorStateManagerProvider);
  bool get historyEnabled => _historyEnabled;
  List<int> get results => _results;

  int get total => _results.fold(0, (sum, value) => sum + value);

  // Load settings
  Future<void> _loadSettings() async {
    _historyEnabled = _ref.read(historyEnabledProvider);
    notifyListeners();
  }

  // State update methods that delegate to StateManager
  Future<void> updateDiceCount(int value) async {
    await _ref
        .read(diceRollGeneratorStateManagerProvider.notifier)
        .updateDiceCount(value);
    notifyListeners();
  }

  Future<void> updateDiceSides(int value) async {
    await _ref
        .read(diceRollGeneratorStateManagerProvider.notifier)
        .updateDiceSides(value);
    notifyListeners();
  }

  Future<void> rollDice() async {
    final currentState = state;
    // Use RandomGenerator from original screen
    _results = RandomGenerator.generateDiceRolls(
      count: currentState.diceCount,
      sides: currentState.diceSides,
    );

    // Save to history if enabled using HistoryProvider
    if (_historyEnabled && _results.isNotEmpty) {
      String historyText;
      if (_results.length == 1) {
        historyText = 'd${currentState.diceSides}: ${_results[0]}';
      } else {
        final rollsStr = _results.join(', ');
        historyText =
            '${_results.length}d${currentState.diceSides}: $rollsStr (Total: $total)';
      }

      await _ref
          .read(historyProvider.notifier)
          .addHistoryItem(historyText, historyType);
    }

    notifyListeners();
  }

  void clearResults() {
    _results = [];
    notifyListeners();
  }

  String getResultsDisplay() {
    if (_results.isEmpty) return '';

    if (_results.length == 1) {
      return '${_results.first}';
    }

    final rolls = _results.join(', ');
    return 'Rolls: [$rolls]\nTotal: $total';
  }
}
