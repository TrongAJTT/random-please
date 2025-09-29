import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/providers/color_generator_state_provider.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/constants/history_types.dart';

// Temporary wrapper to maintain compatibility
class ColorGeneratorViewModel extends ChangeNotifier {
  static const String historyType = HistoryTypes.color;
  final WidgetRef? _ref;

  ColorGeneratorViewModel({WidgetRef? ref}) : _ref = ref;

  List<GenerationHistoryItem> _historyItems = [];
  bool _historyEnabled = false;
  Color _currentColor = Colors.blue; // Match screen gốc

  // Getters - now delegate to state manager
  ColorGeneratorState get state {
    if (_ref != null) {
      return _ref!.read(colorGeneratorStateManagerProvider);
    }
    return ColorGeneratorState.createDefault();
  }

  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  Color get currentColor => _currentColor;

  Future<void> initHive() async {
    _historyEnabled = await GenerationHistoryService.isHistoryEnabled();
    notifyListeners();
  }

  Future<void> loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history = await GenerationHistoryService.getHistory(historyType);
    _historyEnabled = enabled;
    _historyItems = history;
    notifyListeners();
  }

  void updateWithAlpha(bool value) {
    if (_ref != null) {
      _ref!
          .read(colorGeneratorStateManagerProvider.notifier)
          .updateWithAlpha(value);
    }
    notifyListeners();
  }

  Future<void> generateColor() async {
    final currentState = state;

    // Use RandomGenerator like original screen
    _currentColor =
        RandomGenerator.generateColor(withAlpha: currentState.withAlpha);

    // Save state on generate
    if (_ref != null) {
      await _ref!
          .read(colorGeneratorStateManagerProvider.notifier)
          .saveStateOnGenerate();
    }

    // Save to history if enabled (match original screen logic)
    if (_historyEnabled) {
      String colorText = getHexColor();
      if (_ref != null) {
        await _ref!
            .read(historyProvider.notifier)
            .addHistoryItem(colorText, historyType);
      } else {
        await GenerationHistoryService.addHistoryItem(colorText, historyType);
        await loadHistory();
      }
    }

    notifyListeners();
  }

  // Helper methods from original screen
  String getHexColor() {
    final currentState = state;
    final colorValue = _currentColor.toARGB32();
    if (currentState.withAlpha) {
      return '#${colorValue.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    } else {
      return '#${(colorValue & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
    }
  }

  String getRgbColor() {
    final currentState = state;
    if (currentState.withAlpha) {
      final alpha = (_currentColor.a / 255.0);
      return 'rgba(${_currentColor.r}, ${_currentColor.g}, ${_currentColor.b}, ${alpha.toStringAsFixed(2)})';
    } else {
      return 'rgb(${_currentColor.r}, ${_currentColor.g}, ${_currentColor.b})';
    }
  }

  String getHslColor() {
    final currentState = state;
    final hsl = _rgbToHsl(
        _currentColor.r as int, _currentColor.g as int, _currentColor.b as int);
    if (currentState.withAlpha) {
      final alpha = (_currentColor.a / 255.0);
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

  void copyColor(String value) {
    Clipboard.setData(ClipboardData(text: value));
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
}
