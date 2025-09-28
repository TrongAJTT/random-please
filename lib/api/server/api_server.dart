// Export implementation dựa trên platform
export 'api_server_native.dart' // Mặc định cho native platforms
    if (dart.library.html) 'api_server_web.dart'; // Web platform

// Abstract server interface
abstract class LocalApiServer {
  Future<void> start({int? port});
  Future<void> stop();
  bool get isRunning;
  String get baseUrl;
}
