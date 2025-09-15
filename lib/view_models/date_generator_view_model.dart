import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'dart:math';

class DateGeneratorViewModel extends ChangeNotifier {
  static const String boxName = 'dateGeneratorBox';
  static const String historyType = 'date';

  late Box<DateGeneratorState> _box;
  DateGeneratorState _state = DateGeneratorState.createDefault();
  bool _isBoxOpen = false;
  bool _historyEnabled = false;
  List<GenerationHistoryItem> _historyItems = [];
  List<String> _results = [];

  // Getters
  DateGeneratorState get state => _state;
  bool get isBoxOpen => _isBoxOpen;
  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  List<String> get results => _results;

  Future<void> initHive() async {
    _box = await Hive.openBox<DateGeneratorState>(boxName);
    _state = _box.get('state') ?? DateGeneratorState.createDefault();
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

  void updateStartDate(DateTime value) {
    _state = _state.copyWith(startDate: value);
    saveState();
    notifyListeners();
  }

  void updateEndDate(DateTime value) {
    _state = _state.copyWith(endDate: value);
    saveState();
    notifyListeners();
  }

  void updateDateCount(int value) {
    _state = _state.copyWith(dateCount: value);
    saveState();
    notifyListeners();
  }

  void updateAllowDuplicates(bool value) {
    _state = _state.copyWith(allowDuplicates: value);
    saveState();
    notifyListeners();
  }

  Future<void> generateDates() async {
    final random = Random();
    final Set<DateTime> generatedSet = {};
    final List<String> resultList = [];

    final startDate = DateTime(
        _state.startDate.year, _state.startDate.month, _state.startDate.day);
    final endDate =
        DateTime(_state.endDate.year, _state.endDate.month, _state.endDate.day);
    final totalDays = endDate.difference(startDate).inDays;

    if (totalDays < 0) {
      _results = [];
      notifyListeners();
      return;
    }

    for (int i = 0; i < _state.dateCount; i++) {
      DateTime date;
      int attempts = 0;
      const maxAttempts = 1000;

      do {
        final randomDay = random.nextInt(totalDays + 1);
        date = startDate.add(Duration(days: randomDay));
        attempts++;
      } while (!_state.allowDuplicates &&
          generatedSet.contains(date) &&
          attempts < maxAttempts);

      if (!_state.allowDuplicates) {
        generatedSet.add(date);
      }

      // Format date as YYYY-MM-DD
      final dateStr = "${date.year.toString().padLeft(4, '0')}-"
          "${date.month.toString().padLeft(2, '0')}-"
          "${date.day.toString().padLeft(2, '0')}";
      resultList.add(dateStr);
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

  bool get hasValidDateRange {
    return _state.endDate.isAfter(_state.startDate);
  }

  @override
  void dispose() {
    if (_isBoxOpen) {
      _box.close();
    }
    super.dispose();
  }
}
