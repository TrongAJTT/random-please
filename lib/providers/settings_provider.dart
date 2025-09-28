import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_please/services/settings_service.dart';

// State class for settings
@immutable
class SettingsState {
  final ThemeMode themeMode;
  final Locale locale;
  final bool saveRandomToolsState;
  final int? autoCleanupHistoryLimit;
  final bool resetCounterOnToggle;
  final int localApiPort;
  final bool localApiAutoStart;

  const SettingsState({
    required this.themeMode,
    required this.locale,
    required this.saveRandomToolsState,
    this.autoCleanupHistoryLimit,
    required this.resetCounterOnToggle,
    required this.localApiPort,
    required this.localApiAutoStart,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? saveRandomToolsState,
    int? autoCleanupHistoryLimit,
    bool? resetCounterOnToggle,
    int? localApiPort,
    bool? localApiAutoStart,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      saveRandomToolsState: saveRandomToolsState ?? this.saveRandomToolsState,
      autoCleanupHistoryLimit:
          autoCleanupHistoryLimit ?? this.autoCleanupHistoryLimit,
      resetCounterOnToggle: resetCounterOnToggle ?? this.resetCounterOnToggle,
      localApiPort: localApiPort ?? this.localApiPort,
      localApiAutoStart: localApiAutoStart ?? this.localApiAutoStart,
    );
  }
}

// Settings Notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier()
      : super(const SettingsState(
          themeMode: ThemeMode.system,
          locale: Locale('en'),
          saveRandomToolsState: false,
          autoCleanupHistoryLimit: null,
          resetCounterOnToggle: false,
          localApiPort: 4000,
          localApiAutoStart: false,
        )) {
    // Auto-load settings on initialization
    loadSettings();
  }

  // Load settings from SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load theme mode
    final themeIndex = prefs.getInt('themeMode') ?? 0;
    final themeMode = ThemeMode.values[themeIndex];

    // Load language
    final languageCode = prefs.getString('language') ?? 'en';
    final locale = Locale(languageCode);

    // Load save random tools state
    final saveRandomToolsState =
        await SettingsService.getSaveRandomToolsState();

    // Load auto cleanup history limit
    final autoCleanupHistoryLimit =
        await SettingsService.getAutoCleanupHistoryLimit();

    // Load reset counter on toggle
    final resetCounterOnToggle =
        await SettingsService.getResetCounterOnToggle();

    // Load local API settings
    final localApiPort = await SettingsService.getLocalApiPort();
    final localApiAutoStart = await SettingsService.getLocalApiAutoStart();

    state = state.copyWith(
      themeMode: themeMode,
      locale: locale,
      saveRandomToolsState: saveRandomToolsState,
      autoCleanupHistoryLimit: autoCleanupHistoryLimit,
      resetCounterOnToggle: resetCounterOnToggle,
      localApiPort: localApiPort,
      localApiAutoStart: localApiAutoStart,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
  }

  Future<void> setLocale(Locale locale) async {
    state = state.copyWith(locale: locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', locale.languageCode);
  }

  Future<void> setSaveRandomToolsState(bool enabled) async {
    await SettingsService.updateSaveRandomToolsState(enabled);
    state = state.copyWith(saveRandomToolsState: enabled);
  }

  Future<void> setAutoCleanupHistoryLimit(int? limit) async {
    await SettingsService.updateAutoCleanupHistoryLimit(limit);
    state = state.copyWith(autoCleanupHistoryLimit: limit);
  }

  Future<void> setResetCounterOnToggle(bool enabled) async {
    await SettingsService.updateResetCounterOnToggle(enabled);
    state = state.copyWith(resetCounterOnToggle: enabled);
  }

  Future<void> updateLocalApiPort(int port) async {
    await SettingsService.updateLocalApiPort(port);
    state = state.copyWith(localApiPort: port);
  }

  Future<void> updateLocalApiAutoStart(bool enabled) async {
    await SettingsService.updateLocalApiAutoStart(enabled);
    state = state.copyWith(localApiAutoStart: enabled);
  }
}

// Provider for settings
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

// Provider for saveRandomToolsState
final saveRandomToolsStateProvider = Provider<bool>((ref) {
  final settingsState = ref.watch(settingsProvider);
  return settingsState.saveRandomToolsState;
});

// Provider for autoCleanupHistoryLimit
final autoCleanupHistoryLimitProvider = Provider<int?>((ref) {
  final settingsState = ref.watch(settingsProvider);
  return settingsState.autoCleanupHistoryLimit;
});

// Provider for resetCounterOnToggle
final resetCounterOnToggleProvider = Provider<bool>((ref) {
  final settingsState = ref.watch(settingsProvider);
  return settingsState.resetCounterOnToggle;
});
