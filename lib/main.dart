import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/providers/settings_provider.dart';
import 'package:random_please/screens/other/about_layout.dart';
import 'package:random_please/services/version_check_service.dart';
import 'package:random_please/utils/variables_utils.dart';
import 'package:random_please/utils/url_utils.dart';
import 'package:random_please/variables.dart';
import 'package:random_please/widgets/generic/uni_route.dart';
import 'package:random_please/services/hive_service.dart';
import 'package:random_please/services/settings_service.dart';
import 'package:random_please/services/list_template_source_service.dart';
import 'package:random_please/services/app_logger.dart';
import 'package:random_please/services/security_manager.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/models/settings_model.dart';
import 'package:random_please/models/list_template_source.dart';
import 'package:random_please/models/cloud_template.dart';
import 'package:random_please/widgets/generic/icon_button_list.dart';
import 'package:window_manager/window_manager.dart';
import 'screens/settings/main_settings.dart';
import 'screens/landing_screen.dart';
import 'screens/landing_desktop_layout.dart';
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

  // Initialize ListTemplateSourceService
  await ListTemplateSourceService.init();

  // Initialize AppLogger service (depends on settings)
  // await AppLogger.instance.initialize();

  // Initialize settings controller and load saved settings
  final container = ProviderContainer();
  await container.read(settingsProvider.notifier).loadSettings();

  runApp(UncontrolledProviderScope(
    container: container,
    child: const MainApp(),
  ));
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
    Hive.registerAdapter(YesNoGeneratorStateAdapter());
  }
  if (!Hive.isAdapterRegistered(74)) {
    Hive.registerAdapter(LoremIpsumGeneratorStateAdapter());
  }
  if (!Hive.isAdapterRegistered(75)) {
    Hive.registerAdapter(CoinFlipGeneratorStateAdapter());
  }
  if (!Hive.isAdapterRegistered(79)) {
    Hive.registerAdapter(RockPaperScissorsGeneratorStateAdapter());
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
  if (!Hive.isAdapterRegistered(77)) {
    Hive.registerAdapter(ListPickerModeAdapter());
  }
  if (!Hive.isAdapterRegistered(13)) {
    Hive.registerAdapter(ListTemplateSourceAdapter());
  }
  if (!Hive.isAdapterRegistered(14)) {
    Hive.registerAdapter(CloudTemplateAdapter());
  }
  if (!Hive.isAdapterRegistered(80)) {
    Hive.registerAdapter(CounterStatisticsAdapter());
  }
  if (!Hive.isAdapterRegistered(81)) {
    Hive.registerAdapter(CoinFlipCounterStatisticsAdapter());
  }
  if (!Hive.isAdapterRegistered(82)) {
    Hive.registerAdapter(RockPaperScissorsCounterStatisticsAdapter());
  }
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

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
      themeMode: settings.themeMode,
      locale: settings.locale,
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
            initialSectionId: 'user_interface',
          );
          UniRoute.navigate(
            context,
            UniRouteModel(
              title: loc.settings,
              content: screen,
            ),
          );
        },
      ),
      if (kIsWeb)
        IconButtonListItem(
          icon: Icons.download_for_offline,
          label: loc.downloadApp,
          onPressed: () {
            UniRoute.navigate(
              context,
              UniRouteModel(
                title: loc.downloadApp,
                content: VersionCheckService.buildDownloadAppLayout(
                  context: context,
                ),
              ),
            );
          },
        ),
      IconButtonListItem(
        icon: Icons.help_outline,
        label: loc.helpAndGuides,
        onPressed: () {
          UriUtils.viewUniUrl(
              context: context, url: appGuidesUrl, confirmExit: true);
        },
      ),
      IconButtonListItem(
        icon: Icons.info_outline,
        label: loc.about,
        onPressed: () {
          UniRoute.navigate(
            context,
            UniRouteModel(
              title: loc.about,
              content: const AboutLayout(),
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
