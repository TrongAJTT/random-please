import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';

class CoinFlipGeneratorViewModel extends ChangeNotifier {
  static const String boxName = 'coinFlipGeneratorBox';
  static const String historyType = 'coin_flip';

  late Box<SimpleGeneratorState> _box;
  SimpleGeneratorState _state = SimpleGeneratorState.createDefault();
  bool _isBoxOpen = false;
  bool _historyEnabled = false;
  List<GenerationHistoryItem> _historyItems = [];
  bool? _result; // true = heads, false = tails

  // Getters
  SimpleGeneratorState get state => _state;
  bool get isBoxOpen => _isBoxOpen;
  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  bool? get result => _result;

  Future<void> initHive() async {
    _box = await Hive.openBox<SimpleGeneratorState>(boxName);
    _state = _box.get('state') ?? SimpleGeneratorState.createDefault();
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

  void updateSkipAnimation(bool value) {
    _state = _state.copyWith(skipAnimation: value);
    saveState();
    notifyListeners();
  }

  Future<void> flipCoin() async {
    final result = RandomGenerator.generateCoinFlip();
    _result = result;

    // Save to history if enabled
    if (_historyEnabled) {
      String resultText = result ? 'Heads' : 'Tails';
      await GenerationHistoryService.addHistoryItem(
        resultText,
        historyType,
      );
      await loadHistory(); // Refresh history
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
