import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/settings_provider.dart';

// Provider để lưu và khôi phục state cho PasswordGenerator
class PasswordGeneratorStateManager
    extends StateNotifier<PasswordGeneratorState> {
  final Ref ref;
  static const String _stateKey = 'password_generator_state';

  PasswordGeneratorStateManager(this.ref)
      : super(PasswordGeneratorState.createDefault()) {
    _loadState();
  }

  // Load state từ SharedPreferences hoặc sử dụng default
  Future<void> _loadState() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();

      // Load từ SharedPreferences
      final passwordLength = prefs.getInt('${_stateKey}_passwordLength');
      final includeLowercase = prefs.getBool('${_stateKey}_includeLowercase');
      final includeUppercase = prefs.getBool('${_stateKey}_includeUppercase');
      final includeNumbers = prefs.getBool('${_stateKey}_includeNumbers');
      final includeSpecial = prefs.getBool('${_stateKey}_includeSpecial');

      if (passwordLength != null &&
          includeLowercase != null &&
          includeUppercase != null &&
          includeNumbers != null &&
          includeSpecial != null) {
        state = PasswordGeneratorState(
          passwordLength: passwordLength,
          includeLowercase: includeLowercase,
          includeUppercase: includeUppercase,
          includeNumbers: includeNumbers,
          includeSpecial: includeSpecial,
          lastUpdated: DateTime.now(),
        );
        return;
      }
    }

    // Nếu không load được hoặc setting tắt, dùng default
    state = PasswordGeneratorState.createDefault();
  }

  // Save state khi generate
  Future<void> saveStateOnGenerate() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('${_stateKey}_passwordLength', state.passwordLength);
      await prefs.setBool(
          '${_stateKey}_includeLowercase', state.includeLowercase);
      await prefs.setBool(
          '${_stateKey}_includeUppercase', state.includeUppercase);
      await prefs.setBool('${_stateKey}_includeNumbers', state.includeNumbers);
      await prefs.setBool('${_stateKey}_includeSpecial', state.includeSpecial);
    }
  }

  // Update methods không auto-save
  void updatePasswordLength(int value) {
    state = state.copyWith(passwordLength: value);
  }

  void updateIncludeLowercase(bool value) {
    state = state.copyWith(includeLowercase: value);
  }

  void updateIncludeUppercase(bool value) {
    state = state.copyWith(includeUppercase: value);
  }

  void updateIncludeNumbers(bool value) {
    state = state.copyWith(includeNumbers: value);
  }

  void updateIncludeSpecial(bool value) {
    state = state.copyWith(includeSpecial: value);
  }

  // Reset về default
  void resetToDefault() {
    state = PasswordGeneratorState.createDefault();
  }

  // Force reload state (khi setting thay đổi)
  Future<void> reloadState() async {
    await _loadState();
  }
}

// Provider cho PasswordGenerator state manager
final passwordGeneratorStateManagerProvider = StateNotifierProvider<
    PasswordGeneratorStateManager, PasswordGeneratorState>((ref) {
  return PasswordGeneratorStateManager(ref);
});
