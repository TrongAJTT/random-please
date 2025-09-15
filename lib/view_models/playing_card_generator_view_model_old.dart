import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'dart:math';

class PlayingCard {
  final String suit;
  final String rank;
  final bool isJoker;

  PlayingCard({required this.suit, required this.rank, this.isJoker = false});

  @override
  String toString() {
    if (isJoker) {
      return rank; // "Red Joker" or "Black Joker"
    }
    return '$rank of $suit';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayingCard &&
          runtimeType == other.runtimeType &&
          suit == other.suit &&
          rank == other.rank &&
          isJoker == other.isJoker;

  @override
  int get hashCode => suit.hashCode ^ rank.hashCode ^ isJoker.hashCode;
}

class PlayingCardGeneratorViewModel extends ChangeNotifier {
  static const String boxName = 'playingCardGeneratorBox';
  static const String historyType = 'playingcard';

  late Box<PlayingCardGeneratorState> _box;
  PlayingCardGeneratorState _state = PlayingCardGeneratorState.createDefault();
  bool _isBoxOpen = false;
  bool _historyEnabled = false;
  List<GenerationHistoryItem> _historyItems = [];
  List<PlayingCard> _results = [];

  // Card definitions
  static const List<String> _suits = ['Hearts', 'Diamonds', 'Clubs', 'Spades'];
  static const List<String> _ranks = [
    'A',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    'J',
    'Q',
    'K'
  ];
  static const List<String> _jokers = ['Red Joker', 'Black Joker'];

  // Getters
  PlayingCardGeneratorState get state => _state;
  bool get isBoxOpen => _isBoxOpen;
  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  List<PlayingCard> get results => _results;

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
    final random = Random();
    final Set<PlayingCard> generatedSet = {};
    final List<PlayingCard> resultList = [];

    // Create deck
    final List<PlayingCard> deck = [];

    // Add regular cards
    for (String suit in _suits) {
      for (String rank in _ranks) {
        deck.add(PlayingCard(suit: suit, rank: rank));
      }
    }

    // Add jokers if included
    if (_state.includeJokers) {
      for (String joker in _jokers) {
        deck.add(PlayingCard(suit: '', rank: joker, isJoker: true));
      }
    }

    if (deck.isEmpty) {
      _results = [];
      notifyListeners();
      return;
    }

    for (int i = 0; i < _state.cardCount; i++) {
      PlayingCard card;
      int attempts = 0;
      const maxAttempts = 1000;

      do {
        card = deck[random.nextInt(deck.length)];
        attempts++;
      } while (!_state.allowDuplicates &&
          generatedSet.contains(card) &&
          attempts < maxAttempts);

      if (!_state.allowDuplicates) {
        generatedSet.add(card);
      }

      resultList.add(card);
    }

    _results = resultList;

    // Save to history if enabled
    if (_historyEnabled && _results.isNotEmpty) {
      await GenerationHistoryService.addHistoryItem(
        _results.map((card) => card.toString()).join(', '),
        historyType,
      );
    }

    notifyListeners();
  }

  void clearResults() {
    _results = [];
    notifyListeners();
  }

  int get maxPossibleCards {
    int standardCards = _suits.length * _ranks.length; // 52
    int jokerCards = _state.includeJokers ? _jokers.length : 0; // 0 or 2
    return standardCards + jokerCards;
  }

  bool get canGenerateCards {
    if (_state.allowDuplicates) return true;
    return _state.cardCount <= maxPossibleCards;
  }

  @override
  void dispose() {
    if (_isBoxOpen) {
      _box.close();
    }
    super.dispose();
  }
}
