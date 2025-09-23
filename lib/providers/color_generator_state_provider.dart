import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/settings_provider.dart';

// Provider để lưu và khôi phục state cho ColorGenerator
class ColorGeneratorStateManager extends StateNotifier<ColorGeneratorState> {
  final Ref ref;
  static const String _stateKey = 'color_generator_state';

  ColorGeneratorStateManager(this.ref)
      : super(ColorGeneratorState.createDefault()) {
    _loadState();
  }

  // Load state từ SharedPreferences hoặc sử dụng default
  Future<void> _loadState() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();

      // Load từ SharedPreferences
      final withAlpha = prefs.getBool('${_stateKey}_withAlpha');

      if (withAlpha != null) {
        state = ColorGeneratorState(
          withAlpha: withAlpha,
          lastUpdated: DateTime.now(),
        );
        return;
      }
    }

    // Nếu không load được hoặc setting tắt, dùng default
    state = ColorGeneratorState.createDefault();
  }

  // Save state khi generate
  Future<void> saveStateOnGenerate() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('${_stateKey}_withAlpha', state.withAlpha);
    }
  }

  // Update methods không auto-save
  void updateWithAlpha(bool value) {
    state = state.copyWith(withAlpha: value);
  }

  // Reset về default
  void resetToDefault() {
    state = ColorGeneratorState.createDefault();
  }

  // Force reload state (khi setting thay đổi)
  Future<void> reloadState() async {
    await _loadState();
  }
}

// Provider cho ColorGenerator state manager
final colorGeneratorStateManagerProvider =
    StateNotifierProvider<ColorGeneratorStateManager, ColorGeneratorState>(
        (ref) {
  return ColorGeneratorStateManager(ref);
});
