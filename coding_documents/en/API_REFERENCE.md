# API Reference - Multi Tools Flutter App
Attch to commit Remove gray layout divider on PC layout | a4b6bb5082a004157e21c62f0624d4a2c7e289f9.

## Core Models

### Template Model
```dart
class Template {
  final String id;
  final String title;
  final String content;
  
  // Computed properties
  int get characterCount;
  int get fieldCount;
  int get loopCount;
  
  // Serialization
  Map<String, dynamic> toJson();
  factory Template.fromJson(Map<String, dynamic> json);
  Template copyWith({String? id, String? title, String? content});
}
```

### Random Generator Model
```dart
class RandomGeneratorConfig {
  final String type;
  final Map<String, dynamic> parameters;
  
  // Factory constructors for different generator types
  factory RandomGeneratorConfig.password({...});
  factory RandomGeneratorConfig.number({...});
  factory RandomGeneratorConfig.date({...});
}
```

## Services

### TemplateService
Static methods for template management:

```dart
class TemplateService {
  // CRUD Operations
  static Future<List<Template>> getTemplates();
  static Future<void> saveTemplate(Template template);
  static Future<void> deleteTemplate(String id);
  static Future<Template?> getTemplate(String id);
  
  // Utility
  static String generateTemplateId();
  static Future<String> getTemplatesDir();
}
```

### CacheService
Cache management for application data:

```dart
class CacheService {
  static Future<int> getTotalCacheSize();
  static Future<void> clearAllCache();
  static Future<void> clearCache(String cacheName);
  static String formatCacheSize(int bytes);
}
```

### FileLoggerService
High-performance file logging service with buffering and automatic cleanup:

```dart
class FileLoggerService {
  static FileLoggerService get instance;
  
  // Initialization & Disposal
  Future<void> initialize();
  Future<void> dispose();
  
  // Logging Methods
  void debug(String message, [Object? error, StackTrace? stackTrace]);
  void info(String message, [Object? error, StackTrace? stackTrace]);
  void warning(String message, [Object? error, StackTrace? stackTrace]);
  void error(String message, [Object? error, StackTrace? stackTrace]);
  
  // Log Management
  Future<List<File>> getLogFiles();
  Future<String> readLogFile(File file);
  Future<void> clearAllLogs();
  Future<void> cleanupOldLogs();
  
  // Performance Features
  static const int _maxBufferSize = 1024 * 10; // 10KB buffer
  static const Duration _flushInterval = Duration(seconds: 3);
  static const int _maxFileSize = 1024 * 1024 * 5; // 5MB per file
}
```

### AppLogger
Application-wide logger wrapper with simplified interface:

```dart
class AppLogger {
  static AppLogger get instance;
  
  // Initialization
  Future<void> initialize({String loggerName = 'MyMultiTools'});
  Future<void> dispose();
  
  // Logging Methods
  void debug(String message, [Object? error, StackTrace? stackTrace]);
  void info(String message, [Object? error, StackTrace? stackTrace]);
  void warning(String message, [Object? error, StackTrace? stackTrace]);
  void error(String message, [Object? error, StackTrace? stackTrace]);
  
  // Log File Management
  Future<List<String>> getLogFileNames();
  Future<String> readLogContent(String fileName);
  Future<void> cleanupOldLogs();
  Future<void> clearLogs();
}
```

### AppLogging Extension
Extension methods for easy object-specific logging:

```dart
extension AppLogging on Object {
  void logDebug(String message, [Object? error, StackTrace? stackTrace]);
  void logInfo(String message, [Object? error, StackTrace? stackTrace]);
  void logWarning(String message, [Object? error, StackTrace? stackTrace]);
  void logError(String message, [Object? error, StackTrace? stackTrace]);
}
```

## Widget Components

### ToolCard
Reusable card component for tool selection:

```dart
class ToolCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final bool isSelected;
  final bool showActions;
}
```

### ImportStatusDialog
Shows results of batch import operations:

```dart
class ImportStatusDialog extends StatelessWidget {
  final List<ImportResult> results;
}

class ImportResult {
  final String fileName;
  final bool success;
  final String? errorMessage;
}
```

### BatchExportDialog
Handles batch export with filename customization:

```dart
class BatchExportDialog extends StatefulWidget {
  final List<Template> templates;
  final Map<String, String> initialFilenames;
  final Function(Map<String, String>) onExport;
}
```

### BatchDeleteDialog
Confirmation dialog for batch delete operations:

```dart
class BatchDeleteDialog extends StatelessWidget {
  final int templateCount;
  final VoidCallback onConfirm;
}
```

## Screen APIs

### Embedded Mode Interface
All screens implementing embedded mode must follow this pattern:

```dart
abstract class EmbeddedScreen {
  final bool isEmbedded;
  final Function(Widget, String)? onToolSelected;
  
  Widget buildContent(); // Main content without Scaffold
  Widget buildScaffold(); // Full screen with AppBar
}
```

### Navigation Callbacks
```dart
typedef ToolSelectedCallback = void Function(Widget tool, String title);
```

## Settings Controller

### SettingsController
Global settings management:

```dart
class SettingsController extends ChangeNotifier {
  ThemeMode get themeMode;
  Locale get locale;
  
  Future<void> loadSettings();
  Future<void> setThemeMode(ThemeMode mode);
  Future<void> setLocale(Locale locale);
}

// Global instance
final SettingsController settingsController = SettingsController();
```

## Localization

### AppLocalizations
Generated localization class:

```dart
class AppLocalizations {
  // Static access
  static AppLocalizations of(BuildContext context);
  static const LocalizationsDelegate<AppLocalizations> delegate;
  static const List<Locale> supportedLocales;
  
  // Localized strings
  String get title;
  String get settings;
  String get random;
  String get textTemplateGen;
  
  // Parameterized strings
  String characterCount(int count);
  String fieldsAndLoops(int fields, int loops);
  String selectedTemplates(int count);
}
```

## File Operations

### File Handling Patterns
```dart
// Template export
Future<void> exportTemplate(Template template) async {
  final json = template.toJson();
  final jsonString = jsonEncode(json);
  
  String? path = await FilePicker.platform.saveFile(
    fileName: '${template.title}.json',
    type: FileType.custom,
    allowedExtensions: ['json'],
  );
  
  if (path != null) {
    await File(path).writeAsString(jsonString);
  }
}

// Template import
Future<Template> importTemplate(String filePath) async {
  final jsonString = await File(filePath).readAsString();
  final json = jsonDecode(jsonString);
  return Template.fromJson(json);
}
```

## Error Handling

### Standard Error Patterns
```dart
try {
  await someOperation();
  // Show success message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(loc.operationSuccess)),
  );
} catch (e) {
  // Show error message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(loc.errorMessage(e.toString())),
      backgroundColor: Colors.red,
    ),
  );
}
```

## Constants

### Breakpoints
```dart
const double mobileBreakpoint = 600.0;
```

### File Extensions
```dart
const List<String> supportedTemplateExtensions = ['json'];
```

### Default Values
```dart
const String defaultLanguage = 'en';
const ThemeMode defaultTheme = ThemeMode.system;
```
