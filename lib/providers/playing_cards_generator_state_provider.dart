import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/settings_provider.dart';

// Provider để lưu và khôi phục state cho PlayingCardsGenerator
class PlayingCardsGeneratorStateManager
    extends StateNotifier<PlayingCardGeneratorState> {
  final Ref ref;
  static const String _stateKey = 'playing_cards_generator_state';

  PlayingCardsGeneratorStateManager(this.ref)
      : super(PlayingCardGeneratorState.createDefault()) {
    _loadState();
  }

  // Load state từ SharedPreferences hoặc sử dụng default
  Future<void> _loadState() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();

      // Load từ SharedPreferences
      final includeJokers = prefs.getBool('${_stateKey}_includeJokers');
      final cardCount = prefs.getInt('${_stateKey}_cardCount');
      final allowDuplicates = prefs.getBool('${_stateKey}_allowDuplicates');

      if (includeJokers != null &&
          cardCount != null &&
          allowDuplicates != null) {
        state = PlayingCardGeneratorState(
          includeJokers: includeJokers,
          cardCount: cardCount,
          allowDuplicates: allowDuplicates,
          lastUpdated: DateTime.now(),
        );
        return;
      }
    }

    // Nếu không load được hoặc setting tắt, dùng default
    state = PlayingCardGeneratorState.createDefault();
  }

  // Save state khi generate
  Future<void> saveStateOnGenerate() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('${_stateKey}_includeJokers', state.includeJokers);
      await prefs.setInt('${_stateKey}_cardCount', state.cardCount);
      await prefs.setBool(
          '${_stateKey}_allowDuplicates', state.allowDuplicates);
    }
  }

  // Update methods không auto-save
  void updateIncludeJokers(bool value) {
    state = state.copyWith(includeJokers: value);
  }

  void updateCardCount(int value) {
    state = state.copyWith(cardCount: value);
  }

  void updateAllowDuplicates(bool value) {
    state = state.copyWith(allowDuplicates: value);
  }

  // Reset về default
  void resetToDefault() {
    state = PlayingCardGeneratorState.createDefault();
  }

  // Force reload state (khi setting thay đổi)
  Future<void> reloadState() async {
    await _loadState();
  }
}

// Provider cho PlayingCardsGenerator state manager
final playingCardsGeneratorStateManagerProvider = StateNotifierProvider<
    PlayingCardsGeneratorStateManager, PlayingCardGeneratorState>((ref) {
  return PlayingCardsGeneratorStateManager(ref);
});
