import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/screens/about_layout.dart';
import 'package:random_please/services/version_check_service.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/utils/variables_utils.dart';
import 'package:random_please/variables.dart';
import 'package:random_please/widgets/generic/generic_settings_helper.dart';
import 'package:random_please/services/cache_service.dart';
import 'package:random_please/services/hive_service.dart';
import 'package:random_please/services/settings_service.dart';
import 'package:random_please/services/app_logger.dart';
import 'package:random_please/services/security_manager.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/models/settings_model.dart';
import 'package:random_please/widgets/generic/icon_button_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'screens/main_settings.dart';
import 'screens/random_tools_screen.dart';
import 'screens/random_tools_desktop_layout.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

// Global navigation key for deep linking
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
  // await AppLogger.instance.initialize();

  // Initialize settings controller and load saved settings
  await settingsController.loadSettings();

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
  if (!Hive.isAdapterRegistered(70)) {
    Hive.registerAdapter(LoremIpsumGeneratorStateAdapter());
  }
  if (!Hive.isAdapterRegistered(76)) {
    Hive.registerAdapter(LoremIpsumTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(71)) {
    Hive.registerAdapter(ListPickerGeneratorStateAdapter());
  }
  if (!Hive.isAdapterRegistered(72)) {
    Hive.registerAdapter(CustomListAdapter());
  }
  if (!Hive.isAdapterRegistered(73)) {
    Hive.registerAdapter(ListItemAdapter());
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
        return MaterialApp(
          title: 'Random Please',
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
  bool _isSecurityChecked = false;
  late AppLocalizations loc;
  int _rebuildKey = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);

    // Handle security setup on app launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleAppLaunch();
    });
  }

  @override
  void didChangeDependencies() {
    loc = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  /// Callback to refresh tool order when settings change
  void _onToolOrderChanged() {
    // Force rebuild by calling setState with new key
    // This will force recreation of the widgets including their FutureBuilder
    setState(() {
      _rebuildKey = DateTime.now().millisecondsSinceEpoch;
    });
  }

  Future<void> _handleAppLaunch() async {
    if (!mounted) return;

    try {
      // Initialize security manager (no automatic dialog)
      final securityManager = SecurityManager.instance;
      await securityManager.handleAppLaunch(context, loc);

      if (mounted) {
        setState(() {
          _isSecurityChecked = true;
        });

        // Show first time setup snackbar if needed
        if (_isFirstTimeSetup) {
          _showFirstTimeSetupSnackbar();
        }
      }
    } catch (e) {
      // Handle error - for now just mark as checked so app can continue
      if (mounted) {
        setState(() {
          _isSecurityChecked = true;
        });
      }
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

  Widget _buildActionAppbar(
      {required bool isDesktop, required int visibleCount}) {
    List<IconButtonListItem> buttons = [
      IconButtonListItem(
        icon: Icons.refresh,
        label: loc.reloadTools,
        onPressed: _onToolOrderChanged,
      ),
      IconButtonListItem(
        icon: Icons.settings,
        label: loc.settings,
        onPressed: () {
          final screen = MainSettingsScreen(
            isEmbedded: isDesktop,
            onToolVisibilityChanged: _onToolOrderChanged,
            initialSectionId: null, // Let the screen decide the initial view
          );
          GenericSettingsHelper.showSettings(
            context,
            GenericSettingsConfig(
              title: loc.settings,
              settingsLayout: screen,
              onSettingsChanged: (newSettings) {},
            ),
          );
        },
      ),
      if (kIsWeb)
        IconButtonListItem(
          icon: Icons.download_for_offline,
          label: loc.downloadApp,
          onPressed: () {
            GenericSettingsHelper.showSettings(
              context,
              GenericSettingsConfig(
                title: loc.downloadApp,
                settingsLayout: VersionCheckService.buildDownloadAppLayout(
                  context: context,
                ),
                onSettingsChanged: (newSettings) {},
              ),
            );
          },
        ),
      IconButtonListItem(
        icon: Icons.info_outline,
        label: loc.about,
        onPressed: () {
          GenericSettingsHelper.showSettings(
            context,
            GenericSettingsConfig(
              title: loc.about,
              settingsLayout: const AboutLayout(),
              onSettingsChanged: (newSettings) {},
            ),
          );
        },
      ),
    ];
    return IconButtonList(
      buttons: buttons,
      visibleCount: visibleCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDesktopContext(context);
    final width = MediaQuery.of(context).size.width;
    final loc = AppLocalizations.of(context)!;

    // Show loading screen while security is being checked
    if (!_isSecurityChecked) {
      return Scaffold(
        appBar: AppBar(
          title: ListTile(
            dense: false,
            contentPadding: const EdgeInsets.only(),
            title:
                Text(loc.title, style: Theme.of(context).textTheme.titleLarge),
            leading: SizedBox(
                width: 40, height: 40, child: Image.asset(imageAssetPath)),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: ListTile(
              dense: false,
              contentPadding: const EdgeInsets.only(),
              title: Text(loc.title,
                  style: Theme.of(context).textTheme.titleLarge),
              leading: SizedBox(
                  width: 40, height: 40, child: Image.asset(imageAssetPath)),
            ),
            actions: [
              _buildActionAppbar(
                  isDesktop: isDesktop, visibleCount: width > 500 ? 4 : 0),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: isDesktop
                ? DesktopLayout(key: ValueKey(_rebuildKey))
                : RandomToolsScreen(key: ValueKey(_rebuildKey)),
          ),
        );
      },
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
        SnackBarUtils.showTyped(context,
            AppLocalizations.of(context)!.clearCache, SnackBarType.success);
      }
    } catch (e) {
      setState(() {
        _clearing = false;
      });

      if (mounted) {
        SnackBarUtils.showTyped(context, 'Error: $e', SnackBarType.error);
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
