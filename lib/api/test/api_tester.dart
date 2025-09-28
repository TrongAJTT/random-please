import 'dart:convert';
import 'package:http/http.dart' as http;

// Demo test class để kiểm tra Local API functionality
class LocalApiTester {
  final String baseUrl;

  LocalApiTester({required this.baseUrl});

  // Test health endpoint
  Future<void> testHealth() async {
    print('🧪 Testing health endpoint...');
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Health check passed: ${data['data']['status']}');
      } else {
        print('❌ Health check failed');
      }
    } catch (e) {
      print('❌ Health check error: $e');
    }
    print('');
  }

  // Test API info endpoint
  Future<void> testInfo() async {
    print('🧪 Testing info endpoint...');
    try {
      final response = await http.get(Uri.parse('$baseUrl/info'));
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ API Info: ${data['data']['name']}');
      } else {
        print('❌ Info test failed');
      }
    } catch (e) {
      print('❌ Info test error: $e');
    }
    print('');
  }

  // Test generators list endpoint
  Future<void> testGenerators() async {
    print('🧪 Testing generators endpoint...');
    try {
      final response = await http.get(Uri.parse('$baseUrl/generators'));
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final generators = data['data'] as List;
        print('✅ Found ${generators.length} generators:');
        for (final gen in generators) {
          print('  - ${gen['name']}: ${gen['description']}');
        }
      } else {
        print('❌ Generators test failed');
      }
    } catch (e) {
      print('❌ Generators test error: $e');
    }
    print('');
  }

  // Test number generator
  Future<void> testNumberGenerator() async {
    print('🧪 Testing number generator...');
    try {
      final url =
          '$baseUrl/api/v1/random/number?minValue=1&maxValue=100&quantity=5&isInteger=true&allowDuplicates=true';
      final response = await http.get(Uri.parse(url));
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final numbers = data['data']['numbers'];
        print('✅ Generated numbers: $numbers');
      } else {
        print('❌ Number generator test failed');
      }
    } catch (e) {
      print('❌ Number generator test error: $e');
    }
    print('');
  }

  // Test color generator
  Future<void> testColorGenerator() async {
    print('🧪 Testing color generator...');
    try {
      final url =
          '$baseUrl/api/v1/random/color?quantity=3&formats=hex&formats=rgb';
      final response = await http.get(Uri.parse(url));
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final colors = data['data']['colors'];
        print('✅ Generated colors:');
        for (final color in colors) {
          print('  - Hex: ${color['hex']}, RGB: ${color['rgb']}');
        }
      } else {
        print('❌ Color generator test failed');
      }
    } catch (e) {
      print('❌ Color generator test error: $e');
    }
    print('');
  }

  // Run all tests
  Future<void> runAllTests() async {
    print('🚀 Starting Local API Tests');
    print('Base URL: $baseUrl');
    print('=' * 50);

    await testHealth();
    await testInfo();
    await testGenerators();
    await testNumberGenerator();
    await testColorGenerator();

    print('✅ All tests completed!');
  }
}
