import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/providers/password_generator_state_provider.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/constants/history_types.dart';
import 'dart:math';

// Temporary wrapper to maintain compatibility
class PasswordGeneratorViewModel extends ChangeNotifier {
  static const String historyType = HistoryTypes.password;
  final WidgetRef? _ref;

  PasswordGeneratorViewModel({WidgetRef? ref}) : _ref = ref;

  List<GenerationHistoryItem> _historyItems = [];
  bool _historyEnabled = false;
  String _result = '';

  // Character sets
  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _numbers = '0123456789';
  static const String _special = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  // Getters - now delegate to state manager
  PasswordGeneratorState get state {
    if (_ref != null) {
      return _ref!.read(passwordGeneratorStateManagerProvider);
    }
    return PasswordGeneratorState.createDefault();
  }

  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  String get result => _result;

  Future<void> initHive() async {
    _historyEnabled = await GenerationHistoryService.isHistoryEnabled();
    notifyListeners();
  }

  Future<void> loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history = await GenerationHistoryService.getHistory(historyType);
    _historyEnabled = enabled;
    _historyItems = history;
    notifyListeners();
  }

  void updatePasswordLength(int value) {
    if (_ref != null) {
      _ref!
          .read(passwordGeneratorStateManagerProvider.notifier)
          .updatePasswordLength(value);
    }
    notifyListeners();
  }

  void updateIncludeLowercase(bool value) {
    if (_ref != null) {
      _ref!
          .read(passwordGeneratorStateManagerProvider.notifier)
          .updateIncludeLowercase(value);
    }
    notifyListeners();
  }

  void updateIncludeUppercase(bool value) {
    if (_ref != null) {
      _ref!
          .read(passwordGeneratorStateManagerProvider.notifier)
          .updateIncludeUppercase(value);
    }
    notifyListeners();
  }

  void updateIncludeNumbers(bool value) {
    if (_ref != null) {
      _ref!
          .read(passwordGeneratorStateManagerProvider.notifier)
          .updateIncludeNumbers(value);
    }
    notifyListeners();
  }

  void updateIncludeSpecial(bool value) {
    if (_ref != null) {
      _ref!
          .read(passwordGeneratorStateManagerProvider.notifier)
          .updateIncludeSpecial(value);
    }
    notifyListeners();
  }

  Future<void> generatePassword() async {
    final currentState = state;
    String availableChars = '';
    final List<String> requiredSets = [];

    if (currentState.includeLowercase) {
      availableChars += _lowercase;
      requiredSets.add(_lowercase);
    }
    if (currentState.includeUppercase) {
      availableChars += _uppercase;
      requiredSets.add(_uppercase);
    }
    if (currentState.includeNumbers) {
      availableChars += _numbers;
      requiredSets.add(_numbers);
    }
    if (currentState.includeSpecial) {
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
      for (int i = 0; i < currentState.passwordLength; i++) {
        buffer.write(availableChars[random.nextInt(availableChars.length)]);
      }
      password = buffer.toString();
      attempt++;
    } while (!isValid(password) && attempt < maxAttempts);

    _result = password;

    // Save state on generate
    if (_ref != null) {
      await _ref!
          .read(passwordGeneratorStateManagerProvider.notifier)
          .saveStateOnGenerate();
    }

    // Save to history if enabled using new standardized encoding
    if (_historyEnabled && _result.isNotEmpty) {
      if (_ref != null) {
        await _ref!
            .read(historyProvider.notifier)
            .addHistoryItems([_result], historyType);
      } else {
        await GenerationHistoryService.addHistoryItems([_result], historyType);
        await loadHistory();
      }
    }

    notifyListeners();
  }

  void clearResult() {
    _result = '';
    notifyListeners();
  }

  bool get hasValidSettings {
    final currentState = state;
    return currentState.includeLowercase ||
        currentState.includeUppercase ||
        currentState.includeNumbers ||
        currentState.includeSpecial;
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
