import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'dart:math';

enum SimpleGeneratorType {
  yesNo,
  coinFlip,
  rockPaperScissors,
}

class SimpleGeneratorViewModel extends ChangeNotifier {
  final SimpleGeneratorType generatorType;

  late String boxName;
  late String historyType;

  late Box<SimpleGeneratorState> _box;
  SimpleGeneratorState _state = SimpleGeneratorState.createDefault();
  bool _isBoxOpen = false;
  bool _historyEnabled = false;
  List<GenerationHistoryItem> _historyItems = [];
  String _result = '';

  SimpleGeneratorViewModel({required this.generatorType}) {
    switch (generatorType) {
      case SimpleGeneratorType.yesNo:
        boxName = 'yesNoGeneratorBox';
        historyType = 'yesno';
        break;
      case SimpleGeneratorType.coinFlip:
        boxName = 'coinFlipGeneratorBox';
        historyType = 'coinflip';
        break;
      case SimpleGeneratorType.rockPaperScissors:
        boxName = 'rockPaperScissorsGeneratorBox';
        historyType = 'rockpaperscissors';
        break;
    }
  }

  // Getters
  SimpleGeneratorState get state => _state;
  bool get isBoxOpen => _isBoxOpen;
  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  String get result => _result;

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

  Future<void> generate() async {
    final random = Random();

    switch (generatorType) {
      case SimpleGeneratorType.yesNo:
        _result = _generateYesNo(random);
        break;
      case SimpleGeneratorType.coinFlip:
        _result = _generateCoinFlip(random);
        break;
      case SimpleGeneratorType.rockPaperScissors:
        _result = _generateRockPaperScissors(random);
        break;
    }

    // Save to history if enabled using new standardized encoding
    if (_historyEnabled && _result.isNotEmpty) {
      await GenerationHistoryService.addHistoryItems([_result], historyType);
    }

    notifyListeners();
  }

  String _generateYesNo(Random random) {
    return random.nextBool() ? 'Yes' : 'No';
  }

  String _generateCoinFlip(Random random) {
    return random.nextBool() ? 'Heads' : 'Tails';
  }

  String _generateRockPaperScissors(Random random) {
    const options = ['Rock', 'Paper', 'Scissors'];
    return options[random.nextInt(options.length)];
  }

  void clearResult() {
    _result = '';
    notifyListeners();
  }

  // Helper methods for UI
  String get generatorTitle {
    switch (generatorType) {
      case SimpleGeneratorType.yesNo:
        return 'Yes/No Generator';
      case SimpleGeneratorType.coinFlip:
        return 'Coin Flip';
      case SimpleGeneratorType.rockPaperScissors:
        return 'Rock Paper Scissors';
    }
  }

  String get generateButtonText {
    switch (generatorType) {
      case SimpleGeneratorType.yesNo:
        return 'Ask Question';
      case SimpleGeneratorType.coinFlip:
        return 'Flip Coin';
      case SimpleGeneratorType.rockPaperScissors:
        return 'Play';
    }
  }

  List<String> get possibleResults {
    switch (generatorType) {
      case SimpleGeneratorType.yesNo:
        return ['Yes', 'No'];
      case SimpleGeneratorType.coinFlip:
        return ['Heads', 'Tails'];
      case SimpleGeneratorType.rockPaperScissors:
        return ['Rock', 'Paper', 'Scissors'];
    }
  }

  IconData? get resultIcon {
    switch (generatorType) {
      case SimpleGeneratorType.yesNo:
        if (_result == 'Yes') return Icons.check_circle;
        if (_result == 'No') return Icons.cancel;
        return null;
      case SimpleGeneratorType.coinFlip:
        if (_result == 'Heads') return Icons.monetization_on;
        if (_result == 'Tails') return Icons.monetization_on_outlined;
        return null;
      case SimpleGeneratorType.rockPaperScissors:
        // Icons for rock, paper, scissors could be custom or emoji-based
        return Icons.sports_esports;
    }
  }

  Color? get resultColor {
    switch (generatorType) {
      case SimpleGeneratorType.yesNo:
        if (_result == 'Yes') return Colors.green;
        if (_result == 'No') return Colors.red;
        return null;
      case SimpleGeneratorType.coinFlip:
        return Colors.amber;
      case SimpleGeneratorType.rockPaperScissors:
        return Colors.blue;
    }
  }

  @override
  void dispose() {
    if (_isBoxOpen) {
      _box.close();
    }
    super.dispose();
  }
}
