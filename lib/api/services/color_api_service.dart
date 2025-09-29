import 'package:flutter/material.dart';
import '../interfaces/api_random_generator.dart';
import '../models/api_models.dart';
import '../../models/random_generator.dart';

// Configuration cho Color Generator API theo CustomAPI.md
class ColorApiConfig extends ApiConfig {
  final bool includeAlpha;
  final String type; // 'all', 'hex', 'rgb'

  ColorApiConfig({
    required this.includeAlpha,
    required this.type,
  });

  factory ColorApiConfig.fromJson(Map<String, dynamic> json) {
    return ColorApiConfig(
      includeAlpha: _parseBool(json['includeAlpha']) ?? true,
      type: (json['type'] as String?) ?? 'all',
    );
  }

  static bool? _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'includeAlpha': includeAlpha,
      'type': type,
    };
  }

  @override
  bool isValid() {
    return ['all', 'hex', 'rgb'].contains(type);
  }
}

// Color data model theo CustomAPI.md - trả về 1 color duy nhất
class ColorData {
  final String? hex;
  final String? rgb;
  final Color color;

  ColorData({
    this.hex,
    this.rgb,
    required this.color,
  });

  Map<String, dynamic> toJson(String type, bool includeAlpha) {
    final Map<String, dynamic> result = {};

    if (type == 'all' || type == 'hex') {
      result['hex'] = includeAlpha
          ? '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}'
          : '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
    }

    if (type == 'all' || type == 'rgb') {
      if (includeAlpha) {
        result['rgba'] =
            'rgba(${color.red}, ${color.green}, ${color.blue}, ${(color.alpha / 255).toStringAsFixed(2)})';
      } else {
        result['rgb'] = 'rgb(${color.red}, ${color.green}, ${color.blue})';
      }
    }

    return result;
  }
}

// Result cho Color Generator API - chỉ trả về 1 color
class ColorApiResult extends ApiResult {
  final ColorData color;
  final ColorApiConfig config;

  ColorApiResult({
    required this.color,
    required this.config,
  });

  @override
  Map<String, dynamic> toJson() {
    return color.toJson(config.type, config.includeAlpha);
  }
}

// Color Generator API Service
class ColorApiService
    implements ApiRandomGenerator<ColorApiConfig, ColorApiResult> {
  @override
  String get generatorName => 'color';

  @override
  String get description =>
      'Generate random colors in various formats (hex, rgb, hsl, hsv)';

  @override
  String get version => '1.0.0';

  @override
  Future<ColorApiResult> generate(ColorApiConfig config) async {
    if (!validateConfig(config)) {
      throw ArgumentError('Invalid configuration for color generator');
    }

    // Generate color via shared RandomGenerator for consistency
    final color = RandomGenerator.generateColor(withAlpha: config.includeAlpha);

    final colorData = ColorData(
      color: color,
    );

    return ColorApiResult(
      color: colorData,
      config: config,
    );
  }

  @override
  bool validateConfig(ColorApiConfig config) {
    return config.isValid();
  }

  @override
  ColorApiConfig getDefaultConfig() {
    return ColorApiConfig(
      includeAlpha: true,
      type: 'all',
    );
  }

  @override
  Map<String, dynamic> resultToJson(ColorApiResult result) {
    return {
      'data':
          result.color.toJson(result.config.type, result.config.includeAlpha),
      'metadata': {
        'config': result.config.toJson(),
        'generator': generatorName,
        'version': version,
      },
    };
  }

  @override
  ColorApiConfig parseConfig(Map<String, dynamic> params) {
    return ColorApiConfig.fromJson(params);
  }
}
