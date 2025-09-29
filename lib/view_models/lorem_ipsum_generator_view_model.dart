import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:faker/faker.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/constants/history_types.dart';
import 'package:random_please/utils/standard_random_utils.dart';

class LoremIpsumGeneratorViewModel extends ChangeNotifier {
  static const String boxName = 'loremIpsumGeneratorBox';
  static const String historyType = HistoryTypes.loremIpsum; // standardized

  late Box<LoremIpsumGeneratorState> _box;
  LoremIpsumGeneratorState _state = LoremIpsumGeneratorState.createDefault();
  bool _isBoxOpen = false;
  bool _historyEnabled = false;
  List<GenerationHistoryItem> _historyItems = [];
  String _result = '';

  final faker = Faker();

  // Getters
  LoremIpsumGeneratorState get state => _state;
  bool get isBoxOpen => _isBoxOpen;
  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  String get result => _result;

  Future<void> initHive() async {
    _box = await Hive.openBox<LoremIpsumGeneratorState>(boxName);
    _state = _box.get('state') ?? LoremIpsumGeneratorState.createDefault();
    _isBoxOpen = true;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history = await GenerationHistoryService.getHistory(historyType);
    _historyEnabled = enabled;
    _historyItems = history;
    notifyListeners();
  }

  void saveState() {
    if (_isBoxOpen) {
      _box.put('state', _state);
    }
  }

  void updateLoremIpsumType(LoremIpsumType type) {
    _state = _state.copyWith(generationType: type);
    saveState();
    notifyListeners();
  }

  void updateWordCount(int count) {
    _state = _state.copyWith(wordCount: count);
    saveState();
    notifyListeners();
  }

  void updateSentenceCount(int count) {
    _state = _state.copyWith(sentenceCount: count);
    saveState();
    notifyListeners();
  }

  void updateParagraphCount(int count) {
    _state = _state.copyWith(paragraphCount: count);
    saveState();
    notifyListeners();
  }

  void updateStartWithLorem(bool value) {
    _state = _state.copyWith(startWithLorem: value);
    saveState();
    notifyListeners();
  }

  Future<void> generateText() async {
    List<String> generatedContent = [];

    try {
      switch (_state.generationType) {
        case LoremIpsumType.words:
          // Generate specific number of words
          for (int i = 0; i < _state.wordCount; i++) {
            generatedContent.add(faker.lorem.word());
          }
          _result = generatedContent.join(' ');
          break;

        case LoremIpsumType.sentences:
          // Generate specific number of sentences
          for (int i = 0; i < _state.sentenceCount; i++) {
            generatedContent.add(faker.lorem.sentence());
          }
          _result = generatedContent.join(' ');
          break;

        case LoremIpsumType.paragraphs:
          // Generate specific number of paragraphs with enhanced randomness for sentence count
          for (int i = 0; i < _state.paragraphCount; i++) {
            final sentencesPerParagraph = 3 + StandardRandomUtils.nextInt(0, 4);
            generatedContent
                .add(faker.lorem.sentences(sentencesPerParagraph).join(' '));
          }
          _result = generatedContent.join('\n\n');
          break;
      }

      // Apply start with lorem if enabled
      if (_state.startWithLorem && _result.isNotEmpty) {
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

      notifyListeners();
    } catch (e) {
      _result = '';
      notifyListeners();
      rethrow;
    }
  }

  String _modifyStartWithLorem(String text) {
    if (_state.generationType == LoremIpsumType.words) {
      final words = text.split(' ');
      if (words.isNotEmpty) {
        words[0] = 'Lorem';
        if (words.length > 1) words[1] = 'ipsum';
        return words.join(' ');
      }
    } else if (_state.generationType == LoremIpsumType.sentences ||
        _state.generationType == LoremIpsumType.paragraphs) {
      return text.replaceFirst(RegExp(r'^\S+'), 'Lorem');
    }
    return text;
  }

  List<String> _modifyStartWithLoremItems(List<String> items) {
    if (items.isEmpty) return items;

    final modifiedItems = List<String>.from(items);

    if (_state.generationType == LoremIpsumType.words) {
      // For words, modify first two items
      if (modifiedItems.isNotEmpty) {
        modifiedItems[0] = 'Lorem';
        if (modifiedItems.length > 1) {
          modifiedItems[1] = 'ipsum';
        }
      }
    } else if (_state.generationType == LoremIpsumType.sentences ||
        _state.generationType == LoremIpsumType.paragraphs) {
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
    notifyListeners();
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

  @override
  void dispose() {
    if (_isBoxOpen) {
      _box.close();
    }
    super.dispose();
  }
}
