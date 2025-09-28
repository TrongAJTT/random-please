// Base interface cho tất cả random generators trong API
abstract class ApiRandomGenerator<TConfig, TResult> {
  /// Tên của generator (ví dụ: "number", "color", "password")
  String get generatorName;

  /// Mô tả của generator
  String get description;

  /// Phiên bản API được support
  String get version;

  /// Generate random data với configuration
  Future<TResult> generate(TConfig config);

  /// Validate configuration trước khi generate
  bool validateConfig(TConfig config);

  /// Lấy default configuration
  TConfig getDefaultConfig();

  /// Chuyển đổi result thành JSON format cho API response
  /// Trả về Map với 'data' và 'metadata' keys
  Map<String, dynamic> resultToJson(TResult result);

  /// Parse configuration từ query parameters hoặc request body
  TConfig parseConfig(Map<String, dynamic> params);
}
