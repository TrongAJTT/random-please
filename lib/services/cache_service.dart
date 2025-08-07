import 'package:random_please/services/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generation_history_service.dart';
import 'hive_service.dart';
import 'random_services/random_state_service.dart';
import 'package:flutter/material.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/widgets/hold_to_confirm_dialog.dart';

class CacheInfo {
  final String name;
  final String description;
  final int itemCount;
  final int sizeBytes;
  final List<String> keys;
  final bool isDeletable;

  CacheInfo({
    required this.name,
    required this.description,
    required this.itemCount,
    required this.sizeBytes,
    required this.keys,
    this.isDeletable = true,
  });
  String get formattedSize {
    if (sizeBytes < 1024) {
      return '$sizeBytes B';
    } else {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    }
  }
}

class CacheService {
  static const String _templatesKey = 'templates';
  // Cache keys for different features
  static const Map<String, List<String>> _cacheKeys = {
    'text_templates': [_templatesKey],
    'settings': ['themeMode', 'language'],
    'random_generators': [
      'generation_history_enabled',
      'generation_history_password',
      'generation_history_number',
      'generation_history_date',
      'generation_history_time',
      'generation_history_date_time',
      'generation_history_color',
      'generation_history_latin_letter',
      'generation_history_playing_card',
      'generation_history_coin_flip',
      'generation_history_dice_roll',
      'generation_history_rock_paper_scissors',
    ],
    'converter_tools': [],
    'p2lan_transfer': [],
  };
  static Future<Map<String, CacheInfo>> getAllCacheInfo(
      {String? appSettingsDesc,
      String? randomGeneratorsName,
      String? randomGeneratorsDesc}) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, CacheInfo> cacheInfoMap =
        {}; // Text Templates Cache - Now using Hive

    // Settings Cache
    final settingsKeys = ['themeMode', 'language'];
    int settingsSize = 0;
    int settingsCount = 0;
    for (final key in settingsKeys) {
      if (prefs.containsKey(key)) {
        settingsCount++;
        final value = prefs.get(key);
        if (value is String) {
          settingsSize += value.length * 2; // UTF-16 encoding
        } else if (value is int) {
          settingsSize += 4; // 32-bit integer
        } else if (value is bool) {
          settingsSize += 1; // 1 byte for boolean
        }
      }
    }
    cacheInfoMap['settings'] = CacheInfo(
      name: 'App Settings',
      description: appSettingsDesc ?? 'Theme, language, and user preferences',
      itemCount: settingsCount,
      sizeBytes: settingsSize,
      keys: settingsKeys,
    );

    // Random Generators Cache - Get actual history data and random states
    final historyEnabled = await GenerationHistoryService.isHistoryEnabled();
    final historyCount = await GenerationHistoryService.getTotalHistoryCount();
    final historySize = await GenerationHistoryService.getHistoryDataSize();

    // Add random states to cache calculation
    int randomStateSize = 0;
    int randomStateCount = 0;
    try {
      final hasRandomState = await RandomStateService.hasState();
      if (hasRandomState) {
        randomStateSize = await RandomStateService.getStateSize();
        final stateKeys = RandomStateService.getAllStateKeys();
        randomStateCount = stateKeys.length;
      }
    } catch (e) {
      logError('CacheService: Error checking random states: $e');
    }

    cacheInfoMap['random_generators'] = CacheInfo(
      name: randomGeneratorsName ?? 'Random Generators',
      description: randomGeneratorsDesc ??
          'Generation history, settings, and random tool states',
      itemCount: historyCount + (historyEnabled ? 1 : 0) + randomStateCount,
      sizeBytes: historySize + (historyEnabled ? 4 : 0) + randomStateSize,
      keys: (_cacheKeys['random_generators'] ?? []) +
          RandomStateService.getAllStateKeys(),
    );

    return cacheInfoMap;
  }

  static Future<void> clearCache(String cacheType) async {
    final prefs = await SharedPreferences.getInstance();
    if (cacheType == 'random_generators') {
      // Clear all generation history through the service
      await GenerationHistoryService.clearAllHistory();
      // Also clear the history enabled setting
      await prefs.remove('generation_history_enabled');
    }
  }

  static Future<void> clearAllCache() async {
    final prefs = await SharedPreferences.getInstance();

    // Clear templates cache from Hive
    await HiveService.clearBox(HiveService.templatesBoxName);

    // Clear history cache from Hive
    await GenerationHistoryService.clearAllHistory();
    // Get all cache keys from SharedPreferences (except settings)
    final allKeys = <String>{};
    for (final keyList in _cacheKeys.values) {
      allKeys.addAll(keyList);
    }

    // Remove all cache keys except settings (preserve user preferences)
    for (final key in allKeys) {
      if (!['themeMode', 'language'].contains(key)) {
        await prefs.remove(key);
      }
    }
  }

  static Future<int> getTotalCacheSize() async {
    final cacheInfoMap = await getAllCacheInfo();
    return cacheInfoMap.values
        .fold<int>(0, (sum, info) => sum + info.sizeBytes);
  }

  // static Future<int> getTotalLogSize() async {
  //   try {
  //     return await AppLogger.instance.getTotalLogSize();
  //   } catch (e) {
  //     return 0;
  //   }
  // }

  static String formatCacheSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  // Method to add cache tracking for other features in the future
  static Future<void> addCacheKey(String cacheType, String key) async {
    // This can be used to dynamically add cache keys for new features
  }

  /// Clear P2P Data Transfer cache
  static Future<void> clearP2PCache() async {
    final p2pBoxNames = [
      'p2p_users',
      'pairing_requests',
      'p2p_storage_settings',
      'file_transfer_requests',
    ];

    for (final boxName in p2pBoxNames) {
      try {
        await HiveService.clearBox(boxName);
        logInfo('CacheService: Cleared P2P box: $boxName');
      } catch (e) {
        logError('CacheService: Error clearing P2P box $boxName: $e');
      }
    }
  }

  /// Shows a confirmation dialog and clears all deletable cache if confirmed.
  static Future<void> confirmAndClearAllCache(
    BuildContext context, {
    required AppLocalizations l10n,
  }) async {
    // First, determine which caches cannot be cleared.
    final allCacheInfo = await getAllCacheInfo();
    final nonDeletableCaches = allCacheInfo.values
        .where((info) => !info.isDeletable)
        .map((info) => info.name)
        .toList();

    String dialogContent = l10n.confirmClearAllCache;
    if (nonDeletableCaches.isNotEmpty) {
      dialogContent +=
          '\n\n${l10n.cannotClearFollowingCaches}\n• ${nonDeletableCaches.join('\n• ')}';
    }

    // Show the hold-to-confirm dialog.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => HoldToConfirmDialog(
        l10n: l10n,
        title: l10n.clearAllCache,
        content: dialogContent,
        holdDuration: const Duration(seconds: 3),
        onConfirmed: () => Navigator.of(context).pop(true),
        actionText: l10n.clearAll,
        holdText: l10n.holdToClearCache,
        processingText: l10n.clearingCache,
        actionIcon: Icons.delete_sweep,
      ),
    );

    if (confirmed == true) {
      await clearAllCache();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.allCacheCleared),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}
