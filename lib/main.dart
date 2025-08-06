import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/models/tool_config.dart';
import 'package:random_please/widgets/tool_card.dart';
import 'package:random_please/services/cache_service.dart';
import 'package:random_please/services/tool_visibility_service.dart';
import 'package:random_please/services/quick_actions_service.dart';
import 'package:random_please/services/hive_service.dart';
import 'package:random_please/services/settings_service.dart';
import 'package:random_please/services/app_logger.dart';
import 'package:random_please/services/number_format_service.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'screens/main_settings.dart';
import 'screens/random_tools_screen.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:io';
import 'package:hive/hive.dart';

// Global navigation key for deep linking
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// --- Workmanager Setup ---
@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // This background task is a simple keep-alive.
    // Its purpose is just to wake the app up periodically to prevent the OS
    // from completely killing the process, allowing P2P timers to continue.
    // No complex logic is needed here.
    return Future.value(true);
  });
}
// --- End Workmanager Setup ---

// Global flag to track first time setup
bool _isFirstTimeSetup = false;

class BreadcrumbData {
  final String title;
  final String toolType;
  final Widget? tool;
  final IconData? icon;

  const BreadcrumbData({
    required this.title,
    required this.toolType,
    this.tool,
    this.icon,
  });
}

Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize workmanager for background tasks on mobile platforms
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
  }

  // Setup window manager for desktop platforms
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.linux)) {
    await windowManager.ensureInitialized();
    // Don't prevent close - just trigger emergency save
    await windowManager.setPreventClose(false);
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Reduce accessibility tree errors on Windows debug builds
  if (kDebugMode && defaultTargetPlatform == TargetPlatform.windows) {
    // Disable semantic debugging to reduce accessibility bridge errors
    WidgetsBinding.instance.ensureSemantics();
  }

  // Initialize Hive database first
  await HiveService.initialize();

  // Register all random state adapters
  _registerRandomStateAdapters();

  // Initialize settings service
  await SettingsService.initialize();

  // Initialize AppLogger service (depends on settings)
  await AppLogger.instance.initialize();

  // Initialize settings controller and load saved settings
  await settingsController.loadSettings();

  // Initialize quick actions
  await _initializeQuickActions();

  runApp(const MainApp());
}

void _registerRandomStateAdapters() {
  // Register SettingsModel adapter first
  if (!Hive.isAdapterRegistered(12)) {
    Hive.registerAdapter(SettingsModelAdapter());
  }
  
  if (!Hive.isAdapterRegistered(60)) {
    Hive.registerAdapter(NumberGeneratorStateAdapter());
  }
  if (!Hive.isAdapterRegistered(61)) {
    Hive.registerAdapter(PasswordGeneratorStateAdapter());
  }
  if (!Hive.isAdapterRegistered(62)) {
    Hive.registerAdapter(DateGeneratorStateAdapter());
  }
  if (!Hive.isAdapterRegistered(65)) {
    Hive.registerAdapter(TimeGeneratorStateAdapter());
  }
  if (!Hive.isAdapterRegistered(64)) {
    Hive.registerAdapter(DateTimeGeneratorStateAdapter());
  }
  if (!Hive.isAdapterRegistered(67)) {
    Hive.registerAdapter(LatinLetterGeneratorStateAdapter());
  }
  if (!Hive.isAdapterRegistered(66)) {
    Hive.registerAdapter(PlayingCardGeneratorStateAdapter());
  }
  if (!Hive.isAdapterRegistered(68)) {
    Hive.registerAdapter(DiceRollGeneratorStateAdapter());
  }
  if (!Hive.isAdapterRegistered(63)) {
    Hive.registerAdapter(ColorGeneratorStateAdapter());
  }
  if (!Hive.isAdapterRegistered(69)) {
    Hive.registerAdapter(SimpleGeneratorStateAdapter());
  }
}

Future<void> _initializeQuickActions() async {
  await QuickActionsService.initialize();

  // Set up quick action handler
  QuickActionsService.setQuickActionHandler((toolId) {
    // Navigate to the selected tool when quick action is triggered
    _navigateToTool(toolId);
  });
}

void _navigateToTool(String toolId) {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  // Find the tool configuration
  ToolVisibilityService.getVisibleToolsInOrder().then((tools) {
    final tool = tools.firstWhere(
      (t) => t.id == toolId,
      orElse: () => tools.first, // Fallback to first tool
    );

    // Navigate to the tool
    // Use navigatorKey.currentState instead of context to avoid using BuildContext across async gaps
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => _getToolScreen(tool)),
      (route) => false, // Clear all previous routes
    );
  });
}

Widget _getToolScreen(ToolConfig tool) {
  switch (tool.id) {
    case 'randomTools':
      return const RandomToolsScreen();
    default:
      return const HomePage(); // Fallback to home
  }
}

class SettingsController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  // Load settings from SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load theme mode
    final themeIndex = prefs.getInt('themeMode') ?? 0;
    _themeMode = ThemeMode.values[themeIndex];

    // Load language
    final languageCode = prefs.getString('language') ?? 'en';
    _locale = Locale(languageCode);

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', locale.languageCode);
    notifyListeners();
  }
}

final SettingsController settingsController = SettingsController();

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (context, _) {
        // Initialize number formatting with current locale
        NumberFormatService.initialize(settingsController.locale);

        return MaterialApp(
          title: 'random_please',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueAccent,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueAccent,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: settingsController.themeMode,
          locale: settingsController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const HomePage(),
          navigatorObservers: [
            NavigatorObserver(),
          ],
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);

    // Show first time setup snackbar if needed
    if (_isFirstTimeSetup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showFirstTimeSetupSnackbar();
      });
    }
  }

  void _showFirstTimeSetupSnackbar() {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.construction, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'TODO: Installation progress - Setting up your new installation...',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange[700],
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );

    // Log for debugging
    AppLogger.instance.info(
      'First time setup detected - showed installation progress snackbar',
    );
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If width is less than 600, we consider it mobile layout
        final isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          return const MobileLayout();
        } else {
          return const DesktopLayout();
        }
      },
    );
  }
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.title)),
      body: const ToolSelectionScreen(),
    );
  }
}

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({super.key});

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  Widget? currentTool;
  String? selectedToolType;
  String? parentToolType; // Track parent category for sub-tools
  String? currentToolTitle;
  List<BreadcrumbData> breadcrumbs = []; // Track navigation hierarchy
  final GlobalKey<_ToolSelectionScreenState> _toolSelectionKey = GlobalKey();

  // Callback to check if current tool has unsaved changes
  Future<bool> Function()? _checkUnsavedChanges;

  void _registerUnsavedChangesCallback(Future<bool> Function()? callback) {
    _checkUnsavedChanges = callback;
  }

  void _refreshToolSelection() {
    // Refresh the tool list first
    _toolSelectionKey.currentState?.refreshTools();
    // Reset the current selection
    setState(() {
      currentTool = null;
      selectedToolType = null;
      parentToolType = null;
      currentToolTitle = null;
      breadcrumbs.clear();
    });
  }

  void _navigateToParent() async {
    // Check for unsaved changes before navigating
    if (_checkUnsavedChanges != null) {
      final hasUnsavedChanges = await _checkUnsavedChanges!();
      if (hasUnsavedChanges) {
        if (!mounted) return; // Guard against unmounted widget

        final l10n = AppLocalizations.of(context)!;
        final result = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(l10n.unsavedChanges),
            content: Text(l10n.unsavedChangesMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop('stay'),
                child: Text(l10n.stayHere),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop('draft'),
                child: Text(l10n.saveDraft),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop('exit'),
                child: Text(l10n.exitWithoutSaving),
              ),
            ],
          ),
        );

        switch (result) {
          case 'stay':
            return; // Don't navigate
          case 'exit':
            break; // Continue with navigation
          case 'draft':
            // Let the current tool handle draft saving
            // Then continue with navigation
            break;
          default:
            return; // Don't navigate if dialog was dismissed
        }
      }
    }

    if (breadcrumbs.isNotEmpty) {
      // Remove current breadcrumb
      breadcrumbs.removeLast();

      // Clear the callback when navigating away
      _checkUnsavedChanges = null;

      if (breadcrumbs.isNotEmpty) {
        // Navigate to parent breadcrumb
        final parent = breadcrumbs.last;
        setState(() {
          currentTool = parent.tool;
          selectedToolType = parent.toolType;
          currentToolTitle = parent.title;
          // Set parentToolType based on breadcrumb hierarchy
          parentToolType = breadcrumbs.length > 1
              ? breadcrumbs[breadcrumbs.length - 2].toolType
              : null;
        });
      } else {
        // Return to main screen
        setState(() {
          currentTool = null;
          selectedToolType = null;
          parentToolType = null;
          currentToolTitle = null;
        });
      }
    }
  }

  // Compact breadcrumb widget for AppBar
  Widget _buildCompactBreadcrumb() {
    if (breadcrumbs.isEmpty || breadcrumbs.length <= 1) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isDark
                  ? theme.colorScheme.surface.withValues(alpha: 0.3)
                  : theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.4,
                    ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? theme.colorScheme.outline.withValues(alpha: 0.4)
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < breadcrumbs.length; i++) ...[
                  if (i > 0) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 12,
                      color: isDark
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.8)
                          : theme.colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.9,
                            ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  if (i < breadcrumbs.length - 1)
                    InkWell(
                      onTap: () {
                        // Navigate to this breadcrumb level
                        final targetBreadcrumb = breadcrumbs[i];
                        // Remove all breadcrumbs after this one
                        breadcrumbs = breadcrumbs.sublist(0, i + 1);
                        setState(() {
                          currentTool = targetBreadcrumb.tool;
                          selectedToolType = targetBreadcrumb.toolType;
                          currentToolTitle = targetBreadcrumb.title;
                          parentToolType =
                              i > 0 ? breadcrumbs[i - 1].toolType : null;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (breadcrumbs[i].icon != null) ...[
                              Icon(
                                breadcrumbs[i].icon,
                                size: 10,
                                color: isDark
                                    ? theme.colorScheme.onSurface.withValues(
                                        alpha: 0.9,
                                      )
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 2),
                            ],
                            Text(
                              breadcrumbs[i].title,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? theme.colorScheme.onSurface.withValues(
                                        alpha: 0.9,
                                      )
                                    : theme.colorScheme.onSurfaceVariant,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    // Current page (not clickable)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (breadcrumbs[i].icon != null) ...[
                          Icon(
                            breadcrumbs[i].icon,
                            size: 10,
                            color: isDark
                                ? theme.colorScheme.primary
                                : theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 2),
                        ],
                        Text(
                          breadcrumbs[i].title,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? theme.colorScheme.primary
                                : theme.colorScheme.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currentToolTitle ?? AppLocalizations.of(context)!.title),
            // Add compact breadcrumb after title on desktop
            if (MediaQuery.of(context).size.width > 800) // Desktop only
              _buildCompactBreadcrumb(),
          ],
        ),
        leading: currentTool != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _navigateToParent,
                tooltip: breadcrumbs.length > 1
                    ? 'Back to ${breadcrumbs[breadcrumbs.length - 2].title}'
                    : 'Back to main menu',
              )
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                // Sidebar chiếm 1/4, main chiếm 3/4, nhưng sidebar min 280, max 380
                double sidebarWidth = (totalWidth / 4).clamp(280, 380);

                return Row(
                  children: [
                    // Sidebar với danh sách tools
                    SizedBox(
                      width: sidebarWidth,
                      child: ToolSelectionScreen(
                        key: _toolSelectionKey,
                        isDesktop: true,
                        selectedToolType: selectedToolType,
                        parentToolType: parentToolType,
                        onToolVisibilityChanged: _refreshToolSelection,
                        onRegisterUnsavedChangesCallback:
                            _registerUnsavedChangesCallback,
                        onToolSelected: (
                          Widget tool,
                          String title, {
                          String? parentCategory,
                          IconData? icon,
                        }) {
                          setState(() {
                            currentTool = tool;
                            final newToolType = tool.runtimeType.toString();
                            selectedToolType = newToolType;
                            parentToolType = parentCategory;
                            currentToolTitle = title;

                            // Determine if this is a top-level tool or sub-tool
                            final isTopLevelTool = parentCategory == null;
                            final isSubTool = parentCategory != null;

                            if (isTopLevelTool) {
                              // Top-level tool from sidebar: Start fresh breadcrumb
                              breadcrumbs.clear();
                              breadcrumbs.add(
                                BreadcrumbData(
                                  title: title,
                                  toolType: newToolType,
                                  tool: tool,
                                  icon: icon,
                                ),
                              );
                            } else if (isSubTool) {
                              // Sub-tool navigation: Check if we're going deeper or switching

                              // If breadcrumbs is empty, this shouldn't happen but handle it
                              if (breadcrumbs.isEmpty) {
                                breadcrumbs.add(
                                  BreadcrumbData(
                                    title: title,
                                    toolType: newToolType,
                                    tool: tool,
                                    icon: icon,
                                  ),
                                );
                              } else {
                                // Check if this is a direct child of the current breadcrumb
                                final currentBreadcrumb = breadcrumbs.last;
                                final isDirectChild =
                                    currentBreadcrumb.toolType ==
                                        parentCategory;

                                if (isDirectChild) {
                                  // Going deeper: Add to breadcrumbs
                                  breadcrumbs.add(
                                    BreadcrumbData(
                                      title: title,
                                      toolType: newToolType,
                                      tool: tool,
                                      icon: icon,
                                    ),
                                  );
                                } else {
                                  // Switching to different sub-tool:
                                  // Find the parent in breadcrumbs and truncate there
                                  int parentIndex = breadcrumbs.indexWhere(
                                    (bc) => bc.toolType == parentCategory,
                                  );

                                  if (parentIndex >= 0) {
                                    // Keep breadcrumbs up to parent, add new child
                                    breadcrumbs = breadcrumbs.sublist(
                                      0,
                                      parentIndex + 1,
                                    );
                                    breadcrumbs.add(
                                      BreadcrumbData(
                                        title: title,
                                        toolType: newToolType,
                                        tool: tool,
                                        icon: icon,
                                      ),
                                    );
                                  } else {
                                    // Parent not found, start fresh with this tool
                                    breadcrumbs.clear();
                                    breadcrumbs.add(
                                      BreadcrumbData(
                                        title: title,
                                        toolType: newToolType,
                                        tool: tool,
                                        icon: icon,
                                      ),
                                    );
                                  }
                                }
                              }
                            }
                          });
                        },
                      ),
                    ),
                    // Main content area
                    Expanded(
                      child: currentTool != null
                          ? ClipRect(child: currentTool!)
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.touch_app,
                                    size: 64,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    AppLocalizations.of(context)!.selectTool,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          )
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.7),
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!
                                        .selectToolDesc,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          )
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.5),
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ToolSelectionScreen extends StatefulWidget {
  final bool isDesktop;
  final Function(Widget, String, {String? parentCategory, IconData? icon})?
      onToolSelected;
  final String? selectedToolType;
  final String? parentToolType;
  final VoidCallback? onToolVisibilityChanged;
  final Function(Future<bool> Function()?)? onRegisterUnsavedChangesCallback;

  const ToolSelectionScreen({
    super.key,
    this.isDesktop = false,
    this.onToolSelected,
    this.selectedToolType,
    this.parentToolType,
    this.onToolVisibilityChanged,
    this.onRegisterUnsavedChangesCallback,
  });

  @override
  State<ToolSelectionScreen> createState() => _ToolSelectionScreenState();
}

class _ToolSelectionScreenState extends State<ToolSelectionScreen> {
  List<ToolConfig> _visibleTools = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadVisibleTools();
  }

  Future<void> _loadVisibleTools() async {
    final tools = await ToolVisibilityService.getVisibleToolsInOrder();
    setState(() {
      _visibleTools = tools;
      _loading = false;
    });
  }

  // Public method to refresh tools when called from outside
  void refreshTools() {
    setState(() {
      _loading = true;
    });
    _loadVisibleTools();
  }

  Widget _getToolWidget(ToolConfig config, AppLocalizations loc) {
    switch (config.id) {
      case 'randomTools':
        return RandomToolsScreen(
          isEmbedded: widget.isDesktop,
          onToolSelected: (tool, title, {parentCategory, icon}) =>
              widget.onToolSelected?.call(
            tool,
            title,
            parentCategory: parentCategory ?? 'RandomToolsScreen',
            icon: icon,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'description':
        return Icons.description;
      case 'casino':
        return Icons.casino;
      case 'swap_horiz':
        return Icons.swap_horiz;
      case 'calculate':
        return Icons.calculate;
      case 'share':
        return Icons.share;
      default:
        return Icons.extension;
    }
  }

  Color _getIconColor(String colorName) {
    switch (colorName) {
      case 'blue800':
        return Colors.blue.shade800;
      case 'purple':
        return Colors.purple;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'teal':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _getLocalizedName(BuildContext context, String nameKey) {
    final l10n = AppLocalizations.of(context)!;
    switch (nameKey) {
      case 'textTemplateGen':
        return l10n.textTemplateGen;
      case 'random':
        return l10n.random;
      case 'converterTools':
        return l10n.converterTools;
      case 'calculatorTools':
        return l10n.calculatorTools;
      case 'p2pDataTransfer':
        return l10n.p2lanTransfer;
      default:
        return nameKey;
    }
  }

  String _getLocalizedDesc(BuildContext context, String descKey) {
    final l10n = AppLocalizations.of(context)!;
    switch (descKey) {
      case 'textTemplateGenDesc':
        return l10n.textTemplateGenDesc;
      case 'randomDesc':
        return l10n.randomDesc;
      case 'converterToolsDesc':
        return l10n.converterToolsDesc;
      case 'calculatorToolsDesc':
        return l10n.calculatorToolsDesc;
      case 'p2pDataTransferDesc':
        return l10n.p2pDataTransferDesc;
      default:
        return descKey;
    }
  }

  String _getSelectedToolType(ToolConfig config) {
    switch (config.id) {
      case 'textTemplate':
        return 'TemplateListScreen';
      case 'randomTools':
        return 'RandomToolsScreen';
      case 'converterTools':
        return 'ConverterToolsScreen';
      case 'calculatorTools':
        return 'CalculatorToolsScreen';
      case 'p2pDataTransfer':
        return 'P2LanTransferScreen';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Check if no tools are visible
    if (_visibleTools.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.visibility_off,
                size: 64,
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                loc.allToolsHidden,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                loc.allToolsHiddenDesc,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    quickAccess() {
      // goes directly to the full scrolling view
      final tool = MainSettingsScreen(
        isEmbedded: widget.isDesktop,
        onToolVisibilityChanged: widget.onToolVisibilityChanged,
        // Go directly to the detailed view
        initialSectionId: 'user_interface',
      );
      if (widget.isDesktop) {
        widget.onToolSelected?.call(
          tool,
          loc.settings,
          icon: Icons.settings,
        );
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => tool));
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Show visible tools
        ..._visibleTools.map((config) {
          final toolType = _getSelectedToolType(config);
          final isDirectlySelected = widget.selectedToolType == toolType;
          final isParentSelected = widget.parentToolType == toolType;
          final isSelected = isDirectlySelected || isParentSelected;

          return ToolCard(
            title: _getLocalizedName(context, config.nameKey),
            description: _getLocalizedDesc(context, config.descKey),
            icon: _getIconData(config.icon),
            iconColor: _getIconColor(config.iconColor),
            isSelected: isSelected,
            onTap: () {
              final tool = _getToolWidget(config, loc);
              if (widget.isDesktop) {
                widget.onToolSelected?.call(
                  tool,
                  _getLocalizedName(context, config.nameKey),
                  icon: _getIconData(config.icon),
                );
              } else {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => tool));
              }
            },
          );
        }).toList(), // Settings tool - always visible
        const SizedBox(height: 32),
        ToolCard(
          title: loc.settings,
          description: loc.settings,
          icon: Icons.settings,
          iconColor: Colors.grey,
          isSelected: widget.selectedToolType == 'MainSettingsScreen',
          onTap: () {
            // Short press: goes to the section list screen
            final tool = MainSettingsScreen(
              isEmbedded: widget.isDesktop,
              onToolVisibilityChanged: widget.onToolVisibilityChanged,
              initialSectionId: null, // Let the screen decide the initial view
            );
            if (widget.isDesktop) {
              widget.onToolSelected?.call(
                tool,
                loc.settings,
                icon: Icons.settings,
              );
            } else {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => tool));
            }
          },
          onLongPress: quickAccess,
          quickActionCallback: quickAccess,
          showActions: false,
        ),
        // Development tools removed for production
      ],
    );
  }
}

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.settings),
      content: const SettingsScreen(),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.close),
        ),
      ],
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ThemeMode _themeMode;
  late String _language;
  String _cacheInfo = 'Calculating...';
  bool _clearing = false;

  @override
  void initState() {
    super.initState();
    _themeMode = settingsController.themeMode;
    _language = settingsController.locale.languageCode;
    _loadCacheInfo();
  }

  Future<void> _loadCacheInfo() async {
    try {
      final totalSize = await CacheService.getTotalCacheSize();
      setState(() {
        _cacheInfo = CacheService.formatCacheSize(totalSize);
      });
    } catch (e) {
      setState(() {
        _cacheInfo = 'Unknown';
      });
    }
  }

  Future<void> _clearCache() async {
    final confirmed = await _showConfirmDialog();
    if (confirmed != true) return;

    setState(() {
      _clearing = true;
    });

    try {
      await CacheService.clearAllCache();
      await _loadCacheInfo(); // Refresh cache info
      setState(() {
        _clearing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.clearCache),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _clearing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _onThemeChanged(ThemeMode? mode) {
    if (mode != null) {
      setState(() => _themeMode = mode);
      settingsController.setThemeMode(mode);
    }
  }

  void _onLanguageChanged(String? lang) {
    if (lang != null) {
      setState(() => _language = lang);
      settingsController.setLocale(Locale(lang));
    }
  }

  Future<bool?> _showConfirmDialog() async {
    final loc = AppLocalizations.of(context)!;
    final textController = TextEditingController();

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(loc.clearAllCache),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.confirmClearAllCache),
              const SizedBox(height: 16),
              Text(
                loc.typeConfirmToProceed,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'confirm',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(loc.cancel),
            ),
            FilledButton(
              onPressed: textController.text.toLowerCase() == 'confirm'
                  ? () => Navigator.of(context).pop(true)
                  : null,
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: Text(loc.clearAllCache),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.settings)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(loc.theme, style: const TextStyle(fontWeight: FontWeight.bold)),
          ListTile(
            title: Text(loc.system),
            leading: Radio<ThemeMode>(
              value: ThemeMode.system,
              groupValue: _themeMode,
              onChanged: _onThemeChanged,
            ),
          ),
          ListTile(
            title: Text(loc.light),
            leading: Radio<ThemeMode>(
              value: ThemeMode.light,
              groupValue: _themeMode,
              onChanged: _onThemeChanged,
            ),
          ),
          ListTile(
            title: Text(loc.dark),
            leading: Radio<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: _themeMode,
              onChanged: _onThemeChanged,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            loc.language,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: Text(loc.english),
            leading: Radio<String>(
              value: 'en',
              groupValue: _language,
              onChanged: _onLanguageChanged,
            ),
          ),
          ListTile(
            title: Text(loc.vietnamese),
            leading: Radio<String>(
              value: 'vi',
              groupValue: _language,
              onChanged: _onLanguageChanged,
            ),
          ),
          const SizedBox(height: 24),
          Text('${loc.cache}: $_cacheInfo'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: _clearing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.delete),
                  label: Text(loc.clearCache),
                  onPressed: _clearing ? null : _clearCache,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
