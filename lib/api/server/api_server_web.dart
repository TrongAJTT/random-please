import 'api_server.dart';

// Web implementation (stub) - Local API không hoạt động trên web
class LocalApiServerWeb implements LocalApiServer {
  @override
  bool get isRunning => false;

  @override
  String get baseUrl => '';

  @override
  Future<void> start({int? port}) async {
    print('❌ Local API Server không hoạt động trên nền tảng web');
    throw UnsupportedError('Local API Server is not supported on web platform');
  }

  @override
  Future<void> stop() async {
    // No-op trên web
  }
}
