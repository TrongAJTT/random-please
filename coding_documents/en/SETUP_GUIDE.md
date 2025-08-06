# Setup & Development Guide
Attch to commit Remove gray layout divider on PC layout | a4b6bb5082a004157e21c62f0624d4a2c7e289f9.

## Quick Start

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart SDK (included with Flutter)
- IDE: VS Code or Android Studio
- Git for version control

### Installation
```bash
# Clone the repository
git clone <repository-url>
cd random_please

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Development Environment
```bash
# Check Flutter installation
flutter doctor

# Generate localization files
flutter gen-l10n

# Run with hot reload
flutter run --hot

# Run tests
flutter test
```

## Project Setup

### IDE Configuration
**VS Code Extensions:**
- Flutter
- Dart
- Flutter Intl (for localization)

**Android Studio Plugins:**
- Flutter
- Dart

### Build Configurations
```bash
# Debug build
flutter run --debug

# Profile build (performance testing)
flutter run --profile

# Release build
flutter run --release
```

## Development Workflow

### Adding New Tools

1. **Create the tool screen:**
```dart
// lib/screens/new_tool_screen.dart
class NewToolScreen extends StatefulWidget {
  final bool isEmbedded;
  final Function(Widget, String)? onToolSelected;
  
  const NewToolScreen({
    super.key, 
    this.isEmbedded = false, 
    this.onToolSelected
  });
  
  @override
  Widget build(BuildContext context) {
    final content = _buildContent();
    
    if (widget.isEmbedded) {
      return content;
    } else {
      return Scaffold(
        appBar: AppBar(title: Text('New Tool')),
        body: content,
      );
    }
  }
}
```

2. **Add to tool selection screen:**
```dart
// In main.dart or tool_selection_screen.dart
ToolCard(
  title: 'New Tool',
  description: 'Description of the new tool',
  icon: Icons.new_releases,
  iconColor: Colors.blue,
  onTap: () => _navigateToTool(NewToolScreen()),
)
```

3. **Add localization strings:**
```json
// lib/l10n/app_en.arb
{
  "newTool": "New Tool",
  "newToolDesc": "Description of the new tool"
}
```

### Adding Localization

1. **Add strings to ARB files:**
```json
// app_en.arb
{
  "newString": "English text",
  "parameterizedString": "Text with {parameter}"
}

// app_vi.arb
{
  "newString": "Văn bản tiếng Việt",
  "parameterizedString": "Văn bản có {parameter}"
}
```

2. **Use in code:**
```dart
final loc = AppLocalizations.of(context)!;
Text(loc.newString)
Text(loc.parameterizedString('value'))
```

3. **Regenerate:**
```bash
flutter gen-l10n
```

## Testing

### Running Tests
```bash
# All tests
flutter test

# Specific test file
flutter test test/widget_test.dart

# With coverage
flutter test --coverage
```

### Writing Tests
```dart
// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:random_please/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
```

## Building for Production

### Android
```bash
# APK
flutter build apk --release

# App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Desktop
```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

### Web
```bash
flutter build web --release
```

## Contributing Guidelines

### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Commit Messages
```
feat: add new random color generator
fix: resolve template export issue
docs: update API documentation
refactor: improve desktop layout code
```

### Pull Request Process
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Update documentation
6. Submit pull request

### Code Review Checklist
- [ ] Code follows style guidelines
- [ ] All tests pass
- [ ] Documentation is updated
- [ ] No breaking changes (or documented)
- [ ] Performance impact considered
- [ ] Accessibility guidelines followed

## Troubleshooting

### Common Issues

**Build errors:**
```bash
flutter clean
flutter pub get
flutter pub deps
```

**Localization not updating:**
```bash
flutter gen-l10n
flutter run
```

**Hot reload not working:**
- Save all files
- Restart hot reload: `r` in terminal
- Full restart: `R` in terminal

**Platform-specific issues:**
- Check `flutter doctor`
- Update Flutter: `flutter upgrade`
- Clear cache: `flutter clean`

### Performance Tips
- Use `const` constructors where possible
- Minimize widget rebuilds
- Profile with `flutter run --profile`
- Use `flutter analyze` regularly

### Debugging
```bash
# Enable debug logging
flutter run --verbose

# Debug with DevTools
flutter run --debug
# Then open DevTools in browser
```

## Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design](https://material.io/design)
- [Flutter Samples](https://flutter.dev/docs/cookbook)
