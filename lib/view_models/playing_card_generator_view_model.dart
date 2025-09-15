import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/services/generation_history_service.dart';

class PlayingCardGeneratorViewModel extends ChangeNotifier {
  static const String boxName = 'playingCardGeneratorBox';
  static const String historyType = 'playing_cards'; // Match screen gốc

  late Box<PlayingCardGeneratorState> _box;
  PlayingCardGeneratorState _state = PlayingCardGeneratorState.createDefault();
  bool _isBoxOpen = false;
  bool _historyEnabled = false;
  List<GenerationHistoryItem> _historyItems = [];
  List<PlayingCard> _generatedCards = []; // Use PlayingCard from RandomGenerator

  // Getters
  PlayingCardGeneratorState get state => _state;
  bool get isBoxOpen => _isBoxOpen;
  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  List<PlayingCard> get generatedCards => _generatedCards;

  Future<void> initHive() async {
    _box = await Hive.openBox<PlayingCardGeneratorState>(boxName);
    _state = _box.get('state') ?? PlayingCardGeneratorState.createDefault();
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

  void updateIncludeJokers(bool value) {
    _state = _state.copyWith(includeJokers: value);
    saveState();
    notifyListeners();
  }

  void updateCardCount(int value) {
    _state = _state.copyWith(cardCount: value);
    saveState();
    notifyListeners();
  }

  void updateAllowDuplicates(bool value) {
    _state = _state.copyWith(allowDuplicates: value);
    saveState();
    notifyListeners();
  }

  Future<void> generateCards() async {
    try {
      // Use RandomGenerator like original screen
      _generatedCards = RandomGenerator.generatePlayingCards(
        count: _state.cardCount,
        includeJokers: _state.includeJokers,
        allowDuplicates: _state.allowDuplicates,
      );

      // Save to history if enabled (match original screen logic)
      if (_historyEnabled && _generatedCards.isNotEmpty) {
        final cardStrings = _generatedCards.map((card) => card.toString()).toList();
        await GenerationHistoryService.addHistoryItem(
          cardStrings.join(', '),
          historyType,
        );
        await loadHistory();
      }

      notifyListeners();
    } catch (e) {
      _generatedCards = [];
      notifyListeners();
      rethrow;
    }
  }

  void clearCards() {
    _generatedCards = [];
    notifyListeners();
  }

  String getCardsDisplay() {
    if (_generatedCards.isEmpty) return '';
    return _generatedCards.map((card) => card.toString()).join('\n');
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