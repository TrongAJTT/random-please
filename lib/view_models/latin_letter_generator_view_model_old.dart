import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'dart:math';

class LatinLetterGeneratorViewModel extends ChangeNotifier {
  static const String boxName = 'latinLetterGeneratorBox';
  static const String historyType = 'latinletter';

  late Box<LatinLetterGeneratorState> _box;
  LatinLetterGeneratorState _state = LatinLetterGeneratorState.createDefault();
  bool _isBoxOpen = false;
  bool _historyEnabled = false;
  List<GenerationHistoryItem> _historyItems = [];
  List<String> _results = [];

  // Letter sets
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';

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
    String availableLetters = '';

    if (_state.includeUppercase) availableLetters += _uppercase;
    if (_state.includeLowercase) availableLetters += _lowercase;

    if (availableLetters.isEmpty) {
      _results = [];
      notifyListeners();
      return;
    }

    final random = Random();
    final Set<String> generatedSet = {};
    final List<String> resultList = [];

    for (int i = 0; i < _state.letterCount; i++) {
      String letter;
      int attempts = 0;
      const maxAttempts = 1000;

      do {
        letter = availableLetters[random.nextInt(availableLetters.length)];
        attempts++;
      } while (!_state.allowDuplicates &&
          generatedSet.contains(letter) &&
          attempts < maxAttempts);

      if (!_state.allowDuplicates) {
        generatedSet.add(letter);
      }

      resultList.add(letter);
    }

    _results = resultList;

    // Save to history if enabled
    if (_historyEnabled && _results.isNotEmpty) {
      await GenerationHistoryService.addHistoryItem(
        _results.join(', '),
        historyType,
      );
    }

    notifyListeners();
  }

  void clearResults() {
    _results = [];
    notifyListeners();
  }

  bool get hasValidSettings {
    return _state.includeUppercase || _state.includeLowercase;
  }

  int get maxPossibleLetters {
    int total = 0;
    if (_state.includeUppercase) total += _uppercase.length;
    if (_state.includeLowercase) total += _lowercase.length;
    return total;
  }

  bool get canGenerateLetters {
    if (!hasValidSettings) return false;
    if (_state.allowDuplicates) return true;
    return _state.letterCount <= maxPossibleLetters;
  }

  String get formattedResults {
    return _results.join(' ');
  }

  @override
  void dispose() {
    if (_isBoxOpen) {
      _box.close();
    }
    super.dispose();
  }
}
