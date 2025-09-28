// API Response wrapper với metadata riêng biệt
class ApiResponse<T> {
  final bool success;
  final T? data;
  final Map<String, dynamic>? metadata;
  final String? error;
  final int timestamp;
  final String version;

  ApiResponse({
    required this.success,
    this.data,
    this.metadata,
    this.error,
    int? timestamp,
    this.version = "1.0.0",
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
      if (metadata != null) 'metadata': metadata,
      'error': error,
      'timestamp': timestamp,
      'version': version,
    };
  }

  // Success response factory with optional metadata
  factory ApiResponse.success(T data, {Map<String, dynamic>? metadata}) {
    return ApiResponse(
      success: true,
      data: data,
      metadata: metadata,
    );
  }

  // Error response factory
  factory ApiResponse.error(String errorMessage) {
    return ApiResponse(
      success: false,
      error: errorMessage,
    );
  }
}

// Configuration base class
abstract class ApiConfig {
  Map<String, dynamic> toJson();
  bool isValid();
}

// Result base class
abstract class ApiResult {
  Map<String, dynamic> toJson();
}
