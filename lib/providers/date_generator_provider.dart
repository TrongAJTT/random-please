import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'dart:math';

// Combined view state for DateGenerator
@immutable
class DateGeneratorViewState {
  final DateGeneratorState generatorState;
  final bool isBoxOpen;
  final bool historyEnabled;
  final List<GenerationHistoryItem> historyItems;
  final List<String> results;

  const DateGeneratorViewState({
    required this.generatorState,
    required this.isBoxOpen,
    required this.historyEnabled,
    required this.historyItems,
    required this.results,
  });

  DateGeneratorViewState copyWith({
    DateGeneratorState? generatorState,
    bool? isBoxOpen,
    bool? historyEnabled,
    List<GenerationHistoryItem>? historyItems,
    List<String>? results,
  }) {
    return DateGeneratorViewState(
      generatorState: generatorState ?? this.generatorState,
      isBoxOpen: isBoxOpen ?? this.isBoxOpen,
      historyEnabled: historyEnabled ?? this.historyEnabled,
      historyItems: historyItems ?? this.historyItems,
      results: results ?? this.results,
    );
  }

  bool get hasValidDateRange {
    return generatorState.endDate.isAfter(generatorState.startDate);
  }
}

// Notifier for DateGenerator
class DateGeneratorNotifier extends StateNotifier<DateGeneratorViewState> {
  static const String boxName = 'dateGeneratorBox';
  static const String historyType = 'date';

  late Box<DateGeneratorState> _box;

  DateGeneratorNotifier()
      : super(DateGeneratorViewState(
          generatorState: DateGeneratorState.createDefault(),
          isBoxOpen: false,
          historyEnabled: false,
          historyItems: const [],
          results: const [],
        )) {
    _init();
  }

  Future<void> _init() async {
    await initHive();
    await loadHistory();
  }

  Future<void> initHive() async {
    _box = await Hive.openBox<DateGeneratorState>(boxName);
    final savedState = _box.get('state') ?? DateGeneratorState.createDefault();
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

  void updateStartDate(DateTime value) {
    final newState = state.generatorState.copyWith(startDate: value);
    state = state.copyWith(generatorState: newState);
    saveState();
  }

  void updateEndDate(DateTime value) {
    final newState = state.generatorState.copyWith(endDate: value);
    state = state.copyWith(generatorState: newState);
    saveState();
  }

  void updateDateCount(int value) {
    final newState = state.generatorState.copyWith(dateCount: value);
    state = state.copyWith(generatorState: newState);
    saveState();
  }

  void updateAllowDuplicates(bool value) {
    final newState = state.generatorState.copyWith(allowDuplicates: value);
    state = state.copyWith(generatorState: newState);
    saveState();
  }

  Future<void> generateDates() async {
    final random = Random();
    final Set<DateTime> generatedSet = {};
    final List<String> resultList = [];

    final startDate = DateTime(
        state.generatorState.startDate.year,
        state.generatorState.startDate.month,
        state.generatorState.startDate.day);
    final endDate = DateTime(state.generatorState.endDate.year,
        state.generatorState.endDate.month, state.generatorState.endDate.day);
    final totalDays = endDate.difference(startDate).inDays;

    if (totalDays < 0) {
      state = state.copyWith(results: []);
      return;
    }

    for (int i = 0; i < state.generatorState.dateCount; i++) {
      DateTime date;
      int attempts = 0;
      const maxAttempts = 1000;

      do {
        final randomDay = random.nextInt(totalDays + 1);
        date = startDate.add(Duration(days: randomDay));
        attempts++;
      } while (!state.generatorState.allowDuplicates &&
          generatedSet.contains(date) &&
          attempts < maxAttempts);

      if (!state.generatorState.allowDuplicates) {
        generatedSet.add(date);
      }

      // Format date as YYYY-MM-DD
      final dateStr = "${date.year.toString().padLeft(4, '0')}-"
          "${date.month.toString().padLeft(2, '0')}-"
          "${date.day.toString().padLeft(2, '0')}";
      resultList.add(dateStr);
    }

    state = state.copyWith(results: resultList);

    // Save to history if enabled using new standardized encoding
    if (state.historyEnabled && state.results.isNotEmpty) {
      await GenerationHistoryService.addHistoryItems(
          state.results, historyType);
      await loadHistory();
    }
  }

  void clearResults() {
    state = state.copyWith(results: []);
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
}

// Provider for DateGenerator
final dateGeneratorProvider =
    StateNotifierProvider<DateGeneratorNotifier, DateGeneratorViewState>(
  (ref) => DateGeneratorNotifier(),
);
