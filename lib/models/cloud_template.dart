import 'package:hive/hive.dart';

part 'cloud_template.g.dart';

@HiveType(typeId: 14)
class CloudTemplate extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String lang;

  @HiveField(2)
  final List<String> values;

  CloudTemplate({
    required this.name,
    required this.lang,
    required this.values,
  });

  factory CloudTemplate.fromJson(Map<String, dynamic> json) {
    return CloudTemplate(
      name: json['name'] as String,
      lang: json['lang'] as String,
      values: List<String>.from(json['values'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lang': lang,
      'values': values,
    };
  }
}
