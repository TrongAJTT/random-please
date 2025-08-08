import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/services/security_service.dart';
import 'package:random_please/services/hive_service.dart';
import 'package:random_please/services/app_logger.dart';

class DataMigrationService {
  /// Migrate unencrypted history data to encrypted format
  static Future<bool> migrateToEncrypted(String masterPassword) async {
    try {
      logInfo('DataMigrationService: Starting migration to encrypted format');

      // Get encryption key
      final encryptionKey =
          await SecurityService.getEncryptionKey(masterPassword);
      if (encryptionKey == null) {
        logError('DataMigrationService: Could not get encryption key');
        return false;
      }

      // Get all history types
      final historyTypes = [
        'coin_flip',
        'number',
        'yes_no',
        'color',
        'time',
        'rock_paper_scissors',
        'playing_card',
        'password',
        'latin_letter',
        'dice_roll',
        'date_time',
        'date',
      ];

      int migratedCount = 0;
      final box = HiveService.historyBox;

      for (final type in historyTypes) {
        try {
          // First check if we already have encrypted data
          final existingEncrypted = box.get('encrypted_history_$type');
          if (existingEncrypted != null) {
            logInfo(
                'DataMigrationService: $type already has encrypted data, skipping');
            continue;
          }

          // Get unencrypted history from the simple encrypted format
          final unencryptedData = box.get('generation_history_$type');

          if (unencryptedData != null && unencryptedData is String) {
            // Decrypt the simple encrypted data first
            String jsonString;
            try {
              jsonString =
                  GenerationHistoryService.decryptOldFormat(unencryptedData);
            } catch (e) {
              logWarning(
                  'DataMigrationService: Could not decrypt $type data: $e');
              continue;
            }

            if (jsonString.isNotEmpty) {
              // Re-encrypt with proper encryption
              final encryptedData =
                  SecurityService.encryptString(jsonString, encryptionKey);

              // Store encrypted data with new key format
              await box.put('encrypted_history_$type', encryptedData);

              migratedCount++;
              logInfo(
                  'DataMigrationService: Migrated $type history to encrypted format');
            }
          }
        } catch (e) {
          logWarning('DataMigrationService: Error migrating $type: $e');
          // Continue with other types
        }
      }

      logInfo(
          'DataMigrationService: Migration completed. Migrated $migratedCount history types');
      return true;
    } catch (e) {
      logError('DataMigrationService: Error during migration to encrypted: $e');
      return false;
    }
  }

  /// Migrate encrypted history data back to unencrypted format
  static Future<bool> migrateToUnencrypted(String masterPassword) async {
    try {
      logInfo('DataMigrationService: Starting migration to unencrypted format');

      // Get encryption key
      final encryptionKey =
          await SecurityService.getEncryptionKey(masterPassword);
      if (encryptionKey == null) {
        logError('DataMigrationService: Could not get encryption key');
        return false;
      }

      // Get all history types
      final historyTypes = [
        'coin_flip',
        'number',
        'yes_no',
        'color',
        'time',
        'rock_paper_scissors',
        'playing_card',
        'password',
        'latin_letter',
        'dice_roll',
        'date_time',
        'date',
      ];

      int migratedCount = 0;
      final box = HiveService.historyBox;

      for (final type in historyTypes) {
        try {
          // Get encrypted data
          final encryptedData = box.get('encrypted_history_$type');

          if (encryptedData != null && encryptedData is String) {
            // Decrypt the data
            final decryptedJson =
                SecurityService.decryptString(encryptedData, encryptionKey);

            // Re-encrypt with simple encryption for old format
            final simpleEncrypted =
                GenerationHistoryService.encryptOldFormat(decryptedJson);

            // Store as unencrypted data using old format
            await box.put('generation_history_$type', simpleEncrypted);

            migratedCount++;
            logInfo(
                'DataMigrationService: Migrated $type history back to unencrypted');
          }
        } catch (e) {
          logWarning('DataMigrationService: Could not migrate $type: $e');
          // Continue with other types
        }
      }

      logInfo(
          'DataMigrationService: Migration completed. Migrated $migratedCount history types');
      return true;
    } catch (e) {
      logError(
          'DataMigrationService: Error during migration to unencrypted: $e');
      return false;
    }
  }

  /// Clear all encrypted history data
  static Future<bool> clearEncryptedData() async {
    try {
      logInfo('DataMigrationService: Clearing all encrypted history data');

      final historyTypes = [
        'coin_flip',
        'number',
        'yes_no',
        'color',
        'time',
        'rock_paper_scissors',
        'playing_card',
        'password',
        'latin_letter',
        'dice_roll',
        'date_time',
        'date',
      ];

      final box = HiveService.historyBox;
      int clearedCount = 0;

      for (final type in historyTypes) {
        try {
          // Remove encrypted data
          await box.delete('encrypted_history_$type');
          // Also remove unencrypted data
          await box.delete('generation_history_$type');
          clearedCount++;
        } catch (e) {
          logWarning('DataMigrationService: Could not clear $type: $e');
        }
      }

      logInfo('DataMigrationService: Cleared $clearedCount history types');
      return true;
    } catch (e) {
      logError('DataMigrationService: Error clearing encrypted data: $e');
      return false;
    }
  }

  /// Check if there's encrypted data available
  static Future<bool> hasEncryptedData() async {
    try {
      final historyTypes = [
        'coin_flip',
        'number',
        'yes_no',
        'color',
        'time',
        'rock_paper_scissors',
        'playing_card',
        'password',
        'latin_letter',
        'dice_roll',
        'date_time',
        'date',
      ];

      final box = HiveService.historyBox;

      for (final type in historyTypes) {
        final encryptedData = box.get('encrypted_history_$type');
        if (encryptedData != null) {
          return true;
        }
      }

      return false;
    } catch (e) {
      logError('DataMigrationService: Error checking encrypted data: $e');
      return false;
    }
  }

  /// Check if there's unencrypted data available
  static Future<bool> hasUnencryptedData() async {
    try {
      final historyTypes = [
        'coin_flip',
        'number',
        'yes_no',
        'color',
        'time',
        'rock_paper_scissors',
        'playing_card',
        'password',
        'latin_letter',
        'dice_roll',
        'date_time',
        'date',
      ];

      final box = HiveService.historyBox;

      for (final type in historyTypes) {
        final unencryptedData = box.get('generation_history_$type');
        if (unencryptedData != null) {
          return true;
        }
      }

      return false;
    } catch (e) {
      logError('DataMigrationService: Error checking unencrypted data: $e');
      return false;
    }
  }

  /// Get migration status
  static Future<Map<String, dynamic>> getMigrationStatus() async {
    try {
      final hasEncrypted = await hasEncryptedData();
      final hasUnencrypted = await hasUnencryptedData();
      final securityEnabled = await SecurityService.isSecurityEnabled();

      return {
        'hasEncryptedData': hasEncrypted,
        'hasUnencryptedData': hasUnencrypted,
        'securityEnabled': securityEnabled,
        'migrationNeeded': securityEnabled && hasUnencrypted,
        'dataMixed': hasEncrypted && hasUnencrypted,
      };
    } catch (e) {
      logError('DataMigrationService: Error getting migration status: $e');
      return {
        'hasEncryptedData': false,
        'hasUnencryptedData': false,
        'securityEnabled': false,
        'migrationNeeded': false,
        'dataMixed': false,
        'error': e.toString(),
      };
    }
  }
}
