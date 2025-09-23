import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/rock_paper_scissors_generator_state_provider.dart';
import 'package:random_please/providers/history_provider.dart';

class RockPaperScissorsGeneratorViewModel extends ChangeNotifier {
  static const String historyType = 'rock_paper_scissors';

  WidgetRef? _ref;
  int? _result; // 0: Rock, 1: Paper, 2: Scissors

  // Options mapping
  static const List<String> _options = ['Rock', 'Paper', 'Scissors'];

  // Getters
  SimpleGeneratorState get state {
    if (_ref != null) {
      return _ref!.watch(rockPaperScissorsGeneratorStateManagerProvider);
    }
    return SimpleGeneratorState.createDefault();
  }

  int? get result => _result;

  void setRef(WidgetRef ref) {
    _ref = ref;
  }

  void updateSkipAnimation(bool value) {
    if (_ref != null) {
      _ref!
          .read(rockPaperScissorsGeneratorStateManagerProvider.notifier)
          .updateSkipAnimation(value);
    }
    notifyListeners();
  }

  Future<void> generateChoice() async {
    final result = RandomGenerator.generateRockPaperScissors();
    _result = result;

    // Save to history via HistoryProvider
    if (_ref != null) {
      final resultText = _options[result];
      _ref!.read(historyProvider.notifier).addHistoryItem(
            resultText,
            historyType,
          );
    }

    notifyListeners();
  }

  void clearResult() {
    _result = null;
    notifyListeners();
  }

  String get formattedResult {
    if (_result == null) return '';
    return _options[_result!];
  }

  List<String> get possibleChoices => _options;

  // History management methods
  Future<void> clearAllHistory() async {
    if (_ref != null) {
      _ref!.read(historyProvider.notifier).clearHistory(historyType);
    }
  }

  Future<void> clearPinnedHistory() async {
    if (_ref != null) {
      _ref!.read(historyProvider.notifier).clearPinnedHistory(historyType);
    }
  }

  Future<void> clearUnpinnedHistory() async {
    if (_ref != null) {
      _ref!.read(historyProvider.notifier).clearUnpinnedHistory(historyType);
    }
  }

  Future<void> deleteHistoryItem(int index) async {
    if (_ref != null) {
      _ref!
          .read(historyProvider.notifier)
          .deleteHistoryItem(historyType, index);
    }
  }

  Future<void> togglePinHistoryItem(int index) async {
    if (_ref != null) {
      _ref!
          .read(historyProvider.notifier)
          .togglePinHistoryItem(historyType, index);
    }
  }

  @override
  void dispose() {
    // No longer need to close Hive box
    super.dispose();
  }
}
