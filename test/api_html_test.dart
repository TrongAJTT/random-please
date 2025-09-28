import 'package:flutter_test/flutter_test.dart';
import 'package:random_please/api/api_manager.dart';
import 'package:http/http.dart' as http;

void main() {
  group('API HTML Endpoints Tests', () {
    late ApiManager apiManager;

    setUp(() {
      apiManager = ApiManager();
    });

    tearDown(() async {
      if (apiManager.isRunning) {
        await apiManager.stopServer();
      }
    });

    test('Root endpoint should serve HTML with correct title', () async {
      await apiManager.startServer(port: 4003);

      final response = await http.get(Uri.parse('http://127.0.0.1:4003/'));

      expect(response.statusCode, 200);
      expect(response.headers['content-type'], contains('text/html'));
      expect(response.body, contains('<title>Random Please API</title>'));
      expect(response.body, contains('Server is running'));

      await apiManager.stopServer();
    });

    test('API documentation endpoint should work', () async {
      await apiManager.startServer(port: 4004);

      final response =
          await http.get(Uri.parse('http://127.0.0.1:4004/api/v1/doc'));

      expect(response.statusCode, 200);
      expect(response.headers['content-type'], contains('text/html'));
      expect(response.body,
          contains('<title>Random Please API Documentation</title>'));
      expect(response.body, contains('Generator Endpoints'));
      expect(response.body, contains('/api/v1/random/number'));

      await apiManager.stopServer();
    });

    test('Favicon endpoint should respond', () async {
      await apiManager.startServer(port: 4005);

      final response =
          await http.get(Uri.parse('http://127.0.0.1:4005/favicon.ico'));

      // Should redirect (301) or return success (200) depending on http client behavior
      expect(response.statusCode, isIn([200, 301]));

      await apiManager.stopServer();
    });

    test('Number generator with string parameters should work', () async {
      await apiManager.startServer(port: 4006);

      // Test with string parameters (como query params always come as strings)
      final response = await http.get(Uri.parse(
          'http://127.0.0.1:4006/api/v1/random/number?from=10&to=20&quantity=3&type=int&dup=false'));

      expect(response.statusCode, 200);
      final body = response.body;
      expect(body, contains('"success":true'));
      expect(
          body,
          contains(
              '"data"')); // New response format uses 'data' instead of 'numbers'
      expect(body, contains('"metadata"')); // Should have metadata section

      await apiManager.stopServer();
    });
  });
}
