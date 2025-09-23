import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/services/cache_service.dart';
import 'package:random_please/providers/settings_provider.dart';

class SettingsViewModel extends ChangeNotifier {
  final WidgetRef ref;

  String _cacheInfo = 'Calculating...';
  bool _clearing = false;
  bool _isLoading = true;

  SettingsViewModel(this.ref);

  // Getters
  String get cacheInfo => _cacheInfo;
  bool get clearing => _clearing;
  bool get isLoading => _isLoading;

  /// Initialize the view model and load settings
  Future<void> initialize() async {
    await loadCacheInfo();
    _isLoading = false;
    notifyListeners();
  }

  /// Set theme mode using settings provider
  Future<void> setThemeMode(ThemeMode mode) async {
    await ref.read(settingsProvider.notifier).setThemeMode(mode);
  }

  /// Set locale using settings provider
  Future<void> setLocale(Locale locale) async {
    await ref.read(settingsProvider.notifier).setLocale(locale);
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
