import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'dart:math';

// Combined view state for PasswordGenerator
@immutable
class PasswordGeneratorViewState {
  final PasswordGeneratorState generatorState;
  final bool isBoxOpen;
  final bool historyEnabled;
  final List<GenerationHistoryItem> historyItems;
  final String result;

  const PasswordGeneratorViewState({
    required this.generatorState,
    required this.isBoxOpen,
    required this.historyEnabled,
    required this.historyItems,
    required this.result,
  });

  PasswordGeneratorViewState copyWith({
    PasswordGeneratorState? generatorState,
    bool? isBoxOpen,
    bool? historyEnabled,
    List<GenerationHistoryItem>? historyItems,
    String? result,
  }) {
    return PasswordGeneratorViewState(
      generatorState: generatorState ?? this.generatorState,
      isBoxOpen: isBoxOpen ?? this.isBoxOpen,
      historyEnabled: historyEnabled ?? this.historyEnabled,
      historyItems: historyItems ?? this.historyItems,
      result: result ?? this.result,
    );
  }
}

// Notifier for PasswordGenerator
class PasswordGeneratorNotifier
    extends StateNotifier<PasswordGeneratorViewState> {
  static const String boxName = 'passwordGeneratorBox';
  static const String historyType = 'password';

  late Box<PasswordGeneratorState> _box;

  // Character sets
  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _numbers = '0123456789';
  static const String _special = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  PasswordGeneratorNotifier()
      : super(PasswordGeneratorViewState(
          generatorState: PasswordGeneratorState.createDefault(),
          isBoxOpen: false,
          historyEnabled: false,
          historyItems: const [],
          result: '',
        ));

  Future<void> initHive() async {
    _box = await Hive.openBox<PasswordGeneratorState>(boxName);
    final savedState =
        _box.get('state') ?? PasswordGeneratorState.createDefault();

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

  void updateLength(int value) {
    final newState = state.generatorState.copyWith(passwordLength: value);
    state = state.copyWith(generatorState: newState);
    saveState();
  }

  void updateUseLowercase(bool value) {
    final newState = state.generatorState.copyWith(includeLowercase: value);
    state = state.copyWith(generatorState: newState);
    saveState();
  }

  void updateUseUppercase(bool value) {
    final newState = state.generatorState.copyWith(includeUppercase: value);
    state = state.copyWith(generatorState: newState);
    saveState();
  }

  void updateUseNumbers(bool value) {
    final newState = state.generatorState.copyWith(includeNumbers: value);
    state = state.copyWith(generatorState: newState);
    saveState();
  }

  void updateUseSpecialChars(bool value) {
    final newState = state.generatorState.copyWith(includeSpecial: value);
    state = state.copyWith(generatorState: newState);
    saveState();
  }

  void updateExcludeSimilar(bool value) {
    // Note: excludeSimilar is not in the state model, this might need to be added
    // For now, we'll skip this implementation
  }

  Future<void> generatePassword() async {
    String charset = '';

    if (state.generatorState.includeLowercase) {
      charset += _lowercase;
    }
    if (state.generatorState.includeUppercase) {
      charset += _uppercase;
    }
    if (state.generatorState.includeNumbers) {
      charset += _numbers;
    }
    if (state.generatorState.includeSpecial) {
      charset += _special;
    }

    if (charset.isEmpty) {
      throw Exception('At least one character type must be selected');
    }

    // Note: excludeSimilar functionality would need to be added to state model
    // For now, skipping this feature

    final random = Random();
    final password = List.generate(
      state.generatorState.passwordLength,
      (index) => charset[random.nextInt(charset.length)],
    ).join();

    state = state.copyWith(result: password);

    // Save to history if enabled
    if (state.historyEnabled) {
      await GenerationHistoryService.addHistoryItem(
        password,
        historyType,
      );
      await loadHistory(); // Refresh history
    }
  }

  @override
  void dispose() {
    // Close box if needed
    super.dispose();
  }
}

// Provider for PasswordGenerator
final passwordGeneratorProvider = StateNotifierProvider<
    PasswordGeneratorNotifier, PasswordGeneratorViewState>((ref) {
  return PasswordGeneratorNotifier();
});
