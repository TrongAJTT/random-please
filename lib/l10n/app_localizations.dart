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

  /// No description provided for @donorsAck.
  ///
  /// In en, this message translates to:
  /// **'Supporters Acknowledgment'**
  String get donorsAck;

  /// No description provided for @donorsAckDesc.
  ///
  /// In en, this message translates to:
  /// **'List of publicly acknowledged supporters. Thank you very much!'**
  String get donorsAckDesc;

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

  /// No description provided for @momoDonateDesc.
  ///
  /// In en, this message translates to:
  /// **'Support me via Momo'**
  String get momoDonateDesc;

  /// No description provided for @donorBenefits.
  ///
  /// In en, this message translates to:
  /// **'Supporter Benefits'**
  String get donorBenefits;

  /// No description provided for @donorBenefit1.
  ///
  /// In en, this message translates to:
  /// **'Be listed in the acknowledgments and share your comments (if you want).'**
  String get donorBenefit1;

  /// No description provided for @donorBenefit2.
  ///
  /// In en, this message translates to:
  /// **'Prioritized feedback consideration.'**
  String get donorBenefit2;

  /// No description provided for @donorBenefit3.
  ///
  /// In en, this message translates to:
  /// **'Access to beta (debug) versions of my other software P2Lan Transfer, however updates are not guaranteed to be frequent.'**
  String get donorBenefit3;

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

  /// Cache size information
  ///
  /// In en, this message translates to:
  /// **'Cache size'**
  String cacheSize(String size);

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
  /// **'Are you sure you want to clear ALL cache data? This will remove all saved templates but preserve your settings.'**
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

  /// No description provided for @confirmBatchDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Batch Delete'**
  String get confirmBatchDelete;

  /// No description provided for @typeConfirmToDelete.
  ///
  /// In en, this message translates to:
  /// **'Type \"confirm\" to delete {count} selected templates:'**
  String typeConfirmToDelete(Object count);

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
  /// **'Include lowercase letters'**
  String get includeLowercase;

  /// No description provided for @includeUppercase.
  ///
  /// In en, this message translates to:
  /// **'Include uppercase letters'**
  String get includeUppercase;

  /// No description provided for @includeNumbers.
  ///
  /// In en, this message translates to:
  /// **'Include numbers'**
  String get includeNumbers;

  /// No description provided for @includeSpecial.
  ///
  /// In en, this message translates to:
  /// **'Include special characters'**
  String get includeSpecial;

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
  /// **'Get quick yes or no decisions'**
  String get yesNoDesc;

  /// No description provided for @flipCoin.
  ///
  /// In en, this message translates to:
  /// **'Flip Coin'**
  String get flipCoin;

  /// No description provided for @flipCoinDesc.
  ///
  /// In en, this message translates to:
  /// **'Virtual coin flip for random choices'**
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

  /// No description provided for @fetchTimeoutSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String fetchTimeoutSeconds(Object seconds);

  /// No description provided for @fetchRetryTimes.
  ///
  /// In en, this message translates to:
  /// **'{times} retries'**
  String fetchRetryTimes(int times);

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
  /// **'Cannot generate {count} unique letters from the available set. Please reduce the count or allow duplicates.'**
  String latinLetterGenerationError(Object count);

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

  /// Cache info with log size
  ///
  /// In en, this message translates to:
  /// **'Cache: {cacheSize} (+{logSize} log)'**
  String cacheWithLogSize(String cacheSize, String logSize);

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

  /// No description provided for @logsManagement.
  ///
  /// In en, this message translates to:
  /// **'App logs management and storage settings'**
  String get logsManagement;

  /// No description provided for @statusInfo.
  ///
  /// In en, this message translates to:
  /// **'Status: {info}'**
  String statusInfo(String info);

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

  /// No description provided for @pressBackAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit the app'**
  String get pressBackAgainToExit;

  /// No description provided for @checkingForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Checking for updates...'**
  String get checkingForUpdates;

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

  /// No description provided for @latest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

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
