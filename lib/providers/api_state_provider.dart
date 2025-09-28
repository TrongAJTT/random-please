import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_manager.dart';

// State class để quản lý API server
class ApiState {
  final bool isRunning;
  final int port;
  final String? error;
  final String baseUrl;

  const ApiState({
    required this.isRunning,
    required this.port,
    this.error,
    required this.baseUrl,
  });

  ApiState copyWith({
    bool? isRunning,
    int? port,
    String? error,
    String? baseUrl,
  }) {
    return ApiState(
      isRunning: isRunning ?? this.isRunning,
      port: port ?? this.port,
      error: error ?? this.error,
      baseUrl: baseUrl ?? this.baseUrl,
    );
  }
}

// Notifier class để quản lý API state
class ApiStateNotifier extends StateNotifier<ApiState> {
  final ApiManager _apiManager;

  ApiStateNotifier(this._apiManager)
      : super(const ApiState(
          isRunning: false,
          port: 4000,
          baseUrl: '',
        ));

  /// Start API server với port được chỉ định
  Future<void> startServer({int? port}) async {
    try {
      // Clear previous error
      state = state.copyWith(error: null);

      await _apiManager.startServer(port: port);

      state = state.copyWith(
        isRunning: true,
        port: _apiManager.currentPort,
        baseUrl: _apiManager.baseUrl,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isRunning: false,
      );
      rethrow;
    }
  }

  /// Stop API server
  Future<void> stopServer() async {
    try {
      await _apiManager.stopServer();

      state = state.copyWith(
        isRunning: false,
        baseUrl: '',
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Update port (chỉ khi server không chạy)
  void updatePort(int newPort) {
    if (!state.isRunning) {
      state = state.copyWith(port: newPort);
    }
  }

  /// Check if API is supported on current platform
  bool get isSupported => _apiManager.isSupported;
}

// Provider instances
final apiManagerProvider = Provider<ApiManager>((ref) => ApiManager());

final apiStateProvider =
    StateNotifierProvider<ApiStateNotifier, ApiState>((ref) {
  final apiManager = ref.watch(apiManagerProvider);
  return ApiStateNotifier(apiManager);
});
