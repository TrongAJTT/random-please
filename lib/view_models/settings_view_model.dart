import 'package:flutter/material.dart';
import 'package:random_please/services/cache_service.dart';
import 'package:random_please/main.dart';

class SettingsViewModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');
  String _cacheInfo = 'Calculating...';
  bool _clearing = false;
  bool _isLoading = true;

  // Getters
  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  String get cacheInfo => _cacheInfo;
  bool get clearing => _clearing;
  bool get isLoading => _isLoading;

  /// Initialize the view model and load settings
  Future<void> initialize() async {
    await loadSettings();
    await loadCacheInfo();
    _isLoading = false;
    notifyListeners();
  }

  /// Load settings from global settings controller
  Future<void> loadSettings() async {
    _themeMode = settingsController.themeMode;
    _locale = settingsController.locale;
    notifyListeners();
  }

  /// Set theme mode using global settings controller
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await settingsController.setThemeMode(mode);
    notifyListeners();
  }

  /// Set locale using global settings controller
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await settingsController.setLocale(locale);
    notifyListeners();
  }

  /// Load cache information
  Future<void> loadCacheInfo() async {
    try {
      final totalSize = await CacheService.getTotalCacheSize();
      _cacheInfo = CacheService.formatCacheSize(totalSize);
    } catch (e) {
      _cacheInfo = 'Unknown';
    }
    notifyListeners();
  }

  /// Clear all cache
  Future<bool> clearCache() async {
    _clearing = true;
    notifyListeners();

    try {
      await CacheService.clearAllCache();
      await loadCacheInfo(); // Refresh cache info
      _clearing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _clearing = false;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
