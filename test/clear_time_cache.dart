import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_please/services/app_logger.dart';

Future<void> main() async {
  try {
    // Get application documents directory
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String hivePath = '${appDocDir.path}/hive_data';

    logInfo('Hive path: $hivePath');

    // Initialize Hive
    Hive.init(hivePath);

    // Try to clear time converter boxes
    try {
      final timeStateBox = await Hive.openBox('time_state');
      await timeStateBox.clear();
      await timeStateBox.close();
      logInfo('✅ Cleared time_state box');
    } catch (e) {
      logError('⚠️ Could not clear time_state box: $e');
    }

    try {
      final timePresetsBox = await Hive.openBox('time_presets');
      await timePresetsBox.clear();
      await timePresetsBox.close();
      logInfo('✅ Cleared time_presets box');
    } catch (e) {
      logError('⚠️ Could not clear time_presets box: $e');
    }

    logInfo('🎉 Time Converter cache cleared successfully!');
    logInfo('Please restart the app to register adapters properly.');
  } catch (e) {
    logError('❌ Error clearing cache: $e');
  }
}
