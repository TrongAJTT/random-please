import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_please/services/app_logger.dart';

void main() async {
  logInfo('Clearing P2P Hive data...');

  try {
    // Initialize Hive
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String hivePath = '${appDocDir.path}/hive_data';

    logInfo('Hive path: $hivePath');

    Hive.init(hivePath);

    // Delete P2P related boxes
    final boxesToDelete = [
      'p2p_users',
      'pairing_requests',
      'p2p_storage_settings',
      'file_transfer_tasks'
    ];

    for (final boxName in boxesToDelete) {
      try {
        await Hive.deleteBoxFromDisk(boxName);
        logInfo('Deleted box: $boxName');
      } catch (e) {
        logError('Failed to delete box $boxName: $e');
      }
    }

    // Also try to delete the files directly
    final hiveDir = Directory(hivePath);
    if (await hiveDir.exists()) {
      final files = await hiveDir.list().toList();
      for (final file in files) {
        final fileName = file.path.split('\\').last;
        if (fileName.contains('p2p_') ||
            fileName.contains('pairing_') ||
            fileName.contains('file_transfer_')) {
          try {
            await file.delete();
            logInfo('Deleted file: $fileName');
          } catch (e) {
            logError('Failed to delete file $fileName: $e');
          }
        }
      }
    }

    logInfo('P2P Hive data cleared successfully!');
  } catch (e) {
    logError('Error clearing P2P data: $e');
  }

  exit(0);
}
