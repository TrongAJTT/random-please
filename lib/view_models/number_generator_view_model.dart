import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'dart:math';

class NumberGeneratorViewModel extends ChangeNotifier {
  static const String boxName = 'numberGeneratorBox';
  static const String historyType = 'number';

  late Box<NumberGeneratorState> _box;
  NumberGeneratorState _state = NumberGeneratorState.createDefault();
  bool _isBoxOpen = false;
  bool _historyEnabled = false;
  List<GenerationHistoryItem> _historyItems = [];
  List<String> _results = [];

  // Getters
  NumberGeneratorState get state => _state;
  bool get isBoxOpen => _isBoxOpen;
  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  List<String> get results => _results;

  Future<void> initHive() async {
    _box = await Hive.openBox<NumberGeneratorState>(boxName);
    _state = _box.get('state') ?? NumberGeneratorState.createDefault();
    _isBoxOpen = true;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history = await GenerationHistoryService.getHistory(historyType);
    _historyEnabled = enabled;
    _historyItems = history;
    notifyListeners();
  }

  void saveState() {
    if (_isBoxOpen) {
      _box.put('state', _state);
    }
  }

  void updateIsInteger(bool value) {
    _state = _state.copyWith(isInteger: value);
    saveState();
    notifyListeners();
  }

  void updateMinValue(double value) {
    _state = _state.copyWith(minValue: value);
    saveState();
    notifyListeners();
  }

  void updateMaxValue(double value) {
    _state = _state.copyWith(maxValue: value);
    saveState();
    notifyListeners();
  }

  void updateQuantity(int value) {
    _state = _state.copyWith(quantity: value);
    saveState();
    notifyListeners();
  }

  void updateAllowDuplicates(bool value) {
    _state = _state.copyWith(allowDuplicates: value);
    saveState();
    notifyListeners();
  }

  Future<void> generateNumbers() async {
    final random = Random();
    final Set<double> generatedSet = {};
    final List<String> resultList = [];

    for (int i = 0; i < _state.quantity; i++) {
      double value;
      int attempts = 0;
      const maxAttempts = 1000;

      do {
        if (_state.isInteger) {
          value = (random.nextInt(
                      _state.maxValue.toInt() - _state.minValue.toInt() + 1) +
                  _state.minValue.toInt())
              .toDouble();
        } else {
          value = random.nextDouble() * (_state.maxValue - _state.minValue) +
              _state.minValue;
        }
        attempts++;
      } while (!_state.allowDuplicates &&
          generatedSet.contains(value) &&
          attempts < maxAttempts);

      if (!_state.allowDuplicates) {
        generatedSet.add(value);
      }

      if (_state.isInteger) {
        resultList.add(value.toInt().toString());
      } else {
        resultList.add(value.toStringAsFixed(2));
      }
    }

    _results = resultList;

    // Save to history if enabled
    if (_historyEnabled && _results.isNotEmpty) {
      await GenerationHistoryService.addHistoryItem(
        _results.join(', '),
        historyType,
      );
      await loadHistory();
    }

    notifyListeners();
  }

  void clearResults() {
    _results = [];
    notifyListeners();
  }

  // History management methods
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

  @override
  void dispose() {
    if (_isBoxOpen) {
      _box.close();
    }
    super.dispose();
  }
}
