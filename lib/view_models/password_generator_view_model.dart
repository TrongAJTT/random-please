import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'dart:math';

class PasswordGeneratorViewModel extends ChangeNotifier {
  static const String boxName = 'passwordGeneratorBox';
  static const String historyType = 'password';

  late Box<PasswordGeneratorState> _box;
  PasswordGeneratorState _state = PasswordGeneratorState.createDefault();
  bool _isBoxOpen = false;
  bool _historyEnabled = false;
  List<GenerationHistoryItem> _historyItems = [];
  String _result = '';

  // Character sets
  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _numbers = '0123456789';
  static const String _special = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  // Getters
  PasswordGeneratorState get state => _state;
  bool get isBoxOpen => _isBoxOpen;
  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  String get result => _result;

  Future<void> initHive() async {
    _box = await Hive.openBox<PasswordGeneratorState>(boxName);
    _state = _box.get('state') ?? PasswordGeneratorState.createDefault();
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

  void updatePasswordLength(int value) {
    _state = _state.copyWith(passwordLength: value);
    saveState();
    notifyListeners();
  }

  void updateIncludeLowercase(bool value) {
    _state = _state.copyWith(includeLowercase: value);
    saveState();
    notifyListeners();
  }

  void updateIncludeUppercase(bool value) {
    _state = _state.copyWith(includeUppercase: value);
    saveState();
    notifyListeners();
  }

  void updateIncludeNumbers(bool value) {
    _state = _state.copyWith(includeNumbers: value);
    saveState();
    notifyListeners();
  }

  void updateIncludeSpecial(bool value) {
    _state = _state.copyWith(includeSpecial: value);
    saveState();
    notifyListeners();
  }

  Future<void> generatePassword() async {
    String availableChars = '';
    final List<String> requiredSets = [];
    if (_state.includeLowercase) {
      availableChars += _lowercase;
      requiredSets.add(_lowercase);
    }
    if (_state.includeUppercase) {
      availableChars += _uppercase;
      requiredSets.add(_uppercase);
    }
    if (_state.includeNumbers) {
      availableChars += _numbers;
      requiredSets.add(_numbers);
    }
    if (_state.includeSpecial) {
      availableChars += _special;
      requiredSets.add(_special);
    }

    if (availableChars.isEmpty) {
      _result = '';
      notifyListeners();
      return;
    }

    final random = Random();
    String password = '';
    const int maxAttempts = 1000;
    int attempt = 0;
    bool isValid(String pwd) {
      for (final set in requiredSets) {
        if (!pwd.split('').any((c) => set.contains(c))) {
          return false;
        }
      }
      return true;
    }

    do {
      final buffer = StringBuffer();
      for (int i = 0; i < _state.passwordLength; i++) {
        buffer.write(availableChars[random.nextInt(availableChars.length)]);
      }
      password = buffer.toString();
      attempt++;
    } while (!isValid(password) && attempt < maxAttempts);

    _result = password;

    // Save to history if enabled
    if (_historyEnabled && _result.isNotEmpty) {
      await GenerationHistoryService.addHistoryItem(
        _result,
        historyType,
      );
      await loadHistory();
    }

    notifyListeners();
  }

  void clearResult() {
    _result = '';
    notifyListeners();
  }

  bool get hasValidSettings {
    return _state.includeLowercase ||
        _state.includeUppercase ||
        _state.includeNumbers ||
        _state.includeSpecial;
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

  @override
  void dispose() {
    if (_isBoxOpen) {
      _box.close();
    }
    super.dispose();
  }
}
