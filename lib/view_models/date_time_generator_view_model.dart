import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'dart:math';

class DateTimeGeneratorViewModel extends ChangeNotifier {
  static const String boxName = 'dateTimeGeneratorBox';
  static const String historyType = 'datetime';

  late Box<DateTimeGeneratorState> _box;
  DateTimeGeneratorState _state = DateTimeGeneratorState.createDefault();
  bool _isBoxOpen = false;
  bool _historyEnabled = false;
  List<GenerationHistoryItem> _historyItems = [];
  List<String> _results = [];

  // Getters
  DateTimeGeneratorState get state => _state;
  bool get isBoxOpen => _isBoxOpen;
  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  List<String> get results => _results;

  Future<void> initHive() async {
    _box = await Hive.openBox<DateTimeGeneratorState>(boxName);
    _state = _box.get('state') ?? DateTimeGeneratorState.createDefault();
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

  void updateStartDateTime(DateTime value) {
    _state = _state.copyWith(startDateTime: value);
    saveState();
    notifyListeners();
  }

  void updateEndDateTime(DateTime value) {
    _state = _state.copyWith(endDateTime: value);
    saveState();
    notifyListeners();
  }

  void updateDateTimeCount(int value) {
    _state = _state.copyWith(dateTimeCount: value);
    saveState();
    notifyListeners();
  }

  void updateAllowDuplicates(bool value) {
    _state = _state.copyWith(allowDuplicates: value);
    saveState();
    notifyListeners();
  }

  Future<void> generateDateTimes() async {
    final random = Random();
    final Set<DateTime> generatedSet = {};
    final List<String> resultList = [];

    final start = _state.startDateTime;
    final end = _state.endDateTime;
    final startDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);
    final totalDays = endDate.difference(startDate).inDays;

    if (totalDays < 0) {
      _results = [];
      notifyListeners();
      return;
    }

    for (int i = 0; i < _state.dateTimeCount; i++) {
      DateTime dateTime;
      int attempts = 0;
      const maxAttempts = 1000;

      do {
        // Random day in range
        final randomDay = random.nextInt(totalDays + 1);
        final date = startDate.add(Duration(days: randomDay));

        // Random time in day
        int minSec = 0;
        int maxSec = 86399; // 24*60*60 - 1
        // If at start or end day, restrict time
        if (date.isAtSameMomentAs(startDate)) {
          minSec = start.hour * 3600 + start.minute * 60 + start.second;
        }
        if (date.isAtSameMomentAs(endDate)) {
          maxSec = end.hour * 3600 + end.minute * 60 + end.second;
        }
        int randomSec = minSec +
            (maxSec > minSec ? random.nextInt(maxSec - minSec + 1) : 0);
        final hour = randomSec ~/ 3600;
        final minute = (randomSec % 3600) ~/ 60;
        final second = randomSec % 60;
        dateTime =
            DateTime(date.year, date.month, date.day, hour, minute, second);
        attempts++;
      } while (!_state.allowDuplicates &&
          generatedSet.contains(dateTime) &&
          attempts < maxAttempts);

      if (!_state.allowDuplicates) {
        generatedSet.add(dateTime);
      }

      // Format datetime as YYYY-MM-DD HH:MM:SS
      final dateTimeStr = "${dateTime.year.toString().padLeft(4, '0')}-"
          "${dateTime.month.toString().padLeft(2, '0')}-"
          "${dateTime.day.toString().padLeft(2, '0')} "
          "${dateTime.hour.toString().padLeft(2, '0')}:"
          "${dateTime.minute.toString().padLeft(2, '0')}:"
          "${dateTime.second.toString().padLeft(2, '0')}";
      resultList.add(dateTimeStr);
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

  bool get hasValidDateTimeRange {
    return _state.endDateTime.isAfter(_state.startDateTime);
  }

  @override
  void dispose() {
    if (_isBoxOpen) {
      _box.close();
    }
    super.dispose();
  }
}
