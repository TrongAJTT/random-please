class AuthorProduct {
  final String code;
  final String name;
  final String logo;
  final String desc;
  final String link;

  AuthorProduct({
    required this.code,
    required this.name,
    required this.logo,
    required this.desc,
    required this.link,
  });

  factory AuthorProduct.fromJson(Map<String, dynamic> json) {
    return AuthorProduct(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      desc: json['desc'] ?? '',
      link: json['link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'logo': logo,
      'desc': desc,
      'link': link,
    };
  }

  @override
  String toString() {
    return 'AuthorProduct(code: $code, name: $name, desc: $desc, link: $link)';
  }
}
