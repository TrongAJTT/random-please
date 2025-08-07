import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'hive_service.dart';

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

      // Keep only the latest items
      if (history.length > maxHistoryItems) {
        history.removeRange(maxHistoryItems, history.length);
      }

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
}
