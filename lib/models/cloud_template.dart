class CloudTemplate {
  final String name;
  final String lang;
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
