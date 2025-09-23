import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/providers/history_provider.dart';
import 'dart:math';

class NumberGeneratorState {
  final int? min;
  final int? max;
  final int? count;
  final List<int> results;
  final String? errorMessage;
  final bool isLoading;

  const NumberGeneratorState({
    this.min,
    this.max,
    this.count,
    this.results = const [],
    this.errorMessage,
    this.isLoading = false,
  });

  NumberGeneratorState copyWith({
    int? min,
    int? max,
    int? count,
    List<int>? results,
    String? errorMessage,
    bool? isLoading,
  }) {
    return NumberGeneratorState(
      min: min ?? this.min,
      max: max ?? this.max,
      count: count ?? this.count,
      results: results ?? this.results,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class NumberGeneratorNotifier extends StateNotifier<NumberGeneratorState> {
  final Ref ref;
  
  NumberGeneratorNotifier(this.ref) : super(const NumberGeneratorState());

  void setMin(int min) {
    state = state.copyWith(min: min, errorMessage: null);
  }

  void setMax(int max) {
    state = state.copyWith(max: max, errorMessage: null);
  }

  void setCount(int count) {
    state = state.copyWith(count: count, errorMessage: null);
  }

  Future<void> generateNumbers() async {
    final min = state.min;
    final max = state.max;
    final count = state.count;

    if (min == null || max == null || count == null) {
      state = state.copyWith(errorMessage: "Vui lòng nhập đầy đủ thông tin");
      return;
    }

    if (min > max) {
      state = state.copyWith(errorMessage: "Số nhỏ nhất phải nhỏ hơn hoặc bằng số lớn nhất");
      return;
    }

    if (count <= 0) {
      state = state.copyWith(errorMessage: "Số lượng phải lớn hơn 0");
      return;
    }

    if (count > 10000) {
      state = state.copyWith(errorMessage: "Số lượng không được vượt quá 10.000");
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final random = Random();
      final results = <int>[];
      
      for (int i = 0; i < count; i++) {
        results.add(min + random.nextInt(max - min + 1));
      }

      state = state.copyWith(results: results, isLoading: false);

      // Save to history as a single string
      final resultString = results.join(", ");
      final historyNotifier = ref.read(historyProvider.notifier);
      await historyNotifier.addHistoryItem(resultString, "number");
    } catch (e) {
      state = state.copyWith(
        errorMessage: "Có lỗi xảy ra: $e",
        isLoading: false,
      );
    }
  }

  void clearResults() {
    state = state.copyWith(results: [], errorMessage: null);
  }
}

final numberGeneratorProvider = StateNotifierProvider<NumberGeneratorNotifier, NumberGeneratorState>(
  (ref) => NumberGeneratorNotifier(ref),
);