import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/services/generation_history_service.dart';

class DiceRollGeneratorViewModel extends ChangeNotifier {
  static const String boxName = 'diceRollGeneratorBox';
  static const String historyType = 'dice_roll'; // Match screen gốc

  late Box<DiceRollGeneratorState> _box;
  DiceRollGeneratorState _state = DiceRollGeneratorState.createDefault();
  bool _isBoxOpen = false;
  bool _historyEnabled = false;
  List<GenerationHistoryItem> _historyItems = [];
  List<int> _results = []; // Use List<int> like original screen
  
  // Available dice sides from original screen
  final List<int> availableSides = [
    3, 4, 5, 6, 7, 8, 10, 12, 14, 16, 20, 24, 30, 48, 50, 100
  ];

  // Getters
  DiceRollGeneratorState get state => _state;
  bool get isBoxOpen => _isBoxOpen;
  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  List<int> get results => _results;
  
  int get total => _results.fold(0, (sum, value) => sum + value);

  Future<void> initHive() async {
    _box = await Hive.openBox<DiceRollGeneratorState>(boxName);
    _state = _box.get('state') ?? DiceRollGeneratorState.createDefault();
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

  void updateDiceCount(int value) {
    _state = _state.copyWith(diceCount: value);
    saveState();
    notifyListeners();
  }

  void updateDiceSides(int value) {
    _state = _state.copyWith(diceSides: value);
    saveState();
    notifyListeners();
  }

  Future<void> rollDice() async {
    // Use RandomGenerator from original screen
    _results = RandomGenerator.generateDiceRolls(
      count: _state.diceCount,
      sides: _state.diceSides,
    );

    // Save to history if enabled (match original screen logic)
    if (_historyEnabled && _results.isNotEmpty) {
      String historyText;
      if (_results.length == 1) {
        historyText = 'd${_state.diceSides}: ${_results[0]}';
      } else {
        final rollsStr = _results.join(', ');
        historyText = '${_results.length}d${_state.diceSides}: $rollsStr (Total: $total)';
      }

      await GenerationHistoryService.addHistoryItem(
        historyText,
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

  String getResultsDisplay() {
    if (_results.isEmpty) return '';
    
    if (_results.length == 1) {
      return '${_results.first}';
    }
    
    final rolls = _results.join(', ');
    return 'Rolls: [$rolls]\nTotal: $total';
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