import 'package:flutter_test/flutter_test.dart';
import 'package:random_please/api/api_manager.dart';
import 'package:random_please/api/test/api_tester.dart';

void main() {
  group('API Integration Tests', () {
    late ApiManager apiManager;

    setUp(() {
      apiManager = ApiManager();
    });

    tearDown(() async {
      if (apiManager.isRunning) {
        await apiManager.stopServer();
      }
    });

    test('API Manager should start and stop server', () async {
      // Start server
      expect(apiManager.isRunning, false);

      await apiManager.startServer(port: 4001);
      expect(apiManager.isRunning, true);
      expect(apiManager.baseUrl, 'http://127.0.0.1:4001');

      // Stop server
      await apiManager.stopServer();
      expect(apiManager.isRunning, false);
    }, timeout: const Timeout(Duration(seconds: 30)));

    test('API endpoints should work correctly', () async {
      await apiManager.startServer(port: 4002);

      final tester = LocalApiTester(baseUrl: 'http://127.0.0.1:4002');

      // Test endpoints
      await tester.testHealth();
      await tester.testInfo();
      await tester.testNumberGenerator();
      await tester.testColorGenerator();
      await tester.testGenerators();

      await apiManager.stopServer();
    }, timeout: const Timeout(Duration(seconds: 60)));
  });
}
