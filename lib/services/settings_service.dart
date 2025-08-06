import 'package:hive/hive.dart';
import 'package:random_please/services/app_logger.dart';
import 'package:random_please/models/settings_model.dart';

class SettingsService {
  static const String _settingsBoxName = 'settings';
  static const String _settingsKey = 'app_settings';

  static Box<SettingsModel>? _settingsBox;

  // Initialize the settings service
  static Future<void> initialize() async {
    try {
      if (_settingsBox == null || !_settingsBox!.isOpen) {
        // Note: Hive should already be initialized by HiveService with custom path
        _settingsBox = await Hive.openBox<SettingsModel>(_settingsBoxName);
        logInfo('SettingsService: Settings box opened successfully');
      }
    } catch (e) {
      // Handle various compatibility issues
      final errorStr = e.toString().toLowerCase();
      bool shouldReset = errorStr.contains('type') || 
                        errorStr.contains('subtype') || 
                        errorStr.contains('unknown typeid') ||
                        errorStr.contains('cannot read');
      
      if (shouldReset) {
        try {
          logWarning('SettingsService: Detected compatibility issue, resetting settings box: $e');
          await Hive.deleteBoxFromDisk(_settingsBoxName);
          _settingsBox = await Hive.openBox<SettingsModel>(_settingsBoxName);
          logInfo('SettingsService: Reset settings box due to compatibility issue');
        } catch (resetError) {
          logError('SettingsService: Failed to reset settings box: $resetError');
          rethrow;
        }
      } else {
        logError('SettingsService: Error opening settings box: $e');
        rethrow;
      }
    }
  }

  // Get current settings
  static Future<SettingsModel> getSettings() async {
    await initialize();

    try {
      final settings = _settingsBox!.get(_settingsKey);
      if (settings == null) {
        // Return default settings
        final defaultSettings = SettingsModel();
        await saveSettings(defaultSettings);
        return defaultSettings;
      }
      return settings;
    } catch (e) {
      // Handle various reading compatibility issues
      final errorStr = e.toString().toLowerCase();
      bool shouldReset = errorStr.contains('type') || 
                        errorStr.contains('subtype') || 
                        errorStr.contains('unknown typeid') ||
                        errorStr.contains('cannot read');
      
      if (shouldReset) {
        logWarning('SettingsService: Settings read failed due to compatibility issue, using defaults: $e');
        final defaultSettings = SettingsModel();
        try {
          await _settingsBox!.clear();
          await saveSettings(defaultSettings);
        } catch (clearError) {
          logError('SettingsService: Failed to clear settings: $clearError');
        }
        return defaultSettings;
      }
      rethrow;
    }
  }

  // Save settings
  static Future<void> saveSettings(SettingsModel settings) async {
    await initialize();
    await _settingsBox!.put(_settingsKey, settings);
  }

  // Update fetch timeout
  static Future<void> updateFetchTimeout(int timeoutSeconds) async {
    final currentSettings = await getSettings();
    final updatedSettings =
        currentSettings.copyWith(fetchTimeoutSeconds: timeoutSeconds);
    await saveSettings(updatedSettings);
  }

  // Get fetch timeout
  static Future<int> getFetchTimeout() async {
    final settings = await getSettings();
    return settings.fetchTimeoutSeconds;
  }

  // Update feature state saving enabled
  static Future<void> updateFeatureStateSaving(bool enabled) async {
    final currentSettings = await getSettings();
    final updatedSettings =
        currentSettings.copyWith(featureStateSavingEnabled: enabled);
    await saveSettings(updatedSettings);
  }

  // Get feature state saving enabled
  static Future<bool> getFeatureStateSaving() async {
    final settings = await getSettings();
    return settings.featureStateSavingEnabled;
  }

  // Update log retention days
  static Future<void> updateLogRetentionDays(int days) async {
    final currentSettings = await getSettings();
    final updatedSettings = currentSettings.copyWith(logRetentionDays: days);
    await saveSettings(updatedSettings);

    // Trigger immediate cleanup when retention period is reduced
    try {
      await AppLogger.instance.cleanupOldLogs();
      logInfo(
          'SettingsService: Triggered immediate log cleanup after retention change to $days days');
    } catch (e) {
      logError('SettingsService: Failed to trigger immediate log cleanup: $e');
    }
  } // Get log retention days with migration support

  static Future<int> getLogRetentionDays() async {
    final settings = await getSettings();
    int retentionDays = settings.logRetentionDays;

    // Migration: handle old values that don't fit new range
    if (retentionDays != -1) {
      // -1 is "forever", keep as is
      // Valid values: 5, 10, 15, 20, 25, 30
      List<int> validValues = [5, 10, 15, 20, 25, 30];

      if (retentionDays < 5) {
        // Migrate values below 5 to 5
        retentionDays = 5;
        await updateLogRetentionDays(retentionDays);
      } else if (retentionDays > 30) {
        // Migrate values above 30 to 30
        retentionDays = 30;
        await updateLogRetentionDays(retentionDays);
      } else if (!validValues.contains(retentionDays)) {
        // Find the closest valid value
        int closest = validValues.reduce((a, b) =>
            (retentionDays - a).abs() < (retentionDays - b).abs() ? a : b);
        retentionDays = closest;
        await updateLogRetentionDays(retentionDays);
      }
    }

    return retentionDays;
  }

  // Update fetch retry times
  static Future<void> updateFetchRetryTimes(int times) async {
    final currentSettings = await getSettings();
    final updatedSettings = currentSettings.copyWith(fetchRetryTimes: times);
    await saveSettings(updatedSettings);
  }

  // Get fetch retry times
  static Future<int> getFetchRetryTimes() async {
    final settings = await getSettings();
    return settings.fetchRetryTimes;
  }

  // Update save random tools state
  static Future<void> updateSaveRandomToolsState(bool enabled) async {
    final currentSettings = await getSettings();
    final updatedSettings =
        currentSettings.copyWith(saveRandomToolsState: enabled);
    await saveSettings(updatedSettings);
  }

  // Get save random tools state
  static Future<bool> getSaveRandomToolsState() async {
    final settings = await getSettings();
    return settings.saveRandomToolsState;
  }

  // Clear settings (for testing or reset)
  static Future<void> clearSettings() async {
    await initialize();
    await _settingsBox!.delete(_settingsKey);
  }
}
