import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/time_generator_state_provider.dart';
import 'package:random_please/providers/history_provider.dart';
import 'dart:math';

class TimeGeneratorViewModel extends ChangeNotifier {
  static const String historyType = 'time_generator';

  final WidgetRef _ref;
  List<String> _results = [];

  TimeGeneratorViewModel(this._ref);

  // Getters
  TimeGeneratorState get state => _ref.read(timeGeneratorStateProvider);
  List<String> get results => _results;

  void updateStartHour(int value) {
    _ref.read(timeGeneratorStateProvider.notifier).updateStartHour(value);
  }

  void updateStartMinute(int value) {
    _ref.read(timeGeneratorStateProvider.notifier).updateStartMinute(value);
  }

  void updateEndHour(int value) {
    _ref.read(timeGeneratorStateProvider.notifier).updateEndHour(value);
  }

  void updateEndMinute(int value) {
    _ref.read(timeGeneratorStateProvider.notifier).updateEndMinute(value);
  }

  void updateTimeCount(int value) {
    _ref.read(timeGeneratorStateProvider.notifier).updateTimeCount(value);
  }

  void updateAllowDuplicates(bool value) {
    _ref.read(timeGeneratorStateProvider.notifier).updateAllowDuplicates(value);
  }

  Future<void> generateTimes() async {
    final currentState = state;
    final random = Random();
    final Set<String> generatedSet = {};
    final List<String> resultList = [];

    // Convert time range to minutes since midnight
    final startMinutes = currentState.startHour * 60 + currentState.startMinute;
    final endMinutes = currentState.endHour * 60 + currentState.endMinute;

    int range;
    if (endMinutes >= startMinutes) {
      range = endMinutes - startMinutes;
    } else {
      // Handle overnight range (e.g., 22:00 to 06:00)
      range = (24 * 60) - startMinutes + endMinutes;
    }

    if (range <= 0) {
      _results = [];
      notifyListeners();
      return;
    }

    for (int i = 0; i < currentState.timeCount; i++) {
      String timeStr;
      int attempts = 0;
      const maxAttempts = 1000;

      do {
        int randomMinutes = startMinutes + random.nextInt(range + 1);

        // Handle day wrap-around
        if (randomMinutes >= 24 * 60) {
          randomMinutes -= 24 * 60;
        }

        final hour = randomMinutes ~/ 60;
        final minute = randomMinutes % 60;

        timeStr = "${hour.toString().padLeft(2, '0')}:"
            "${minute.toString().padLeft(2, '0')}";
        attempts++;
      } while (!currentState.allowDuplicates &&
          generatedSet.contains(timeStr) &&
          attempts < maxAttempts);

      if (!currentState.allowDuplicates) {
        generatedSet.add(timeStr);
      }

      resultList.add(timeStr);
    }

    _results = resultList;

    // Save to history if enabled
    if (_results.isNotEmpty) {
      _ref.read(historyProvider.notifier).addHistoryItem(
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

  bool get hasValidTimeRange {
    final currentState = state;
    final startMinutes = currentState.startHour * 60 + currentState.startMinute;
    final endMinutes = currentState.endHour * 60 + currentState.endMinute;
    return startMinutes != endMinutes;
  }

  String get formattedStartTime {
    final currentState = state;
    return "${currentState.startHour.toString().padLeft(2, '0')}:"
        "${currentState.startMinute.toString().padLeft(2, '0')}";
  }

  String get formattedEndTime {
    final currentState = state;
    return "${currentState.endHour.toString().padLeft(2, '0')}:"
        "${currentState.endMinute.toString().padLeft(2, '0')}";
  }

}
