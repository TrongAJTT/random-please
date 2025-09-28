import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Random Please'**
  String get title;

  /// No description provided for @helpAndGuides.
  ///
  /// In en, this message translates to:
  /// **'Help & User Guides'**
  String get helpAndGuides;

  /// No description provided for @pressBackAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get pressBackAgainToExit;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @versionType.
  ///
  /// In en, this message translates to:
  /// **'Version Type'**
  String get versionType;

  /// No description provided for @versionTypeDev.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get versionTypeDev;

  /// No description provided for @versionTypeBeta.
  ///
  /// In en, this message translates to:
  /// **'Beta'**
  String get versionTypeBeta;

  /// No description provided for @versionTypeRelease.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get versionTypeRelease;

  /// No description provided for @versionTypeDevDisplay.
  ///
  /// In en, this message translates to:
  /// **'Development Version'**
  String get versionTypeDevDisplay;

  /// No description provided for @versionTypeBetaDisplay.
  ///
  /// In en, this message translates to:
  /// **'Beta Version'**
  String get versionTypeBetaDisplay;

  /// No description provided for @versionTypeReleaseDisplay.
  ///
  /// In en, this message translates to:
  /// **'Release Version'**
  String get versionTypeReleaseDisplay;

  /// No description provided for @githubRepo.
  ///
  /// In en, this message translates to:
  /// **'GitHub Repository'**
  String get githubRepo;

  /// No description provided for @githubRepoDesc.
  ///
  /// In en, this message translates to:
  /// **'View source code of the application on GitHub'**
  String get githubRepoDesc;

  /// No description provided for @creditAck.
  ///
  /// In en, this message translates to:
  /// **'Credits & Acknowledgements'**
  String get creditAck;

  /// No description provided for @creditAckDesc.
  ///
  /// In en, this message translates to:
  /// **'Libraries and resources used in this app'**
  String get creditAckDesc;

  /// No description provided for @supportDesc.
  ///
  /// In en, this message translates to:
  /// **'Random Please helps you generate random data easily, conveniently, and at no cost. If you find it useful, consider supporting me to maintain and improve it. Thank you very much!'**
  String get supportDesc;

  /// No description provided for @supportOnGitHub.
  ///
  /// In en, this message translates to:
  /// **'Support on GitHub'**
  String get supportOnGitHub;

  /// No description provided for @donate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get donate;

  /// No description provided for @donateDesc.
  ///
  /// In en, this message translates to:
  /// **'Support me if you find this app useful'**
  String get donateDesc;

  /// No description provided for @oneTimeDonation.
  ///
  /// In en, this message translates to:
  /// **'One-time Donation'**
  String get oneTimeDonation;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @userInterface.
  ///
  /// In en, this message translates to:
  /// **'User Interface'**
  String get userInterface;

  /// No description provided for @userInterfaceDesc.
  ///
  /// In en, this message translates to:
  /// **'Customize the theme, language, and display style'**
  String get userInterfaceDesc;

  /// No description provided for @randomTools.
  ///
  /// In en, this message translates to:
  /// **'Random Tools'**
  String get randomTools;

  /// No description provided for @randomToolsDesc.
  ///
  /// In en, this message translates to:
  /// **'History, status, tools arrangement, and data protection'**
  String get randomToolsDesc;

  /// No description provided for @dataManager.
  ///
  /// In en, this message translates to:
  /// **'Data Managerment'**
  String get dataManager;

  /// No description provided for @dataManagerDesc.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get dataManagerDesc;

  /// No description provided for @autoCleanupHistoryLimit.
  ///
  /// In en, this message translates to:
  /// **'Auto-cleanup old history records'**
  String get autoCleanupHistoryLimit;

  /// No description provided for @autoCleanupHistoryLimitDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically delete oldest unpinned records when limit is exceeded'**
  String get autoCleanupHistoryLimitDesc;

  /// No description provided for @historyLimitRecords.
  ///
  /// In en, this message translates to:
  /// **'{count} records'**
  String historyLimitRecords(int count);

  /// No description provided for @noLimit.
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get noLimit;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get vietnamese;

  /// No description provided for @cache.
  ///
  /// In en, this message translates to:
  /// **'Cache'**
  String get cache;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @cacheSize.
  ///
  /// In en, this message translates to:
  /// **'Cache size'**
  String get cacheSize;

  /// No description provided for @clearAllCache.
  ///
  /// In en, this message translates to:
  /// **'Clear All Cache'**
  String get clearAllCache;

  /// No description provided for @viewLogs.
  ///
  /// In en, this message translates to:
  /// **'View Logs'**
  String get viewLogs;

  /// No description provided for @clearLogs.
  ///
  /// In en, this message translates to:
  /// **'Clear Logs'**
  String get clearLogs;

  /// No description provided for @logRetention.
  ///
  /// In en, this message translates to:
  /// **'Log Retention'**
  String get logRetention;

  /// No description provided for @logRetentionDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String logRetentionDays(int days);

  /// No description provided for @logRetentionForever.
  ///
  /// In en, this message translates to:
  /// **'Keep forever'**
  String get logRetentionForever;

  /// No description provided for @historyManager.
  ///
  /// In en, this message translates to:
  /// **'History Managerment'**
  String get historyManager;

  /// No description provided for @logRetentionDescDetail.
  ///
  /// In en, this message translates to:
  /// **'Choose log retention period (5-30 days in 5-day intervals, or forever)'**
  String get logRetentionDescDetail;

  /// No description provided for @dataAndStorage.
  ///
  /// In en, this message translates to:
  /// **'Data & Storage'**
  String get dataAndStorage;

  /// No description provided for @confirmClearAllCache.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear ALL cache data? This will remove all history from all tools but preserve your settings.'**
  String get confirmClearAllCache;

  /// Warning text for caches that cannot be cleared
  ///
  /// In en, this message translates to:
  /// **'The following caches cannot be cleared because they are currently in use:'**
  String get cannotClearFollowingCaches;

  /// No description provided for @allCacheCleared.
  ///
  /// In en, this message translates to:
  /// **'All cache cleared successfully'**
  String get allCacheCleared;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @random.
  ///
  /// In en, this message translates to:
  /// **'Random Generator'**
  String get random;

  /// No description provided for @randomDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate random passwords, numbers, dates, and more'**
  String get randomDesc;

  /// No description provided for @textTemplateGen.
  ///
  /// In en, this message translates to:
  /// **'Text Template Generator'**
  String get textTemplateGen;

  /// No description provided for @textTemplateGenDesc.
  ///
  /// In en, this message translates to:
  /// **'Create documents from templates. You can create reusable templates with fields like text, number, date.'**
  String get textTemplateGenDesc;

  /// No description provided for @holdToDeleteInstruction.
  ///
  /// In en, this message translates to:
  /// **'Hold the delete button for 5 seconds to confirm'**
  String get holdToDeleteInstruction;

  /// No description provided for @holdToDelete.
  ///
  /// In en, this message translates to:
  /// **'Hold to delete...'**
  String get holdToDelete;

  /// No description provided for @deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get deleting;

  /// No description provided for @holdToClearCache.
  ///
  /// In en, this message translates to:
  /// **'Hold to clear...'**
  String get holdToClearCache;

  /// No description provided for @clearingCache.
  ///
  /// In en, this message translates to:
  /// **'Clearing cache...'**
  String get clearingCache;

  /// No description provided for @batchDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected'**
  String get batchDelete;

  /// No description provided for @passwordGenerator.
  ///
  /// In en, this message translates to:
  /// **'Password Generator'**
  String get passwordGenerator;

  /// No description provided for @passwordGeneratorDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate secure random passwords'**
  String get passwordGeneratorDesc;

  /// No description provided for @numCharacters.
  ///
  /// In en, this message translates to:
  /// **'Number of characters'**
  String get numCharacters;

  /// No description provided for @includeLowercase.
  ///
  /// In en, this message translates to:
  /// **'Lowercase letters'**
  String get includeLowercase;

  /// No description provided for @includeLowercaseDesc.
  ///
  /// In en, this message translates to:
  /// **'a-z'**
  String get includeLowercaseDesc;

  /// No description provided for @includeUppercase.
  ///
  /// In en, this message translates to:
  /// **'Uppercase letters'**
  String get includeUppercase;

  /// No description provided for @includeUppercaseDesc.
  ///
  /// In en, this message translates to:
  /// **'A-Z'**
  String get includeUppercaseDesc;

  /// No description provided for @includeNumbers.
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get includeNumbers;

  /// No description provided for @includeNumbersDesc.
  ///
  /// In en, this message translates to:
  /// **'0-9'**
  String get includeNumbersDesc;

  /// No description provided for @includeSpecial.
  ///
  /// In en, this message translates to:
  /// **'Special characters'**
  String get includeSpecial;

  /// No description provided for @includeSpecialDesc.
  ///
  /// In en, this message translates to:
  /// **'e.g. !@#\$%^&*'**
  String get includeSpecialDesc;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @generatedAtTime.
  ///
  /// In en, this message translates to:
  /// **'Generated at {time}'**
  String generatedAtTime(String time);

  /// No description provided for @generatedPassword.
  ///
  /// In en, this message translates to:
  /// **'Generated Password'**
  String get generatedPassword;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to Clipboard'**
  String get copyToClipboard;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get copied;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @first.
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get first;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryYet;

  /// No description provided for @confirmClearHistory.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear history?'**
  String get confirmClearHistory;

  /// No description provided for @confirmClearHistoryMessage.
  ///
  /// In en, this message translates to:
  /// **'This will remove all saved history items. This action cannot be undone.\nMake sure you have saved any important results before proceeding.'**
  String get confirmClearHistoryMessage;

  /// No description provided for @historyCleared.
  ///
  /// In en, this message translates to:
  /// **'History cleared successfully'**
  String get historyCleared;

  /// No description provided for @pinnedHistoryCleared.
  ///
  /// In en, this message translates to:
  /// **'Pinned history cleared successfully'**
  String get pinnedHistoryCleared;

  /// No description provided for @unpinnedHistoryCleared.
  ///
  /// In en, this message translates to:
  /// **'Unpinned history cleared successfully'**
  String get unpinnedHistoryCleared;

  /// No description provided for @numberGenerator.
  ///
  /// In en, this message translates to:
  /// **'Number Generator'**
  String get numberGenerator;

  /// No description provided for @numberGeneratorDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate random numbers and sequences'**
  String get numberGeneratorDesc;

  /// No description provided for @integers.
  ///
  /// In en, this message translates to:
  /// **'Integers'**
  String get integers;

  /// No description provided for @floatingPoint.
  ///
  /// In en, this message translates to:
  /// **'Floating Point'**
  String get floatingPoint;

  /// No description provided for @minValue.
  ///
  /// In en, this message translates to:
  /// **'Minimum Value'**
  String get minValue;

  /// No description provided for @maxValue.
  ///
  /// In en, this message translates to:
  /// **'Maximum Value'**
  String get maxValue;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @allowDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Allow Duplicates'**
  String get allowDuplicates;

  /// No description provided for @allowDuplicatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Allow picking the same item multiple times'**
  String get allowDuplicatesDesc;

  /// No description provided for @includeSeconds.
  ///
  /// In en, this message translates to:
  /// **'Include Seconds'**
  String get includeSeconds;

  /// No description provided for @generatedNumbers.
  ///
  /// In en, this message translates to:
  /// **'Generated Numbers'**
  String get generatedNumbers;

  /// No description provided for @yesNo.
  ///
  /// In en, this message translates to:
  /// **'Yes or No?'**
  String get yesNo;

  /// No description provided for @yesNoDesc.
  ///
  /// In en, this message translates to:
  /// **'Random Yes or No decision'**
  String get yesNoDesc;

  /// No description provided for @flipCoin.
  ///
  /// In en, this message translates to:
  /// **'Flip Coin'**
  String get flipCoin;

  /// No description provided for @flipCoinDesc.
  ///
  /// In en, this message translates to:
  /// **'Random coin flip result'**
  String get flipCoinDesc;

  /// No description provided for @rockPaperScissors.
  ///
  /// In en, this message translates to:
  /// **'Rock Paper Scissors'**
  String get rockPaperScissors;

  /// No description provided for @rockPaperScissorsDesc.
  ///
  /// In en, this message translates to:
  /// **'Play the classic hand game'**
  String get rockPaperScissorsDesc;

  /// No description provided for @rollDice.
  ///
  /// In en, this message translates to:
  /// **'Roll Dice'**
  String get rollDice;

  /// No description provided for @rollDiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Roll virtual dice with custom sides'**
  String get rollDiceDesc;

  /// No description provided for @diceCount.
  ///
  /// In en, this message translates to:
  /// **'Number of dice'**
  String get diceCount;

  /// No description provided for @diceSides.
  ///
  /// In en, this message translates to:
  /// **'Sides per die'**
  String get diceSides;

  /// No description provided for @colorGenerator.
  ///
  /// In en, this message translates to:
  /// **'Color Generator'**
  String get colorGenerator;

  /// No description provided for @colorGeneratorDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate random colors and palettes'**
  String get colorGeneratorDesc;

  /// No description provided for @generatedColor.
  ///
  /// In en, this message translates to:
  /// **'Generated Color'**
  String get generatedColor;

  /// No description provided for @latinLetters.
  ///
  /// In en, this message translates to:
  /// **'Latin Letters'**
  String get latinLetters;

  /// No description provided for @latinLettersDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate random alphabet letters'**
  String get latinLettersDesc;

  /// No description provided for @letterCount.
  ///
  /// In en, this message translates to:
  /// **'Number of letters'**
  String get letterCount;

  /// No description provided for @letters.
  ///
  /// In en, this message translates to:
  /// **'letters'**
  String get letters;

  /// No description provided for @playingCards.
  ///
  /// In en, this message translates to:
  /// **'Playing Cards'**
  String get playingCards;

  /// No description provided for @playingCardsDesc.
  ///
  /// In en, this message translates to:
  /// **'Draw random playing cards'**
  String get playingCardsDesc;

  /// No description provided for @includeJokers.
  ///
  /// In en, this message translates to:
  /// **'Include Jokers'**
  String get includeJokers;

  /// No description provided for @includeJokersDesc.
  ///
  /// In en, this message translates to:
  /// **'Include jokers in the deck'**
  String get includeJokersDesc;

  /// No description provided for @cardCount.
  ///
  /// In en, this message translates to:
  /// **'Number of cards'**
  String get cardCount;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @dateGenerator.
  ///
  /// In en, this message translates to:
  /// **'Date Generator'**
  String get dateGenerator;

  /// No description provided for @dateGeneratorDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate random dates within ranges'**
  String get dateGeneratorDesc;

  /// No description provided for @dateCount.
  ///
  /// In en, this message translates to:
  /// **'Number of dates'**
  String get dateCount;

  /// No description provided for @timeGenerator.
  ///
  /// In en, this message translates to:
  /// **'Time Generator'**
  String get timeGenerator;

  /// No description provided for @timeGeneratorDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate random times of day'**
  String get timeGeneratorDesc;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @timeCount.
  ///
  /// In en, this message translates to:
  /// **'Number of times'**
  String get timeCount;

  /// No description provided for @dateTimeGenerator.
  ///
  /// In en, this message translates to:
  /// **'Date & Time Generator'**
  String get dateTimeGenerator;

  /// No description provided for @dateTimeGeneratorDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate random date and time combinations'**
  String get dateTimeGeneratorDesc;

  /// No description provided for @heads.
  ///
  /// In en, this message translates to:
  /// **'Heads'**
  String get heads;

  /// No description provided for @tails.
  ///
  /// In en, this message translates to:
  /// **'Tails'**
  String get tails;

  /// No description provided for @rock.
  ///
  /// In en, this message translates to:
  /// **'Rock'**
  String get rock;

  /// No description provided for @paper.
  ///
  /// In en, this message translates to:
  /// **'Paper'**
  String get paper;

  /// No description provided for @scissors.
  ///
  /// In en, this message translates to:
  /// **'Scissors'**
  String get scissors;

  /// No description provided for @randomResult.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get randomResult;

  /// No description provided for @skipAnimation.
  ///
  /// In en, this message translates to:
  /// **'Skip Animation'**
  String get skipAnimation;

  /// No description provided for @skipAnimationDesc.
  ///
  /// In en, this message translates to:
  /// **'Show result immediately without visual effects'**
  String get skipAnimationDesc;

  /// No description provided for @latinLetterGenerationError.
  ///
  /// In en, this message translates to:
  /// **'Cannot generate {count} unique letters. Maximum available: {max} letters. Please reduce the count or allow duplicates.'**
  String latinLetterGenerationError(int count, int max);

  /// No description provided for @saveGenerationHistory.
  ///
  /// In en, this message translates to:
  /// **'Save Generation History'**
  String get saveGenerationHistory;

  /// No description provided for @saveGenerationHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Remember and display history of generated items'**
  String get saveGenerationHistoryDesc;

  /// No description provided for @generationHistory.
  ///
  /// In en, this message translates to:
  /// **'Generation History'**
  String get generationHistory;

  /// No description provided for @generatedAt.
  ///
  /// In en, this message translates to:
  /// **'Generated at'**
  String get generatedAt;

  /// No description provided for @noHistoryMessage.
  ///
  /// In en, this message translates to:
  /// **'Your generation history items will appear here'**
  String get noHistoryMessage;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @clearAllItems.
  ///
  /// In en, this message translates to:
  /// **'Clear All History'**
  String get clearAllItems;

  /// No description provided for @confirmClearAllHistory.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear ALL history? This will remove all history of this tool even your pinned items.\nMake sure you have saved any important results before proceeding.'**
  String get confirmClearAllHistory;

  /// No description provided for @clearPinnedItems.
  ///
  /// In en, this message translates to:
  /// **'Clear Pinned Items'**
  String get clearPinnedItems;

  /// No description provided for @clearPinnedItemsDesc.
  ///
  /// In en, this message translates to:
  /// **'Remove all pinned items from history? This will not affect unpinned items.\nMake sure you have saved any important results before proceeding.'**
  String get clearPinnedItemsDesc;

  /// No description provided for @clearUnpinnedItems.
  ///
  /// In en, this message translates to:
  /// **'Clear Unpinned Items'**
  String get clearUnpinnedItems;

  /// No description provided for @clearUnpinnedItemsDesc.
  ///
  /// In en, this message translates to:
  /// **'Remove all unpinned items from history? This will not affect pinned items.\nMake sure you have saved any important results before proceeding.'**
  String get clearUnpinnedItemsDesc;

  /// No description provided for @typeConfirmToProceed.
  ///
  /// In en, this message translates to:
  /// **'Type \"confirm\" to proceed:'**
  String get typeConfirmToProceed;

  /// Button to clear all selected files
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @converterTools.
  ///
  /// In en, this message translates to:
  /// **'Converter Tools'**
  String get converterTools;

  /// No description provided for @converterToolsDesc.
  ///
  /// In en, this message translates to:
  /// **'Convert between different units and systems'**
  String get converterToolsDesc;

  /// No description provided for @calculatorTools.
  ///
  /// In en, this message translates to:
  /// **'Calculator Tools'**
  String get calculatorTools;

  /// No description provided for @calculatorToolsDesc.
  ///
  /// In en, this message translates to:
  /// **'Specialized calculators for health, finance, and more'**
  String get calculatorToolsDesc;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @calculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get calculating;

  /// Unknown status or value
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @logsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Logs available'**
  String get logsAvailable;

  /// No description provided for @scrollToTop.
  ///
  /// In en, this message translates to:
  /// **'Scroll to Top'**
  String get scrollToTop;

  /// No description provided for @scrollToBottom.
  ///
  /// In en, this message translates to:
  /// **'Scroll to Bottom'**
  String get scrollToBottom;

  /// No description provided for @logActions.
  ///
  /// In en, this message translates to:
  /// **'Log Actions'**
  String get logActions;

  /// No description provided for @logApplication.
  ///
  /// In en, this message translates to:
  /// **'Log Application'**
  String get logApplication;

  /// No description provided for @previousChunk.
  ///
  /// In en, this message translates to:
  /// **'Previous Chunk'**
  String get previousChunk;

  /// No description provided for @nextChunk.
  ///
  /// In en, this message translates to:
  /// **'Next Chunk'**
  String get nextChunk;

  /// No description provided for @loadAll.
  ///
  /// In en, this message translates to:
  /// **'Load All'**
  String get loadAll;

  /// No description provided for @firstPart.
  ///
  /// In en, this message translates to:
  /// **'First Part'**
  String get firstPart;

  /// No description provided for @lastPart.
  ///
  /// In en, this message translates to:
  /// **'Last Part'**
  String get lastPart;

  /// No description provided for @largeFile.
  ///
  /// In en, this message translates to:
  /// **'Large File'**
  String get largeFile;

  /// No description provided for @loadingLargeFile.
  ///
  /// In en, this message translates to:
  /// **'Loading large file...'**
  String get loadingLargeFile;

  /// No description provided for @loadingLogContent.
  ///
  /// In en, this message translates to:
  /// **'Loading log content...'**
  String get loadingLogContent;

  /// No description provided for @largeFileDetected.
  ///
  /// In en, this message translates to:
  /// **'Large file detected. Using optimized loading...'**
  String get largeFileDetected;

  /// Focus mode setting label
  ///
  /// In en, this message translates to:
  /// **'Focus Mode'**
  String get focusModeEnabled;

  /// Save random tools state setting label
  ///
  /// In en, this message translates to:
  /// **'Save Random Tools State'**
  String get saveRandomToolsState;

  /// Save random tools state setting description
  ///
  /// In en, this message translates to:
  /// **'Automatically save tool settings when generating results'**
  String get saveRandomToolsStateDesc;

  /// No description provided for @aspectRatio.
  ///
  /// In en, this message translates to:
  /// **'Aspect Ratio'**
  String get aspectRatio;

  /// Button to confirm reset
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @deletingOldLogs.
  ///
  /// In en, this message translates to:
  /// **'Deleting old logs...'**
  String get deletingOldLogs;

  /// Message showing how many old log files were deleted
  ///
  /// In en, this message translates to:
  /// **'Deleted {count} old log files'**
  String deletedOldLogFiles(int count);

  /// No description provided for @noOldLogFilesToDelete.
  ///
  /// In en, this message translates to:
  /// **'No old log files to delete'**
  String get noOldLogFilesToDelete;

  /// Error message when deleting logs fails
  ///
  /// In en, this message translates to:
  /// **'Error deleting logs: {error}'**
  String errorDeletingLogs(String error);

  /// Title for the P2P File Transfer tool
  ///
  /// In en, this message translates to:
  /// **'P2P File Transfer'**
  String get p2pDataTransfer;

  /// Description for the P2P File Transfer tool
  ///
  /// In en, this message translates to:
  /// **'Transfer files between devices on the same local network.'**
  String get p2pDataTransferDesc;

  /// Button to clear cache
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Debug button label
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get debug;

  /// Button to remove/delete
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No organization option
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// Tab label for storage settings
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @moveTo.
  ///
  /// In en, this message translates to:
  /// **'Move to'**
  String get moveTo;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @colorFormat.
  ///
  /// In en, this message translates to:
  /// **'Color Format'**
  String get colorFormat;

  /// No description provided for @aboutToOpenUrlOutsideApp.
  ///
  /// In en, this message translates to:
  /// **'You are about to open a URL outside the app. Do you want to proceed?'**
  String get aboutToOpenUrlOutsideApp;

  /// No description provided for @ccontinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get ccontinue;

  /// No description provided for @errorOpeningUrl.
  ///
  /// In en, this message translates to:
  /// **'Error opening URL'**
  String get errorOpeningUrl;

  /// No description provided for @canNotOpenUrl.
  ///
  /// In en, this message translates to:
  /// **'Cannot open URL'**
  String get canNotOpenUrl;

  /// No description provided for @linkCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard'**
  String get linkCopiedToClipboard;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @supporterS.
  ///
  /// In en, this message translates to:
  /// **'Supporter(s)'**
  String get supporterS;

  /// No description provided for @thanksLibAuthor.
  ///
  /// In en, this message translates to:
  /// **'Thank You, Library Authors!'**
  String get thanksLibAuthor;

  /// No description provided for @thanksLibAuthorDesc.
  ///
  /// In en, this message translates to:
  /// **'This app uses several open-source libraries that make it possible. We are grateful to all the authors for their hard work and dedication.'**
  String get thanksLibAuthorDesc;

  /// No description provided for @thanksDonors.
  ///
  /// In en, this message translates to:
  /// **'Thank You, Supporters!'**
  String get thanksDonors;

  /// No description provided for @thanksDonorsDesc.
  ///
  /// In en, this message translates to:
  /// **'Special thanks to our supporters who support the development of this app. Your contributions help us keep improving and maintaining the project.'**
  String get thanksDonorsDesc;

  /// No description provided for @thanksForUrSupport.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your support!'**
  String get thanksForUrSupport;

  /// No description provided for @checkingForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Checking for updates...'**
  String get checkingForUpdates;

  /// No description provided for @minimum.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get minimum;

  /// No description provided for @maximum.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get maximum;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Avg'**
  String get average;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @leastFrequent.
  ///
  /// In en, this message translates to:
  /// **'Least'**
  String get leastFrequent;

  /// No description provided for @mostFrequent.
  ///
  /// In en, this message translates to:
  /// **'Most'**
  String get mostFrequent;

  /// No description provided for @leastFrequentRank.
  ///
  /// In en, this message translates to:
  /// **'Least frequent rank'**
  String get leastFrequentRank;

  /// No description provided for @mostFrequentRank.
  ///
  /// In en, this message translates to:
  /// **'Most frequent rank'**
  String get mostFrequentRank;

  /// No description provided for @leastFrequentSuit.
  ///
  /// In en, this message translates to:
  /// **'Least frequent suit'**
  String get leastFrequentSuit;

  /// No description provided for @mostFrequentSuit.
  ///
  /// In en, this message translates to:
  /// **'Most frequent suit'**
  String get mostFrequentSuit;

  /// No description provided for @minGap.
  ///
  /// In en, this message translates to:
  /// **'Min Gap'**
  String get minGap;

  /// No description provided for @maxGap.
  ///
  /// In en, this message translates to:
  /// **'Max Gap'**
  String get maxGap;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @expandStatistics.
  ///
  /// In en, this message translates to:
  /// **'Expand statistics'**
  String get expandStatistics;

  /// No description provided for @collapseStatistics.
  ///
  /// In en, this message translates to:
  /// **'Collapse statistics'**
  String get collapseStatistics;

  /// No description provided for @autoScrollToResults.
  ///
  /// In en, this message translates to:
  /// **'Auto Scroll to Results'**
  String get autoScrollToResults;

  /// No description provided for @autoScrollToResultsDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically scroll down to show results after generation'**
  String get autoScrollToResultsDesc;

  /// No description provided for @earliest.
  ///
  /// In en, this message translates to:
  /// **'Earliest'**
  String get earliest;

  /// No description provided for @latest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

  /// No description provided for @shortestGap.
  ///
  /// In en, this message translates to:
  /// **'Shortest Gap'**
  String get shortestGap;

  /// No description provided for @longestGap.
  ///
  /// In en, this message translates to:
  /// **'Longest Gap'**
  String get longestGap;

  /// No description provided for @characters.
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get characters;

  /// No description provided for @dice.
  ///
  /// In en, this message translates to:
  /// **'Dice'**
  String get dice;

  /// No description provided for @passwordStrength.
  ///
  /// In en, this message translates to:
  /// **'Password Strength'**
  String get passwordStrength;

  /// No description provided for @strengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get strengthWeak;

  /// No description provided for @strengthFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get strengthFair;

  /// No description provided for @strengthGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get strengthGood;

  /// No description provided for @strengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get strengthStrong;

  /// No description provided for @strengthVeryStrong.
  ///
  /// In en, this message translates to:
  /// **'Very Strong'**
  String get strengthVeryStrong;

  /// No description provided for @clickToCopy.
  ///
  /// In en, this message translates to:
  /// **'Click to copy'**
  String get clickToCopy;

  /// No description provided for @noNewUpdates.
  ///
  /// In en, this message translates to:
  /// **'No new updates'**
  String get noNewUpdates;

  /// No description provided for @updateCheckError.
  ///
  /// In en, this message translates to:
  /// **'Error checking updates: {errorMessage}'**
  String updateCheckError(String errorMessage);

  /// No description provided for @usingLatestVersion.
  ///
  /// In en, this message translates to:
  /// **'You are using the latest version'**
  String get usingLatestVersion;

  /// No description provided for @newVersionAvailable.
  ///
  /// In en, this message translates to:
  /// **'New version available'**
  String get newVersionAvailable;

  /// No description provided for @currentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current: {version}'**
  String currentVersion(String version);

  /// No description provided for @publishDate.
  ///
  /// In en, this message translates to:
  /// **'Publish date: {publishDate}'**
  String publishDate(String publishDate);

  /// No description provided for @releaseNotes.
  ///
  /// In en, this message translates to:
  /// **'Release notes'**
  String get releaseNotes;

  /// No description provided for @noReleaseNotes.
  ///
  /// In en, this message translates to:
  /// **'No release notes'**
  String get noReleaseNotes;

  /// No description provided for @alreadyLatestVersion.
  ///
  /// In en, this message translates to:
  /// **'Already the latest version'**
  String get alreadyLatestVersion;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @selectVersionToDownload.
  ///
  /// In en, this message translates to:
  /// **'Select version to download'**
  String get selectVersionToDownload;

  /// No description provided for @selectPlatform.
  ///
  /// In en, this message translates to:
  /// **'Select platform'**
  String get selectPlatform;

  /// No description provided for @downloadPlatform.
  ///
  /// In en, this message translates to:
  /// **'Download for {platform}'**
  String downloadPlatform(String platform);

  /// No description provided for @noDownloadsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No downloads available'**
  String get noDownloadsAvailable;

  /// No description provided for @downloadApp.
  ///
  /// In en, this message translates to:
  /// **'Download App'**
  String get downloadApp;

  /// No description provided for @downloadAppDesc.
  ///
  /// In en, this message translates to:
  /// **'Download app for offline use when no internet connection is available'**
  String get downloadAppDesc;

  /// No description provided for @filteredForPlatform.
  ///
  /// In en, this message translates to:
  /// **'Filtered for {getPlatformName}'**
  String filteredForPlatform(String getPlatformName);

  /// No description provided for @sizeInMB.
  ///
  /// In en, this message translates to:
  /// **'Size: {sizeInMB}'**
  String sizeInMB(String sizeInMB);

  /// No description provided for @uploadDate.
  ///
  /// In en, this message translates to:
  /// **'Upload date: {updatedAt}'**
  String uploadDate(String updatedAt);

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @confirmDownload.
  ///
  /// In en, this message translates to:
  /// **'Confirm download'**
  String get confirmDownload;

  /// No description provided for @confirmDownloadMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to download this version?\n\nFile name: {name}\nSize: {sizeInMB}'**
  String confirmDownloadMessage(String name, String sizeInMB);

  /// No description provided for @currentPlatform.
  ///
  /// In en, this message translates to:
  /// **'Current platform'**
  String get currentPlatform;

  /// No description provided for @eerror.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get eerror;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @termsOfUseView.
  ///
  /// In en, this message translates to:
  /// **'View Terms of Use of this application'**
  String get termsOfUseView;

  /// No description provided for @versionInfo.
  ///
  /// In en, this message translates to:
  /// **'Version Information'**
  String get versionInfo;

  /// No description provided for @checkForNewVersion.
  ///
  /// In en, this message translates to:
  /// **'Check for New Version'**
  String get checkForNewVersion;

  /// No description provided for @checkForNewVersionDesc.
  ///
  /// In en, this message translates to:
  /// **'Check if there is a new version of the app and download the latest version if available'**
  String get checkForNewVersionDesc;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

  /// No description provided for @fileS.
  ///
  /// In en, this message translates to:
  /// **'File(s)'**
  String get fileS;

  /// No description provided for @alsoViewAuthorOtherProducts.
  ///
  /// In en, this message translates to:
  /// **'Also view author\'s other products'**
  String get alsoViewAuthorOtherProducts;

  /// No description provided for @authorProducts.
  ///
  /// In en, this message translates to:
  /// **'Other Products'**
  String get authorProducts;

  /// No description provided for @authorProductsDesc.
  ///
  /// In en, this message translates to:
  /// **'View other products by the author, maybe you\'ll find something interesting!'**
  String get authorProductsDesc;

  /// No description provided for @authorProductsMessage.
  ///
  /// In en, this message translates to:
  /// **'Hi there! Here are some of my other products. If you\'re interested, feel free to check them out! I hope you\'ll find something useful among them. Thank you for visiting!'**
  String get authorProductsMessage;

  /// No description provided for @noOtherProducts.
  ///
  /// In en, this message translates to:
  /// **'No other products available'**
  String get noOtherProducts;

  /// No description provided for @loadingProducts.
  ///
  /// In en, this message translates to:
  /// **'Loading products...'**
  String get loadingProducts;

  /// No description provided for @failedToLoadProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load products'**
  String get failedToLoadProducts;

  /// No description provided for @retryLoadProducts.
  ///
  /// In en, this message translates to:
  /// **'Retry loading products'**
  String get retryLoadProducts;

  /// No description provided for @visitProduct.
  ///
  /// In en, this message translates to:
  /// **'Visit Product'**
  String get visitProduct;

  /// No description provided for @productCount.
  ///
  /// In en, this message translates to:
  /// **'{count} product(s)'**
  String productCount(int count);

  /// No description provided for @deleteHistoryItem.
  ///
  /// In en, this message translates to:
  /// **'Delete item'**
  String get deleteHistoryItem;

  /// No description provided for @tapDeleteAgainToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Tap delete again to confirm removal'**
  String get tapDeleteAgainToConfirm;

  /// No description provided for @historyItemDeleted.
  ///
  /// In en, this message translates to:
  /// **'History item deleted'**
  String get historyItemDeleted;

  /// No description provided for @pinHistoryItem.
  ///
  /// In en, this message translates to:
  /// **'Pin item'**
  String get pinHistoryItem;

  /// No description provided for @unpinHistoryItem.
  ///
  /// In en, this message translates to:
  /// **'Unpin item'**
  String get unpinHistoryItem;

  /// No description provided for @historyItemPinned.
  ///
  /// In en, this message translates to:
  /// **'Item pinned'**
  String get historyItemPinned;

  /// No description provided for @historyItemUnpinned.
  ///
  /// In en, this message translates to:
  /// **'Item unpinned'**
  String get historyItemUnpinned;

  /// No description provided for @securitySetupTitle.
  ///
  /// In en, this message translates to:
  /// **'App Security Setup'**
  String get securitySetupTitle;

  /// No description provided for @securitySetupMessage.
  ///
  /// In en, this message translates to:
  /// **'Would you like to set up a master password to protect your data?\nThis will secure your history from unauthorized access and protect it from data theft.'**
  String get securitySetupMessage;

  /// No description provided for @setMasterPassword.
  ///
  /// In en, this message translates to:
  /// **'Set Master Password'**
  String get setMasterPassword;

  /// No description provided for @skipSecurity.
  ///
  /// In en, this message translates to:
  /// **'Skip (Use without password)'**
  String get skipSecurity;

  /// No description provided for @createMasterPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Master Password'**
  String get createMasterPasswordTitle;

  /// No description provided for @createMasterPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Please create a strong master password.\nRemember this password carefully.\nIf you forget it, all your data will be lost.'**
  String get createMasterPasswordMessage;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @enterMasterPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Master Password'**
  String get enterMasterPasswordTitle;

  /// No description provided for @enterMasterPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter your master password to access the app.'**
  String get enterMasterPasswordMessage;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password. Please try again.'**
  String get wrongPassword;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'I forgot my password and accept data loss'**
  String get forgotPasswordButton;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmDataLossTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Data Loss'**
  String get confirmDataLossTitle;

  /// No description provided for @confirmDataLossMessage.
  ///
  /// In en, this message translates to:
  /// **'You will be able to continue using the app without entering a password, but all your history data will be permanently deleted.\nThis action cannot be undone.'**
  String get confirmDataLossMessage;

  /// No description provided for @holdToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Hold to confirm'**
  String get holdToConfirm;

  /// No description provided for @dataProtectionSettings.
  ///
  /// In en, this message translates to:
  /// **'Data Protection Settings'**
  String get dataProtectionSettings;

  /// No description provided for @enableDataProtection.
  ///
  /// In en, this message translates to:
  /// **'Enable Data Protection'**
  String get enableDataProtection;

  /// No description provided for @disableDataProtection.
  ///
  /// In en, this message translates to:
  /// **'Disable Data Protection'**
  String get disableDataProtection;

  /// No description provided for @dataProtectionEnabled.
  ///
  /// In en, this message translates to:
  /// **'Data protection is currently enabled'**
  String get dataProtectionEnabled;

  /// No description provided for @dataProtectionDisabled.
  ///
  /// In en, this message translates to:
  /// **'Data protection is currently disabled'**
  String get dataProtectionDisabled;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter current password to disable protection'**
  String get enterCurrentPassword;

  /// No description provided for @securityEnabled.
  ///
  /// In en, this message translates to:
  /// **'Security enabled successfully'**
  String get securityEnabled;

  /// No description provided for @securityDisabled.
  ///
  /// In en, this message translates to:
  /// **'Security disabled successfully'**
  String get securityDisabled;

  /// No description provided for @migrationInProgress.
  ///
  /// In en, this message translates to:
  /// **'Migrating data...'**
  String get migrationInProgress;

  /// No description provided for @migrationCompleted.
  ///
  /// In en, this message translates to:
  /// **'Data migration completed'**
  String get migrationCompleted;

  /// No description provided for @migrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Data migration failed'**
  String get migrationFailed;

  /// No description provided for @solid.
  ///
  /// In en, this message translates to:
  /// **'Solid'**
  String get solid;

  /// No description provided for @includeAlpha.
  ///
  /// In en, this message translates to:
  /// **'Include Alpha'**
  String get includeAlpha;

  /// No description provided for @totalANumber.
  ///
  /// In en, this message translates to:
  /// **'Total: {total}'**
  String totalANumber(int total);

  /// No description provided for @numberType.
  ///
  /// In en, this message translates to:
  /// **'Number Type'**
  String get numberType;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @dateErrStartEndConflict.
  ///
  /// In en, this message translates to:
  /// **'Start date cannot be after end date'**
  String get dateErrStartEndConflict;

  /// No description provided for @arrangeTools.
  ///
  /// In en, this message translates to:
  /// **'Arrange Tools'**
  String get arrangeTools;

  /// No description provided for @arrangeToolsDesc.
  ///
  /// In en, this message translates to:
  /// **'Customize the order of tools in the interface'**
  String get arrangeToolsDesc;

  /// No description provided for @howToArrangeTools.
  ///
  /// In en, this message translates to:
  /// **'How to arrange tools'**
  String get howToArrangeTools;

  /// No description provided for @dragAndDropToReorder.
  ///
  /// In en, this message translates to:
  /// **'Drag and drop to reorder the tools as you prefer'**
  String get dragAndDropToReorder;

  /// No description provided for @defaultOrder.
  ///
  /// In en, this message translates to:
  /// **'Default Order'**
  String get defaultOrder;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @reloadTools.
  ///
  /// In en, this message translates to:
  /// **'Reload Tools'**
  String get reloadTools;

  /// No description provided for @compactTabLayout.
  ///
  /// In en, this message translates to:
  /// **'Compact Tab Layout'**
  String get compactTabLayout;

  /// No description provided for @compactTabLayoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Hide icons in tabs for a more compact look'**
  String get compactTabLayoutDesc;

  /// No description provided for @letterCountRange.
  ///
  /// In en, this message translates to:
  /// **'Letter Count Range'**
  String get letterCountRange;

  /// No description provided for @numberRangeFromTo.
  ///
  /// In en, this message translates to:
  /// **'Number Range: From {from} to {to}'**
  String numberRangeFromTo(String from, String to);

  /// No description provided for @loremIpsumGenerator.
  ///
  /// In en, this message translates to:
  /// **'Lorem Ipsum Generator'**
  String get loremIpsumGenerator;

  /// No description provided for @loremIpsumGeneratorDesc.
  ///
  /// In en, this message translates to:
  /// **'Lorem Ipsum'**
  String get loremIpsumGeneratorDesc;

  /// No description provided for @generationType.
  ///
  /// In en, this message translates to:
  /// **'Generation Type'**
  String get generationType;

  /// No description provided for @words.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get words;

  /// No description provided for @sentences.
  ///
  /// In en, this message translates to:
  /// **'Sentences'**
  String get sentences;

  /// No description provided for @paragraphs.
  ///
  /// In en, this message translates to:
  /// **'Paragraphs'**
  String get paragraphs;

  /// No description provided for @wordCount.
  ///
  /// In en, this message translates to:
  /// **'Word Count'**
  String get wordCount;

  /// No description provided for @numberOfWordsToGenerate.
  ///
  /// In en, this message translates to:
  /// **'Number of words to generate'**
  String get numberOfWordsToGenerate;

  /// No description provided for @sentenceCount.
  ///
  /// In en, this message translates to:
  /// **'Sentence Count'**
  String get sentenceCount;

  /// No description provided for @numberOfSentencesToGenerate.
  ///
  /// In en, this message translates to:
  /// **'Number of sentences to generate'**
  String get numberOfSentencesToGenerate;

  /// No description provided for @paragraphCount.
  ///
  /// In en, this message translates to:
  /// **'Paragraph Count'**
  String get paragraphCount;

  /// No description provided for @numberOfParagraphsToGenerate.
  ///
  /// In en, this message translates to:
  /// **'Number of paragraphs to generate'**
  String get numberOfParagraphsToGenerate;

  /// No description provided for @startWithLorem.
  ///
  /// In en, this message translates to:
  /// **'Start with Lorem'**
  String get startWithLorem;

  /// No description provided for @startWithLoremDesc.
  ///
  /// In en, this message translates to:
  /// **'Begin with classic \'Lorem ipsum dolor sit amet...\''**
  String get startWithLoremDesc;

  /// No description provided for @listPicker.
  ///
  /// In en, this message translates to:
  /// **'Pick from List'**
  String get listPicker;

  /// No description provided for @listPickerDesc.
  ///
  /// In en, this message translates to:
  /// **'Pick from custom lists'**
  String get listPickerDesc;

  /// No description provided for @selectList.
  ///
  /// In en, this message translates to:
  /// **'Select List'**
  String get selectList;

  /// No description provided for @createNewList.
  ///
  /// In en, this message translates to:
  /// **'Create New List'**
  String get createNewList;

  /// No description provided for @noListsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No lists available'**
  String get noListsAvailable;

  /// No description provided for @selectOrCreateList.
  ///
  /// In en, this message translates to:
  /// **'Select or create a list to start picking'**
  String get selectOrCreateList;

  /// No description provided for @manageList.
  ///
  /// In en, this message translates to:
  /// **'Manage List'**
  String get manageList;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @generatorOptions.
  ///
  /// In en, this message translates to:
  /// **'Generator Options'**
  String get generatorOptions;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @generateRandom.
  ///
  /// In en, this message translates to:
  /// **'Pick Random'**
  String get generateRandom;

  /// No description provided for @listName.
  ///
  /// In en, this message translates to:
  /// **'List Name'**
  String get listName;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @listPickerMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get listPickerMode;

  /// No description provided for @modeRandom.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get modeRandom;

  /// No description provided for @modeRandomDesc.
  ///
  /// In en, this message translates to:
  /// **'Pick random items from the list'**
  String get modeRandomDesc;

  /// No description provided for @modeShuffle.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get modeShuffle;

  /// No description provided for @modeShuffleDesc.
  ///
  /// In en, this message translates to:
  /// **'Shuffle and pick items in order'**
  String get modeShuffleDesc;

  /// No description provided for @modeTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get modeTeam;

  /// No description provided for @modeTeamDesc.
  ///
  /// In en, this message translates to:
  /// **'Divide items into teams'**
  String get modeTeamDesc;

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @createListDialog.
  ///
  /// In en, this message translates to:
  /// **'Create New List'**
  String get createListDialog;

  /// No description provided for @enterListName.
  ///
  /// In en, this message translates to:
  /// **'Enter list name (max 30 characters)'**
  String get enterListName;

  /// No description provided for @listNameRequired.
  ///
  /// In en, this message translates to:
  /// **'List name is required'**
  String get listNameRequired;

  /// No description provided for @listNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'List name is too long (max 30 characters)'**
  String get listNameTooLong;

  /// No description provided for @listNameExists.
  ///
  /// In en, this message translates to:
  /// **'A list with this name already exists'**
  String get listNameExists;

  /// No description provided for @teams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get teams;

  /// No description provided for @itemsPerTeam.
  ///
  /// In en, this message translates to:
  /// **'Items per team'**
  String get itemsPerTeam;

  /// No description provided for @addSingleItem.
  ///
  /// In en, this message translates to:
  /// **'Add single item'**
  String get addSingleItem;

  /// No description provided for @addMultipleItems.
  ///
  /// In en, this message translates to:
  /// **'Add multiple items'**
  String get addMultipleItems;

  /// No description provided for @addBatchItems.
  ///
  /// In en, this message translates to:
  /// **'Add Multiple Items'**
  String get addBatchItems;

  /// No description provided for @enterItemsOneLine.
  ///
  /// In en, this message translates to:
  /// **'Enter items, one per line:'**
  String get enterItemsOneLine;

  /// No description provided for @batchItemsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Item 1\nItem 2\nItem 3\n...'**
  String get batchItemsPlaceholder;

  /// No description provided for @previewItems.
  ///
  /// In en, this message translates to:
  /// **'Preview: {count} items'**
  String previewItems(int count);

  /// No description provided for @addItems.
  ///
  /// In en, this message translates to:
  /// **'Add Items'**
  String get addItems;

  /// No description provided for @confirmAddItems.
  ///
  /// In en, this message translates to:
  /// **'Confirm Add Items'**
  String get confirmAddItems;

  /// No description provided for @confirmAddItemsMessage.
  ///
  /// In en, this message translates to:
  /// **'Add {count} items to \"{listName}\"?'**
  String confirmAddItemsMessage(int count, String listName);

  /// No description provided for @addedItemsSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Added {count} items successfully'**
  String addedItemsSuccessfully(int count);

  /// No description provided for @enterAtLeastOneItem.
  ///
  /// In en, this message translates to:
  /// **'Please enter at least one item'**
  String get enterAtLeastOneItem;

  /// No description provided for @maximumItemsAllowed.
  ///
  /// In en, this message translates to:
  /// **'Maximum 100 items allowed'**
  String get maximumItemsAllowed;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get itemName;

  /// No description provided for @itemNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Item name is required'**
  String get itemNameRequired;

  /// No description provided for @itemNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Item name is too long (max 30 characters)'**
  String get itemNameTooLong;

  /// No description provided for @deleteList.
  ///
  /// In en, this message translates to:
  /// **'Delete List'**
  String get deleteList;

  /// No description provided for @deleteListConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{listName}\"? This action cannot be undone.'**
  String deleteListConfirm(String listName);

  /// No description provided for @expand.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get expand;

  /// No description provided for @collapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get collapse;

  /// No description provided for @minimize.
  ///
  /// In en, this message translates to:
  /// **'Minimize'**
  String get minimize;

  /// No description provided for @collapseToLimitedView.
  ///
  /// In en, this message translates to:
  /// **'Collapse to limited view'**
  String get collapseToLimitedView;

  /// No description provided for @minimizeToHeaderOnly.
  ///
  /// In en, this message translates to:
  /// **'Minimize to header only'**
  String get minimizeToHeaderOnly;

  /// No description provided for @expandToFullView.
  ///
  /// In en, this message translates to:
  /// **'Expand to full view'**
  String get expandToFullView;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @renameList.
  ///
  /// In en, this message translates to:
  /// **'Rename List'**
  String get renameList;

  /// No description provided for @renameItem.
  ///
  /// In en, this message translates to:
  /// **'Rename Item'**
  String get renameItem;

  /// No description provided for @renameListDialog.
  ///
  /// In en, this message translates to:
  /// **'Rename List'**
  String get renameListDialog;

  /// No description provided for @renameItemDialog.
  ///
  /// In en, this message translates to:
  /// **'Rename Item'**
  String get renameItemDialog;

  /// No description provided for @enterNewListName.
  ///
  /// In en, this message translates to:
  /// **'Enter new list name (max 30 characters)'**
  String get enterNewListName;

  /// No description provided for @enterNewItemName.
  ///
  /// In en, this message translates to:
  /// **'Enter new item name (max 30 characters)'**
  String get enterNewItemName;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @newNameRequired.
  ///
  /// In en, this message translates to:
  /// **'New name is required'**
  String get newNameRequired;

  /// No description provided for @newNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'New name is too long (max 30 characters)'**
  String get newNameTooLong;

  /// No description provided for @template.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get template;

  /// No description provided for @templates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get templates;

  /// No description provided for @cloudTemplates.
  ///
  /// In en, this message translates to:
  /// **'Cloud Templates'**
  String get cloudTemplates;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @pleaseConnectAndTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please connect to the internet and try again'**
  String get pleaseConnectAndTryAgain;

  /// No description provided for @languageCode.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageCode;

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String itemsCount(int count);

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @languageNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Language Mismatch'**
  String get languageNotMatch;

  /// No description provided for @templateNotDesignedForLanguage.
  ///
  /// In en, this message translates to:
  /// **'This template is not designed for your language.\nDo you want to continue?'**
  String get templateNotDesignedForLanguage;

  /// No description provided for @fetchingTemplates.
  ///
  /// In en, this message translates to:
  /// **'Fetching templates...'**
  String get fetchingTemplates;

  /// No description provided for @noTemplatesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No templates available'**
  String get noTemplatesAvailable;

  /// No description provided for @selectTemplate.
  ///
  /// In en, this message translates to:
  /// **'Select a template to import'**
  String get selectTemplate;

  /// No description provided for @templateImported.
  ///
  /// In en, this message translates to:
  /// **'Template imported successfully'**
  String get templateImported;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @importingTemplate.
  ///
  /// In en, this message translates to:
  /// **'Importing template...'**
  String get importingTemplate;

  /// No description provided for @errorImportingTemplate.
  ///
  /// In en, this message translates to:
  /// **'Error importing template'**
  String get errorImportingTemplate;

  /// No description provided for @remoteListTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'Remote List Template Sources'**
  String get remoteListTemplateTitle;

  /// No description provided for @fetchAll.
  ///
  /// In en, this message translates to:
  /// **'Fetch All'**
  String get fetchAll;

  /// No description provided for @fetchLatestDefaults.
  ///
  /// In en, this message translates to:
  /// **'Fetch Latest Defaults'**
  String get fetchLatestDefaults;

  /// No description provided for @defaultSourcesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Default sources updated successfully'**
  String get defaultSourcesUpdated;

  /// No description provided for @addCustomSource.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Source'**
  String get addCustomSource;

  /// No description provided for @whatIsThis.
  ///
  /// In en, this message translates to:
  /// **'What is this?'**
  String get whatIsThis;

  /// No description provided for @defaultSources.
  ///
  /// In en, this message translates to:
  /// **'Default Sources'**
  String get defaultSources;

  /// No description provided for @customSources.
  ///
  /// In en, this message translates to:
  /// **'Custom Sources'**
  String get customSources;

  /// No description provided for @allSources.
  ///
  /// In en, this message translates to:
  /// **'All Sources'**
  String get allSources;

  /// No description provided for @noSourcesToDisplay.
  ///
  /// In en, this message translates to:
  /// **'No sources to display'**
  String get noSourcesToDisplay;

  /// No description provided for @errorSavingData.
  ///
  /// In en, this message translates to:
  /// **'Error saving data'**
  String get errorSavingData;

  /// No description provided for @cannotOpenUrl.
  ///
  /// In en, this message translates to:
  /// **'Cannot open URL'**
  String get cannotOpenUrl;

  /// No description provided for @viewSourceUrl.
  ///
  /// In en, this message translates to:
  /// **'View source URL'**
  String get viewSourceUrl;

  /// No description provided for @disable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @fetch.
  ///
  /// In en, this message translates to:
  /// **'Fetch'**
  String get fetch;

  /// No description provided for @lastFetch.
  ///
  /// In en, this message translates to:
  /// **'Last fetch'**
  String get lastFetch;

  /// No description provided for @fetchTemplate.
  ///
  /// In en, this message translates to:
  /// **'Fetch Template'**
  String get fetchTemplate;

  /// No description provided for @cannotOpenHelpPage.
  ///
  /// In en, this message translates to:
  /// **'Cannot open help page'**
  String get cannotOpenHelpPage;

  /// No description provided for @errorLoadingSources.
  ///
  /// In en, this message translates to:
  /// **'Error loading sources'**
  String get errorLoadingSources;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @myCustomSource.
  ///
  /// In en, this message translates to:
  /// **'My Custom Source'**
  String get myCustomSource;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterName;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @pleaseEnterUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a URL'**
  String get pleaseEnterUrl;

  /// No description provided for @pleaseEnterValidUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL'**
  String get pleaseEnterValidUrl;

  /// No description provided for @editSource.
  ///
  /// In en, this message translates to:
  /// **'Edit Source'**
  String get editSource;

  /// No description provided for @errorUpdatingDefaults.
  ///
  /// In en, this message translates to:
  /// **'Error updating defaults'**
  String get errorUpdatingDefaults;

  /// No description provided for @urlHintText.
  ///
  /// In en, this message translates to:
  /// **'https://example.com/list.json'**
  String get urlHintText;

  /// No description provided for @fetchListTemplates.
  ///
  /// In en, this message translates to:
  /// **'Fetch List Templates'**
  String get fetchListTemplates;

  /// No description provided for @fetchingData.
  ///
  /// In en, this message translates to:
  /// **'Fetching data...'**
  String get fetchingData;

  /// No description provided for @preparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing...'**
  String get preparing;

  /// No description provided for @inAppBrowser.
  ///
  /// In en, this message translates to:
  /// **'In-App Browser'**
  String get inAppBrowser;

  /// No description provided for @loadUrlError.
  ///
  /// In en, this message translates to:
  /// **'Error loading URL'**
  String get loadUrlError;

  /// No description provided for @copyUrl.
  ///
  /// In en, this message translates to:
  /// **'Copy URL'**
  String get copyUrl;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @goForward.
  ///
  /// In en, this message translates to:
  /// **'Go Forward'**
  String get goForward;

  /// No description provided for @noSourceSelected.
  ///
  /// In en, this message translates to:
  /// **'No source selected'**
  String get noSourceSelected;

  /// No description provided for @failedToFetchData.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch data'**
  String get failedToFetchData;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @templatesCount.
  ///
  /// In en, this message translates to:
  /// **'Templates ({count})'**
  String templatesCount(int count);

  /// No description provided for @andMoreItems.
  ///
  /// In en, this message translates to:
  /// **'... and {count} more items'**
  String andMoreItems(int count);

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @increase.
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get increase;

  /// No description provided for @decrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get decrease;

  /// No description provided for @range.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get range;

  /// No description provided for @between.
  ///
  /// In en, this message translates to:
  /// **'Between'**
  String get between;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @browseLink.
  ///
  /// In en, this message translates to:
  /// **'Browse link'**
  String get browseLink;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @openInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in browser'**
  String get openInBrowser;

  /// No description provided for @failedToLoadWebpage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load webpage'**
  String get failedToLoadWebpage;

  /// No description provided for @urlOptions.
  ///
  /// In en, this message translates to:
  /// **'URL Options'**
  String get urlOptions;

  /// No description provided for @currentUrl.
  ///
  /// In en, this message translates to:
  /// **'Current URL:'**
  String get currentUrl;

  /// No description provided for @urlCopied.
  ///
  /// In en, this message translates to:
  /// **'URL copied to clipboard'**
  String get urlCopied;

  /// No description provided for @importTemplate.
  ///
  /// In en, this message translates to:
  /// **'Import Template'**
  String get importTemplate;

  /// No description provided for @customizeData.
  ///
  /// In en, this message translates to:
  /// **'Customize Data'**
  String get customizeData;

  /// No description provided for @fetchTemplatesFirst.
  ///
  /// In en, this message translates to:
  /// **'Fetch templates from sources first'**
  String get fetchTemplatesFirst;

  /// No description provided for @templateItems.
  ///
  /// In en, this message translates to:
  /// **'Template Items'**
  String get templateItems;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @importedList.
  ///
  /// In en, this message translates to:
  /// **'Imported List'**
  String get importedList;

  /// No description provided for @imported.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get imported;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @setListName.
  ///
  /// In en, this message translates to:
  /// **'Set List Name'**
  String get setListName;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @importing.
  ///
  /// In en, this message translates to:
  /// **'Importing'**
  String get importing;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get pleaseWait;

  /// No description provided for @importFromFile.
  ///
  /// In en, this message translates to:
  /// **'Import from File'**
  String get importFromFile;

  /// No description provided for @selectFileToImport.
  ///
  /// In en, this message translates to:
  /// **'Select a file to import'**
  String get selectFileToImport;

  /// No description provided for @supportedFormat.
  ///
  /// In en, this message translates to:
  /// **'Supported format: .txt files with one item per line'**
  String get supportedFormat;

  /// No description provided for @selectFile.
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get selectFile;

  /// No description provided for @previewData.
  ///
  /// In en, this message translates to:
  /// **'Preview Data'**
  String get previewData;

  /// No description provided for @readyToImport.
  ///
  /// In en, this message translates to:
  /// **'Ready to Import'**
  String get readyToImport;

  /// No description provided for @importConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Click Import to add this data to your lists'**
  String get importConfirmation;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'Item Count'**
  String get itemCount;

  /// No description provided for @importEmptyFileError.
  ///
  /// In en, this message translates to:
  /// **'The selected file is empty or contains no valid items'**
  String get importEmptyFileError;

  /// No description provided for @importFileError.
  ///
  /// In en, this message translates to:
  /// **'Failed to read file'**
  String get importFileError;

  /// No description provided for @importError.
  ///
  /// In en, this message translates to:
  /// **'Import failed'**
  String get importError;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data imported successfully'**
  String get importSuccess;

  /// No description provided for @dragDropHint.
  ///
  /// In en, this message translates to:
  /// **'Or drag and drop a file here'**
  String get dragDropHint;

  /// No description provided for @enterManually.
  ///
  /// In en, this message translates to:
  /// **'Enter manually'**
  String get enterManually;

  /// No description provided for @useElementAsName.
  ///
  /// In en, this message translates to:
  /// **'Use an element as name'**
  String get useElementAsName;

  /// No description provided for @elementNumber.
  ///
  /// In en, this message translates to:
  /// **'Element number'**
  String get elementNumber;

  /// No description provided for @removeElementFromList.
  ///
  /// In en, this message translates to:
  /// **'Remove this element from the list'**
  String get removeElementFromList;

  /// No description provided for @removeElementDescription.
  ///
  /// In en, this message translates to:
  /// **'The selected element will not be included in the final list'**
  String get removeElementDescription;

  /// No description provided for @listPreview.
  ///
  /// In en, this message translates to:
  /// **'List Preview'**
  String get listPreview;

  /// No description provided for @noNameSet.
  ///
  /// In en, this message translates to:
  /// **'No name set'**
  String get noNameSet;

  /// No description provided for @listNamingOptions.
  ///
  /// In en, this message translates to:
  /// **'List Naming Options'**
  String get listNamingOptions;

  /// No description provided for @processingFile.
  ///
  /// In en, this message translates to:
  /// **'Processing file...'**
  String get processingFile;

  /// No description provided for @largeFileWarning.
  ///
  /// In en, this message translates to:
  /// **'Large File Warning'**
  String get largeFileWarning;

  /// No description provided for @largeFileWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'This file contains {count} lines. Processing large amounts of data may cause slowdowns or crashes on low-end devices. Do you want to continue?'**
  String largeFileWarningMessage(int count);

  /// No description provided for @remoteListTemplateSource.
  ///
  /// In en, this message translates to:
  /// **'Remote List Template Source'**
  String get remoteListTemplateSource;

  /// No description provided for @remoteListTemplateSourceDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage cloud template sources for Pick From List'**
  String get remoteListTemplateSourceDesc;

  /// No description provided for @yesNoGenerator.
  ///
  /// In en, this message translates to:
  /// **'Yes/No Generator'**
  String get yesNoGenerator;

  /// No description provided for @yesNoGeneratorDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate random Yes or No answers'**
  String get yesNoGeneratorDesc;

  /// No description provided for @counterMode.
  ///
  /// In en, this message translates to:
  /// **'Counter Mode'**
  String get counterMode;

  /// No description provided for @counterModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Track statistics of Yes/No results'**
  String get counterModeDesc;

  /// No description provided for @rockPaperScissorsCounterMode.
  ///
  /// In en, this message translates to:
  /// **'Counter Mode'**
  String get rockPaperScissorsCounterMode;

  /// No description provided for @rockPaperScissorsCounterModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Track statistics of Rock/Paper/Scissors results'**
  String get rockPaperScissorsCounterModeDesc;

  /// No description provided for @rockCount.
  ///
  /// In en, this message translates to:
  /// **'Rock Count'**
  String get rockCount;

  /// No description provided for @paperCount.
  ///
  /// In en, this message translates to:
  /// **'Paper Count'**
  String get paperCount;

  /// No description provided for @scissorsCount.
  ///
  /// In en, this message translates to:
  /// **'Scissors Count'**
  String get scissorsCount;

  /// No description provided for @batchCount.
  ///
  /// In en, this message translates to:
  /// **'Batch Count'**
  String get batchCount;

  /// No description provided for @batchCountDesc.
  ///
  /// In en, this message translates to:
  /// **'Number of results to generate at once'**
  String get batchCountDesc;

  /// No description provided for @counterStatistics.
  ///
  /// In en, this message translates to:
  /// **'Counter Statistics'**
  String get counterStatistics;

  /// No description provided for @totalGenerations.
  ///
  /// In en, this message translates to:
  /// **'Total Generations'**
  String get totalGenerations;

  /// No description provided for @yesCount.
  ///
  /// In en, this message translates to:
  /// **'Yes Count'**
  String get yesCount;

  /// No description provided for @noCount.
  ///
  /// In en, this message translates to:
  /// **'No Count'**
  String get noCount;

  /// No description provided for @yesPercentage.
  ///
  /// In en, this message translates to:
  /// **'Yes Percentage'**
  String get yesPercentage;

  /// No description provided for @noPercentage.
  ///
  /// In en, this message translates to:
  /// **'No Percentage'**
  String get noPercentage;

  /// No description provided for @headsCount.
  ///
  /// In en, this message translates to:
  /// **'Heads Count'**
  String get headsCount;

  /// No description provided for @headsPercentage.
  ///
  /// In en, this message translates to:
  /// **'Heads Percentage'**
  String get headsPercentage;

  /// No description provided for @tailsCount.
  ///
  /// In en, this message translates to:
  /// **'Tails Count'**
  String get tailsCount;

  /// No description provided for @tailsPercentage.
  ///
  /// In en, this message translates to:
  /// **'Tails Percentage'**
  String get tailsPercentage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
