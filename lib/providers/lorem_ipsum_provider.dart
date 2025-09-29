import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:faker/faker.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/constants/history_types.dart';
import 'package:random_please/utils/enhanced_random.dart';

class LoremIpsumNotifier extends StateNotifier<LoremIpsumGeneratorState> {
  static const String boxName = 'loremIpsumGeneratorBox';
  static const String historyType = HistoryTypes.loremIpsum;

  late Box<LoremIpsumGeneratorState> _box;
  bool _isBoxOpen = false;
  bool _historyEnabled = false;
  List<GenerationHistoryItem> _historyItems = [];
  String _result = '';

  final faker = Faker();

  LoremIpsumNotifier() : super(LoremIpsumGeneratorState.createDefault()) {
    _init();
  }

  // Getters
  bool get isBoxOpen => _isBoxOpen;
  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  String get result => _result;

  Future<void> _init() async {
    await initHive();
    await loadHistory();
  }

  Future<void> initHive() async {
    _box = await Hive.openBox<LoremIpsumGeneratorState>(boxName);
    final savedState =
        _box.get('state') ?? LoremIpsumGeneratorState.createDefault();
    state = savedState;
    _isBoxOpen = true;
  }

  Future<void> loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history = await GenerationHistoryService.getHistory(historyType);
    _historyEnabled = enabled;
    _historyItems = history;
  }

  void saveState() {
    if (_isBoxOpen) {
      _box.put('state', state);
    }
  }

  void updateLoremIpsumType(LoremIpsumType type) {
    state = state.copyWith(generationType: type);
    saveState();
  }

  void updateWordCount(int count) {
    state = state.copyWith(wordCount: count);
    saveState();
  }

  void updateSentenceCount(int count) {
    state = state.copyWith(sentenceCount: count);
    saveState();
  }

  void updateParagraphCount(int count) {
    state = state.copyWith(paragraphCount: count);
    saveState();
  }

  void updateStartWithLorem(bool value) {
    state = state.copyWith(startWithLorem: value);
    saveState();
  }

  Future<void> generateText() async {
    List<String> generatedContent = [];

    try {
      switch (state.generationType) {
        case LoremIpsumType.words:
          // Generate specific number of words
          for (int i = 0; i < state.wordCount; i++) {
            generatedContent.add(faker.lorem.word());
          }
          _result = generatedContent.join(' ');
          break;

        case LoremIpsumType.sentences:
          // Generate specific number of sentences
          for (int i = 0; i < state.sentenceCount; i++) {
            generatedContent.add(faker.lorem.sentence());
          }
          _result = generatedContent.join(' ');
          break;

        case LoremIpsumType.paragraphs:
          // Generate specific number of paragraphs with enhanced randomness for sentence count
          for (int i = 0; i < state.paragraphCount; i++) {
            final sentencesPerParagraph = 3 + EnhancedRandom.nextInt(5);
            generatedContent
                .add(faker.lorem.sentences(sentencesPerParagraph).join(' '));
          }
          _result = generatedContent.join('\n\n');
          break;
      }

      // Apply start with lorem if enabled
      if (state.startWithLorem && _result.isNotEmpty) {
        _result = _modifyStartWithLorem(_result);
        // Also modify the individual items
        generatedContent = _modifyStartWithLoremItems(generatedContent);
      }

      // Save to history if enabled using new standardized encoding
      // Save individual items instead of joined result
      if (_historyEnabled && generatedContent.isNotEmpty) {
        await GenerationHistoryService.addHistoryItems(
            generatedContent, historyType);
        await loadHistory();
      }
    } catch (e) {
      _result = '';
      rethrow;
    }
  }

  String _modifyStartWithLorem(String text) {
    if (state.generationType == LoremIpsumType.words) {
      final words = text.split(' ');
      if (words.isNotEmpty) {
        words[0] = 'Lorem';
        if (words.length > 1) words[1] = 'ipsum';
        return words.join(' ');
      }
    } else if (state.generationType == LoremIpsumType.sentences ||
        state.generationType == LoremIpsumType.paragraphs) {
      return text.replaceFirst(RegExp(r'^\S+'), 'Lorem');
    }
    return text;
  }

  List<String> _modifyStartWithLoremItems(List<String> items) {
    if (items.isEmpty) return items;

    final modifiedItems = List<String>.from(items);

    if (state.generationType == LoremIpsumType.words) {
      // For words, modify first two items
      if (modifiedItems.isNotEmpty) {
        modifiedItems[0] = 'Lorem';
        if (modifiedItems.length > 1) {
          modifiedItems[1] = 'ipsum';
        }
      }
    } else if (state.generationType == LoremIpsumType.sentences ||
        state.generationType == LoremIpsumType.paragraphs) {
      // For sentences/paragraphs, modify first item
      if (modifiedItems.isNotEmpty) {
        modifiedItems[0] =
            modifiedItems[0].replaceFirst(RegExp(r'^\S+'), 'Lorem');
      }
    }

    return modifiedItems;
  }

  void clearResult() {
    _result = '';
  }

  // History management methods
  Future<void> clearAllHistory() async {
    await GenerationHistoryService.clearHistory(historyType);
    await loadHistory();
  }

  Future<void> clearPinnedHistory() async {
    await GenerationHistoryService.clearPinnedHistory(historyType);
    await loadHistory();
  }

  Future<void> clearUnpinnedHistory() async {
    await GenerationHistoryService.clearUnpinnedHistory(historyType);
    await loadHistory();
  }

  Future<void> deleteHistoryItem(int index) async {
    await GenerationHistoryService.deleteHistoryItem(historyType, index);
    await loadHistory();
  }

  Future<void> togglePinHistoryItem(int index) async {
    await GenerationHistoryService.togglePinHistoryItem(historyType, index);
    await loadHistory();
  }
}

final loremIpsumProvider =
    StateNotifierProvider<LoremIpsumNotifier, LoremIpsumGeneratorState>(
  (ref) => LoremIpsumNotifier(),
);
