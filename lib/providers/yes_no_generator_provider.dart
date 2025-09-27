import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/history_provider.dart';
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
    await initHive();
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
    final random = Random();

    if (state.counterMode) {
      // Generate batch of results
      final results = <String>[];
      for (int i = 0; i < state.batchCount; i++) {
        final result = random.nextBool() ? 'Yes' : 'No';
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
      final resultText = random.nextBool() ? 'Yes' : 'No';

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
}

final yesNoGeneratorProvider =
    StateNotifierProvider<YesNoGeneratorNotifier, YesNoGeneratorState>(
  (ref) => YesNoGeneratorNotifier(),
);
