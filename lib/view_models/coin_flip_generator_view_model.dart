import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/coin_flip_generator_state_provider.dart';
import 'package:random_please/providers/history_provider.dart';

class CoinFlipGeneratorViewModel extends ChangeNotifier {
  static const String historyType = 'coin_flip';

  WidgetRef? _ref;
  bool? _result; // true = heads, false = tails

  // Getters
  SimpleGeneratorState get state {
    if (_ref != null) {
      return _ref!.watch(coinFlipGeneratorStateManagerProvider);
    }
    return SimpleGeneratorState.createDefault();
  }

  bool? get result => _result;

  void setRef(WidgetRef ref) {
    _ref = ref;
  }

  void updateSkipAnimation(bool value) {
    if (_ref != null) {
      _ref!
          .read(coinFlipGeneratorStateManagerProvider.notifier)
          .updateSkipAnimation(value);
    }
    notifyListeners();
  }

  Future<void> flipCoin() async {
    final result = RandomGenerator.generateCoinFlip();
    _result = result;

    // Save to history via HistoryProvider
    if (_ref != null) {
      final resultText = result ? 'Heads' : 'Tails';
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
    return _result! ? 'Heads' : 'Tails';
  }

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
