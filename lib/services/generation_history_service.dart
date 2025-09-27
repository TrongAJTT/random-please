import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'hive_service.dart';
import 'settings_service.dart';
import 'history_data_encoder.dart';

class GenerationHistoryItem {
  final String value;
  final DateTime timestamp;
  final String type; // 'password', 'number', 'date', 'color', etc.
  final bool isPinned;

  GenerationHistoryItem({
    required this.value,
    required this.timestamp,
    required this.type,
    this.isPinned = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'isPinned': isPinned,
    };
  }

  factory GenerationHistoryItem.fromJson(Map<String, dynamic> json) {
    return GenerationHistoryItem(
      value: json['value'],
      timestamp: DateTime.parse(json['timestamp']),
      type: json['type'],
      isPinned: json['isPinned'] ?? false,
    );
  }
}

class GenerationHistoryService {
  static const String _historyEnabledKey = 'generation_history_enabled';
  static const String _historyKey = 'generation_history';
  static const String _encryptionKey =
      'random_please_history_encryption_key_2024';

  // Maximum number of items to keep in history
  static const int maxHistoryItems = 100;

  /// Check if history saving is enabled
  static Future<bool> isHistoryEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_historyEnabledKey) ?? true; // Default to true
  }

  /// Enable or disable history saving
  static Future<void> setHistoryEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_historyEnabledKey, enabled);
  }

  /// Simple encryption using base64 and key rotation
  static String _encrypt(String plainText) {
    final bytes = utf8.encode(plainText);
    final keyBytes = utf8.encode(_encryptionKey);

    // Simple XOR encryption with key rotation
    final encrypted = Uint8List(bytes.length);
    for (int i = 0; i < bytes.length; i++) {
      encrypted[i] = bytes[i] ^ keyBytes[i % keyBytes.length];
    }

    return base64.encode(encrypted);
  }

  /// Simple decryption
  static String _decrypt(String encryptedText) {
    try {
      final encrypted = base64.decode(encryptedText);
      final keyBytes = utf8.encode(_encryptionKey);

      // Simple XOR decryption with key rotation
      final decrypted = Uint8List(encrypted.length);
      for (int i = 0; i < encrypted.length; i++) {
        decrypted[i] = encrypted[i] ^ keyBytes[i % keyBytes.length];
      }

      return utf8.decode(decrypted);
    } catch (e) {
      // If decryption fails, return empty string
      return '';
    }
  }

  /// Public method to decrypt old format data (for migration)
  static String decryptOldFormat(String encryptedText) {
    return _decrypt(encryptedText);
  }

  /// Public method to encrypt to old format data (for migration)
  static String encryptOldFormat(String plainText) {
    return _encrypt(plainText);
  }

  /// Add a new item to history
  static Future<void> addHistoryItem(String value, String type) async {
    final enabled = await isHistoryEnabled();
    if (!enabled) return;

    try {
      final box = HiveService.historyBox;
      final history = await getHistory(type);

      // Add new item at the beginning
      final newItem = GenerationHistoryItem(
        value: value,
        timestamp: DateTime.now(),
        type: type,
        isPinned: false, // New items are not pinned by default
      );

      history.insert(0, newItem);

      // Sort history: pinned items first, then by timestamp
      history.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.timestamp.compareTo(a.timestamp);
      });

      // Auto-cleanup based on user settings
      await _autoCleanupHistory(history);

      // Encrypt and save to Hive
      final jsonList = history.map((item) => item.toJson()).toList();
      final jsonString = json.encode(jsonList);
      final encryptedData = _encrypt(jsonString);

      await box.put('${_historyKey}_$type', encryptedData);
    } catch (e) {
      // Silently fail to avoid breaking the app
    }
  }

  /// Add a list of items to history using the new standardized encoding
  static Future<void> addHistoryItems(List<String> items, String type) async {
    final enabled = await isHistoryEnabled();
    if (!enabled || items.isEmpty) return;

    try {
      // Encode the list using the new encoding system
      final encodedValue = HistoryDataEncoder.encodeList(items);

      final box = HiveService.historyBox;
      final history = await getHistory(type);

      // Add new item at the beginning
      final newItem = GenerationHistoryItem(
        value: encodedValue,
        timestamp: DateTime.now(),
        type: type,
        isPinned: false, // New items are not pinned by default
      );

      history.insert(0, newItem);

      // Sort history: pinned items first, then by timestamp
      history.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.timestamp.compareTo(a.timestamp);
      });

      // Auto-cleanup based on user settings
      await _autoCleanupHistory(history);

      // Encrypt and save to Hive
      final jsonList = history.map((item) => item.toJson()).toList();
      final jsonString = json.encode(jsonList);
      final encryptedData = _encrypt(jsonString);

      await box.put('${_historyKey}_$type', encryptedData);
    } catch (e) {
      // Silently fail to avoid breaking the app
    }
  }

  /// Get history for a specific type
  static Future<List<GenerationHistoryItem>> getHistory(String type) async {
    final enabled = await isHistoryEnabled();
    if (!enabled) return [];

    try {
      final box = HiveService.historyBox;
      final encryptedData = box.get('${_historyKey}_$type');

      if (encryptedData == null || encryptedData.isEmpty) {
        return [];
      }

      final decryptedData = _decrypt(encryptedData);
      if (decryptedData.isEmpty) return [];

      final jsonList = json.decode(decryptedData) as List;
      final history =
          jsonList.map((json) => GenerationHistoryItem.fromJson(json)).toList();

      // Sort history: pinned items first, then by timestamp
      history.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.timestamp.compareTo(a.timestamp);
      });

      return history;
    } catch (e) {
      // If parsing fails, return empty list
      return [];
    }
  }

  /// Get decoded history items for a specific type
  /// Returns a list of decoded items for each history entry
  static Future<List<List<String>>> getDecodedHistory(String type) async {
    final history = await getHistory(type);
    return history.map((item) {
      try {
        // Try to decode as new format first
        if (item.value.isValidEncodedHistory) {
          return item.value.fromEncodedHistory();
        } else {
          // Fallback to legacy format - try to split by common separators
          if (item.value.contains('; ')) {
            return item.value.split('; ');
          } else if (item.value.contains(', ')) {
            return item.value.split(', ');
          } else {
            return [item.value]; // Single item
          }
        }
      } catch (e) {
        // If decoding fails, return the original value as single item
        return [item.value];
      }
    }).toList();
  }

  /// Check if a history item uses the new encoding format
  static bool isEncodedHistoryItem(GenerationHistoryItem item) {
    return item.value.isValidEncodedHistory;
  }

  /// Decode a single history item
  static List<String> decodeHistoryItem(GenerationHistoryItem item) {
    try {
      if (item.value.isValidEncodedHistory) {
        return item.value.fromEncodedHistory();
      } else {
        // Fallback to legacy format
        if (item.value.contains('; ')) {
          return item.value.split('; ');
        } else if (item.value.contains(', ')) {
          return item.value.split(', ');
        } else {
          return [item.value];
        }
      }
    } catch (e) {
      return [item.value];
    }
  }

  /// Clear history for a specific type
  static Future<void> clearHistory(String type) async {
    try {
      final box = HiveService.historyBox;
      await box.delete('${_historyKey}_$type');
    } catch (e) {
      // Silently fail to avoid breaking the app
    }
  }

  /// Clear all pinned history items for a specific type
  static Future<void> clearPinnedHistory(String type) async {
    try {
      final history = await getHistory(type);
      final unpinnedHistory = history.where((item) => !item.isPinned).toList();

      // Save unpinned history back
      final box = HiveService.historyBox;
      final jsonList = unpinnedHistory.map((item) => item.toJson()).toList();
      final jsonString = json.encode(jsonList);
      final encryptedData = _encrypt(jsonString);

      await box.put('${_historyKey}_$type', encryptedData);
    } catch (e) {
      // Silently fail to avoid breaking the app
    }
  }

  /// Clear all unpinned history items for a specific type
  static Future<void> clearUnpinnedHistory(String type) async {
    try {
      final history = await getHistory(type);
      final pinnedHistory = history.where((item) => item.isPinned).toList();
      // Save pinned history back
      final box = HiveService.historyBox;
      final jsonList = pinnedHistory.map((item) => item.toJson()).toList();
      final jsonString = json.encode(jsonList);
      final encryptedData = _encrypt(jsonString);
      await box.put('${_historyKey}_$type', encryptedData);
    } catch (e) {
      // Silently fail to avoid breaking the app
    }
  }

  /// Delete a specific history item by index
  static Future<void> deleteHistoryItem(String type, int index) async {
    try {
      final history = await getHistory(type);
      if (index >= 0 && index < history.length) {
        history.removeAt(index);

        final box = HiveService.historyBox;
        final jsonList = history.map((item) => item.toJson()).toList();
        final jsonString = json.encode(jsonList);
        final encryptedData = _encrypt(jsonString);

        await box.put('${_historyKey}_$type', encryptedData);
      }
    } catch (e) {
      // Silently fail to avoid breaking the app
    }
  }

  /// Toggle pin status of a specific history item by index
  static Future<void> togglePinHistoryItem(String type, int index) async {
    try {
      final history = await getHistory(type);
      if (index >= 0 && index < history.length) {
        final item = history[index];
        final updatedItem = GenerationHistoryItem(
          value: item.value,
          timestamp: item.timestamp,
          type: item.type,
          isPinned: !item.isPinned,
        );

        history[index] = updatedItem;

        // Sort history: pinned items first, then by timestamp
        history.sort((a, b) {
          if (a.isPinned && !b.isPinned) return -1;
          if (!a.isPinned && b.isPinned) return 1;
          return b.timestamp.compareTo(a.timestamp);
        });

        final box = HiveService.historyBox;
        final jsonList = history.map((item) => item.toJson()).toList();
        final jsonString = json.encode(jsonList);
        final encryptedData = _encrypt(jsonString);

        await box.put('${_historyKey}_$type', encryptedData);
      }
    } catch (e) {
      // Silently fail to avoid breaking the app
    }
  }

  /// Clear all history
  static Future<void> clearAllHistory() async {
    try {
      final box = HiveService.historyBox;

      // Get all keys that start with history key prefix
      final keysToDelete = box.keys
          .where((key) => key.toString().startsWith(_historyKey))
          .toList();

      for (final key in keysToDelete) {
        await box.delete(key);
      }
    } catch (e) {
      // Silently fail to avoid breaking the app
    }
  }

  /// Get total count of history items across all types
  static Future<int> getTotalHistoryCount() async {
    final enabled = await isHistoryEnabled();
    if (!enabled) return 0;

    try {
      final box = HiveService.historyBox;
      final keys = box.keys
          .where((key) =>
              key.toString().startsWith(_historyKey) &&
              key.toString() != _historyEnabledKey)
          .toList();

      int totalCount = 0;
      for (final key in keys) {
        final typeKey = key.toString().replaceFirst('${_historyKey}_', '');
        final history = await getHistory(typeKey);
        totalCount += history.length;
      }

      return totalCount;
    } catch (e) {
      return 0;
    }
  }

  /// Get size of history data in bytes (estimated)
  static Future<int> getHistoryDataSize() async {
    final enabled = await isHistoryEnabled();
    if (!enabled) return 0;

    try {
      final box = HiveService.historyBox;
      final keys = box.keys
          .where((key) =>
              key.toString().startsWith(_historyKey) &&
              key.toString() != _historyEnabledKey)
          .toList();

      int totalSize = 0;
      for (final key in keys) {
        final data = box.get(key, defaultValue: '');
        if (data is String) {
          totalSize += data.length * 2; // UTF-16 encoding estimate
        }
      }

      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  /// Auto-cleanup history based on user settings
  /// Removes oldest unpinned items when the limit is exceeded
  static Future<void> _autoCleanupHistory(
      List<GenerationHistoryItem> history) async {
    try {
      // Import SettingsService to get the user's auto-cleanup limit
      final limit = await SettingsService.getAutoCleanupHistoryLimit();

      // If no limit is set (null), fallback to default maxHistoryItems
      final effectiveLimit = limit ?? maxHistoryItems;

      if (history.length <= effectiveLimit) {
        return; // No cleanup needed
      }

      // Separate pinned and unpinned items
      final pinnedItems = history.where((item) => item.isPinned).toList();
      final unpinnedItems = history.where((item) => !item.isPinned).toList();

      // Calculate how many items need to be removed
      final totalExcess = history.length - effectiveLimit;

      // Only remove unpinned items
      if (unpinnedItems.length > totalExcess) {
        // Remove oldest unpinned items
        unpinnedItems
            .sort((a, b) => a.timestamp.compareTo(b.timestamp)); // Oldest first
        unpinnedItems.removeRange(0, totalExcess.toInt());
      } else {
        // Remove all unpinned items if needed
        unpinnedItems.clear();
      }

      // Rebuild the history with remaining items
      history.clear();
      history.addAll([...pinnedItems, ...unpinnedItems]);

      // Re-sort: pinned items first, then by timestamp
      history.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.timestamp.compareTo(a.timestamp);
      });
    } catch (e) {
      // Silently fail and fallback to default behavior
      if (history.length > maxHistoryItems) {
        history.removeRange(maxHistoryItems, history.length);
      }
    }
  }
}
