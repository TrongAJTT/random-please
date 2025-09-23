import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/settings_provider.dart';

// Provider để lưu và khôi phục state cho LoremIpsumGenerator
class LoremIpsumGeneratorStateManager
    extends StateNotifier<LoremIpsumGeneratorState> {
  final Ref ref;
  static const String _stateKey = 'lorem_ipsum_generator_state';

  LoremIpsumGeneratorStateManager(this.ref)
      : super(LoremIpsumGeneratorState.createDefault()) {
    _loadState();
  }

  // Load state từ SharedPreferences hoặc sử dụng default
  Future<void> _loadState() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();

      // Load từ SharedPreferences
      final generationTypeIndex = prefs.getInt('${_stateKey}_generationType');
      final wordCount = prefs.getInt('${_stateKey}_wordCount');
      final sentenceCount = prefs.getInt('${_stateKey}_sentenceCount');
      final paragraphCount = prefs.getInt('${_stateKey}_paragraphCount');
      final startWithLorem = prefs.getBool('${_stateKey}_startWithLorem');

      if (generationTypeIndex != null &&
          wordCount != null &&
          sentenceCount != null &&
          paragraphCount != null &&
          startWithLorem != null) {
        state = LoremIpsumGeneratorState(
          generationType: LoremIpsumType.values[generationTypeIndex],
          wordCount: wordCount,
          sentenceCount: sentenceCount,
          paragraphCount: paragraphCount,
          startWithLorem: startWithLorem,
          lastUpdated: DateTime.now(),
        );
        return;
      }
    }

    // Nếu không load được hoặc setting tắt, dùng default
    state = LoremIpsumGeneratorState.createDefault();
  }

  // Save state khi generate
  Future<void> saveStateOnGenerate() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
          '${_stateKey}_generationType', state.generationType.index);
      await prefs.setInt('${_stateKey}_wordCount', state.wordCount);
      await prefs.setInt('${_stateKey}_sentenceCount', state.sentenceCount);
      await prefs.setInt('${_stateKey}_paragraphCount', state.paragraphCount);
      await prefs.setBool('${_stateKey}_startWithLorem', state.startWithLorem);
    }
  }

  // Update methods không auto-save
  void updateGenerationType(LoremIpsumType value) {
    state = state.copyWith(generationType: value);
  }

  void updateWordCount(int value) {
    state = state.copyWith(wordCount: value);
  }

  void updateSentenceCount(int value) {
    state = state.copyWith(sentenceCount: value);
  }

  void updateParagraphCount(int value) {
    state = state.copyWith(paragraphCount: value);
  }

  void updateStartWithLorem(bool value) {
    state = state.copyWith(startWithLorem: value);
  }

  // Reset về default
  void resetToDefault() {
    state = LoremIpsumGeneratorState.createDefault();
  }

  // Force reload state (khi setting thay đổi)
  Future<void> reloadState() async {
    await _loadState();
  }
}

// Provider cho LoremIpsumGenerator state manager
final loremIpsumGeneratorStateManagerProvider = StateNotifierProvider<
    LoremIpsumGeneratorStateManager, LoremIpsumGeneratorState>((ref) {
  return LoremIpsumGeneratorStateManager(ref);
});
