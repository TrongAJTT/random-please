import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/app_logger.dart';
import 'package:random_please/services/settings_service.dart';
import 'package:hive/hive.dart';

class RandomStateService {
  static const String _boxName = 'random_states';
  static Box<dynamic>? _box;

  // Initialize the service
  static Future<void> initialize() async {
    if (_box == null || !_box!.isOpen) {
      try {
        _box = await Hive.openBox<dynamic>(_boxName);
        logInfo('RandomStateService: Box opened successfully');
      } catch (e) {
        logError('RandomStateService: Error opening box: $e');
        rethrow;
      }
    }
  }

  // Helper method to check if state saving is enabled
  static Future<bool> _isStateSavingEnabled() async {
    try {
      return await SettingsService.getSaveRandomToolsState();
    } catch (e) {
      logError('RandomStateService: Error checking state saving setting: $e');
      return true; // Default to enabled if error
    }
  }

  // Generic save method that checks the setting first
  static Future<void> _saveState<T>(String key, T state) async {
    try {
      final isEnabled = await _isStateSavingEnabled();
      if (!isEnabled) {
        return; // Don't save if setting is disabled
      }

      await initialize();
      await _box!.put(key, state);
      logDebug('RandomStateService: Saved state for $key');
    } catch (e) {
      logError('RandomStateService: Error saving state for $key: $e');
    }
  }

  // Generic load method
  static Future<T> _loadState<T>(String key, T defaultState) async {
    try {
      await initialize();
      final state = _box!.get(key);
      if (state != null && state is T) {
        logDebug('RandomStateService: Loaded state for $key');
        return state;
      }
      logDebug('RandomStateService: Using default state for $key');
      return defaultState;
    } catch (e) {
      logError('RandomStateService: Error loading state for $key: $e');
      return defaultState;
    }
  }

  // Number Generator
  static Future<void> saveNumberGeneratorState(
      NumberGeneratorState state) async {
    await _saveState('number_generator', state);
  }

  static Future<NumberGeneratorState> getNumberGeneratorState() async {
    return await _loadState(
        'number_generator', NumberGeneratorState.createDefault());
  }

  // Latin Letter Generator
  static Future<void> saveLatinLetterGeneratorState(
      LatinLetterGeneratorState state) async {
    await _saveState('latin_letter_generator', state);
  }

  static Future<LatinLetterGeneratorState>
      getLatinLetterGeneratorState() async {
    return await _loadState(
        'latin_letter_generator', LatinLetterGeneratorState.createDefault());
  }

  // Password Generator
  static Future<void> savePasswordGeneratorState(
      PasswordGeneratorState state) async {
    await _saveState('password_generator', state);
  }

  static Future<PasswordGeneratorState> getPasswordGeneratorState() async {
    return await _loadState(
        'password_generator', PasswordGeneratorState.createDefault());
  }

  // Dice Roll Generator
  static Future<void> saveDiceRollGeneratorState(
      DiceRollGeneratorState state) async {
    await _saveState('dice_roll_generator', state);
  }

  static Future<DiceRollGeneratorState> getDiceRollGeneratorState() async {
    return await _loadState(
        'dice_roll_generator', DiceRollGeneratorState.createDefault());
  }

  // Playing Card Generator
  static Future<void> savePlayingCardGeneratorState(
      PlayingCardGeneratorState state) async {
    await _saveState('playing_card_generator', state);
  }

  static Future<PlayingCardGeneratorState>
      getPlayingCardGeneratorState() async {
    return await _loadState(
        'playing_card_generator', PlayingCardGeneratorState.createDefault());
  }

  // Color Generator
  static Future<void> saveColorGeneratorState(ColorGeneratorState state) async {
    await _saveState('color_generator', state);
  }

  static Future<ColorGeneratorState> getColorGeneratorState() async {
    return await _loadState(
        'color_generator', ColorGeneratorState.createDefault());
  }

  // Date Generator
  static Future<void> saveDateGeneratorState(DateGeneratorState state) async {
    await _saveState('date_generator', state);
  }

  static Future<DateGeneratorState> getDateGeneratorState() async {
    return await _loadState(
        'date_generator', DateGeneratorState.createDefault());
  }

  // Time Generator
  static Future<void> saveTimeGeneratorState(TimeGeneratorState state) async {
    await _saveState('time_generator', state);
  }

  static Future<TimeGeneratorState> getTimeGeneratorState() async {
    return await _loadState(
        'time_generator', TimeGeneratorState.createDefault());
  }

  // Date Time Generator
  static Future<void> saveDateTimeGeneratorState(
      DateTimeGeneratorState state) async {
    await _saveState('date_time_generator', state);
  }

  static Future<DateTimeGeneratorState> getDateTimeGeneratorState() async {
    return await _loadState(
        'date_time_generator', DateTimeGeneratorState.createDefault());
  }

  // Simple generators (Coin Flip, Yes/No, Rock Paper Scissors)
  static Future<void> saveCoinFlipGeneratorState(
      SimpleGeneratorState state) async {
    await _saveState('coin_flip_generator', state);
  }

  static Future<SimpleGeneratorState> getCoinFlipGeneratorState() async {
    return await _loadState(
        'coin_flip_generator', SimpleGeneratorState.createDefault());
  }

  static Future<void> saveYesNoGeneratorState(
      SimpleGeneratorState state) async {
    await _saveState('yes_no_generator', state);
  }

  static Future<SimpleGeneratorState> getYesNoGeneratorState() async {
    return await _loadState(
        'yes_no_generator', SimpleGeneratorState.createDefault());
  }

  static Future<void> saveRockPaperScissorsGeneratorState(
      SimpleGeneratorState state) async {
    await _saveState('rock_paper_scissors_generator', state);
  }

  static Future<SimpleGeneratorState>
      getRockPaperScissorsGeneratorState() async {
    return await _loadState(
        'rock_paper_scissors_generator', SimpleGeneratorState.createDefault());
  }

  // Clear all states
  static Future<void> clearAllStates() async {
    try {
      await initialize();
      await _box!.clear();
      logInfo('RandomStateService: Cleared all states');
    } catch (e) {
      logError('RandomStateService: Error clearing states: $e');
    }
  }

  // Clear specific state
  static Future<void> clearState(String key) async {
    try {
      await initialize();
      await _box!.delete(key);
      logDebug('RandomStateService: Cleared state for $key');
    } catch (e) {
      logError('RandomStateService: Error clearing state for $key: $e');
    }
  }

  // Check if any state exists
  static Future<bool> hasState() async {
    try {
      await initialize();
      return _box!.isNotEmpty;
    } catch (e) {
      logError('RandomStateService: Error checking state existence: $e');
      return false;
    }
  }

  // Get total size of all states (approximate)
  static Future<int> getStateSize() async {
    try {
      await initialize();
      int totalSize = 0;
      for (final key in _box!.keys) {
        final value = _box!.get(key);
        if (value != null) {
          // Approximate size calculation
          totalSize += key.toString().length * 2; // Key size
          totalSize += 100; // Approximate value size
        }
      }
      return totalSize;
    } catch (e) {
      logError('RandomStateService: Error calculating state size: $e');
      return 0;
    }
  }

  // Get all state keys
  static List<String> getAllStateKeys() {
    try {
      if (_box == null || !_box!.isOpen) {
        return [];
      }
      return _box!.keys.cast<String>().toList();
    } catch (e) {
      logError('RandomStateService: Error getting state keys: $e');
      return [];
    }
  }
}
