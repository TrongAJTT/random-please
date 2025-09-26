import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/cloud_template.dart';
import '../variables.dart';

class CloudTemplateService {
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<List<CloudTemplate>> fetchCloudTemplates() async {
    try {
      final response = await http.get(
        // @NOTICE: Refactoring needed if multiple endpoints are used
        Uri.parse(authorCloudListEndpoint),
        headers: {
          'User-Agent': userAgent,
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => CloudTemplate.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load templates: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch templates: $e');
    }
  }
}
