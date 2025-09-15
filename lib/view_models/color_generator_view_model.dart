import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/services/generation_history_service.dart';

class ColorGeneratorViewModel extends ChangeNotifier {
  static const String boxName = 'colorGeneratorBox';
  static const String historyType = 'color';

  late Box<ColorGeneratorState> _box;
  ColorGeneratorState _state = ColorGeneratorState.createDefault();
  bool _isBoxOpen = false;
  bool _historyEnabled = false;
  List<GenerationHistoryItem> _historyItems = [];
  Color _currentColor = Colors.blue; // Match screen gốc

  // Getters
  ColorGeneratorState get state => _state;
  bool get isBoxOpen => _isBoxOpen;
  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  Color get currentColor => _currentColor;

  Future<void> initHive() async {
    _box = await Hive.openBox<ColorGeneratorState>(boxName);
    _state = _box.get('state') ?? ColorGeneratorState.createDefault();
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

  void updateWithAlpha(bool value) {
    _state = _state.copyWith(withAlpha: value);
    saveState();
    notifyListeners();
  }

  Future<void> generateColor() async {
    // Use RandomGenerator like original screen
    _currentColor = RandomGenerator.generateColor(withAlpha: _state.withAlpha);

    // Save to history if enabled (match original screen logic)
    if (_historyEnabled) {
      String colorText = getHexColor();
      await GenerationHistoryService.addHistoryItem(
        colorText,
        historyType,
      );
      await loadHistory();
    }

    notifyListeners();
  }

  // Helper methods from original screen
  String getHexColor() {
    if (_state.withAlpha) {
      return '#${_currentColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    } else {
      return '#${(_currentColor.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
    }
  }

  String getRgbColor() {
    if (_state.withAlpha) {
      final alpha = (_currentColor.alpha / 255.0);
      return 'rgba(${_currentColor.red}, ${_currentColor.green}, ${_currentColor.blue}, ${alpha.toStringAsFixed(2)})';
    } else {
      return 'rgb(${_currentColor.red}, ${_currentColor.green}, ${_currentColor.blue})';
    }
  }

  String getHslColor() {
    final hsl = _rgbToHsl(_currentColor.red, _currentColor.green, _currentColor.blue);
    if (_state.withAlpha) {
      final alpha = (_currentColor.alpha / 255.0);
      return 'hsla(${hsl[0].round()}, ${(hsl[1] * 100).round()}%, ${(hsl[2] * 100).round()}%, ${alpha.toStringAsFixed(2)})';
    } else {
      return 'hsl(${hsl[0].round()}, ${(hsl[1] * 100).round()}%, ${(hsl[2] * 100).round()}%)';
    }
  }

  List<double> _rgbToHsl(int r, int g, int b) {
    final rNorm = r / 255.0;
    final gNorm = g / 255.0;
    final bNorm = b / 255.0;

    final max = [rNorm, gNorm, bNorm].reduce((a, b) => a > b ? a : b);
    final min = [rNorm, gNorm, bNorm].reduce((a, b) => a < b ? a : b);

    double h, s, l = (max + min) / 2.0;

    if (max == min) {
      h = s = 0.0; // achromatic
    } else {
      final d = max - min;
      s = l > 0.5 ? d / (2.0 - max - min) : d / (max + min);
      switch (max) {
        case double max when max == rNorm:
          h = (gNorm - bNorm) / d + (gNorm < bNorm ? 6 : 0);
          break;
        case double max when max == gNorm:
          h = (bNorm - rNorm) / d + 2;
          break;
        case double max when max == bNorm:
          h = (rNorm - gNorm) / d + 4;
          break;
        default:
          h = 0;
      }
      h /= 6;
    }

    return [h * 360, s, l];
  }

  void clearColor() {
    _currentColor = Colors.blue;
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