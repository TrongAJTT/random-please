import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/services/settings_service.dart';
import 'package:faker/faker.dart';
import 'dart:math';

class RockPaperScissorsGeneratorNotifier
    extends StateNotifier<RockPaperScissorsGeneratorState> {
  static const String boxName = 'rockPaperScissorsGeneratorBox';
  static const String historyType = 'rock_paper_scissors';

  late Box<RockPaperScissorsGeneratorState> _box;
  bool _isBoxOpen = false;
  WidgetRef? _ref;
  RockPaperScissorsCounterStatistics _counterStats =
      RockPaperScissorsCounterStatistics(startTime: DateTime.now());

  RockPaperScissorsGeneratorNotifier()
      : super(RockPaperScissorsGeneratorState.createDefault()) {
    _init();
  }

  // Getters
  bool get isBoxOpen => _isBoxOpen;
  String get result => state.result;
  RockPaperScissorsCounterStatistics get counterStats => _counterStats;

  void setRef(WidgetRef ref) {
    _ref = ref;
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    await initHive();
    state = state.copyWith(isLoading: false);
  }

  Future<void> initHive() async {
    _box = await Hive.openBox<RockPaperScissorsGeneratorState>(boxName);

    // Check if state saving is enabled
    final isStateSavingEnabled =
        await SettingsService.getSaveRandomToolsState();

    if (isStateSavingEnabled) {
      // Load saved state if setting is enabled
      final savedState =
          _box.get('state') ?? RockPaperScissorsGeneratorState.createDefault();
      state = savedState;
    } else {
      // Use default state if setting is disabled
      state = RockPaperScissorsGeneratorState.createDefault();
    }

    _isBoxOpen = true;
  }

  void saveState() async {
    if (_isBoxOpen) {
      // Check if state saving is enabled
      final isStateSavingEnabled =
          await SettingsService.getSaveRandomToolsState();

      if (isStateSavingEnabled) {
        await _box.put('state', state);
      }
    }
  }

  void updateSkipAnimation(bool value) {
    state = state.copyWith(skipAnimation: value);
    saveState();
  }

  void updateCounterMode(bool value) {
    state = state.copyWith(counterMode: value);
    // Only save state if not in counter mode (as per requirement)
    if (!value) {
      saveState();
    }

    // Reset counter stats when enabling counter mode
    if (value) {
      _counterStats =
          RockPaperScissorsCounterStatistics(startTime: DateTime.now());
    }
  }

  void updateBatchCount(int value) {
    state = state.copyWith(batchCount: value);
    // Only save state if not in counter mode (as per requirement)
    if (!state.counterMode) {
      saveState();
    }
  }

  Future<void> generate() async {
    if (state.counterMode) {
      // Generate batch of results
      final results = <String>[];
      for (int i = 0; i < state.batchCount; i++) {
        final result = _generateEnhancedRandomRPS();
        results.add(result);

        // Update counter stats
        _counterStats = _counterStats.copyWith(
          totalGenerations: _counterStats.totalGenerations + 1,
          rockCount: result == 'Rock'
              ? _counterStats.rockCount + 1
              : _counterStats.rockCount,
          paperCount: result == 'Paper'
              ? _counterStats.paperCount + 1
              : _counterStats.paperCount,
          scissorsCount: result == 'Scissors'
              ? _counterStats.scissorsCount + 1
              : _counterStats.scissorsCount,
        );
      }

      final resultText = results.join(', ');

      // Save to history via HistoryProvider
      if (_ref != null && results.isNotEmpty) {
        await _ref!
            .read(historyProvider.notifier)
            .addHistoryItems(results, historyType);
      }

      // Update state with result
      state = state.copyWith(result: resultText);

      // Save state to persist result (regardless of counter mode)
      saveState();
    } else {
      // Generate single result
      final resultText = _generateEnhancedRandomRPS();

      // Save to history via HistoryProvider
      if (_ref != null && resultText.isNotEmpty) {
        await _ref!
            .read(historyProvider.notifier)
            .addHistoryItems([resultText], historyType);
      }

      // Update state with result
      state = state.copyWith(result: resultText);

      // Save state to persist result
      saveState();
    }
  }

  void clearResult() {
    state = state.copyWith(result: '');
  }

  void resetCounter() {
    _counterStats =
        RockPaperScissorsCounterStatistics(startTime: DateTime.now());
    // Trigger UI refresh by updating state
    state = state.copyWith();
  }

  // History management methods
  Future<void> clearAllHistory() async {
    if (_ref != null) {
      await _ref!.read(historyProvider.notifier).clearHistory(historyType);
    }
  }

  @override
  void dispose() {
    if (_isBoxOpen) {
      _box.close();
    }
    super.dispose();
  }

  /// Enhanced random Rock Paper Scissors generation using multiple entropy sources
  String _generateEnhancedRandomRPS() {
    // Multiple entropy sources for better randomness
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fakerRandom = faker.randomGenerator;

    // Combine multiple random sources
    final entropy1 = random.nextInt(1000);
    final entropy2 = timestamp % 1000;
    final entropy3 = fakerRandom.integer(1000);
    final entropy4 = fakerRandom.decimal(scale: 3).toInt();

    // Create weighted random using multiple sources
    final combinedEntropy = (entropy1 + entropy2 + entropy3 + entropy4) % 1000;

    // Use Faker's random integer as additional entropy
    final fakerInt = fakerRandom.integer(3); // 0, 1, or 2

    // Combine all sources for final decision
    final finalValue = (combinedEntropy + (fakerInt * 333)) % 1000;

    // Return Rock/Paper/Scissors based on combined entropy
    if (finalValue < 333) {
      return 'Rock';
    } else if (finalValue < 666) {
      return 'Paper';
    } else {
      return 'Scissors';
    }
  }
}

final rockPaperScissorsGeneratorProvider = StateNotifierProvider<
    RockPaperScissorsGeneratorNotifier, RockPaperScissorsGeneratorState>(
  (ref) => RockPaperScissorsGeneratorNotifier(),
);
