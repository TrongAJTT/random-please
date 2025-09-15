import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';

class LatinLetterGeneratorViewModel extends ChangeNotifier {
  static const String boxName = 'latinLetterGeneratorBox';
  static const String historyType = 'latin_letter';

  late Box<LatinLetterGeneratorState> _box;
  LatinLetterGeneratorState _state = LatinLetterGeneratorState.createDefault();
  bool _isBoxOpen = false;
  bool _historyEnabled = false;
  List<GenerationHistoryItem> _historyItems = [];
  List<String> _results = [];

  // Getters
  LatinLetterGeneratorState get state => _state;
  bool get isBoxOpen => _isBoxOpen;
  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  List<String> get results => _results;

  Future<void> initHive() async {
    _box = await Hive.openBox<LatinLetterGeneratorState>(boxName);
    _state = _box.get('state') ?? LatinLetterGeneratorState.createDefault();
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

  void updateIncludeUppercase(bool value) {
    _state = _state.copyWith(includeUppercase: value);
    saveState();
    notifyListeners();
  }

  void updateIncludeLowercase(bool value) {
    _state = _state.copyWith(includeLowercase: value);
    saveState();
    notifyListeners();
  }

  void updateLetterCount(int value) {
    _state = _state.copyWith(letterCount: value);
    saveState();
    notifyListeners();
  }

  void updateAllowDuplicates(bool value) {
    _state = _state.copyWith(allowDuplicates: value);
    saveState();
    notifyListeners();
  }

  void updateSkipAnimation(bool value) {
    _state = _state.copyWith(skipAnimation: value);
    saveState();
    notifyListeners();
  }

  Future<void> generateLetters() async {
    try {
      final lettersString = RandomGenerator.generateLatinLetters(
        _state.letterCount,
        includeUppercase: _state.includeUppercase,
        includeLowercase: _state.includeLowercase,
        allowDuplicates: _state.allowDuplicates,
      );
      
      _results = lettersString.split('');

      // Save to history if enabled
      if (_historyEnabled && _results.isNotEmpty) {
        await GenerationHistoryService.addHistoryItem(
          _results.join(''),
          historyType,
        );
        await loadHistory(); // Refresh history
      }

      notifyListeners();
    } on ArgumentError {
      // Handle generation errors (e.g., invalid parameters)
      _results = [];
      notifyListeners();
      rethrow; // Let the UI handle the error display
    }
  }

  void clearResults() {
    _results = [];
    notifyListeners();
  }

  bool get hasValidSettings {
    return _state.includeUppercase || _state.includeLowercase;
  }

  String get formattedResults {
    return _results.join('');
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