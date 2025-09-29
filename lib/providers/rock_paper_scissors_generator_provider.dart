import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/providers/settings_provider.dart';
import 'package:random_please/services/settings_service.dart';
// Uses proper statistical algorithms instead of flawed averaging
import 'package:random_please/constants/history_types.dart';
import 'package:random_please/utils/standard_random_utils.dart';

class RockPaperScissorsGeneratorNotifier
    extends StateNotifier<RockPaperScissorsGeneratorState> {
  static const String boxName = 'rockPaperScissorsGeneratorBox';
  static const String counterStatsBoxName = 'rockPaperScissorsCounterStatsBox';
  static const String historyType = HistoryTypes.rockPaperScissors;

  late Box<RockPaperScissorsGeneratorState> _box;
  late Box<RockPaperScissorsCounterStatistics> _counterStatsBox;
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
    _counterStatsBox = await Hive.openBox<RockPaperScissorsCounterStatistics>(
        counterStatsBoxName);

    // Check if state saving is enabled
    final isStateSavingEnabled =
        await SettingsService.getSaveRandomToolsState();

    if (isStateSavingEnabled) {
      // Load saved state if setting is enabled
      final savedState =
          _box.get('state') ?? RockPaperScissorsGeneratorState.createDefault();
      state = savedState;

      // Load saved counter stats
      final savedStats = _counterStatsBox.get('stats');
      if (savedStats != null) {
        _counterStats = savedStats;
      }
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
        _counterStats =
            RockPaperScissorsCounterStatistics(startTime: DateTime.now());
        saveCounterStats();
      }
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

      // Save counter stats after updating
      saveCounterStats();

      final resultText = results.join(', ');

      // Save to history via HistoryProvider
      if (_ref != null && results.isNotEmpty) {
        final enabled = _ref!.read(historyEnabledProvider);
        if (enabled) {
          await _ref!
              .read(historyProvider.notifier)
              .addHistoryItems(results, historyType);
        }
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
        final enabled = _ref!.read(historyEnabledProvider);
        if (enabled) {
          await _ref!
              .read(historyProvider.notifier)
              .addHistoryItems([resultText], historyType);
        }
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
    // Save counter stats after reset
    saveCounterStats();
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
      _counterStatsBox.close();
    }
    super.dispose();
  }

  /// Enhanced random Rock Paper Scissors generation using multiple entropy sources
  String _generateEnhancedRandomRPS() {
    // Use StandardRandomUtils for uniform distribution to map 0..2 → Rock/Paper/Scissors
    final idx = StandardRandomUtils.nextInt(0, 2); // 0,1,2
    switch (idx) {
      case 0:
        return 'Rock';
      case 1:
        return 'Paper';
      default:
        return 'Scissors';
    }
  }
}

final rockPaperScissorsGeneratorProvider = StateNotifierProvider<
    RockPaperScissorsGeneratorNotifier, RockPaperScissorsGeneratorState>(
  (ref) => RockPaperScissorsGeneratorNotifier(),
);
