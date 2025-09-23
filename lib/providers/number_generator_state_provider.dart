import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_please/models/random_models/random_state_models.dart'
    as models;
import 'package:random_please/providers/settings_provider.dart';

// Provider để lưu và khôi phục state cho NumberGenerator
class NumberGeneratorStateManager
    extends StateNotifier<models.NumberGeneratorState> {
  final Ref ref;
  static const String _stateKey = 'number_generator_state';

  NumberGeneratorStateManager(this.ref)
      : super(models.NumberGeneratorState.createDefault()) {
    _loadState();
  }

  // Load state từ SharedPreferences hoặc sử dụng default
  Future<void> _loadState() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();

      // Load từ SharedPreferences
      final minValue = prefs.getDouble('${_stateKey}_minValue');
      final maxValue = prefs.getDouble('${_stateKey}_maxValue');
      final quantity = prefs.getInt('${_stateKey}_quantity');
      final isInteger = prefs.getBool('${_stateKey}_isInteger');
      final allowDuplicates = prefs.getBool('${_stateKey}_allowDuplicates');

      if (minValue != null &&
          maxValue != null &&
          quantity != null &&
          isInteger != null &&
          allowDuplicates != null) {
        state = models.NumberGeneratorState(
          minValue: minValue,
          maxValue: maxValue,
          quantity: quantity,
          isInteger: isInteger,
          allowDuplicates: allowDuplicates,
          lastUpdated: DateTime.now(),
        );
        return;
      }
    }

    // Nếu không load được hoặc setting tắt, dùng default
    state = models.NumberGeneratorState.createDefault();
  }

  // Save state khi có thay đổi
  Future<void> _saveState() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('${_stateKey}_minValue', state.minValue);
      await prefs.setDouble('${_stateKey}_maxValue', state.maxValue);
      await prefs.setInt('${_stateKey}_quantity', state.quantity);
      await prefs.setBool('${_stateKey}_isInteger', state.isInteger);
      await prefs.setBool(
          '${_stateKey}_allowDuplicates', state.allowDuplicates);
    }
  }

  // Update methods - không auto save, chỉ save khi generate
  void updateMinValue(double value) {
    state = state.copyWith(minValue: value);
  }

  void updateMaxValue(double value) {
    state = state.copyWith(maxValue: value);
  }

  void updateQuantity(int value) {
    state = state.copyWith(quantity: value);
  }

  void updateIsInteger(bool value) {
    state = state.copyWith(isInteger: value);
  }

  void updateAllowDuplicates(bool value) {
    state = state.copyWith(allowDuplicates: value);
  }

  // Save state khi generate (chỉ khi setting được bật)
  Future<void> saveStateOnGenerate() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('${_stateKey}_minValue', state.minValue);
      await prefs.setDouble('${_stateKey}_maxValue', state.maxValue);
      await prefs.setInt('${_stateKey}_quantity', state.quantity);
      await prefs.setBool('${_stateKey}_isInteger', state.isInteger);
      await prefs.setBool(
          '${_stateKey}_allowDuplicates', state.allowDuplicates);
    }
  }

  // Reset về default
  Future<void> resetToDefault() async {
    state = models.NumberGeneratorState.createDefault();
    await _saveState();
  }

  // Force reload state (khi setting thay đổi)
  Future<void> reloadState() async {
    await _loadState();
  }
}

// Provider cho NumberGenerator state manager
final numberGeneratorStateManagerProvider = StateNotifierProvider<
    NumberGeneratorStateManager, models.NumberGeneratorState>((ref) {
  return NumberGeneratorStateManager(ref);
});
