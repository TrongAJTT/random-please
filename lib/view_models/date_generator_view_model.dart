import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/date_generator_state_provider.dart';
import 'package:random_please/providers/history_provider.dart';
import 'dart:math';

class DateGeneratorViewModel extends ChangeNotifier {
  static const String historyType = 'date_generator';

  WidgetRef? _ref;
  List<String> _results = [];

  // Getters
  DateGeneratorState get state {
    if (_ref != null) {
      return _ref!.watch(dateGeneratorStateManagerProvider);
    }
    return DateGeneratorState.createDefault();
  }

  List<String> get results => _results;

  void setRef(WidgetRef ref) {
    _ref = ref;
  }

  void updateStartDate(DateTime value) {
    if (_ref != null) {
      _ref!
          .read(dateGeneratorStateManagerProvider.notifier)
          .updateStartDate(value);
    }
    notifyListeners();
  }

  void updateEndDate(DateTime value) {
    if (_ref != null) {
      _ref!
          .read(dateGeneratorStateManagerProvider.notifier)
          .updateEndDate(value);
    }
    notifyListeners();
  }

  void updateDateCount(int value) {
    if (_ref != null) {
      _ref!
          .read(dateGeneratorStateManagerProvider.notifier)
          .updateDateCount(value);
    }
    notifyListeners();
  }

  void updateAllowDuplicates(bool value) {
    if (_ref != null) {
      _ref!
          .read(dateGeneratorStateManagerProvider.notifier)
          .updateAllowDuplicates(value);
    }
    notifyListeners();
  }

  Future<void> generateDates() async {
    final currentState = state;
    final random = Random();
    final Set<DateTime> generatedSet = {};
    final List<String> resultList = [];

    final startDate = DateTime(currentState.startDate.year,
        currentState.startDate.month, currentState.startDate.day);
    final endDate = DateTime(currentState.endDate.year,
        currentState.endDate.month, currentState.endDate.day);
    final totalDays = endDate.difference(startDate).inDays;

    if (totalDays < 0) {
      _results = [];
      notifyListeners();
      return;
    }

    for (int i = 0; i < currentState.dateCount; i++) {
      DateTime date;
      int attempts = 0;
      const maxAttempts = 1000;

      do {
        final randomDay = random.nextInt(totalDays + 1);
        date = startDate.add(Duration(days: randomDay));
        attempts++;
      } while (!currentState.allowDuplicates &&
          generatedSet.contains(date) &&
          attempts < maxAttempts);

      if (!currentState.allowDuplicates) {
        generatedSet.add(date);
      }

      // Format date as YYYY-MM-DD
      final dateStr = "${date.year.toString().padLeft(4, '0')}-"
          "${date.month.toString().padLeft(2, '0')}-"
          "${date.day.toString().padLeft(2, '0')}";
      resultList.add(dateStr);
    }

    _results = resultList;

    // Save to history via HistoryProvider
    if (_ref != null && _results.isNotEmpty) {
      _ref!.read(historyProvider.notifier).addHistoryItem(
            _results.join(', '),
            historyType,
          );
    }

    notifyListeners();
  }

  void clearResults() {
    _results = [];
    notifyListeners();
  }

  bool get hasValidDateRange {
    final currentState = state;
    return currentState.endDate.isAfter(currentState.startDate);
  }

  // History management methods
  Future<void> clearAllHistory() async {
    if (_ref != null) {
      _ref!.read(historyProvider.notifier).clearHistory(historyType);
    }
  }

  Future<void> clearPinnedHistory() async {
    if (_ref != null) {
      _ref!.read(historyProvider.notifier).clearPinnedHistory(historyType);
    }
  }

  Future<void> clearUnpinnedHistory() async {
    if (_ref != null) {
      _ref!.read(historyProvider.notifier).clearUnpinnedHistory(historyType);
    }
  }

  Future<void> deleteHistoryItem(int index) async {
    if (_ref != null) {
      _ref!
          .read(historyProvider.notifier)
          .deleteHistoryItem(historyType, index);
    }
  }

  Future<void> togglePinHistoryItem(int index) async {
    if (_ref != null) {
      _ref!
          .read(historyProvider.notifier)
          .togglePinHistoryItem(historyType, index);
    }
  }

  @override
  void dispose() {
    // No longer need to close Hive box
    super.dispose();
  }
}
