import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/providers/settings_provider.dart';
import 'package:random_please/services/settings_service.dart';
import 'package:random_please/constants/history_types.dart';
// Removed direct faker usage; EnhancedRandom handles entropy
import 'package:random_please/utils/enhanced_random.dart';

class YesNoGeneratorNotifier extends StateNotifier<YesNoGeneratorState> {
  static const String boxName = 'yesNoGeneratorBox';
  static const String counterStatsBoxName = 'yesNoCounterStatsBox';
  static const String historyType = HistoryTypes.yesNo;

  late Box<YesNoGeneratorState> _box;
  late Box<CounterStatistics> _counterStatsBox;
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
    _counterStatsBox =
        await Hive.openBox<CounterStatistics>(counterStatsBoxName);

    // Check if state saving is enabled
    final isStateSavingEnabled =
        await SettingsService.getSaveRandomToolsState();

    if (isStateSavingEnabled) {
      // Load saved state if setting is enabled
      final savedState =
          _box.get('state') ?? YesNoGeneratorState.createDefault();
      state = savedState;

      // Load saved counter stats
      final savedStats = _counterStatsBox.get('stats');
      if (savedStats != null) {
        _counterStats = savedStats;
      }
    } else {
      // Use default state if setting is disabled
      state = YesNoGeneratorState.createDefault();
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
        _counterStats = CounterStatistics(startTime: DateTime.now());
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

  /// Enhanced random Yes/No generation using shared utility (uniform 50/50)
  String _generateEnhancedRandomYesNo() {
    return EnhancedRandom.nextInt(2) == 0 ? 'Yes' : 'No';
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

      // Save counter stats after updating
      saveCounterStats();

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
}

final yesNoGeneratorProvider =
    StateNotifierProvider<YesNoGeneratorNotifier, YesNoGeneratorState>(
  (ref) => YesNoGeneratorNotifier(),
);
