import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'dart:math';

enum SimpleGeneratorType {
  yesNo,
  coinFlip,
  rockPaperScissors,
}

// Combined view state for SimpleGenerator
@immutable
class SimpleGeneratorViewState {
  final SimpleGeneratorState generatorState;
  final bool isBoxOpen;
  final bool historyEnabled;
  final List<GenerationHistoryItem> historyItems;
  final String result;

  const SimpleGeneratorViewState({
    required this.generatorState,
    required this.isBoxOpen,
    required this.historyEnabled,
    required this.historyItems,
    required this.result,
  });

  SimpleGeneratorViewState copyWith({
    SimpleGeneratorState? generatorState,
    bool? isBoxOpen,
    bool? historyEnabled,
    List<GenerationHistoryItem>? historyItems,
    String? result,
  }) {
    return SimpleGeneratorViewState(
      generatorState: generatorState ?? this.generatorState,
      isBoxOpen: isBoxOpen ?? this.isBoxOpen,
      historyEnabled: historyEnabled ?? this.historyEnabled,
      historyItems: historyItems ?? this.historyItems,
      result: result ?? this.result,
    );
  }
}

// Notifier for SimpleGenerator
class SimpleGeneratorNotifier extends StateNotifier<SimpleGeneratorViewState> {
  final SimpleGeneratorType generatorType;

  late String boxName;
  late String historyType;
  late Box<SimpleGeneratorState> _box;

  SimpleGeneratorNotifier({required this.generatorType})
      : super(SimpleGeneratorViewState(
          generatorState: SimpleGeneratorState.createDefault(),
          isBoxOpen: false,
          historyEnabled: false,
          historyItems: const [],
          result: '',
        )) {
    _initializeConfig();
  }

  void _initializeConfig() {
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

  Future<void> initHive() async {
    _box = await Hive.openBox<SimpleGeneratorState>(boxName);
    final savedState =
        _box.get('state') ?? SimpleGeneratorState.createDefault();

    state = state.copyWith(
      generatorState: savedState,
      isBoxOpen: true,
    );
  }

  Future<void> loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history = await GenerationHistoryService.getHistory(historyType);

    state = state.copyWith(
      historyEnabled: enabled,
      historyItems: history,
    );
  }

  void saveState() {
    if (state.isBoxOpen) {
      _box.put('state', state.generatorState);
    }
  }

  void updateSkipAnimation(bool value) {
    final newState = state.generatorState.copyWith(skipAnimation: value);
    state = state.copyWith(generatorState: newState);
    saveState();
  }

  Future<void> generate() async {
    final random = Random();
    String result;

    switch (generatorType) {
      case SimpleGeneratorType.yesNo:
        result = _generateYesNo(random);
        break;
      case SimpleGeneratorType.coinFlip:
        result = _generateCoinFlip(random);
        break;
      case SimpleGeneratorType.rockPaperScissors:
        result = _generateRockPaperScissors(random);
        break;
    }

    state = state.copyWith(result: result);

    // Save to history if enabled
    if (state.historyEnabled && result.isNotEmpty) {
      await GenerationHistoryService.addHistoryItem(
        result,
        historyType,
      );
      await loadHistory(); // Refresh history
    }
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

  @override
  void dispose() {
    // Close box if needed
    super.dispose();
  }
}

// Providers for each type
final yesNoGeneratorProvider =
    StateNotifierProvider<SimpleGeneratorNotifier, SimpleGeneratorViewState>(
        (ref) {
  return SimpleGeneratorNotifier(generatorType: SimpleGeneratorType.yesNo);
});

final coinFlipGeneratorProvider =
    StateNotifierProvider<SimpleGeneratorNotifier, SimpleGeneratorViewState>(
        (ref) {
  return SimpleGeneratorNotifier(generatorType: SimpleGeneratorType.coinFlip);
});

final rockPaperScissorsGeneratorProvider =
    StateNotifierProvider<SimpleGeneratorNotifier, SimpleGeneratorViewState>(
        (ref) {
  return SimpleGeneratorNotifier(
      generatorType: SimpleGeneratorType.rockPaperScissors);
});
