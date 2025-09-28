import 'dart:io';
import 'dart:convert';
import 'dart:isolate';
import 'package:random_please/services/app_logger.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'api_server.dart';
import '../services/api_service_registry.dart';
import '../models/api_models.dart';
import '../../variables.dart';

// Native implementation của Local API Server
class LocalApiServerNative implements LocalApiServer {
  int port;
  static const String host = '127.0.0.1';

  Isolate? _isolate;
  bool _isRunning = false;

  LocalApiServerNative({this.port = 4000});

  @override
  bool get isRunning => _isRunning;

  @override
  String get baseUrl => 'http://$host:$port';

  @override
  Future<void> start({int? port}) async {
    if (_isRunning) return;

    // Update port if provided
    if (port != null) {
      this.port = port;
    }

    try {
      // Start server in isolate to avoid blocking UI
      final receivePort = ReceivePort();
      _isolate = await Isolate.spawn(_serverEntryPoint,
          {'sendPort': receivePort.sendPort, 'port': this.port});

      // Wait for confirmation from isolate
      await receivePort.first;
      _isRunning = true;

      logInfo('✅ Local API Server started at $baseUrl');
    } catch (e) {
      logError('❌ Failed to start API server: $e');
      throw Exception('Failed to start API server: $e');
    }
  }

  @override
  Future<void> stop() async {
    if (!_isRunning) return;

    try {
      _isolate?.kill();
      _isolate = null;
      _isRunning = false;
      logInfo('🛑 Local API Server stopped');
    } catch (e) {
      logError('❌ Error stopping API server: $e');
    }
  }

  // Entry point for isolate
  static void _serverEntryPoint(Map<String, dynamic> params) async {
    final SendPort sendPort = params['sendPort'];
    final int port = params['port'];
    final app = Router();
    final serviceRegistry = ApiServiceRegistry();

    // CORS middleware
    final corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
    };

    // CORS middleware function
    Handler corsMiddleware(Handler innerHandler) {
      return (Request request) async {
        final response = await innerHandler(request);
        return response.change(headers: {...response.headers, ...corsHeaders});
      };
    }

    // Middleware pipeline
    final handler = const Pipeline()
        .addMiddleware(corsMiddleware)
        .addMiddleware(logRequests())
        .addMiddleware(_errorHandler)
        .addHandler(app);

    // Health check endpoint
    app.get('/health', (Request request) {
      return Response.ok(
        jsonEncode(ApiResponse.success({
          'status': 'healthy',
          'timestamp': DateTime.now().toIso8601String(),
          'version': '1.0.0',
        }).toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // Root endpoint - serve HTML page
    app.get('/', (Request request) {
      return Response.ok(
        _buildHtmlPage(
            'Random Please API', 'Welcome to Random Please Local API'),
        headers: {'Content-Type': 'text/html'},
      );
    });

    // Favicon endpoint - redirect to actual icon
    app.get('/favicon.ico', (Request request) {
      // Redirect to the app icon URL from variables
      return Response.movedPermanently(appAssetIconUrl);
    });

    // API info endpoint
    app.get('/info', (Request request) {
      return Response.ok(
        jsonEncode(ApiResponse.success({
          'name': 'Random Please Local API',
          'version': '1.0.0',
          'baseUrl': 'http://$host:${port}',
          'endpoints': {
            'health': '/health',
            'info': '/info',
            'generators': '/generators',
            'random': '/api/v1/random/{generator}',
            'documentation': '/api/v1/doc',
          },
        }).toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // List available generators
    app.get('/generators', (Request request) {
      final generators = serviceRegistry.getServicesInfo();
      return Response.ok(
        jsonEncode(ApiResponse.success(generators).toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // API Documentation endpoint
    app.get('/api/v1/doc', (Request request) {
      return Response.ok(
        _buildHtmlPage('Random Please API Documentation',
            'Complete API documentation for all endpoints',
            body: _buildApiDocumentationBody(serviceRegistry, port)),
        headers: {'Content-Type': 'text/html'},
      );
    });

    // Random generator endpoints
    app.get('/api/v1/random/<generator>',
        (Request request, String generator) async {
      try {
        final service = serviceRegistry.getService(generator);
        if (service == null) {
          return Response.notFound(
            jsonEncode(
                ApiResponse.error('Generator "$generator" not found').toJson()),
            headers: {'Content-Type': 'application/json'},
          );
        }

        // Parse query parameters
        final params = request.url.queryParameters;
        final config = service.parseConfig(params);

        if (!service.validateConfig(config)) {
          return Response.badRequest(
            body: jsonEncode(
                ApiResponse.error('Invalid configuration parameters').toJson()),
            headers: {'Content-Type': 'application/json'},
          );
        }

        // Generate result
        final result = await service.generate(config);
        final jsonResult = service.resultToJson(result);

        return Response.ok(
          jsonEncode(ApiResponse.success(jsonResult['data'],
                  metadata: jsonResult['metadata'])
              .toJson()),
          headers: {
            'Content-Type': 'application/json',
            'X-Title': 'Random Please API - $generator'
          },
        );
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode(ApiResponse.error('Generation failed: $e').toJson()),
          headers: {'Content-Type': 'application/json'},
        );
      }
    });

    // OPTIONS handler for CORS preflight
    app.options('/<path|.*>', (Request request, String path) {
      return Response.ok('', headers: corsHeaders);
    });

    // 404 handler
    app.all('/<path|.*>', (Request request, String path) {
      return Response.notFound(
        jsonEncode(
            ApiResponse.error('Endpoint not found: ${request.method} /$path')
                .toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    });

    try {
      final server =
          await shelf_io.serve(handler, InternetAddress.loopbackIPv4, port);
      server.autoCompress = true;

      // Notify main isolate that server started
      sendPort.send('started');

      logInfo(
          '🚀 API Server running on http://${server.address.host}:${server.port}');
    } catch (e) {
      sendPort.send('error: $e');
    }
  }

  // Helper method to build HTML pages
  static String _buildHtmlPage(String title, String content, {String? body}) {
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$title</title>
    <link rel="icon" type="image/png" href="$appAssetIconUrl">
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            border-bottom: 3px solid #007acc;
            padding-bottom: 10px;
        }
        h2 {
            color: #555;
            margin-top: 30px;
        }
        .endpoint {
            background: #f8f9fa;
            padding: 15px;
            border-left: 4px solid #007acc;
            margin: 10px 0;
            border-radius: 4px;
        }
        .method {
            font-weight: bold;
            color: #28a745;
        }
        code {
            background: #e9ecef;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Courier New', monospace;
        }
        pre {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
        }
        .status-running {
            color: #28a745;
            font-weight: bold;
        }
        .api-links {
            display: flex;
            gap: 10px;
            margin: 20px 0;
            flex-wrap: wrap;
        }
        .api-link {
            padding: 10px 15px;
            background: #007acc;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        .api-link:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>$title</h1>
        <p class="status-running">🚀 Server is running</p>
        <p>$content</p>
        ${body ?? _buildDefaultApiBody()}
    </div>
</body>
</html>''';
  }

  static String _buildDefaultApiBody() {
    return '''
        <h2>Available Endpoints</h2>
        <div class="api-links">
            <a href="/info" class="api-link">📋 API Information</a>
            <a href="/generators" class="api-link">🎲 Available Generators</a>
            <a href="/api/v1/doc" class="api-link">📖 Full Documentation</a>
            <a href="/health" class="api-link">❤️ Health Check</a>
        </div>
        
        <div class="endpoint">
            <div class="method">GET</div>
            <strong>/health</strong> - Server health status
        </div>
        
        <div class="endpoint">
            <div class="method">GET</div>
            <strong>/info</strong> - API information and endpoints
        </div>
        
        <div class="endpoint">
            <div class="method">GET</div>
            <strong>/generators</strong> - List all available generators
        </div>
        
        <div class="endpoint">
            <div class="method">GET</div>
            <strong>/api/v1/random/{generator}</strong> - Generate random data
        </div>
        
        <div class="endpoint">
            <div class="method">GET</div>
            <strong>/api/v1/doc</strong> - Full API documentation
        </div>
        
        <h2>Quick Examples</h2>
        <div class="endpoint">
            <strong>Generate random numbers:</strong><br>
            <code>/api/v1/random/number?from=1&to=100&quantity=5&type=int</code>
        </div>
        
        <div class="endpoint">
            <strong>Generate random colors:</strong><br>
            <code>/api/v1/random/color?type=hex&includeAlpha=true</code>
        </div>
        
        <div class="endpoint">
            <strong>Generate password:</strong><br>
            <code>/api/v1/random/password?quantity=12&upper=true&number=true</code>
        </div>
    ''';
  }

  static String _buildApiDocumentationBody(
      ApiServiceRegistry serviceRegistry, int port) {
    final generators = serviceRegistry.getServicesInfo();
    final baseUrl = 'http://$host:$port';

    final buffer = StringBuffer();

    buffer.write('''
        <h2>🎯 API Overview</h2>
        <p>Random Please Local API provides endpoints to generate various types of random data. All endpoints support CORS and return JSON responses.</p>
        
        <div class="endpoint">
            <strong>Base URL:</strong> <code>$baseUrl</code>
        </div>
        
        <h2>📋 Core Endpoints</h2>
        
        <div class="endpoint">
            <div class="method">GET</div>
            <strong>/health</strong><br>
            <em>Check server health status</em><br>
            <strong>Response:</strong> <code>{"success": true, "data": {"status": "healthy"}}</code>
        </div>
        
        <div class="endpoint">
            <div class="method">GET</div>
            <strong>/info</strong><br>
            <em>Get API information and available endpoints</em><br>
            <strong>Response:</strong> API metadata with endpoint list
        </div>
        
        <div class="endpoint">
            <div class="method">GET</div>
            <strong>/generators</strong><br>
            <em>List all available random generators</em><br>
            <strong>Response:</strong> Array of generator information
        </div>
        
        <h2>🎲 Generator Endpoints</h2>
        <p>All generators follow the pattern: <code>/api/v1/random/{generator}</code></p>
    ''');

    // Document each generator
    for (final generator in generators) {
      final name = generator['name'] as String;
      final description = generator['description'] as String;

      buffer.write('''
        <div class="endpoint">
            <div class="method">GET</div>
            <strong>/api/v1/random/$name</strong><br>
            <em>$description</em><br>
            <strong>Example:</strong> <code>$baseUrl/api/v1/random/$name${_getExampleParams(name)}</code><br>
            ${_getParameterDocumentation(name)}
        </div>
      ''');
    }

    buffer.write('''
        <h2>📝 Response Format</h2>
        <p>All API responses follow a consistent format:</p>
        <pre>{
  "success": true|false,
  "data": [...] | "..." | {...},  // ← Clean data only
  "metadata": {                   // ← Configuration & info
    "count": 5,
    "config": {...},
    "generator": "number",
    "version": "1.0.0"
  },
  "error": "error message" | null,
  "timestamp": 1234567890,
  "version": "1.0.0"
}</pre>
        
        <h2>🎯 New Data Structure</h2>
        <p><strong>Clean Separation:</strong></p>
        <ul>
            <li><strong>data:</strong> Pure random results (numbers, colors, strings, etc.)</li>
            <li><strong>metadata:</strong> Configuration, count, generator info</li>
        </ul>
        
        <h2>🔧 Common Parameters</h2>
        <div class="endpoint">
            <strong>quantity:</strong> Number of items to generate (default: varies by generator)<br>
            <strong>type:</strong> Output format type (generator-specific)<br>
        </div>
        
        <h2>⚠️ Error Handling</h2>
        <p>HTTP Status Codes:</p>
        <ul>
            <li><strong>200 OK:</strong> Successful request</li>
            <li><strong>400 Bad Request:</strong> Invalid parameters</li>
            <li><strong>404 Not Found:</strong> Generator not found</li>
            <li><strong>500 Internal Server Error:</strong> Server error</li>
        </ul>
        
        <h2>🌐 CORS Support</h2>
        <p>All endpoints support Cross-Origin Resource Sharing (CORS) for web applications.</p>
    ''');

    return buffer.toString();
  }

  static String _getExampleParams(String generator) {
    switch (generator) {
      case 'number':
        return '?from=1&to=100&quantity=5&type=int&dup=true';
      case 'color':
        return '?type=hex&includeAlpha=true';
      case 'password':
        return '?quantity=12&upper=true&lower=true&number=true&special=true';
      case 'card':
        return '?quantity=5&includeJokers=false';
      case 'coin':
        return '?quantity=10';
      case 'dice':
        return '?quantity=5&sides=6';
      case 'rps':
        return '?quantity=3';
      case 'yesno':
        return '?quantity=5';
      default:
        return '';
    }
  }

  static String _getParameterDocumentation(String generator) {
    switch (generator) {
      case 'number':
        return '''<strong>Parameters:</strong>
            <ul>
                <li><code>from</code> (number): Minimum value (default: 1)</li>
                <li><code>to</code> (number): Maximum value (default: 100)</li>
                <li><code>quantity</code> (integer): Number of numbers to generate (default: 1)</li>
                <li><code>type</code> (string): "int" or "float" (default: "int")</li>
                <li><code>dup</code> (boolean): Allow duplicates (default: true)</li>
            </ul>''';
      case 'color':
        return '''<strong>Parameters:</strong>
            <ul>
                <li><code>type</code> (string): "hex", "rgb", "hsl", "hsv", or "all" (default: "all")</li>
                <li><code>includeAlpha</code> (boolean): Include alpha channel (default: true)</li>
            </ul>''';
      case 'password':
        return '''<strong>Parameters:</strong>
            <ul>
                <li><code>quantity</code> (integer): Password length (default: 8)</li>
                <li><code>upper</code> (boolean): Include uppercase letters (default: true)</li>
                <li><code>lower</code> (boolean): Include lowercase letters (default: true)</li>
                <li><code>number</code> (boolean): Include numbers (default: true)</li>
                <li><code>special</code> (boolean): Include special characters (default: true)</li>
            </ul>''';
      case 'card':
        return '''<strong>Parameters:</strong>
            <ul>
                <li><code>quantity</code> (integer): Number of cards (default: 1)</li>
                <li><code>includeJokers</code> (boolean): Include joker cards (default: false)</li>
            </ul>''';
      case 'coin':
      case 'rps':
      case 'yesno':
        return '''<strong>Parameters:</strong>
            <ul>
                <li><code>quantity</code> (integer): Number of results (default: 10)</li>
            </ul>''';
      case 'dice':
        return '''<strong>Parameters:</strong>
            <ul>
                <li><code>quantity</code> (integer): Number of dice (default: 10)</li>
                <li><code>sides</code> (integer): Number of sides per die (default: 6)</li>
            </ul>''';
      default:
        return '';
    }
  }

  // Error handling middleware
  static Future<Response> Function(Request request) _errorHandler(
      Handler innerHandler) {
    return (Request request) async {
      try {
        return await innerHandler(request);
      } catch (e, stackTrace) {
        logError('API Error: $e');
        logError('Stack trace: $stackTrace');

        return Response.internalServerError(
          body: jsonEncode(ApiResponse.error('Internal server error').toJson()),
          headers: {'Content-Type': 'application/json'},
        );
      }
    };
  }
}
