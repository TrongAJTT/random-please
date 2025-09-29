import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/providers/settings_provider.dart';
import 'package:random_please/services/settings_service.dart';
import 'package:random_please/constants/history_types.dart';
import 'package:faker/faker.dart';
import 'dart:math';

class CoinFlipGeneratorNotifier extends StateNotifier<CoinFlipGeneratorState> {
  static const String boxName = 'coinFlipGeneratorBox';
  static const String counterStatsBoxName = 'coinFlipCounterStatsBox';
  static const String historyType = HistoryTypes.coinFlip;

  late Box<CoinFlipGeneratorState> _box;
  late Box<CoinFlipCounterStatistics> _counterStatsBox;
  bool _isBoxOpen = false;
  WidgetRef? _ref;
  CoinFlipCounterStatistics _counterStats =
      CoinFlipCounterStatistics(startTime: DateTime.now());

  CoinFlipGeneratorNotifier() : super(CoinFlipGeneratorState.createDefault()) {
    _init();
  }

  // Getters
  bool get isBoxOpen => _isBoxOpen;
  String get result => state.result;
  CoinFlipCounterStatistics get counterStats => _counterStats;

  void setRef(WidgetRef ref) {
    _ref = ref;
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    await initHive();
    state = state.copyWith(isLoading: false);
  }

  Future<void> initHive() async {
    _box = await Hive.openBox<CoinFlipGeneratorState>(boxName);
    _counterStatsBox =
        await Hive.openBox<CoinFlipCounterStatistics>(counterStatsBoxName);

    // Check if state saving is enabled
    final isStateSavingEnabled =
        await SettingsService.getSaveRandomToolsState();

    if (isStateSavingEnabled) {
      // Load saved state if setting is enabled
      final savedState =
          _box.get('state') ?? CoinFlipGeneratorState.createDefault();
      state = savedState;

      // Load saved counter stats
      final savedStats = _counterStatsBox.get('stats');
      if (savedStats != null) {
        _counterStats = savedStats;
      }
    } else {
      // Use default state if setting is disabled
      state = CoinFlipGeneratorState.createDefault();
    }

    _isBoxOpen = true;
  }

  Future<void> saveState() async {
    if (_isBoxOpen) {
      // Check if state saving is enabled
      final isStateSavingEnabled =
          await SettingsService.getSaveRandomToolsState();

      if (isStateSavingEnabled) {
        await _box.put('state', state);
      }
    }
  }

  void saveCounterStats() async {
    if (_isBoxOpen) {
      // Check if state saving is enabled
      final isStateSavingEnabled =
          await SettingsService.getSaveRandomToolsState();

      if (isStateSavingEnabled) {
        await _counterStatsBox.put('stats', _counterStats);
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

    // Check if should reset counter when toggling counter mode
    if (_ref != null) {
      final resetOnToggle = _ref!.read(resetCounterOnToggleProvider);
      if (resetOnToggle) {
        _counterStats = CoinFlipCounterStatistics(startTime: DateTime.now());
        saveCounterStats();
      }
    }
  }

  void updateBatchCount(int value) {
    state = state.copyWith(batchCount: value);
    saveState();
  }

  Future<void> generate() async {
    if (state.counterMode) {
      // Generate batch of results
      final results = <String>[];
      for (int i = 0; i < state.batchCount; i++) {
        final result = _generateEnhancedRandomCoinFlip();
        results.add(result);

        // Update counter stats
        _counterStats = _counterStats.copyWith(
          totalGenerations: _counterStats.totalGenerations + 1,
          headsCount: result == 'Heads'
              ? _counterStats.headsCount + 1
              : _counterStats.headsCount,
          tailsCount: result == 'Tails'
              ? _counterStats.tailsCount + 1
              : _counterStats.tailsCount,
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
      final resultText = _generateEnhancedRandomCoinFlip();

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
    _counterStats = CoinFlipCounterStatistics(startTime: DateTime.now());
    // Trigger UI refresh by updating state
    state = state.copyWith();
  }

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

  /// Enhanced random Coin Flip generation using multiple entropy sources
  String _generateEnhancedRandomCoinFlip() {
    // Multiple entropy sources for better randomness
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fakerRandom = faker.randomGenerator;

    // Generate three independent random values from different sources
    final fakerValue = fakerRandom.integer(1000);
    final dartValue = random.nextInt(1000);

    // Use timestamp-based seed for additional randomness
    final timestampSeed = timestamp % 1000;
    final timestampRandom = Random(timestampSeed);
    final timestampValue = timestampRandom.nextInt(1000);

    // Combine all three sources using weighted average
    final combinedValue = (fakerValue + dartValue + timestampValue) % 1000;

    // Return Heads/Tails based on combined value (50/50 distribution)
    return combinedValue < 500 ? 'Heads' : 'Tails';
  }
}

final coinFlipGeneratorProvider =
    StateNotifierProvider<CoinFlipGeneratorNotifier, CoinFlipGeneratorState>(
  (ref) => CoinFlipGeneratorNotifier(),
);
