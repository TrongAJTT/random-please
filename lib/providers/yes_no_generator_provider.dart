import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:faker/faker.dart';
import 'dart:math';

class YesNoGeneratorNotifier extends StateNotifier<YesNoGeneratorState> {
  static const String boxName = 'yesNoGeneratorBox';
  static const String historyType = 'yesno';

  late Box<YesNoGeneratorState> _box;
  bool _isBoxOpen = false;
  WidgetRef? _ref;
  CounterStatistics _counterStats =
      CounterStatistics(startTime: DateTime.now());

  YesNoGeneratorNotifier() : super(YesNoGeneratorState.createDefault()) {
    _init();
  }

  // Getters
  bool get isBoxOpen => _isBoxOpen;
  String get result => state.result;
  CounterStatistics get counterStats => _counterStats;

  void setRef(WidgetRef ref) {
    _ref = ref;
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    await initHive();
    state = state.copyWith(isLoading: false);
  }

  Future<void> initHive() async {
    _box = await Hive.openBox<YesNoGeneratorState>(boxName);
    final savedState = _box.get('state') ?? YesNoGeneratorState.createDefault();
    state = savedState;
    _isBoxOpen = true;
  }

  void saveState() {
    if (_isBoxOpen) {
      _box.put('state', state);
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
      _counterStats = CounterStatistics(startTime: DateTime.now());
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
        final result = _generateEnhancedRandomYesNo();
        results.add(result);

        // Update counter stats
        _counterStats = _counterStats.copyWith(
          totalGenerations: _counterStats.totalGenerations + 1,
          yesCount: result == 'Yes'
              ? _counterStats.yesCount + 1
              : _counterStats.yesCount,
          noCount: result == 'No'
              ? _counterStats.noCount + 1
              : _counterStats.noCount,
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
      final resultText = _generateEnhancedRandomYesNo();

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
    _counterStats = CounterStatistics(startTime: DateTime.now());
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

  /// Enhanced random Yes/No generation using multiple entropy sources
  String _generateEnhancedRandomYesNo() {
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

    // Use Faker's random boolean as additional entropy
    final fakerBool = fakerRandom.boolean();

    // Combine all sources for final decision
    final finalValue = (combinedEntropy + (fakerBool ? 500 : 0)) % 1000;

    // Return Yes/No based on combined entropy
    return finalValue < 500 ? 'Yes' : 'No';
  }
}

final yesNoGeneratorProvider =
    StateNotifierProvider<YesNoGeneratorNotifier, YesNoGeneratorState>(
  (ref) => YesNoGeneratorNotifier(),
);
