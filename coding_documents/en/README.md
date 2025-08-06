# Multi Tools Flutter App - Coding Documentation
Attch to commit Remove gray layout divider on PC layout | a4b6bb5082a004157e21c62f0624d4a2c7e289f9.

## Overview
A cross-platform Flutter application providing various utility tools including text template generation and random generators. The app features responsive design with dedicated mobile and desktop layouts.

## Architecture

### Project Structure
```
lib/
├── main.dart                    # App entry point and layout management
├── l10n/                       # Internationalization files
├── models/                     # Data models
├── screens/                    # UI screens
├── services/                   # Business logic and data services
├── utils/                      # Utility functions
└── widgets/                    # Reusable UI components
```

### Key Design Patterns

#### 1. Responsive Layout
- **Mobile Layout**: Traditional navigation with `Navigator.push()`
- **Desktop Layout**: Sidebar navigation with embedded content
- Breakpoint: 600px width

#### 2. Embedded Mode Pattern
All tool screens support embedded mode for desktop layout:
```dart
class ToolScreen extends StatefulWidget {
  final bool isEmbedded;
  final Function(Widget, String)? onToolSelected;
  
  const ToolScreen({
    super.key, 
    this.isEmbedded = false, 
    this.onToolSelected
  });
}
```

#### 3. Navigation Strategy
- **Mobile**: Standard Flutter navigation stack
- **Desktop**: Callback-based tool switching without navigation stack

## Core Features

### 1. Text Template Generator
- Create reusable document templates
- Support for dynamic fields (text, number, date, time)
- Data loops for repetitive content
- Template import/export (JSON format)
- Batch operations (export, delete)

**Key Files:**
- `screens/text_template_gen_list_screen.dart` - Template management
- `screens/text_template_gen_edit_screen.dart` - Template editor
- `screens/text_template_gen_use_screen.dart` - Template usage
- `models/text_template.dart` - Data model
- `services/template_service.dart` - Business logic

### 2. Random Generators
Collection of random generation tools:
- Password Generator
- Number Generator
- Date/Time Generator
- Coin Flip, Dice Roll
- Playing Cards, Colors
- Rock Paper Scissors
- Yes/No Generator

**Key Files:**
- `screens/random_tools_screen.dart` - Tool selection
- `screens/random_tools/*.dart` - Individual generators
- `models/random_generator.dart` - Base model

## Implementation Guidelines

### Screen Structure
```dart
@override
Widget build(BuildContext context) {
  final content = _buildMainContent();
  
  if (widget.isEmbedded) {
    return content; // Desktop embedded view
  } else {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: content,
    ); // Mobile view
  }
}
```

### Navigation Handling
```dart
void _navigateToTool() {
  final tool = SomeToolScreen(isEmbedded: widget.isEmbedded);
  
  if (widget.isEmbedded && widget.onToolSelected != null) {
    widget.onToolSelected!(tool, 'Tool Title'); // Desktop
  } else {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => tool,
    )); // Mobile
  }
}
```

### Internationalization
- Uses Flutter's built-in l10n support
- ARB files for translations: `app_en.arb`, `app_vi.arb`
- Generated classes: `AppLocalizations`

### State Management
- Uses `StatefulWidget` with `setState()`
- Shared preferences for settings
- Local storage for templates and cache

## Technical Specifications

### Dependencies
- **Core**: Flutter SDK 3.0+
- **File Operations**: `file_picker`, `path_provider`
- **Storage**: `shared_preferences`
- **Internationalization**: `flutter_localizations`, `intl`
- **Logging**: `logger`

### Platform Mainly Support
- Android
- Windows

### Performance Considerations
- Lazy loading of template lists
- Efficient JSON serialization
- Responsive UI updates
- Memory management for file operations

## Development Guidelines

### Code Style
- Follow official Dart style guide
- Use meaningful variable names
- Document complex functions
- Implement proper error handling

### Testing Strategy
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for complete workflows

### Build & Deployment
```bash
# Development build
flutter run

# Release build
flutter build apk --release
flutter build windows --release
```

## Additional Documentation
- **[Logging Implementation](LOGGING_IMPLEMENTATION.md)**: Comprehensive logging system with file persistence and automatic cleanup
- **[API Reference](API_REFERENCE.md)**: Complete API documentation for models and services
- **[Setup Guide](SETUP_GUIDE.md)**: Development environment setup instructions

## Future Enhancements
- Cloud synchronization
- Plugin system for custom tools
- Advanced template scripting
- Export to multiple formats (PDF, DOCX)
- Dark theme improvements
- Performance optimizations

## Troubleshooting

### Common Issues
1. **Layout issues on desktop**: Check `isEmbedded` flag implementation
2. **Navigation problems**: Verify callback vs Navigator usage
3. **Localization not working**: Check ARB file syntax and generation
4. **File operations failing**: Verify permissions and paths

### Debug Commands
```bash
flutter clean
flutter pub get
flutter pub run build_runner build
flutter analyze
```
