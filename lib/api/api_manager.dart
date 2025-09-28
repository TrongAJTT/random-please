import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/services/app_logger.dart';
import 'server/api_server.dart';
import 'services/platform_service.dart';

// API Manager để quản lý Local API Server theo SOLID principles
class ApiManager {
  final PlatformService _platformService;
  LocalApiServer? _server;
  int _currentPort = 4000;

  ApiManager({PlatformService? platformService})
      : _platformService = platformService ?? PlatformService();

  /// Get current configured port
  int get currentPort => _currentPort;

  /// Check if API is supported on current platform
  bool get isSupported => _platformService.supportsLocalApi;

  /// Check if server is running
  bool get isRunning => _server?.isRunning ?? false;

  /// Get server base URL
  String get baseUrl => _server?.baseUrl ?? '';

  /// Start the API server with custom port
  Future<void> startServer({int? port}) async {
    if (!isSupported) {
      throw UnsupportedError('Local API is not supported on this platform');
    }

    if (isRunning) {
      logInfo('🔄 API Server is already running at $baseUrl');
      return;
    }

    try {
      // Update current port if provided
      if (port != null) {
        _currentPort = port;
      }

      // Create platform-specific server instance
      // Conditional imports sẽ tự động chọn đúng implementation
      _server = LocalApiServerNative();

      await _server!.start(port: _currentPort);
      logInfo('✅ API Server started successfully at ${_server!.baseUrl}');
    } catch (e) {
      logError('❌ Failed to start API server: $e');
      rethrow;
    }
  }

  /// Stop the API server
  Future<void> stopServer() async {
    if (!isRunning) {
      logInfo('ℹ️ API Server is not running');
      return;
    }

    try {
      await _server?.stop();
      _server = null;
      logInfo('🛑 API Server stopped successfully');
    } catch (e) {
      logError('❌ Error stopping API server: $e');
      rethrow;
    }
  }

  /// Get server status information
  Map<String, dynamic> getStatus() {
    return {
      'supported': isSupported,
      'running': isRunning,
      'baseUrl': baseUrl,
      'platform': _platformService.getPlatformConfig(),
    };
  }

  /// Test if a port is available for binding
  Future<bool> testPortAvailability(int port) async {
    if (!isSupported) {
      return false;
    }

    try {
      // Try to create a temporary server to test port availability
      _server = LocalApiServerNative();
      await _server!.start(port: port);

      // If successful, stop the test server immediately
      await _server!.stop();
      _server = null;

      return true;
    } catch (e) {
      // Port is not available or there's an error
      _server = null;
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    stopServer();
  }
}

// Riverpod provider cho API Manager
final apiManagerProvider = Provider<ApiManager>((ref) {
  final manager = ApiManager();

  // Cleanup when provider is disposed
  ref.onDispose(() {
    manager.dispose();
  });

  return manager;
});

// State provider để theo dõi server status
class ApiServerState {
  final bool isSupported;
  final bool isRunning;
  final String baseUrl;
  final String? error;

  ApiServerState({
    required this.isSupported,
    required this.isRunning,
    required this.baseUrl,
    this.error,
  });

  ApiServerState copyWith({
    bool? isSupported,
    bool? isRunning,
    String? baseUrl,
    String? error,
  }) {
    return ApiServerState(
      isSupported: isSupported ?? this.isSupported,
      isRunning: isRunning ?? this.isRunning,
      baseUrl: baseUrl ?? this.baseUrl,
      error: error,
    );
  }
}

class ApiServerStateNotifier extends StateNotifier<ApiServerState> {
  final ApiManager _apiManager;

  ApiServerStateNotifier(this._apiManager)
      : super(ApiServerState(
          isSupported: _apiManager.isSupported,
          isRunning: _apiManager.isRunning,
          baseUrl: _apiManager.baseUrl,
        ));

  Future<void> startServer() async {
    try {
      state = state.copyWith(error: null);
      await _apiManager.startServer();
      state = state.copyWith(
        isRunning: true,
        baseUrl: _apiManager.baseUrl,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> stopServer() async {
    try {
      state = state.copyWith(error: null);
      await _apiManager.stopServer();
      state = state.copyWith(
        isRunning: false,
        baseUrl: '',
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
}

// Provider cho API server state
final apiServerStateProvider =
    StateNotifierProvider<ApiServerStateNotifier, ApiServerState>((ref) {
  final apiManager = ref.watch(apiManagerProvider);
  return ApiServerStateNotifier(apiManager);
});
