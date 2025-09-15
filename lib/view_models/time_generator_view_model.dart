import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'dart:math';

class TimeGeneratorViewModel extends ChangeNotifier {
  static const String boxName = 'timeGeneratorBox';
  static const String historyType = 'time';

  late Box<TimeGeneratorState> _box;
  TimeGeneratorState _state = TimeGeneratorState.createDefault();
  bool _isBoxOpen = false;
  bool _historyEnabled = false;
  List<GenerationHistoryItem> _historyItems = [];
  List<String> _results = [];

  // Getters
  TimeGeneratorState get state => _state;
  bool get isBoxOpen => _isBoxOpen;
  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  List<String> get results => _results;

  Future<void> initHive() async {
    _box = await Hive.openBox<TimeGeneratorState>(boxName);
    _state = _box.get('state') ?? TimeGeneratorState.createDefault();
    _isBoxOpen = true;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history = await GenerationHistoryService.getHistory(historyType);
    _historyEnabled = enabled;
    _historyItems = history;
    notifyListeners();
  }

  void saveState() {
    if (_isBoxOpen) {
      _box.put('state', _state);
    }
  }

  void updateStartHour(int value) {
    _state = _state.copyWith(startHour: value);
    saveState();
    notifyListeners();
  }

  void updateStartMinute(int value) {
    _state = _state.copyWith(startMinute: value);
    saveState();
    notifyListeners();
  }

  void updateEndHour(int value) {
    _state = _state.copyWith(endHour: value);
    saveState();
    notifyListeners();
  }

  void updateEndMinute(int value) {
    _state = _state.copyWith(endMinute: value);
    saveState();
    notifyListeners();
  }

  void updateTimeCount(int value) {
    _state = _state.copyWith(timeCount: value);
    saveState();
    notifyListeners();
  }

  void updateAllowDuplicates(bool value) {
    _state = _state.copyWith(allowDuplicates: value);
    saveState();
    notifyListeners();
  }

  Future<void> generateTimes() async {
    final random = Random();
    final Set<String> generatedSet = {};
    final List<String> resultList = [];

    // Convert time range to minutes since midnight
    final startMinutes = _state.startHour * 60 + _state.startMinute;
    final endMinutes = _state.endHour * 60 + _state.endMinute;

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

    for (int i = 0; i < _state.timeCount; i++) {
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
      } while (!_state.allowDuplicates &&
          generatedSet.contains(timeStr) &&
          attempts < maxAttempts);

      if (!_state.allowDuplicates) {
        generatedSet.add(timeStr);
      }

      resultList.add(timeStr);
    }

    _results = resultList;

    // Save to history if enabled
    if (_historyEnabled && _results.isNotEmpty) {
      await GenerationHistoryService.addHistoryItem(
        _results.join(', '),
        historyType,
      );
    }

    await loadHistory();
    notifyListeners();
  }

  void clearResults() {
    _results = [];
    notifyListeners();
  }

  bool get hasValidTimeRange {
    final startMinutes = _state.startHour * 60 + _state.startMinute;
    final endMinutes = _state.endHour * 60 + _state.endMinute;
    return startMinutes != endMinutes;
  }

  String get formattedStartTime {
    return "${_state.startHour.toString().padLeft(2, '0')}:"
        "${_state.startMinute.toString().padLeft(2, '0')}";
  }

  String get formattedEndTime {
    return "${_state.endHour.toString().padLeft(2, '0')}:"
        "${_state.endMinute.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    if (_isBoxOpen) {
      _box.close();
    }
    super.dispose();
  }
}
