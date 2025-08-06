import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_please/services/app_logger.dart';
import 'package:random_please/models/settings_model.dart';

class HiveService {
  // Box names
  static const String templatesBoxName = 'templates';
  static const String historyBoxName = 'history';
  static const String currencyCacheBoxName = 'currency_cache';
  static const String settingsBoxName = 'settings';

  // Box instances
  static Box? _templatesBox;
  static Box? _historyBox;

  /// Initialize Hive database with custom path
  static Future<void> initialize() async {
    try {
      // Get application documents directory for storing Hive data
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String hivePath = '${appDocDir.path}/hive_data';

      // Create directory if it doesn't exist
      final Directory hiveDir = Directory(hivePath);
      if (!await hiveDir.exists()) {
        await hiveDir.create(recursive: true);
        logInfo('HiveService: Created Hive data directory at $hivePath');
      }

      // Initialize Hive with custom path
      Hive.init(hivePath);
      logInfo('HiveService: Initialized Hive with path: $hivePath');

      // TEMPORARY FIX: Clear the file transfer requests box to resolve a data migration issue.
      // This error (type 'bool' is not a subtype of type 'String?') occurs when the
      // structure of a stored object changes in an incompatible way.
      try {
        await Hive.deleteBoxFromDisk('file_transfer_requests');
        logInfo(
            "HiveService: Cleared 'file_transfer_requests' box to fix migration error.");
      } catch (e) {
        logWarning(
            "HiveService: Could not clear 'file_transfer_requests' box: $e");
      }

      if (!Hive.isAdapterRegistered(12)) {
        Hive.registerAdapter(SettingsModelAdapter());
      }

      // Open boxes
      _templatesBox = await Hive.openBox(templatesBoxName);
      _historyBox = await Hive.openBox(historyBoxName);

      logInfo('HiveService: Initialized successfully with custom path');
    } catch (e) {
      logFatal('HiveService: Failed to initialize: $e');
      rethrow;
    }
  }

  /// Get templates box
  static Box get templatesBox {
    if (_templatesBox == null || !_templatesBox!.isOpen) {
      throw Exception(
          'Templates box is not initialized. Call HiveService.initialize() first.');
    }
    return _templatesBox!;
  }

  /// Get history box
  static Box get historyBox {
    if (_historyBox == null || !_historyBox!.isOpen) {
      throw Exception(
          'History box is not initialized. Call HiveService.initialize() first.');
    }
    return _historyBox!;
  }

  /// Close all boxes
  static Future<void> closeAll() async {
    try {
      await _templatesBox?.close();
      await _historyBox?.close();
      logInfo('All Hive boxes closed');
    } catch (e) {
      logError('Error closing Hive boxes: $e');
    }
  }

  /// Clear all data from a specific box
  static Future<void> clearBox(String boxName) async {
    try {
      Box box;
      switch (boxName) {
        case templatesBoxName:
          box = templatesBox;
          break;
        case historyBoxName:
          box = historyBox;
          break;
        default:
          throw Exception('Unknown box name: $boxName');
      }

      await box.clear();
      logInfo('Cleared box: $boxName');
    } catch (e) {
      logError('Error clearing box $boxName: $e');
      rethrow;
    }
  }

  /// Get the size of a box in bytes by reading its file size from disk.
  static Future<int> getBoxSize(String boxName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      // Construct the path for both .hive and .lock files
      final hivePath = '${dir.path}/hive_data/$boxName.hive';
      final lockPath = '${dir.path}/hive_data/$boxName.lock';

      int totalSize = 0;

      final hiveFile = File(hivePath);
      if (await hiveFile.exists()) {
        totalSize += await hiveFile.length();
      }

      final lockFile = File(lockPath);
      if (await lockFile.exists()) {
        totalSize += await lockFile.length();
      }

      return totalSize;
    } catch (e) {
      logError('Error getting box size for $boxName: $e');
      return 0;
    }
  }

  /// Get the number of items in a box
  static int getBoxItemCount(String boxName) {
    try {
      Box box;
      switch (boxName) {
        case templatesBoxName:
          box = templatesBox;
          break;
        case historyBoxName:
          box = historyBox;
          break;
        default:
          return 0;
      }

      return box.length;
    } catch (e) {
      logError('Error getting item count for $boxName: $e');
      return 0;
    }
  }

  /// Get a generic box for typed models
  static Future<Box<T>> getBox<T>(String boxName) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        return await Hive.openBox<T>(boxName);
      }
      return Hive.box<T>(boxName);
    } catch (e) {
      logError('Error opening box $boxName: $e');
      rethrow;
    }
  }

  /// Check if Hive is initialized
  static bool get isInitialized {
    return _templatesBox != null &&
        _historyBox != null &&
        _templatesBox!.isOpen &&
        _historyBox!.isOpen;
  }

  /// Get current Hive storage path
  static Future<String> getHivePath() async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      return '${appDocDir.path}/hive_data';
    } catch (e) {
      logError('HiveService: Error getting Hive path: $e');
      return 'Unknown';
    }
  }

  /// Get storage info for debugging
  static Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      final hivePath = await getHivePath();
      final hiveDir = Directory(hivePath);

      Map<String, dynamic> info = {
        'path': hivePath,
        'exists': await hiveDir.exists(),
        'files': <String>[],
        'totalSize': 0,
      };

      if (await hiveDir.exists()) {
        final files = await hiveDir.list().toList();
        info['files'] = files.map((f) => f.path.split('/').last).toList();

        int totalSize = 0;
        for (final file in files) {
          if (file is File) {
            totalSize += await file.length();
          }
        }
        info['totalSize'] = totalSize;
      }

      return info;
    } catch (e) {
      logError('HiveService: Error getting storage info: $e');
      return {'error': e.toString()};
    }
  }
}
