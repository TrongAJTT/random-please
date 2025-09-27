import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/models/random_models/random_state_models.dart'
    as models;
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/providers/number_generator_state_provider.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'dart:math';

// Temporary wrapper to maintain compatibility
class NumberGeneratorViewModel extends ChangeNotifier {
  static const String historyType = 'number';
  final WidgetRef? _ref;

  NumberGeneratorViewModel({WidgetRef? ref}) : _ref = ref;

  List<String> _results = [];
  List<GenerationHistoryItem> _historyItems = [];
  bool _historyEnabled = false;

  // Getters - now delegate to state manager
  models.NumberGeneratorState get state {
    if (_ref != null) {
      return _ref!.read(numberGeneratorStateManagerProvider);
    }
    return models.NumberGeneratorState.createDefault();
  }

  List<String> get results => _results;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  bool get historyEnabled => _historyEnabled;

  Future<void> initHive() async {
    _historyEnabled = await GenerationHistoryService.isHistoryEnabled();
    notifyListeners();
  }

  Future<void> loadHistory() async {
    _historyItems = await GenerationHistoryService.getHistory(historyType);
    notifyListeners();
  }

  void updateMinValue(double value) {
    if (_ref != null) {
      _ref!
          .read(numberGeneratorStateManagerProvider.notifier)
          .updateMinValue(value);
    }
    notifyListeners();
  }

  void updateMaxValue(double value) {
    if (_ref != null) {
      _ref!
          .read(numberGeneratorStateManagerProvider.notifier)
          .updateMaxValue(value);
    }
    notifyListeners();
  }

  void updateQuantity(int value) {
    if (_ref != null) {
      _ref!
          .read(numberGeneratorStateManagerProvider.notifier)
          .updateQuantity(value);
    }
    notifyListeners();
  }

  void updateIsInteger(bool value) {
    if (_ref != null) {
      _ref!
          .read(numberGeneratorStateManagerProvider.notifier)
          .updateIsInteger(value);
    }
    notifyListeners();
  }

  void updateAllowDuplicates(bool value) {
    if (_ref != null) {
      _ref!
          .read(numberGeneratorStateManagerProvider.notifier)
          .updateAllowDuplicates(value);
    }
    notifyListeners();
  }

  Future<void> generateNumbers() async {
    notifyListeners();

    try {
      final currentState = state; // Get current state
      final random = Random();
      final results = <String>[];

      for (int i = 0; i < currentState.quantity; i++) {
        if (currentState.isInteger) {
          int result = currentState.minValue.toInt() +
              random.nextInt(currentState.maxValue.toInt() -
                  currentState.minValue.toInt() +
                  1);
          results.add(result.toString());
        } else {
          double result = currentState.minValue +
              random.nextDouble() *
                  (currentState.maxValue - currentState.minValue);
          results.add(result.toStringAsFixed(2));
        }

        // Handle duplicates if not allowed
        if (!currentState.allowDuplicates &&
            results.length != results.toSet().length) {
          results.removeLast();
          i--;
        }
      }

      _results = results;

      // Save state khi generate (chỉ khi setting được bật)
      if (_ref != null) {
        await _ref!
            .read(numberGeneratorStateManagerProvider.notifier)
            .saveStateOnGenerate();
      }

      // Save to history using new standardized encoding
      if (_historyEnabled) {
        if (_ref != null) {
          await _ref!
              .read(historyProvider.notifier)
              .addHistoryItems(results, historyType);
        } else {
          await GenerationHistoryService.addHistoryItems(results, historyType);
          await loadHistory();
        }
      }

      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  Future<void> clearAllHistory() async {
    await GenerationHistoryService.clearHistory(historyType);
    await loadHistory();
  }

  Future<void> clearPinnedHistory() async {
    await GenerationHistoryService.clearPinnedHistory(historyType);
    await loadHistory();
  }

  Future<void> clearUnpinnedHistory() async {
    await GenerationHistoryService.clearUnpinnedHistory(historyType);
    await loadHistory();
  }

  Future<void> deleteHistoryItem(int index) async {
    await GenerationHistoryService.deleteHistoryItem(historyType, index);
    await loadHistory();
  }

  Future<void> togglePinHistoryItem(int index) async {
    await GenerationHistoryService.togglePinHistoryItem(historyType, index);
    await loadHistory();
  }
}
