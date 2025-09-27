import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/models/random_generator.dart';
import 'package:random_please/services/generation_history_service.dart';

// Combined view state for ColorGenerator
@immutable
class ColorGeneratorViewState {
  final ColorGeneratorState generatorState;
  final bool isBoxOpen;
  final bool historyEnabled;
  final List<GenerationHistoryItem> historyItems;
  final Color currentColor;

  const ColorGeneratorViewState({
    required this.generatorState,
    required this.isBoxOpen,
    required this.historyEnabled,
    required this.historyItems,
    required this.currentColor,
  });

  ColorGeneratorViewState copyWith({
    ColorGeneratorState? generatorState,
    bool? isBoxOpen,
    bool? historyEnabled,
    List<GenerationHistoryItem>? historyItems,
    Color? currentColor,
  }) {
    return ColorGeneratorViewState(
      generatorState: generatorState ?? this.generatorState,
      isBoxOpen: isBoxOpen ?? this.isBoxOpen,
      historyEnabled: historyEnabled ?? this.historyEnabled,
      historyItems: historyItems ?? this.historyItems,
      currentColor: currentColor ?? this.currentColor,
    );
  }
}

// Notifier for ColorGenerator
class ColorGeneratorNotifier extends StateNotifier<ColorGeneratorViewState> {
  static const String boxName = 'colorGeneratorBox';
  static const String historyType = 'color';

  late Box<ColorGeneratorState> _box;

  ColorGeneratorNotifier()
      : super(ColorGeneratorViewState(
          generatorState: ColorGeneratorState.createDefault(),
          isBoxOpen: false,
          historyEnabled: false,
          historyItems: const [],
          currentColor: Colors.blue,
        )) {
    _init();
  }

  Future<void> _init() async {
    await initHive();
    await loadHistory();
  }

  Future<void> initHive() async {
    _box = await Hive.openBox<ColorGeneratorState>(boxName);
    final savedState = _box.get('state') ?? ColorGeneratorState.createDefault();
    state = state.copyWith(
      generatorState: savedState,
      isBoxOpen: true,
    );
  }

  Future<void> loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history = await GenerationHistoryService.getHistory(historyType);
    state = state.copyWith(
      historyEnabled: enabled,
      historyItems: history,
    );
  }

  void saveState() {
    if (state.isBoxOpen) {
      _box.put('state', state.generatorState);
    }
  }

  void updateWithAlpha(bool value) {
    final newState = state.generatorState.copyWith(withAlpha: value);
    state = state.copyWith(generatorState: newState);
    saveState();
  }

  Future<void> generateColor() async {
    // Use RandomGenerator like original screen
    final newColor = RandomGenerator.generateColor(
        withAlpha: state.generatorState.withAlpha);
    state = state.copyWith(currentColor: newColor);

    // Save to history if enabled using new standardized encoding
    if (state.historyEnabled) {
      String colorText = getHexColor();
      await GenerationHistoryService.addHistoryItems([colorText], historyType);
      await loadHistory();
    }
  }

  // Helper methods from original screen
  String getHexColor() {
    final colorValue = state.currentColor.toARGB32();
    if (state.generatorState.withAlpha) {
      return '#${colorValue.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    } else {
      return '#${(colorValue & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
    }
  }

  String getRgbColor() {
    final color = state.currentColor;
    if (state.generatorState.withAlpha) {
      final alpha = (color.a / 255.0);
      return 'rgba(${color.r}, ${color.g}, ${color.b}, ${alpha.toStringAsFixed(2)})';
    } else {
      return 'rgb(${color.r}, ${color.g}, ${color.b})';
    }
  }

  String getHslColor() {
    final color = state.currentColor;
    final hsl = _rgbToHsl(color.r as int, color.g as int, color.b as int);
    if (state.generatorState.withAlpha) {
      final alpha = (color.a / 255.0);
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
    state = state.copyWith(currentColor: Colors.blue);
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

// Provider for ColorGenerator
final colorGeneratorProvider =
    StateNotifierProvider<ColorGeneratorNotifier, ColorGeneratorViewState>(
  (ref) => ColorGeneratorNotifier(),
);
