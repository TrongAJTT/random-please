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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
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

  /// No description provided for @cacheDetails.
  ///
  /// In en, this message translates to:
  /// **'Cache Details'**
  String get cacheDetails;

  /// No description provided for @viewCacheDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewCacheDetails;

  /// Cache size information
  ///
  /// In en, this message translates to:
  /// **'Cache size'**
  String cacheSize(String size);

  /// No description provided for @cacheItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get cacheItems;

  /// No description provided for @clearAllCache.
  ///
  /// In en, this message translates to:
  /// **'Clear All Cache'**
  String get clearAllCache;

  /// No description provided for @logs.
  ///
  /// In en, this message translates to:
  /// **'Application Logs'**
  String get logs;

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

  /// No description provided for @logRetentionDesc.
  ///
  /// In en, this message translates to:
  /// **'Set how long to keep application logs before automatic deletion'**
  String get logRetentionDesc;

  /// No description provided for @logRetentionDescDetail.
  ///
  /// In en, this message translates to:
  /// **'Choose log retention period (5-30 days in 5-day intervals, or forever)'**
  String get logRetentionDescDetail;

  /// No description provided for @logRetentionAutoDelete.
  ///
  /// In en, this message translates to:
  /// **'Auto-delete after a period of time'**
  String get logRetentionAutoDelete;

  /// No description provided for @logManagement.
  ///
  /// In en, this message translates to:
  /// **'App logs management and storage settings'**
  String get logManagement;

  /// No description provided for @logManagementDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage application logs and retention settings'**
  String get logManagementDesc;

  /// No description provided for @logStatus.
  ///
  /// In en, this message translates to:
  /// **'Log Status'**
  String get logStatus;

  /// No description provided for @logsDesc.
  ///
  /// In en, this message translates to:
  /// **'Application log files and debug information'**
  String get logsDesc;

  /// No description provided for @dataAndStorage.
  ///
  /// In en, this message translates to:
  /// **'Data & Storage'**
  String get dataAndStorage;

  /// No description provided for @confirmClearCache.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear \"{cacheName}\" cache?'**
  String confirmClearCache(Object cacheName);

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

  /// No description provided for @cacheCleared.
  ///
  /// In en, this message translates to:
  /// **'{cacheName} cache cleared successfully'**
  String cacheCleared(Object cacheName);

  /// No description provided for @allCacheCleared.
  ///
  /// In en, this message translates to:
  /// **'All cache cleared successfully'**
  String get allCacheCleared;

  /// No description provided for @errorClearingCache.
  ///
  /// In en, this message translates to:
  /// **'Error clearing cache: {error}'**
  String errorClearingCache(Object error);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

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

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Label for saved devices
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @saveToHistory.
  ///
  /// In en, this message translates to:
  /// **'Save to History'**
  String get saveToHistory;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @fileName.
  ///
  /// In en, this message translates to:
  /// **'File Name'**
  String get fileName;

  /// No description provided for @overwrite.
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get overwrite;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @selectTool.
  ///
  /// In en, this message translates to:
  /// **'Select a tool from the sidebar'**
  String get selectTool;

  /// No description provided for @selectToolDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose a tool from the left sidebar to get started'**
  String get selectToolDesc;

  /// No description provided for @settingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Personalize your experience'**
  String get settingsDesc;

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

  /// No description provided for @editTemplate.
  ///
  /// In en, this message translates to:
  /// **'Edit Template'**
  String get editTemplate;

  /// No description provided for @createTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create New Template'**
  String get createTemplate;

  /// No description provided for @templateEditSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Template saved successfully! You can now navigate back.'**
  String get templateEditSuccessMessage;

  /// No description provided for @contentTab.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get contentTab;

  /// No description provided for @structureTab.
  ///
  /// In en, this message translates to:
  /// **'Structure'**
  String get structureTab;

  /// No description provided for @templateTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Template Title *'**
  String get templateTitleLabel;

  /// No description provided for @templateTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter title for this template'**
  String get templateTitleHint;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterTitle;

  /// No description provided for @addDataField.
  ///
  /// In en, this message translates to:
  /// **'Add Data Field'**
  String get addDataField;

  /// No description provided for @addDataLoop.
  ///
  /// In en, this message translates to:
  /// **'Add Data Loop'**
  String get addDataLoop;

  /// No description provided for @fieldTypeText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get fieldTypeText;

  /// No description provided for @fieldTypeLargeText.
  ///
  /// In en, this message translates to:
  /// **'Large Text'**
  String get fieldTypeLargeText;

  /// No description provided for @fieldTypeNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get fieldTypeNumber;

  /// No description provided for @fieldTypeDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fieldTypeDate;

  /// No description provided for @fieldTypeTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get fieldTypeTime;

  /// No description provided for @fieldTypeDateTime.
  ///
  /// In en, this message translates to:
  /// **'DateTime'**
  String get fieldTypeDateTime;

  /// No description provided for @fieldTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Field title *'**
  String get fieldTitleLabel;

  /// No description provided for @fieldTitleHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. Customer name'**
  String get fieldTitleHint;

  /// No description provided for @pleaseEnterFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter field title'**
  String get pleaseEnterFieldTitle;

  /// No description provided for @copyAndClose.
  ///
  /// In en, this message translates to:
  /// **'Copy and Close'**
  String get copyAndClose;

  /// No description provided for @insertAtCursor.
  ///
  /// In en, this message translates to:
  /// **'Insert at Cursor'**
  String get insertAtCursor;

  /// No description provided for @appendToEnd.
  ///
  /// In en, this message translates to:
  /// **'Append to End'**
  String get appendToEnd;

  /// No description provided for @loopTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Loop title *'**
  String get loopTitleLabel;

  /// No description provided for @loopTitleHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. Product list'**
  String get loopTitleHint;

  /// No description provided for @pleaseFixDuplicateIds.
  ///
  /// In en, this message translates to:
  /// **'Please fix inconsistent duplicate IDs before saving'**
  String get pleaseFixDuplicateIds;

  /// No description provided for @errorSavingTemplate.
  ///
  /// In en, this message translates to:
  /// **'Error saving template: {error}'**
  String errorSavingTemplate(Object error);

  /// No description provided for @templateContentLabel.
  ///
  /// In en, this message translates to:
  /// **'Template Content *'**
  String get templateContentLabel;

  /// No description provided for @templateContentHint.
  ///
  /// In en, this message translates to:
  /// **'Enter template content and add data fields...'**
  String get templateContentHint;

  /// No description provided for @pleaseEnterTemplateContent.
  ///
  /// In en, this message translates to:
  /// **'Please enter template content'**
  String get pleaseEnterTemplateContent;

  /// No description provided for @templateStructure.
  ///
  /// In en, this message translates to:
  /// **'Template Structure'**
  String get templateStructure;

  /// No description provided for @templateStructureOverview.
  ///
  /// In en, this message translates to:
  /// **'View an overview of fields and loops in your template.'**
  String get templateStructureOverview;

  /// No description provided for @textTemplatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get textTemplatesTitle;

  /// No description provided for @addNewTemplate.
  ///
  /// In en, this message translates to:
  /// **'Add new template'**
  String get addNewTemplate;

  /// No description provided for @noTemplatesYet.
  ///
  /// In en, this message translates to:
  /// **'No templates yet'**
  String get noTemplatesYet;

  /// No description provided for @createTemplatesHint.
  ///
  /// In en, this message translates to:
  /// **'Create your first template to get started.'**
  String get createTemplatesHint;

  /// No description provided for @createNewTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create new template'**
  String get createNewTemplate;

  /// No description provided for @exportToJson.
  ///
  /// In en, this message translates to:
  /// **'Export to JSON'**
  String get exportToJson;

  /// No description provided for @confirmDeletion.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get confirmDeletion;

  /// No description provided for @confirmDeleteTemplateMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String confirmDeleteTemplateMsg(Object title);

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

  /// No description provided for @holdToClearCacheInstruction.
  ///
  /// In en, this message translates to:
  /// **'Hold the clear button for 10 seconds to confirm'**
  String get holdToClearCacheInstruction;

  /// No description provided for @templateDeleted.
  ///
  /// In en, this message translates to:
  /// **'Template deleted.'**
  String get templateDeleted;

  /// No description provided for @errorDeletingTemplate.
  ///
  /// In en, this message translates to:
  /// **'Error deleting template: {error}'**
  String errorDeletingTemplate(Object error);

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @usageGuide.
  ///
  /// In en, this message translates to:
  /// **'Usage Guide'**
  String get usageGuide;

  /// No description provided for @textTemplateToolIntro.
  ///
  /// In en, this message translates to:
  /// **'This tool helps you manage and use text templates efficiently.'**
  String get textTemplateToolIntro;

  /// No description provided for @helpCreateNewTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create a new template using the + button.'**
  String get helpCreateNewTemplate;

  /// No description provided for @helpTapToUseTemplate.
  ///
  /// In en, this message translates to:
  /// **'Tap a template to use it.'**
  String get helpTapToUseTemplate;

  /// No description provided for @helpTapMenuForActions.
  ///
  /// In en, this message translates to:
  /// **'Tap the menu (⋮) for more actions.'**
  String get helpTapMenuForActions;

  /// No description provided for @textTemplateScreenHint.
  ///
  /// In en, this message translates to:
  /// **'Templates are saved locally on your device.'**
  String get textTemplateScreenHint;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @addTemplate.
  ///
  /// In en, this message translates to:
  /// **'Add Template'**
  String get addTemplate;

  /// No description provided for @addManually.
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get addManually;

  /// No description provided for @createTemplateFromScratch.
  ///
  /// In en, this message translates to:
  /// **'Create a template from scratch'**
  String get createTemplateFromScratch;

  /// No description provided for @addFromFile.
  ///
  /// In en, this message translates to:
  /// **'Add from file'**
  String get addFromFile;

  /// No description provided for @importTemplateFromJson.
  ///
  /// In en, this message translates to:
  /// **'Import multiple templates from JSON files'**
  String get importTemplateFromJson;

  /// No description provided for @templateImported.
  ///
  /// In en, this message translates to:
  /// **'Template imported successfully.'**
  String get templateImported;

  /// No description provided for @templatesImported.
  ///
  /// In en, this message translates to:
  /// **'Templates imported successfully.'**
  String templatesImported(Object count);

  /// No description provided for @importResults.
  ///
  /// In en, this message translates to:
  /// **'Import Results'**
  String get importResults;

  /// No description provided for @importSummary.
  ///
  /// In en, this message translates to:
  /// **'{successCount} successful, {failCount} failed'**
  String importSummary(Object failCount, Object successCount);

  /// No description provided for @successfulImports.
  ///
  /// In en, this message translates to:
  /// **'Successful imports ({count})'**
  String successfulImports(Object count);

  /// No description provided for @failedImports.
  ///
  /// In en, this message translates to:
  /// **'Failed imports ({count})'**
  String failedImports(Object count);

  /// No description provided for @noImportsAttempted.
  ///
  /// In en, this message translates to:
  /// **'No files were selected for import'**
  String get noImportsAttempted;

  /// No description provided for @invalidTemplateFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid template format: {error}'**
  String invalidTemplateFormat(Object error);

  /// No description provided for @errorImportingTemplate.
  ///
  /// In en, this message translates to:
  /// **'Error importing template: {error}'**
  String errorImportingTemplate(Object error);

  /// No description provided for @copySuffix.
  ///
  /// In en, this message translates to:
  /// **'copy'**
  String get copySuffix;

  /// No description provided for @templateCopied.
  ///
  /// In en, this message translates to:
  /// **'Template copied.'**
  String get templateCopied;

  /// No description provided for @errorCopyingTemplate.
  ///
  /// In en, this message translates to:
  /// **'Error copying template: {error}'**
  String errorCopyingTemplate(Object error);

  /// No description provided for @saveTemplateAsJson.
  ///
  /// In en, this message translates to:
  /// **'Save template as JSON'**
  String get saveTemplateAsJson;

  /// No description provided for @templateExported.
  ///
  /// In en, this message translates to:
  /// **'Template exported to {path}'**
  String templateExported(Object path);

  /// No description provided for @errorExportingTemplate.
  ///
  /// In en, this message translates to:
  /// **'Error exporting template: {error}'**
  String errorExportingTemplate(Object error);

  /// No description provided for @generateDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Generate Document: {title}'**
  String generateDocumentTitle(Object title);

  /// No description provided for @fillDataTab.
  ///
  /// In en, this message translates to:
  /// **'Fill Data'**
  String get fillDataTab;

  /// No description provided for @previewTab.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewTab;

  /// No description provided for @showDocument.
  ///
  /// In en, this message translates to:
  /// **'Show Document'**
  String get showDocument;

  /// No description provided for @fillInformation.
  ///
  /// In en, this message translates to:
  /// **'Fill Information'**
  String get fillInformation;

  /// No description provided for @dataLoops.
  ///
  /// In en, this message translates to:
  /// **'Data Loops'**
  String get dataLoops;

  /// No description provided for @generateDocument.
  ///
  /// In en, this message translates to:
  /// **'Generate Document'**
  String get generateDocument;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @addNewRow.
  ///
  /// In en, this message translates to:
  /// **'Add New Row'**
  String get addNewRow;

  /// No description provided for @rowNumber.
  ///
  /// In en, this message translates to:
  /// **'Row {number}'**
  String rowNumber(Object number);

  /// No description provided for @deleteThisRow.
  ///
  /// In en, this message translates to:
  /// **'Delete this row'**
  String get deleteThisRow;

  /// No description provided for @enterField.
  ///
  /// In en, this message translates to:
  /// **'Enter {field}'**
  String enterField(Object field);

  /// No description provided for @unsupportedFieldType.
  ///
  /// In en, this message translates to:
  /// **'Field type {type} not supported'**
  String unsupportedFieldType(Object type);

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// No description provided for @selectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Select date and time'**
  String get selectDateTime;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @completedDocument.
  ///
  /// In en, this message translates to:
  /// **'Completed Document'**
  String get completedDocument;

  /// No description provided for @fieldCount.
  ///
  /// In en, this message translates to:
  /// **'Fields: {count}'**
  String fieldCount(Object count);

  /// No description provided for @basicFieldCount.
  ///
  /// In en, this message translates to:
  /// **'basic fields'**
  String get basicFieldCount;

  /// No description provided for @loopFieldCount.
  ///
  /// In en, this message translates to:
  /// **'fields in loops'**
  String get loopFieldCount;

  /// No description provided for @loopDataCount.
  ///
  /// In en, this message translates to:
  /// **'Data loops: {count}'**
  String loopDataCount(Object count);

  /// No description provided for @duplicateIdWarning.
  ///
  /// In en, this message translates to:
  /// **'Detected {count} inconsistent duplicate IDs. Elements with the same ID must have the same type and title.'**
  String duplicateIdWarning(Object count);

  /// No description provided for @normalFields.
  ///
  /// In en, this message translates to:
  /// **'Normal fields:'**
  String get normalFields;

  /// No description provided for @loopLabel.
  ///
  /// In en, this message translates to:
  /// **'Loop: {title}'**
  String loopLabel(Object title);

  /// No description provided for @structureDetail.
  ///
  /// In en, this message translates to:
  /// **'Structure details'**
  String get structureDetail;

  /// No description provided for @basicFields.
  ///
  /// In en, this message translates to:
  /// **'Basic fields'**
  String get basicFields;

  /// No description provided for @loopContent.
  ///
  /// In en, this message translates to:
  /// **'Loop content'**
  String get loopContent;

  /// No description provided for @fieldInLoop.
  ///
  /// In en, this message translates to:
  /// **'Field \"{field}\" belongs to loop \"{loop}\"'**
  String fieldInLoop(Object field, Object loop);

  /// No description provided for @characterCount.
  ///
  /// In en, this message translates to:
  /// **'{count} characters'**
  String characterCount(Object count);

  /// No description provided for @fieldsAndLoops.
  ///
  /// In en, this message translates to:
  /// **'{fields} fields, {loops} loops'**
  String fieldsAndLoops(Object fields, Object loops);

  /// No description provided for @longPressToSelect.
  ///
  /// In en, this message translates to:
  /// **'Long press to select templates'**
  String get longPressToSelect;

  /// No description provided for @selectedTemplates.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedTemplates(Object count);

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// No description provided for @batchExport.
  ///
  /// In en, this message translates to:
  /// **'Export Selected'**
  String get batchExport;

  /// No description provided for @batchDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected'**
  String get batchDelete;

  /// No description provided for @exportTemplates.
  ///
  /// In en, this message translates to:
  /// **'Export Templates'**
  String get exportTemplates;

  /// No description provided for @editFilenames.
  ///
  /// In en, this message translates to:
  /// **'Edit file names before export:'**
  String get editFilenames;

  /// No description provided for @filenameFor.
  ///
  /// In en, this message translates to:
  /// **'Filename for \"{title}\":'**
  String filenameFor(Object title);

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

  /// No description provided for @confirmText.
  ///
  /// In en, this message translates to:
  /// **'confirm'**
  String get confirmText;

  /// No description provided for @confirmationRequired.
  ///
  /// In en, this message translates to:
  /// **'Please type \"confirm\" to proceed'**
  String get confirmationRequired;

  /// No description provided for @batchExportCompleted.
  ///
  /// In en, this message translates to:
  /// **'Exported {count} templates successfully'**
  String batchExportCompleted(Object count);

  /// No description provided for @batchDeleteCompleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted {count} templates successfully'**
  String batchDeleteCompleted(Object count);

  /// No description provided for @errorDuringBatchExport.
  ///
  /// In en, this message translates to:
  /// **'Error exporting some templates: {errors}'**
  String errorDuringBatchExport(Object errors);

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

  /// No description provided for @restored.
  ///
  /// In en, this message translates to:
  /// **'Restored!'**
  String get restored;

  /// Title for the Date Calculator tool
  ///
  /// In en, this message translates to:
  /// **'Date Calculator'**
  String get dateCalculator;

  /// Description for the Date Calculator tool
  ///
  /// In en, this message translates to:
  /// **'A versatile tool for handling all your date-related calculations. Below is an overview of its features:'**
  String get dateCalculatorDesc;

  /// No description provided for @dateInfoTabDescription.
  ///
  /// In en, this message translates to:
  /// **'Provides detailed information for any date, including day of the week, day of the year, week number, quarter, and leap year status.'**
  String get dateInfoTabDescription;

  /// No description provided for @dateDifferenceTabDescription.
  ///
  /// In en, this message translates to:
  /// **'Calculates the duration between two dates, showing the result in a combination of years, months, and days, as well as in total units like months, weeks, days, etc.'**
  String get dateDifferenceTabDescription;

  /// No description provided for @addSubtractTabDescription.
  ///
  /// In en, this message translates to:
  /// **'Adds or subtracts a specific number of years, months, and days from a given date to determine the resulting date.'**
  String get addSubtractTabDescription;

  /// No description provided for @ageCalculatorTabDescription.
  ///
  /// In en, this message translates to:
  /// **'Calculates the age from a birth date and shows the total days lived, days until the next birthday, and the date of the next birthday.'**
  String get ageCalculatorTabDescription;

  /// Title for the history panel in the Date Calculator
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get dateCalculatorHistory;

  /// No description provided for @dateDifference.
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get dateDifference;

  /// No description provided for @addSubtractDate.
  ///
  /// In en, this message translates to:
  /// **'Add/Subtract'**
  String get addSubtractDate;

  /// No description provided for @ageCalculator.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get ageCalculator;

  /// No description provided for @ageCalculatorDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate age and track upcoming birthdays.'**
  String get ageCalculatorDesc;

  /// No description provided for @workingDays.
  ///
  /// In en, this message translates to:
  /// **'Working Days'**
  String get workingDays;

  /// No description provided for @timezoneConverter.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get timezoneConverter;

  /// No description provided for @recurringDates.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get recurringDates;

  /// No description provided for @countdown.
  ///
  /// In en, this message translates to:
  /// **'Countdown'**
  String get countdown;

  /// No description provided for @dateInfo.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get dateInfo;

  /// No description provided for @dateInfoDesc.
  ///
  /// In en, this message translates to:
  /// **'Get detailed information about any selected date'**
  String get dateInfoDesc;

  /// No description provided for @timeUnitConverter.
  ///
  /// In en, this message translates to:
  /// **'Time Unit'**
  String get timeUnitConverter;

  /// No description provided for @nthWeekday.
  ///
  /// In en, this message translates to:
  /// **'Nth Weekday'**
  String get nthWeekday;

  /// No description provided for @allCalculations.
  ///
  /// In en, this message translates to:
  /// **'All Calculations'**
  String get allCalculations;

  /// No description provided for @filterByType.
  ///
  /// In en, this message translates to:
  /// **'Filter by Type'**
  String get filterByType;

  /// No description provided for @clearCalculationHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearCalculationHistory;

  /// No description provided for @bookmarkResult.
  ///
  /// In en, this message translates to:
  /// **'Bookmark Result'**
  String get bookmarkResult;

  /// No description provided for @resultBookmarked.
  ///
  /// In en, this message translates to:
  /// **'Result bookmarked to history'**
  String get resultBookmarked;

  /// No description provided for @clearTabData.
  ///
  /// In en, this message translates to:
  /// **'Clear Data'**
  String get clearTabData;

  /// No description provided for @tabDataCleared.
  ///
  /// In en, this message translates to:
  /// **'Data cleared for current tab'**
  String get tabDataCleared;

  /// No description provided for @showCalculatorInfo.
  ///
  /// In en, this message translates to:
  /// **'Show calculator information'**
  String get showCalculatorInfo;

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

  /// No description provided for @baseDate.
  ///
  /// In en, this message translates to:
  /// **'Base Date'**
  String get baseDate;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// No description provided for @targetDate.
  ///
  /// In en, this message translates to:
  /// **'Target Date'**
  String get targetDate;

  /// No description provided for @selectDateToView.
  ///
  /// In en, this message translates to:
  /// **'Select a date to view detailed information'**
  String get selectDateToView;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @dateDistanceSection.
  ///
  /// In en, this message translates to:
  /// **'Date Distance'**
  String get dateDistanceSection;

  /// No description provided for @unitConversionSection.
  ///
  /// In en, this message translates to:
  /// **'Unit Conversion'**
  String get unitConversionSection;

  /// No description provided for @totalMonths.
  ///
  /// In en, this message translates to:
  /// **'Total Months'**
  String get totalMonths;

  /// No description provided for @totalWeeks.
  ///
  /// In en, this message translates to:
  /// **'Total Weeks'**
  String get totalWeeks;

  /// No description provided for @totalDays.
  ///
  /// In en, this message translates to:
  /// **'Total Days'**
  String get totalDays;

  /// No description provided for @totalHours.
  ///
  /// In en, this message translates to:
  /// **'Total Hours'**
  String get totalHours;

  /// No description provided for @totalMinutes.
  ///
  /// In en, this message translates to:
  /// **'Total Minutes'**
  String get totalMinutes;

  /// No description provided for @resultDate.
  ///
  /// In en, this message translates to:
  /// **'Result Date'**
  String get resultDate;

  /// No description provided for @dayOfWeek.
  ///
  /// In en, this message translates to:
  /// **'Day of the week'**
  String get dayOfWeek;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get months;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @weeks.
  ///
  /// In en, this message translates to:
  /// **'Weeks'**
  String get weeks;

  /// No description provided for @addSubtractValues.
  ///
  /// In en, this message translates to:
  /// **'Add/Subtract Values'**
  String get addSubtractValues;

  /// No description provided for @addSubtractResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get addSubtractResultsTitle;

  /// Title for the age calculator results card
  ///
  /// In en, this message translates to:
  /// **'Age Calculation Results'**
  String get ageCalculatorResultsTitle;

  /// Label for age in age calculator
  ///
  /// In en, this message translates to:
  /// **'Your Current Age'**
  String get age;

  /// Label for total days lived in age calculator
  ///
  /// In en, this message translates to:
  /// **'Total Days Lived'**
  String get daysLived;

  /// Label for the date of the next birthday
  ///
  /// In en, this message translates to:
  /// **'Next Birthday On'**
  String get nextBirthday;

  /// Label for days until next birthday in age calculator
  ///
  /// In en, this message translates to:
  /// **'Days Until Next Birthday'**
  String get daysUntilBirthday;

  /// No description provided for @workingDaysCount.
  ///
  /// In en, this message translates to:
  /// **'Working Days'**
  String get workingDaysCount;

  /// No description provided for @excludeWeekends.
  ///
  /// In en, this message translates to:
  /// **'Exclude Weekends'**
  String get excludeWeekends;

  /// No description provided for @customHolidays.
  ///
  /// In en, this message translates to:
  /// **'Custom Holidays'**
  String get customHolidays;

  /// No description provided for @addHoliday.
  ///
  /// In en, this message translates to:
  /// **'Add Holiday'**
  String get addHoliday;

  /// No description provided for @removeHoliday.
  ///
  /// In en, this message translates to:
  /// **'Remove Holiday'**
  String get removeHoliday;

  /// No description provided for @fromTimezone.
  ///
  /// In en, this message translates to:
  /// **'From Timezone'**
  String get fromTimezone;

  /// No description provided for @toTimezone.
  ///
  /// In en, this message translates to:
  /// **'To Timezone'**
  String get toTimezone;

  /// No description provided for @convertedTime.
  ///
  /// In en, this message translates to:
  /// **'Converted Time'**
  String get convertedTime;

  /// No description provided for @recurringPattern.
  ///
  /// In en, this message translates to:
  /// **'Pattern'**
  String get recurringPattern;

  /// No description provided for @interval.
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get interval;

  /// No description provided for @occurrences.
  ///
  /// In en, this message translates to:
  /// **'Occurrences'**
  String get occurrences;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @generatedDates.
  ///
  /// In en, this message translates to:
  /// **'Generated Dates'**
  String get generatedDates;

  /// No description provided for @eventName.
  ///
  /// In en, this message translates to:
  /// **'Event Name'**
  String get eventName;

  /// No description provided for @timeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time remaining: {seconds}s'**
  String timeRemaining(Object seconds);

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @daysRemaining.
  ///
  /// In en, this message translates to:
  /// **'Days Remaining'**
  String get daysRemaining;

  /// No description provided for @hoursRemaining.
  ///
  /// In en, this message translates to:
  /// **'Hours Remaining'**
  String get hoursRemaining;

  /// No description provided for @minutesRemaining.
  ///
  /// In en, this message translates to:
  /// **'Minutes Remaining'**
  String get minutesRemaining;

  /// No description provided for @currentWeek.
  ///
  /// In en, this message translates to:
  /// **'Current Week'**
  String get currentWeek;

  /// No description provided for @weekOf.
  ///
  /// In en, this message translates to:
  /// **'Week of {year}'**
  String weekOf(int year);

  /// No description provided for @currentDay.
  ///
  /// In en, this message translates to:
  /// **'Current Day'**
  String get currentDay;

  /// No description provided for @dayOf.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of {year}'**
  String dayOf(int day, int year);

  /// No description provided for @convertValue.
  ///
  /// In en, this message translates to:
  /// **'Convert Value'**
  String get convertValue;

  /// No description provided for @toUnit.
  ///
  /// In en, this message translates to:
  /// **'To Unit'**
  String get toUnit;

  /// No description provided for @convertedValue.
  ///
  /// In en, this message translates to:
  /// **'Converted Value'**
  String get convertedValue;

  /// No description provided for @timeUnits.
  ///
  /// In en, this message translates to:
  /// **'Time Units'**
  String get timeUnits;

  /// No description provided for @findWeekday.
  ///
  /// In en, this message translates to:
  /// **'Find Weekday'**
  String get findWeekday;

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

  /// No description provided for @weekday.
  ///
  /// In en, this message translates to:
  /// **'Weekday'**
  String get weekday;

  /// No description provided for @occurrence.
  ///
  /// In en, this message translates to:
  /// **'Occurrence'**
  String get occurrence;

  /// No description provided for @first.
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get first;

  /// No description provided for @second.
  ///
  /// In en, this message translates to:
  /// **'Second'**
  String get second;

  /// No description provided for @third.
  ///
  /// In en, this message translates to:
  /// **'Third'**
  String get third;

  /// No description provided for @fourth.
  ///
  /// In en, this message translates to:
  /// **'Fourth'**
  String get fourth;

  /// No description provided for @last.
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get last;

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

  /// No description provided for @dateNotFound.
  ///
  /// In en, this message translates to:
  /// **'Date not found'**
  String get dateNotFound;

  /// No description provided for @invalidDate.
  ///
  /// In en, this message translates to:
  /// **'Invalid date'**
  String get invalidDate;

  /// No description provided for @calculationError.
  ///
  /// In en, this message translates to:
  /// **'Calculation error'**
  String get calculationError;

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryYet;

  /// No description provided for @performCalculation.
  ///
  /// In en, this message translates to:
  /// **'Perform your first calculation to see history here'**
  String get performCalculation;

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

  /// No description provided for @historyItem.
  ///
  /// In en, this message translates to:
  /// **'History Item'**
  String get historyItem;

  /// No description provided for @loadFromHistory.
  ///
  /// In en, this message translates to:
  /// **'Load from History'**
  String get loadFromHistory;

  /// No description provided for @deleteFromHistory.
  ///
  /// In en, this message translates to:
  /// **'Delete from History'**
  String get deleteFromHistory;

  /// No description provided for @historyItemDeleted.
  ///
  /// In en, this message translates to:
  /// **'History item deleted'**
  String get historyItemDeleted;

  /// No description provided for @restoreExpression.
  ///
  /// In en, this message translates to:
  /// **'Restore Expression'**
  String get restoreExpression;

  /// No description provided for @restoreResult.
  ///
  /// In en, this message translates to:
  /// **'Restore Result'**
  String get restoreResult;

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

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

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

  /// No description provided for @flipCoinInstruction.
  ///
  /// In en, this message translates to:
  /// **'Flip the coin to see the result'**
  String get flipCoinInstruction;

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

  /// No description provided for @hex6.
  ///
  /// In en, this message translates to:
  /// **'HEX (6-digit)'**
  String get hex6;

  /// No description provided for @hex8.
  ///
  /// In en, this message translates to:
  /// **'HEX (8-digit with alpha)'**
  String get hex8;

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

  /// No description provided for @tens.
  ///
  /// In en, this message translates to:
  /// **'Tens'**
  String get tens;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

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

  /// No description provided for @currencyConverter.
  ///
  /// In en, this message translates to:
  /// **'Currency Converter'**
  String get currencyConverter;

  /// No description provided for @updatingRates.
  ///
  /// In en, this message translates to:
  /// **'Updating exchange rates...'**
  String get updatingRates;

  /// No description provided for @lastUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date} at {time}'**
  String lastUpdatedAt(Object date, Object time);

  /// No description provided for @noRatesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No exchange rate information available, fetching rates...'**
  String get noRatesAvailable;

  /// No description provided for @staticRates.
  ///
  /// In en, this message translates to:
  /// **'Static'**
  String get staticRates;

  /// No description provided for @refreshRates.
  ///
  /// In en, this message translates to:
  /// **'Refresh rates'**
  String get refreshRates;

  /// No description provided for @resetLayout.
  ///
  /// In en, this message translates to:
  /// **'Reset Layout'**
  String get resetLayout;

  /// No description provided for @confirmResetLayout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Reset Layout'**
  String get confirmResetLayout;

  /// No description provided for @confirmResetLayoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset the layout? This will remove all cards and restore default settings.'**
  String get confirmResetLayoutMessage;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @addCard.
  ///
  /// In en, this message translates to:
  /// **'Add Card'**
  String get addCard;

  /// No description provided for @addRow.
  ///
  /// In en, this message translates to:
  /// **'Add Row'**
  String get addRow;

  /// No description provided for @cardView.
  ///
  /// In en, this message translates to:
  /// **'Card View'**
  String get cardView;

  /// No description provided for @cards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get cards;

  /// No description provided for @rows.
  ///
  /// In en, this message translates to:
  /// **'Rows'**
  String get rows;

  /// No description provided for @converter.
  ///
  /// In en, this message translates to:
  /// **'Converter'**
  String get converter;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @fromCurrency.
  ///
  /// In en, this message translates to:
  /// **'From Currency'**
  String get fromCurrency;

  /// No description provided for @convertedTo.
  ///
  /// In en, this message translates to:
  /// **'Converted to'**
  String get convertedTo;

  /// No description provided for @removeCard.
  ///
  /// In en, this message translates to:
  /// **'Remove card'**
  String get removeCard;

  /// No description provided for @removeRow.
  ///
  /// In en, this message translates to:
  /// **'Remove row'**
  String get removeRow;

  /// No description provided for @liveRatesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Live rates updated successfully'**
  String get liveRatesUpdated;

  /// No description provided for @staticRatesUsed.
  ///
  /// In en, this message translates to:
  /// **'Using static rates (live data unavailable)'**
  String get staticRatesUsed;

  /// No description provided for @failedToUpdateRates.
  ///
  /// In en, this message translates to:
  /// **'Failed to update rates'**
  String get failedToUpdateRates;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @customizeCurrenciesDialog.
  ///
  /// In en, this message translates to:
  /// **'Customize Currencies'**
  String get customizeCurrenciesDialog;

  /// No description provided for @searchCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Search currencies...'**
  String get searchCurrencies;

  /// No description provided for @noCurrenciesFound.
  ///
  /// In en, this message translates to:
  /// **'No currencies found'**
  String get noCurrenciesFound;

  /// No description provided for @currenciesSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} currencies selected'**
  String currenciesSelected(Object count);

  /// No description provided for @applyChanges.
  ///
  /// In en, this message translates to:
  /// **'Apply Changes'**
  String get applyChanges;

  /// No description provided for @currencyStatusSuccess.
  ///
  /// In en, this message translates to:
  /// **'Live rate'**
  String get currencyStatusSuccess;

  /// No description provided for @currencyStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch'**
  String get currencyStatusFailed;

  /// No description provided for @currencyStatusTimeout.
  ///
  /// In en, this message translates to:
  /// **'Timeout'**
  String get currencyStatusTimeout;

  /// No description provided for @currencyStatusNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Not supported'**
  String get currencyStatusNotSupported;

  /// No description provided for @currencyStatusStatic.
  ///
  /// In en, this message translates to:
  /// **'Static rate'**
  String get currencyStatusStatic;

  /// No description provided for @currencyStatusFetchedRecently.
  ///
  /// In en, this message translates to:
  /// **'Recently fetched'**
  String get currencyStatusFetchedRecently;

  /// No description provided for @currencyStatusSuccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Successfully fetched live rate'**
  String get currencyStatusSuccessDesc;

  /// No description provided for @currencyStatusFailedDesc.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch live rate, using static fallback'**
  String get currencyStatusFailedDesc;

  /// No description provided for @currencyStatusTimeoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Request timed out, using static fallback'**
  String get currencyStatusTimeoutDesc;

  /// No description provided for @currencyStatusNotSupportedDesc.
  ///
  /// In en, this message translates to:
  /// **'Currency not supported by API'**
  String get currencyStatusNotSupportedDesc;

  /// No description provided for @currencyStatusStaticDesc.
  ///
  /// In en, this message translates to:
  /// **'Using static exchange rate'**
  String get currencyStatusStaticDesc;

  /// No description provided for @currencyStatusFetchedRecentlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Successfully fetched within the last hour'**
  String get currencyStatusFetchedRecentlyDesc;

  /// No description provided for @currencyConverterInfo.
  ///
  /// In en, this message translates to:
  /// **'Currency Converter Info'**
  String get currencyConverterInfo;

  /// No description provided for @aboutThisFeature.
  ///
  /// In en, this message translates to:
  /// **'About This Feature'**
  String get aboutThisFeature;

  /// No description provided for @aboutThisFeatureDesc.
  ///
  /// In en, this message translates to:
  /// **'The Currency Converter allows you to convert between different currencies using live or static exchange rates. It supports over 80 currencies worldwide.'**
  String get aboutThisFeatureDesc;

  /// No description provided for @howToUseDesc.
  ///
  /// In en, this message translates to:
  /// **'• Add or remove cards/rows for multiple conversions\n• Customize visible currencies\n• Switch between card and table view\n• Rates update automatically based on your settings'**
  String get howToUseDesc;

  /// No description provided for @staticRatesInfo.
  ///
  /// In en, this message translates to:
  /// **'Static Exchange Rates'**
  String get staticRatesInfo;

  /// No description provided for @staticRatesInfoDesc.
  ///
  /// In en, this message translates to:
  /// **'Static rates are fallback values used when live rates cannot be fetched. These rates are updated periodically and may not reflect real-time market prices.'**
  String get staticRatesInfoDesc;

  /// No description provided for @viewStaticRates.
  ///
  /// In en, this message translates to:
  /// **'View Static Rates'**
  String get viewStaticRates;

  /// No description provided for @lastStaticUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last static rates update: May 2025'**
  String get lastStaticUpdate;

  /// No description provided for @staticRatesList.
  ///
  /// In en, this message translates to:
  /// **'Static Exchange Rates List'**
  String get staticRatesList;

  /// No description provided for @rateBasedOnUSD.
  ///
  /// In en, this message translates to:
  /// **'All rates are based on 1 USD'**
  String get rateBasedOnUSD;

  /// No description provided for @maxCurrenciesSelected.
  ///
  /// In en, this message translates to:
  /// **'Maximum 10 currencies can be selected'**
  String get maxCurrenciesSelected;

  /// No description provided for @savePreset.
  ///
  /// In en, this message translates to:
  /// **'Save Preset'**
  String get savePreset;

  /// No description provided for @loadPreset.
  ///
  /// In en, this message translates to:
  /// **'Load Preset'**
  String get loadPreset;

  /// No description provided for @presetName.
  ///
  /// In en, this message translates to:
  /// **'Preset Name'**
  String get presetName;

  /// No description provided for @enterPresetName.
  ///
  /// In en, this message translates to:
  /// **'Enter preset name'**
  String get enterPresetName;

  /// No description provided for @presetNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Preset name is required'**
  String get presetNameRequired;

  /// No description provided for @presetLoaded.
  ///
  /// In en, this message translates to:
  /// **'Preset loaded successfully'**
  String get presetLoaded;

  /// No description provided for @presetDeleted.
  ///
  /// In en, this message translates to:
  /// **'Preset deleted successfully'**
  String get presetDeleted;

  /// No description provided for @deletePreset.
  ///
  /// In en, this message translates to:
  /// **'Delete Preset'**
  String get deletePreset;

  /// No description provided for @confirmDeletePreset.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this preset?'**
  String get confirmDeletePreset;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortByName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortByName;

  /// No description provided for @sortByDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sortByDate;

  /// No description provided for @noPresetsFound.
  ///
  /// In en, this message translates to:
  /// **'No presets found'**
  String get noPresetsFound;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @createdOn.
  ///
  /// In en, this message translates to:
  /// **'Created on {date}'**
  String createdOn(Object date);

  /// No description provided for @currencies.
  ///
  /// In en, this message translates to:
  /// **'{count} currencies'**
  String currencies(Object count);

  /// No description provided for @currenciesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} currencies'**
  String currenciesCount(Object count);

  /// No description provided for @createdDate.
  ///
  /// In en, this message translates to:
  /// **'Created: {date}'**
  String createdDate(Object date);

  /// No description provided for @sortByLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort by:'**
  String get sortByLabel;

  /// No description provided for @selectPreset.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectPreset;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @deletePresetAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deletePresetAction;

  /// No description provided for @deletePresetTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Preset'**
  String get deletePresetTitle;

  /// No description provided for @deletePresetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this preset?'**
  String get deletePresetConfirm;

  /// No description provided for @presetDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Preset deleted'**
  String get presetDeletedSuccess;

  /// No description provided for @errorLabel.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get errorLabel;

  /// No description provided for @fetchTimeout.
  ///
  /// In en, this message translates to:
  /// **'Fetch Timeout'**
  String get fetchTimeout;

  /// No description provided for @fetchTimeoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Set timeout for currency rate fetching (5-20 seconds)'**
  String get fetchTimeoutDesc;

  /// No description provided for @fetchTimeoutSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String fetchTimeoutSeconds(Object seconds);

  /// No description provided for @fetchRetryIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Retry when incomplete'**
  String get fetchRetryIncomplete;

  /// No description provided for @fetchRetryIncompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically retry failed/timeout currencies during fetch'**
  String get fetchRetryIncompleteDesc;

  /// No description provided for @fetchRetryTimes.
  ///
  /// In en, this message translates to:
  /// **'{times} retries'**
  String fetchRetryTimes(int times);

  /// No description provided for @fetchingRates.
  ///
  /// In en, this message translates to:
  /// **'Fetching Currency Rates'**
  String get fetchingRates;

  /// No description provided for @fetchingProgress.
  ///
  /// In en, this message translates to:
  /// **'Fetching progress: {completed}/{total}'**
  String fetchingProgress(Object completed, Object total);

  /// No description provided for @fetchingStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get fetchingStatus;

  /// No description provided for @fetchingCurrency.
  ///
  /// In en, this message translates to:
  /// **'Fetching {currency}...'**
  String fetchingCurrency(Object currency);

  /// No description provided for @fetchComplete.
  ///
  /// In en, this message translates to:
  /// **'Fetch Complete'**
  String get fetchComplete;

  /// No description provided for @fetchCancelled.
  ///
  /// In en, this message translates to:
  /// **'Fetch Cancelled'**
  String get fetchCancelled;

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

  /// No description provided for @flipping.
  ///
  /// In en, this message translates to:
  /// **'Flipping...'**
  String get flipping;

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

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @quickActionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Select up to 4 tools for quick access.'**
  String get quickActionsDesc;

  /// No description provided for @cacheTypeTextTemplates.
  ///
  /// In en, this message translates to:
  /// **'Text Templates'**
  String get cacheTypeTextTemplates;

  /// No description provided for @cacheTypeTextTemplatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Saved text templates and content'**
  String get cacheTypeTextTemplatesDesc;

  /// No description provided for @cacheTypeAppSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get cacheTypeAppSettings;

  /// No description provided for @cacheTypeAppSettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Theme, language, and user preferences'**
  String get cacheTypeAppSettingsDesc;

  /// No description provided for @cacheTypeRandomGenerators.
  ///
  /// In en, this message translates to:
  /// **'Random Generators'**
  String get cacheTypeRandomGenerators;

  /// No description provided for @cacheTypeRandomGeneratorsDesc.
  ///
  /// In en, this message translates to:
  /// **'Generation history and settings'**
  String get cacheTypeRandomGeneratorsDesc;

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
  /// **'Your BMI calculation history will appear here'**
  String get noHistoryMessage;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @calculationHistory.
  ///
  /// In en, this message translates to:
  /// **'Calculation History'**
  String get calculationHistory;

  /// No description provided for @noCalculationHistory.
  ///
  /// In en, this message translates to:
  /// **'No calculation history yet'**
  String get noCalculationHistory;

  /// No description provided for @saveCalculationHistory.
  ///
  /// In en, this message translates to:
  /// **'Save Calculation History'**
  String get saveCalculationHistory;

  /// No description provided for @saveCalculationHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Remember and display history of calculations'**
  String get saveCalculationHistoryDesc;

  /// No description provided for @typeConfirmToProceed.
  ///
  /// In en, this message translates to:
  /// **'Type \"confirm\" to proceed:'**
  String get typeConfirmToProceed;

  /// No description provided for @toolsShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Tools & Shortcuts'**
  String get toolsShortcuts;

  /// No description provided for @displayArrangeTools.
  ///
  /// In en, this message translates to:
  /// **'Display and arrange tools'**
  String get displayArrangeTools;

  /// No description provided for @displayArrangeToolsDesc.
  ///
  /// In en, this message translates to:
  /// **'Control which tools are visible and their order'**
  String get displayArrangeToolsDesc;

  /// No description provided for @manageToolVisibility.
  ///
  /// In en, this message translates to:
  /// **'Manage Tool Visibility and Order'**
  String get manageToolVisibility;

  /// No description provided for @dragToReorder.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder tools'**
  String get dragToReorder;

  /// No description provided for @allToolsHidden.
  ///
  /// In en, this message translates to:
  /// **'All tools are hidden'**
  String get allToolsHidden;

  /// No description provided for @allToolsHiddenDesc.
  ///
  /// In en, this message translates to:
  /// **'Please enable at least one tool to continue using the application'**
  String get allToolsHiddenDesc;

  /// No description provided for @enableAtLeastOneTool.
  ///
  /// In en, this message translates to:
  /// **'Please enable at least one tool.'**
  String get enableAtLeastOneTool;

  /// No description provided for @toolVisibilityChanged.
  ///
  /// In en, this message translates to:
  /// **'Tool visibility and order have been updated.'**
  String get toolVisibilityChanged;

  /// No description provided for @errorMinOneTool.
  ///
  /// In en, this message translates to:
  /// **'At least one tool must be visible.'**
  String get errorMinOneTool;

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get resetToDefault;

  /// No description provided for @manageQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Manage Quick Actions'**
  String get manageQuickActions;

  /// No description provided for @manageQuickActionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Configure shortcuts for quick access to tools'**
  String get manageQuickActionsDesc;

  /// No description provided for @quickActionsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActionsDialogTitle;

  /// No description provided for @quickActionsDialogDesc.
  ///
  /// In en, this message translates to:
  /// **'Select up to 4 tools for quick access via app icon or taskbar'**
  String get quickActionsDialogDesc;

  /// No description provided for @quickActionsLimit.
  ///
  /// In en, this message translates to:
  /// **'Maximum 4 quick actions allowed'**
  String get quickActionsLimit;

  /// No description provided for @quickActionsLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You can only select up to 4 tools for quick actions'**
  String get quickActionsLimitReached;

  /// No description provided for @clearAllQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAllQuickActions;

  /// No description provided for @quickActionsCleared.
  ///
  /// In en, this message translates to:
  /// **'Quick actions cleared'**
  String get quickActionsCleared;

  /// No description provided for @quickActionsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Quick actions updated'**
  String get quickActionsUpdated;

  /// No description provided for @quickActionsInfo.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActionsInfo;

  /// No description provided for @selectUpTo4Tools.
  ///
  /// In en, this message translates to:
  /// **'Select up to 4 tools for quick access.'**
  String get selectUpTo4Tools;

  /// No description provided for @quickActionsEnableDesc.
  ///
  /// In en, this message translates to:
  /// **'Quick actions will appear when you long-press the app icon on Android or right-click the taskbar icon on Windows.'**
  String get quickActionsEnableDesc;

  /// No description provided for @quickActionsEnableDescMobile.
  ///
  /// In en, this message translates to:
  /// **'Quick actions will appear when you long-press the app icon (Android/iOS only).'**
  String get quickActionsEnableDescMobile;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'Selected: {current} of {max}'**
  String selectedCount(int current, int max);

  /// No description provided for @maxQuickActionsReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum 4 quick actions reached'**
  String get maxQuickActionsReached;

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

  /// No description provided for @lengthConverter.
  ///
  /// In en, this message translates to:
  /// **'Length Converter'**
  String get lengthConverter;

  /// No description provided for @temperatureConverter.
  ///
  /// In en, this message translates to:
  /// **'Temperature Converter'**
  String get temperatureConverter;

  /// No description provided for @volumeConverter.
  ///
  /// In en, this message translates to:
  /// **'Volume Converter'**
  String get volumeConverter;

  /// Title for area converter tool
  ///
  /// In en, this message translates to:
  /// **'Area Converter'**
  String get areaConverter;

  /// No description provided for @speedConverter.
  ///
  /// In en, this message translates to:
  /// **'Speed Converter'**
  String get speedConverter;

  /// No description provided for @timeConverter.
  ///
  /// In en, this message translates to:
  /// **'Time Converter'**
  String get timeConverter;

  /// No description provided for @dataConverter.
  ///
  /// In en, this message translates to:
  /// **'Data Storage Converter'**
  String get dataConverter;

  /// No description provided for @numberSystemConverter.
  ///
  /// In en, this message translates to:
  /// **'Number System Converter'**
  String get numberSystemConverter;

  /// No description provided for @tables.
  ///
  /// In en, this message translates to:
  /// **'Tables'**
  String get tables;

  /// No description provided for @tableView.
  ///
  /// In en, this message translates to:
  /// **'Table View'**
  String get tableView;

  /// No description provided for @listView.
  ///
  /// In en, this message translates to:
  /// **'List View'**
  String get listView;

  /// No description provided for @customizeUnits.
  ///
  /// In en, this message translates to:
  /// **'Customize Units'**
  String get customizeUnits;

  /// No description provided for @visibleUnits.
  ///
  /// In en, this message translates to:
  /// **'Visible Units'**
  String get visibleUnits;

  /// No description provided for @selectUnitsToShow.
  ///
  /// In en, this message translates to:
  /// **'Select units to display'**
  String get selectUnitsToShow;

  /// No description provided for @enterValue.
  ///
  /// In en, this message translates to:
  /// **'Enter value'**
  String get enterValue;

  /// No description provided for @conversionResults.
  ///
  /// In en, this message translates to:
  /// **'Conversion Results'**
  String get conversionResults;

  /// No description provided for @meters.
  ///
  /// In en, this message translates to:
  /// **'Meters'**
  String get meters;

  /// No description provided for @kilometers.
  ///
  /// In en, this message translates to:
  /// **'Kilometers'**
  String get kilometers;

  /// No description provided for @centimeters.
  ///
  /// In en, this message translates to:
  /// **'Centimeters'**
  String get centimeters;

  /// No description provided for @millimeters.
  ///
  /// In en, this message translates to:
  /// **'Millimeters'**
  String get millimeters;

  /// No description provided for @inches.
  ///
  /// In en, this message translates to:
  /// **'Inches'**
  String get inches;

  /// No description provided for @feet.
  ///
  /// In en, this message translates to:
  /// **'Feet'**
  String get feet;

  /// No description provided for @yards.
  ///
  /// In en, this message translates to:
  /// **'Yards'**
  String get yards;

  /// No description provided for @miles.
  ///
  /// In en, this message translates to:
  /// **'Miles'**
  String get miles;

  /// No description provided for @grams.
  ///
  /// In en, this message translates to:
  /// **'Grams'**
  String get grams;

  /// No description provided for @kilograms.
  ///
  /// In en, this message translates to:
  /// **'Kilograms'**
  String get kilograms;

  /// No description provided for @pounds.
  ///
  /// In en, this message translates to:
  /// **'Pounds'**
  String get pounds;

  /// No description provided for @ounces.
  ///
  /// In en, this message translates to:
  /// **'Ounces'**
  String get ounces;

  /// No description provided for @tons.
  ///
  /// In en, this message translates to:
  /// **'Tons'**
  String get tons;

  /// No description provided for @celsius.
  ///
  /// In en, this message translates to:
  /// **'Celsius'**
  String get celsius;

  /// No description provided for @fahrenheit.
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit'**
  String get fahrenheit;

  /// No description provided for @kelvin.
  ///
  /// In en, this message translates to:
  /// **'Kelvin'**
  String get kelvin;

  /// No description provided for @liters.
  ///
  /// In en, this message translates to:
  /// **'Liters'**
  String get liters;

  /// No description provided for @milliliters.
  ///
  /// In en, this message translates to:
  /// **'Milliliters'**
  String get milliliters;

  /// No description provided for @gallons.
  ///
  /// In en, this message translates to:
  /// **'Gallons'**
  String get gallons;

  /// No description provided for @quarts.
  ///
  /// In en, this message translates to:
  /// **'Quarts'**
  String get quarts;

  /// No description provided for @pints.
  ///
  /// In en, this message translates to:
  /// **'Pints'**
  String get pints;

  /// No description provided for @cups.
  ///
  /// In en, this message translates to:
  /// **'Cups'**
  String get cups;

  /// No description provided for @squareMeters.
  ///
  /// In en, this message translates to:
  /// **'Square Meters'**
  String get squareMeters;

  /// No description provided for @squareKilometers.
  ///
  /// In en, this message translates to:
  /// **'Square Kilometers'**
  String get squareKilometers;

  /// No description provided for @squareFeet.
  ///
  /// In en, this message translates to:
  /// **'Square Feet'**
  String get squareFeet;

  /// No description provided for @squareInches.
  ///
  /// In en, this message translates to:
  /// **'Square Inches'**
  String get squareInches;

  /// No description provided for @acres.
  ///
  /// In en, this message translates to:
  /// **'Acres'**
  String get acres;

  /// No description provided for @hectares.
  ///
  /// In en, this message translates to:
  /// **'Hectares'**
  String get hectares;

  /// No description provided for @metersPerSecond.
  ///
  /// In en, this message translates to:
  /// **'Meters per Second'**
  String get metersPerSecond;

  /// No description provided for @kilometersPerHour.
  ///
  /// In en, this message translates to:
  /// **'Kilometers per Hour'**
  String get kilometersPerHour;

  /// No description provided for @milesPerHour.
  ///
  /// In en, this message translates to:
  /// **'Miles per Hour'**
  String get milesPerHour;

  /// No description provided for @knots.
  ///
  /// In en, this message translates to:
  /// **'Knots'**
  String get knots;

  /// No description provided for @bytes.
  ///
  /// In en, this message translates to:
  /// **'Bytes'**
  String get bytes;

  /// No description provided for @kilobytes.
  ///
  /// In en, this message translates to:
  /// **'Kilobytes'**
  String get kilobytes;

  /// No description provided for @megabytes.
  ///
  /// In en, this message translates to:
  /// **'Megabytes'**
  String get megabytes;

  /// No description provided for @gigabytes.
  ///
  /// In en, this message translates to:
  /// **'Gigabytes'**
  String get gigabytes;

  /// No description provided for @terabytes.
  ///
  /// In en, this message translates to:
  /// **'Terabytes'**
  String get terabytes;

  /// No description provided for @bits.
  ///
  /// In en, this message translates to:
  /// **'Bits'**
  String get bits;

  /// No description provided for @decimal.
  ///
  /// In en, this message translates to:
  /// **'Decimal (Base 10)'**
  String get decimal;

  /// No description provided for @binary.
  ///
  /// In en, this message translates to:
  /// **'Binary (Base 2)'**
  String get binary;

  /// No description provided for @octal.
  ///
  /// In en, this message translates to:
  /// **'Octal (Base 8)'**
  String get octal;

  /// No description provided for @hexadecimal.
  ///
  /// In en, this message translates to:
  /// **'Hexadecimal (Base 16)'**
  String get hexadecimal;

  /// No description provided for @usd.
  ///
  /// In en, this message translates to:
  /// **'US Dollar'**
  String get usd;

  /// No description provided for @eur.
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get eur;

  /// No description provided for @gbp.
  ///
  /// In en, this message translates to:
  /// **'British Pound'**
  String get gbp;

  /// No description provided for @jpy.
  ///
  /// In en, this message translates to:
  /// **'Japanese Yen'**
  String get jpy;

  /// No description provided for @cad.
  ///
  /// In en, this message translates to:
  /// **'Canadian Dollar'**
  String get cad;

  /// No description provided for @aud.
  ///
  /// In en, this message translates to:
  /// **'Australian Dollar'**
  String get aud;

  /// No description provided for @vnd.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese Dong'**
  String get vnd;

  /// No description provided for @currencyConverterDesc.
  ///
  /// In en, this message translates to:
  /// **'Convert between different currencies with live exchange rates'**
  String get currencyConverterDesc;

  /// No description provided for @lengthConverterDesc.
  ///
  /// In en, this message translates to:
  /// **'Convert between different units of length'**
  String get lengthConverterDesc;

  /// Description for weight converter tool
  ///
  /// In en, this message translates to:
  /// **'Convert between force/weight units (N, kgf, lbf)'**
  String get weightConverterDesc;

  /// No description provided for @temperatureConverterDesc.
  ///
  /// In en, this message translates to:
  /// **'Convert between different temperature scales'**
  String get temperatureConverterDesc;

  /// No description provided for @volumeConverterDesc.
  ///
  /// In en, this message translates to:
  /// **'Convert between different units of volume'**
  String get volumeConverterDesc;

  /// Description for area converter tool
  ///
  /// In en, this message translates to:
  /// **'Convert between area units (m², km², ha, acres, ft²)'**
  String get areaConverterDesc;

  /// No description provided for @speedConverterDesc.
  ///
  /// In en, this message translates to:
  /// **'Convert between different units of speed'**
  String get speedConverterDesc;

  /// No description provided for @timeConverterDesc.
  ///
  /// In en, this message translates to:
  /// **'Convert between different units of time'**
  String get timeConverterDesc;

  /// No description provided for @dataConverterDesc.
  ///
  /// In en, this message translates to:
  /// **'Convert between different units of data storage'**
  String get dataConverterDesc;

  /// No description provided for @numberSystemConverterDesc.
  ///
  /// In en, this message translates to:
  /// **'Convert between number systems (binary, decimal, hexadecimal, etc.)'**
  String get numberSystemConverterDesc;

  /// No description provided for @fromUnit.
  ///
  /// In en, this message translates to:
  /// **'From Unit'**
  String get fromUnit;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get showAll;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @bmiCalculator.
  ///
  /// In en, this message translates to:
  /// **'BMI Calculator'**
  String get bmiCalculator;

  /// No description provided for @bmiCalculatorDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate Body Mass Index and health category'**
  String get bmiCalculatorDesc;

  /// No description provided for @scientificCalculator.
  ///
  /// In en, this message translates to:
  /// **'Scientific Calculator'**
  String get scientificCalculator;

  /// No description provided for @scientificCalculatorDesc.
  ///
  /// In en, this message translates to:
  /// **'Advanced calculator with trigonometric, logarithmic functions'**
  String get scientificCalculatorDesc;

  /// No description provided for @graphingCalculator.
  ///
  /// In en, this message translates to:
  /// **'Graphing Calculator'**
  String get graphingCalculator;

  /// No description provided for @graphingCalculatorDesc.
  ///
  /// In en, this message translates to:
  /// **'Plot and visualize mathematical functions'**
  String get graphingCalculatorDesc;

  /// No description provided for @graphingCalculatorDetailedInfo.
  ///
  /// In en, this message translates to:
  /// **'Graphing Calculator Information'**
  String get graphingCalculatorDetailedInfo;

  /// No description provided for @graphingCalculatorOverview.
  ///
  /// In en, this message translates to:
  /// **'Advanced mathematical function plotting and visualization tool'**
  String get graphingCalculatorOverview;

  /// No description provided for @graphingKeyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get graphingKeyFeatures;

  /// No description provided for @realTimePlotting.
  ///
  /// In en, this message translates to:
  /// **'Real-time Plotting'**
  String get realTimePlotting;

  /// No description provided for @realTimePlottingDesc.
  ///
  /// In en, this message translates to:
  /// **'Instantly visualize functions as you type with smooth curve rendering'**
  String get realTimePlottingDesc;

  /// No description provided for @multipleFunction.
  ///
  /// In en, this message translates to:
  /// **'Multiple Functions'**
  String get multipleFunction;

  /// No description provided for @multipleFunctionDesc.
  ///
  /// In en, this message translates to:
  /// **'Plot and compare multiple functions simultaneously with color coding'**
  String get multipleFunctionDesc;

  /// No description provided for @interactiveControls.
  ///
  /// In en, this message translates to:
  /// **'Interactive Controls'**
  String get interactiveControls;

  /// No description provided for @interactiveControlsDesc.
  ///
  /// In en, this message translates to:
  /// **'Zoom, pan, and navigate the graph with intuitive touch and mouse controls'**
  String get interactiveControlsDesc;

  /// No description provided for @aspectRatioControl.
  ///
  /// In en, this message translates to:
  /// **'Aspect Ratio Control'**
  String get aspectRatioControl;

  /// No description provided for @aspectRatioControlDesc.
  ///
  /// In en, this message translates to:
  /// **'Customize X:Y axis scaling for optimal function visualization'**
  String get aspectRatioControlDesc;

  /// No description provided for @functionHistory.
  ///
  /// In en, this message translates to:
  /// **'Function History'**
  String get functionHistory;

  /// No description provided for @functionHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Save and load function groups with automatic state preservation'**
  String get functionHistoryDesc;

  /// No description provided for @mathExpressionSupport.
  ///
  /// In en, this message translates to:
  /// **'Advanced Math Support'**
  String get mathExpressionSupport;

  /// No description provided for @mathExpressionSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'Supports trigonometric, logarithmic, and polynomial functions'**
  String get mathExpressionSupportDesc;

  /// No description provided for @graphingHowToUse.
  ///
  /// In en, this message translates to:
  /// **'How to Use'**
  String get graphingHowToUse;

  /// No description provided for @step1Graph.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Enter Function'**
  String get step1Graph;

  /// No description provided for @step1GraphDesc.
  ///
  /// In en, this message translates to:
  /// **'Type a mathematical function in the input field (e.g., x^2, sin(x), log(x))'**
  String get step1GraphDesc;

  /// No description provided for @step2Graph.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Plot Function'**
  String get step2Graph;

  /// No description provided for @step2GraphDesc.
  ///
  /// In en, this message translates to:
  /// **'Press Enter or tap the add button to plot the function on the graph'**
  String get step2GraphDesc;

  /// No description provided for @step3Graph.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Navigate Graph'**
  String get step3Graph;

  /// No description provided for @step3GraphDesc.
  ///
  /// In en, this message translates to:
  /// **'Use zoom controls, pan gestures, or adjust aspect ratio for better viewing'**
  String get step3GraphDesc;

  /// No description provided for @step4Graph.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Add More Functions'**
  String get step4Graph;

  /// No description provided for @step4GraphDesc.
  ///
  /// In en, this message translates to:
  /// **'Add multiple functions to compare and analyze their behaviors'**
  String get step4GraphDesc;

  /// No description provided for @graphingTips.
  ///
  /// In en, this message translates to:
  /// **'Pro Tips'**
  String get graphingTips;

  /// No description provided for @tip1Graph.
  ///
  /// In en, this message translates to:
  /// **'Use parentheses for complex expressions: sin(x^2) instead of sin x^2'**
  String get tip1Graph;

  /// No description provided for @tip2Graph.
  ///
  /// In en, this message translates to:
  /// **'Common functions: sin(x), cos(x), tan(x), log(x), sqrt(x), abs(x)'**
  String get tip2Graph;

  /// No description provided for @tip3Graph.
  ///
  /// In en, this message translates to:
  /// **'Use π and e constants: sin(π*x), e^x'**
  String get tip3Graph;

  /// No description provided for @tip4Graph.
  ///
  /// In en, this message translates to:
  /// **'Pan by dragging the graph area with mouse or touch'**
  String get tip4Graph;

  /// No description provided for @tip5Graph.
  ///
  /// In en, this message translates to:
  /// **'Save function groups to history for quick access later'**
  String get tip5Graph;

  /// No description provided for @tip6Graph.
  ///
  /// In en, this message translates to:
  /// **'Toggle function visibility using the eye icon without removing them'**
  String get tip6Graph;

  /// No description provided for @tip7Graph.
  ///
  /// In en, this message translates to:
  /// **'Use aspect ratio controls for specialized viewing (1:1 for circles, 5:1 for oscillations)'**
  String get tip7Graph;

  /// No description provided for @supportedFunctions.
  ///
  /// In en, this message translates to:
  /// **'Supported Functions'**
  String get supportedFunctions;

  /// No description provided for @basicOperations.
  ///
  /// In en, this message translates to:
  /// **'Basic Operations'**
  String get basicOperations;

  /// No description provided for @basicOperationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Addition (+), Subtraction (-), Multiplication (*), Division (/), Power (^)'**
  String get basicOperationsDesc;

  /// No description provided for @trigonometricFunctions.
  ///
  /// In en, this message translates to:
  /// **'Trigonometric Functions'**
  String get trigonometricFunctions;

  /// No description provided for @trigonometricFunctionsDesc.
  ///
  /// In en, this message translates to:
  /// **'sin(x), cos(x), tan(x) and their inverse functions'**
  String get trigonometricFunctionsDesc;

  /// No description provided for @logarithmicFunctions.
  ///
  /// In en, this message translates to:
  /// **'Logarithmic Functions'**
  String get logarithmicFunctions;

  /// No description provided for @logarithmicFunctionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Natural logarithm log(x), exponential e^x'**
  String get logarithmicFunctionsDesc;

  /// No description provided for @otherFunctions.
  ///
  /// In en, this message translates to:
  /// **'Other Functions'**
  String get otherFunctions;

  /// No description provided for @otherFunctionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Square root sqrt(x), absolute value abs(x), polynomial functions'**
  String get otherFunctionsDesc;

  /// No description provided for @navigationControls.
  ///
  /// In en, this message translates to:
  /// **'Navigation Controls'**
  String get navigationControls;

  /// No description provided for @zoomControls.
  ///
  /// In en, this message translates to:
  /// **'Zoom Controls'**
  String get zoomControls;

  /// No description provided for @zoomControlsDesc.
  ///
  /// In en, this message translates to:
  /// **'Use + and - buttons or pinch gestures to zoom in and out'**
  String get zoomControlsDesc;

  /// No description provided for @panControls.
  ///
  /// In en, this message translates to:
  /// **'Pan Controls'**
  String get panControls;

  /// No description provided for @panControlsDesc.
  ///
  /// In en, this message translates to:
  /// **'Drag the graph to move around and explore different areas'**
  String get panControlsDesc;

  /// No description provided for @resetControls.
  ///
  /// In en, this message translates to:
  /// **'Reset Controls'**
  String get resetControls;

  /// No description provided for @resetControlsDesc.
  ///
  /// In en, this message translates to:
  /// **'Return to center or reset the entire plot to default state'**
  String get resetControlsDesc;

  /// No description provided for @aspectRatioDialog.
  ///
  /// In en, this message translates to:
  /// **'Aspect Ratio'**
  String get aspectRatioDialog;

  /// No description provided for @aspectRatioDialogDesc.
  ///
  /// In en, this message translates to:
  /// **'Adjust X:Y axis scaling from 0.1:1 to 10:1 for optimal viewing'**
  String get aspectRatioDialogDesc;

  /// No description provided for @graphingPracticalApplications.
  ///
  /// In en, this message translates to:
  /// **'Practical Applications'**
  String get graphingPracticalApplications;

  /// No description provided for @graphingPracticalApplicationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Useful for students learning algebra and calculus, visualizing function behavior, and exploring mathematical concepts through interactive graphs.'**
  String get graphingPracticalApplicationsDesc;

  /// No description provided for @scientificCalculatorDetailedInfo.
  ///
  /// In en, this message translates to:
  /// **'Scientific Calculator Information'**
  String get scientificCalculatorDetailedInfo;

  /// No description provided for @scientificCalculatorOverview.
  ///
  /// In en, this message translates to:
  /// **'Advanced scientific calculator with comprehensive mathematical functions'**
  String get scientificCalculatorOverview;

  /// No description provided for @scientificKeyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get scientificKeyFeatures;

  /// No description provided for @realTimeCalculation.
  ///
  /// In en, this message translates to:
  /// **'Real-time Calculation'**
  String get realTimeCalculation;

  /// No description provided for @realTimeCalculationDesc.
  ///
  /// In en, this message translates to:
  /// **'See instant preview results as you type expressions'**
  String get realTimeCalculationDesc;

  /// No description provided for @comprehensiveFunctions.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive Functions'**
  String get comprehensiveFunctions;

  /// No description provided for @comprehensiveFunctionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete set of trigonometric, logarithmic, and algebraic functions'**
  String get comprehensiveFunctionsDesc;

  /// No description provided for @dualAngleModes.
  ///
  /// In en, this message translates to:
  /// **'Dual Angle Modes'**
  String get dualAngleModes;

  /// No description provided for @dualAngleModesDesc.
  ///
  /// In en, this message translates to:
  /// **'Switch between radians and degrees for trigonometric calculations'**
  String get dualAngleModesDesc;

  /// No description provided for @secondaryFunctions.
  ///
  /// In en, this message translates to:
  /// **'Secondary Functions'**
  String get secondaryFunctions;

  /// No description provided for @secondaryFunctionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Access extended functions with the 2nd button toggle'**
  String get secondaryFunctionsDesc;

  /// No description provided for @calculationHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Track your BMI calculations over time with detailed history'**
  String get calculationHistoryDesc;

  /// No description provided for @memoryOperations.
  ///
  /// In en, this message translates to:
  /// **'Memory Operations'**
  String get memoryOperations;

  /// No description provided for @memoryOperationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Store and recall values with memory management functions'**
  String get memoryOperationsDesc;

  /// No description provided for @scientificHowToUse.
  ///
  /// In en, this message translates to:
  /// **'How to Use'**
  String get scientificHowToUse;

  /// No description provided for @step1Scientific.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Enter Expression'**
  String get step1Scientific;

  /// No description provided for @step1ScientificDesc.
  ///
  /// In en, this message translates to:
  /// **'Type numbers and use function buttons to build mathematical expressions'**
  String get step1ScientificDesc;

  /// No description provided for @step2Scientific.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Use Functions'**
  String get step2Scientific;

  /// No description provided for @step2ScientificDesc.
  ///
  /// In en, this message translates to:
  /// **'Access trigonometric, logarithmic, and algebraic functions from the keypad'**
  String get step2ScientificDesc;

  /// No description provided for @step3Scientific.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Toggle Modes'**
  String get step3Scientific;

  /// No description provided for @step3ScientificDesc.
  ///
  /// In en, this message translates to:
  /// **'Switch between radians/degrees and primary/secondary functions as needed'**
  String get step3ScientificDesc;

  /// Step 4 for using scientific calculator
  ///
  /// In en, this message translates to:
  /// **'Step 4: Use History - View and reuse previous calculations'**
  String get step4Scientific;

  /// No description provided for @step4ScientificDesc.
  ///
  /// In en, this message translates to:
  /// **'Press = to calculate or see real-time preview while typing'**
  String get step4ScientificDesc;

  /// No description provided for @scientificTips.
  ///
  /// In en, this message translates to:
  /// **'Pro Tips'**
  String get scientificTips;

  /// Tip 1 for scientific calculator
  ///
  /// In en, this message translates to:
  /// **'Use parentheses to ensure correct order of operations: (2+3)×4 = 20'**
  String get tip1Scientific;

  /// Tip 2 for scientific calculator
  ///
  /// In en, this message translates to:
  /// **'Switch to DEG mode for degree calculations, RAD for radians'**
  String get tip2Scientific;

  /// Tip 3 for scientific calculator
  ///
  /// In en, this message translates to:
  /// **'Use the 2nd button to access inverse functions: sin⁻¹, cos⁻¹, log⁻¹'**
  String get tip3Scientific;

  /// Tip 4 for scientific calculator
  ///
  /// In en, this message translates to:
  /// **'Use memory functions (MS, MR, M+, M-) to store intermediate results'**
  String get tip4Scientific;

  /// Tip 5 for scientific calculator
  ///
  /// In en, this message translates to:
  /// **'Double-tap numbers to select and copy results'**
  String get tip5Scientific;

  /// Tip 6 for scientific calculator
  ///
  /// In en, this message translates to:
  /// **'Use EXP for scientific notation: 1.23E+5 = 123,000'**
  String get tip6Scientific;

  /// Tip 7 for scientific calculator
  ///
  /// In en, this message translates to:
  /// **'Clear individual entries with C, or clear all with AC'**
  String get tip7Scientific;

  /// Basic arithmetic operations section
  ///
  /// In en, this message translates to:
  /// **'Basic Arithmetic'**
  String get basicArithmetic;

  /// Trigonometric functions section for scientific calculator
  ///
  /// In en, this message translates to:
  /// **'Trigonometric Functions'**
  String get trigonometricFunctionsScientific;

  /// Logarithmic functions section for scientific calculator
  ///
  /// In en, this message translates to:
  /// **'Logarithmic Functions'**
  String get logarithmicFunctionsScientific;

  /// Algebraic functions section
  ///
  /// In en, this message translates to:
  /// **'Algebraic Functions'**
  String get algebraicFunctions;

  /// No description provided for @scientificFunctionCategories.
  ///
  /// In en, this message translates to:
  /// **'Function Categories'**
  String get scientificFunctionCategories;

  /// No description provided for @basicArithmeticDesc.
  ///
  /// In en, this message translates to:
  /// **'Addition (+), Subtraction (-), Multiplication (*), Division (/)'**
  String get basicArithmeticDesc;

  /// No description provided for @trigonometricFunctionsScientificDesc.
  ///
  /// In en, this message translates to:
  /// **'sin, cos, tan and their inverse functions (asin, acos, atan)'**
  String get trigonometricFunctionsScientificDesc;

  /// No description provided for @logarithmicFunctionsScientificDesc.
  ///
  /// In en, this message translates to:
  /// **'Natural log (ln), common log (log), exponential (exp, eˣ, 10ˣ)'**
  String get logarithmicFunctionsScientificDesc;

  /// No description provided for @algebraicFunctionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Powers (x², x³, xʸ), roots (√, ∛), factorial (n!), absolute value (|x|)'**
  String get algebraicFunctionsDesc;

  /// Angle mode control
  ///
  /// In en, this message translates to:
  /// **'Angle Mode'**
  String get angleMode;

  /// Function toggle control
  ///
  /// In en, this message translates to:
  /// **'Function Toggle'**
  String get functionToggle;

  /// Memory functions control
  ///
  /// In en, this message translates to:
  /// **'Memory Functions'**
  String get memoryFunctions;

  /// History access control
  ///
  /// In en, this message translates to:
  /// **'History Access'**
  String get historyAccess;

  /// Practical applications section for scientific calculator
  ///
  /// In en, this message translates to:
  /// **'Practical Applications'**
  String get scientificCalculatorPracticalApplications;

  /// Practical applications description for scientific calculator
  ///
  /// In en, this message translates to:
  /// **'Helpful for students in mathematics and science courses, basic engineering calculations, and everyday problem-solving involving complex mathematical operations.'**
  String get scientificCalculatorPracticalApplicationsDesc;

  /// Cache info with log size
  ///
  /// In en, this message translates to:
  /// **'Cache: {cacheSize} (+{logSize} log)'**
  String cacheWithLogSize(String cacheSize, String logSize);

  /// No description provided for @scientificModeControls.
  ///
  /// In en, this message translates to:
  /// **'Mode Controls'**
  String get scientificModeControls;

  /// No description provided for @angleModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Toggle between Radians and Degrees for trigonometric calculations'**
  String get angleModeDesc;

  /// No description provided for @functionToggleDesc.
  ///
  /// In en, this message translates to:
  /// **'Press 2nd to switch between primary and secondary function sets'**
  String get functionToggleDesc;

  /// No description provided for @memoryFunctionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Store, recall, and manage values in calculator memory'**
  String get memoryFunctionsDesc;

  /// No description provided for @historyAccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Browse previous calculations and reuse expressions'**
  String get historyAccessDesc;

  /// No description provided for @scientificPracticalApplications.
  ///
  /// In en, this message translates to:
  /// **'Practical Applications'**
  String get scientificPracticalApplications;

  /// No description provided for @scientificPracticalApplicationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Helpful for students in mathematics and science courses, performing calculations that require trigonometric, logarithmic, and algebraic functions.'**
  String get scientificPracticalApplicationsDesc;

  /// No description provided for @metric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get metric;

  /// No description provided for @imperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get imperial;

  /// No description provided for @enterMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Enter your measurements'**
  String get enterMeasurements;

  /// No description provided for @heightCm.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightCm;

  /// No description provided for @heightInches.
  ///
  /// In en, this message translates to:
  /// **'Height (inches)'**
  String get heightInches;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @weightPounds.
  ///
  /// In en, this message translates to:
  /// **'Weight (pounds)'**
  String get weightPounds;

  /// No description provided for @yourBMI.
  ///
  /// In en, this message translates to:
  /// **'Your BMI'**
  String get yourBMI;

  /// No description provided for @bmiScale.
  ///
  /// In en, this message translates to:
  /// **'BMI Scale'**
  String get bmiScale;

  /// No description provided for @underweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get underweight;

  /// No description provided for @normalWeight.
  ///
  /// In en, this message translates to:
  /// **'Normal Weight'**
  String get normalWeight;

  /// No description provided for @overweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get overweight;

  /// No description provided for @overweightI.
  ///
  /// In en, this message translates to:
  /// **'Overweight I'**
  String get overweightI;

  /// No description provided for @overweightII.
  ///
  /// In en, this message translates to:
  /// **'Overweight II'**
  String get overweightII;

  /// No description provided for @obese.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get obese;

  /// No description provided for @obeseI.
  ///
  /// In en, this message translates to:
  /// **'Obese I'**
  String get obeseI;

  /// No description provided for @obeseII.
  ///
  /// In en, this message translates to:
  /// **'Obese II'**
  String get obeseII;

  /// No description provided for @obeseIII.
  ///
  /// In en, this message translates to:
  /// **'Obese III'**
  String get obeseIII;

  /// No description provided for @bmiPercentileOverweight.
  ///
  /// In en, this message translates to:
  /// **'85th to 95th percentile'**
  String get bmiPercentileOverweight;

  /// No description provided for @bmiPercentileOverweightI.
  ///
  /// In en, this message translates to:
  /// **'85th - 95th percentile'**
  String get bmiPercentileOverweightI;

  /// No description provided for @bmiPercentileObese.
  ///
  /// In en, this message translates to:
  /// **'Above 95th percentile'**
  String get bmiPercentileObese;

  /// No description provided for @bmiPercentileObeseI.
  ///
  /// In en, this message translates to:
  /// **'≥ 95th percentile'**
  String get bmiPercentileObeseI;

  /// No description provided for @bmiNormalInterpretation.
  ///
  /// In en, this message translates to:
  /// **'Your BMI is within the normal weight range. This indicates a healthy weight for your height.'**
  String bmiNormalInterpretation(String bmi);

  /// No description provided for @bmiOverweightInterpretation.
  ///
  /// In en, this message translates to:
  /// **'Your BMI indicates that you are overweight. Consider lifestyle changes to achieve a healthier weight.'**
  String bmiOverweightInterpretation(String bmi);

  /// No description provided for @bmiObeseInterpretation.
  ///
  /// In en, this message translates to:
  /// **'Your BMI indicates obesity. It\'s important to consult with healthcare professionals for proper guidance.'**
  String bmiObeseInterpretation(String bmi);

  /// No description provided for @bmiUnderweightRec1.
  ///
  /// In en, this message translates to:
  /// **'Increase calorie intake with nutritious, high-calorie foods'**
  String get bmiUnderweightRec1;

  /// No description provided for @bmiUnderweightRec2.
  ///
  /// In en, this message translates to:
  /// **'Include healthy fats, proteins, and complex carbohydrates in your diet'**
  String get bmiUnderweightRec2;

  /// No description provided for @bmiUnderweightRec3.
  ///
  /// In en, this message translates to:
  /// **'Consult a healthcare provider to rule out underlying health issues'**
  String get bmiUnderweightRec3;

  /// No description provided for @bmiNormalRec1.
  ///
  /// In en, this message translates to:
  /// **'Maintain a balanced diet with variety of nutrients'**
  String get bmiNormalRec1;

  /// No description provided for @bmiNormalRec2.
  ///
  /// In en, this message translates to:
  /// **'Continue regular physical activity and exercise routine'**
  String get bmiNormalRec2;

  /// No description provided for @bmiNormalRec3.
  ///
  /// In en, this message translates to:
  /// **'Monitor your weight regularly to stay within healthy range'**
  String get bmiNormalRec3;

  /// No description provided for @bmiOverweightRec1.
  ///
  /// In en, this message translates to:
  /// **'Create a moderate calorie deficit through diet and exercise'**
  String get bmiOverweightRec1;

  /// No description provided for @bmiOverweightRec2.
  ///
  /// In en, this message translates to:
  /// **'Focus on portion control and choose nutrient-dense foods'**
  String get bmiOverweightRec2;

  /// No description provided for @bmiOverweightRec3.
  ///
  /// In en, this message translates to:
  /// **'Increase physical activity with both cardio and strength training'**
  String get bmiOverweightRec3;

  /// No description provided for @bmiObeseRec1.
  ///
  /// In en, this message translates to:
  /// **'Work with healthcare professionals to develop a safe weight loss plan'**
  String get bmiObeseRec1;

  /// No description provided for @bmiObeseRec2.
  ///
  /// In en, this message translates to:
  /// **'Consider comprehensive lifestyle changes including diet and exercise'**
  String get bmiObeseRec2;

  /// No description provided for @bmiObeseRec3.
  ///
  /// In en, this message translates to:
  /// **'Regular medical monitoring may be necessary for optimal health'**
  String get bmiObeseRec3;

  /// No description provided for @bmiUnderweightDesc.
  ///
  /// In en, this message translates to:
  /// **'May indicate malnutrition, eating disorders, or underlying health conditions'**
  String get bmiUnderweightDesc;

  /// No description provided for @bmiNormalDesc.
  ///
  /// In en, this message translates to:
  /// **'Associated with lowest risk of weight-related health problems'**
  String get bmiNormalDesc;

  /// No description provided for @bmiOverweightDesc.
  ///
  /// In en, this message translates to:
  /// **'Increased risk of cardiovascular disease, diabetes, and other health issues'**
  String get bmiOverweightDesc;

  /// No description provided for @bmiObeseDesc.
  ///
  /// In en, this message translates to:
  /// **'Significantly increased risk of serious health complications'**
  String get bmiObeseDesc;

  /// No description provided for @bmiKeyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get bmiKeyFeatures;

  /// No description provided for @comprehensiveBmiCalc.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive BMI Calculation'**
  String get comprehensiveBmiCalc;

  /// No description provided for @comprehensiveBmiCalcDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate BMI using height, weight, age, and gender for accurate results'**
  String get comprehensiveBmiCalcDesc;

  /// No description provided for @multipleUnitSystems.
  ///
  /// In en, this message translates to:
  /// **'Multiple Unit Systems'**
  String get multipleUnitSystems;

  /// No description provided for @multipleUnitSystemsDesc.
  ///
  /// In en, this message translates to:
  /// **'Support for both metric (cm/kg) and imperial (ft-in/lbs) measurements'**
  String get multipleUnitSystemsDesc;

  /// No description provided for @healthInsights.
  ///
  /// In en, this message translates to:
  /// **'Health Insights'**
  String get healthInsights;

  /// No description provided for @healthInsightsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get personalized recommendations based on your BMI category'**
  String get healthInsightsDesc;

  /// No description provided for @ageGenderConsideration.
  ///
  /// In en, this message translates to:
  /// **'Age & Gender Consideration'**
  String get ageGenderConsideration;

  /// No description provided for @ageGenderConsiderationDesc.
  ///
  /// In en, this message translates to:
  /// **'BMI interpretation adjusted for age and gender factors'**
  String get ageGenderConsiderationDesc;

  /// No description provided for @bmiHowToUse.
  ///
  /// In en, this message translates to:
  /// **'How to Use'**
  String get bmiHowToUse;

  /// No description provided for @step1Bmi.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Select Unit System'**
  String get step1Bmi;

  /// No description provided for @step1BmiDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose between metric (cm/kg) or imperial (ft-in/lbs) measurements'**
  String get step1BmiDesc;

  /// No description provided for @step2Bmi.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Enter Your Information'**
  String get step2Bmi;

  /// No description provided for @step2BmiDesc.
  ///
  /// In en, this message translates to:
  /// **'Input your height, weight, age, and gender for accurate calculation'**
  String get step2BmiDesc;

  /// No description provided for @step3Bmi.
  ///
  /// In en, this message translates to:
  /// **'Step 3: View Results'**
  String get step3Bmi;

  /// No description provided for @step3BmiDesc.
  ///
  /// In en, this message translates to:
  /// **'See your BMI value, category, and personalized health recommendations'**
  String get step3BmiDesc;

  /// No description provided for @step4Bmi.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Track Progress'**
  String get step4Bmi;

  /// No description provided for @step4BmiDesc.
  ///
  /// In en, this message translates to:
  /// **'Save calculations to history and monitor changes over time'**
  String get step4BmiDesc;

  /// No description provided for @bmiTips.
  ///
  /// In en, this message translates to:
  /// **'Health Tips'**
  String get bmiTips;

  /// No description provided for @tip1Bmi.
  ///
  /// In en, this message translates to:
  /// **'BMI is a screening tool - consult healthcare providers for complete health assessment'**
  String get tip1Bmi;

  /// No description provided for @tip2Bmi.
  ///
  /// In en, this message translates to:
  /// **'Regular monitoring helps track progress toward health goals'**
  String get tip2Bmi;

  /// No description provided for @tip3Bmi.
  ///
  /// In en, this message translates to:
  /// **'BMI may not accurately reflect body composition for athletes or elderly'**
  String get tip3Bmi;

  /// No description provided for @tip4Bmi.
  ///
  /// In en, this message translates to:
  /// **'Focus on healthy lifestyle changes rather than just the number'**
  String get tip4Bmi;

  /// No description provided for @tip5Bmi.
  ///
  /// In en, this message translates to:
  /// **'Combine BMI with other health indicators for better understanding'**
  String get tip5Bmi;

  /// No description provided for @bmiLimitations.
  ///
  /// In en, this message translates to:
  /// **'Understanding BMI Limitations'**
  String get bmiLimitations;

  /// No description provided for @bmiLimitationsDesc.
  ///
  /// In en, this message translates to:
  /// **'BMI is a useful screening tool but has limitations. It doesn\'t distinguish between muscle and fat mass, and may not be accurate for athletes, elderly, or certain ethnic groups. Always consult healthcare professionals for comprehensive health assessment.'**
  String get bmiLimitationsDesc;

  /// No description provided for @bmiPracticalApplications.
  ///
  /// In en, this message translates to:
  /// **'Practical Applications'**
  String get bmiPracticalApplications;

  /// No description provided for @bmiPracticalApplicationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Useful for health screening, weight management planning, fitness goal setting, and tracking health progress over time.'**
  String get bmiPracticalApplicationsDesc;

  /// No description provided for @clearBmiHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear BMI History'**
  String get clearBmiHistory;

  /// No description provided for @bmiResult.
  ///
  /// In en, this message translates to:
  /// **'BMI: {bmi}'**
  String bmiResult(String bmi);

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @measurements.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get measurements;

  /// No description provided for @bmiResults.
  ///
  /// In en, this message translates to:
  /// **'BMI Results'**
  String get bmiResults;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @autoSaveToHistory.
  ///
  /// In en, this message translates to:
  /// **'Auto-save to History'**
  String get autoSaveToHistory;

  /// No description provided for @autoSaveToHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically save calculations to history'**
  String get autoSaveToHistoryDesc;

  /// No description provided for @rememberLastValues.
  ///
  /// In en, this message translates to:
  /// **'Remember Last Values'**
  String get rememberLastValues;

  /// No description provided for @rememberLastValuesDesc.
  ///
  /// In en, this message translates to:
  /// **'Remember your last entered values'**
  String get rememberLastValuesDesc;

  /// No description provided for @currencyFetchMode.
  ///
  /// In en, this message translates to:
  /// **'Currency Rate Fetching'**
  String get currencyFetchMode;

  /// No description provided for @currencyFetchModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose how currency exchange rates are updated'**
  String get currencyFetchModeDesc;

  /// No description provided for @fetchModeManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get fetchModeManual;

  /// No description provided for @fetchModeManualDesc.
  ///
  /// In en, this message translates to:
  /// **'Only use cached rates, update manually by tapping refresh (limited to once every 6 hours)'**
  String get fetchModeManualDesc;

  /// No description provided for @fetchModeOnceADay.
  ///
  /// In en, this message translates to:
  /// **'Once a day'**
  String get fetchModeOnceADay;

  /// No description provided for @fetchModeOnceADayDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically fetch rates once per day'**
  String get fetchModeOnceADayDesc;

  /// No description provided for @currencyFetchStatus.
  ///
  /// In en, this message translates to:
  /// **'Currency Fetch Status'**
  String get currencyFetchStatus;

  /// No description provided for @fetchStatusSummary.
  ///
  /// In en, this message translates to:
  /// **'Fetch Status Summary'**
  String get fetchStatusSummary;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @timeout.
  ///
  /// In en, this message translates to:
  /// **'Timeout'**
  String get timeout;

  /// No description provided for @static.
  ///
  /// In en, this message translates to:
  /// **'Static'**
  String get static;

  /// No description provided for @noCurrenciesInThisCategory.
  ///
  /// In en, this message translates to:
  /// **'No currencies in this category'**
  String get noCurrenciesInThisCategory;

  /// No description provided for @saveFeatureState.
  ///
  /// In en, this message translates to:
  /// **'Save Feature State'**
  String get saveFeatureState;

  /// No description provided for @saveFeatureStateDesc.
  ///
  /// In en, this message translates to:
  /// **'Remember the state of features between app sessions'**
  String get saveFeatureStateDesc;

  /// No description provided for @testCache.
  ///
  /// In en, this message translates to:
  /// **'Test Cache'**
  String get testCache;

  /// No description provided for @viewDataStatus.
  ///
  /// In en, this message translates to:
  /// **'View Data Status'**
  String get viewDataStatus;

  /// No description provided for @retryAttempt.
  ///
  /// In en, this message translates to:
  /// **'Retry {current}/{max}'**
  String retryAttempt(int current, int max);

  /// No description provided for @ratesUpdatedWithErrors.
  ///
  /// In en, this message translates to:
  /// **'Rates updated with {errorCount} errors'**
  String ratesUpdatedWithErrors(int errorCount);

  /// No description provided for @newRatesAvailable.
  ///
  /// In en, this message translates to:
  /// **'New exchange rates are available. Would you like to fetch them now?'**
  String get newRatesAvailable;

  /// No description provided for @progressDialogInfo.
  ///
  /// In en, this message translates to:
  /// **'This will show a progress dialog while fetching rates.'**
  String get progressDialogInfo;

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

  /// No description provided for @noTimeData.
  ///
  /// In en, this message translates to:
  /// **'--:--:--'**
  String get noTimeData;

  /// No description provided for @fetchStatusTab.
  ///
  /// In en, this message translates to:
  /// **'Fetch Status'**
  String get fetchStatusTab;

  /// No description provided for @currencyValueTab.
  ///
  /// In en, this message translates to:
  /// **'Currency Value'**
  String get currencyValueTab;

  /// No description provided for @successfulCount.
  ///
  /// In en, this message translates to:
  /// **'Successful ({count})'**
  String successfulCount(int count);

  /// No description provided for @failedCount.
  ///
  /// In en, this message translates to:
  /// **'Failed ({count})'**
  String failedCount(int count);

  /// No description provided for @timeoutCount.
  ///
  /// In en, this message translates to:
  /// **'Timeout ({count})'**
  String timeoutCount(int count);

  /// No description provided for @recentlyUpdatedCount.
  ///
  /// In en, this message translates to:
  /// **'Recently Updated ({count})'**
  String recentlyUpdatedCount(int count);

  /// No description provided for @updatedCount.
  ///
  /// In en, this message translates to:
  /// **'Updated ({count})'**
  String updatedCount(int count);

  /// No description provided for @staticCount.
  ///
  /// In en, this message translates to:
  /// **'Static ({count})'**
  String staticCount(int count);

  /// No description provided for @noCurrenciesInCategory.
  ///
  /// In en, this message translates to:
  /// **'No currencies in this category'**
  String get noCurrenciesInCategory;

  /// No description provided for @updatedWithinLastHour.
  ///
  /// In en, this message translates to:
  /// **'Updated within the last hour'**
  String get updatedWithinLastHour;

  /// No description provided for @updatedDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Updated {days} days ago'**
  String updatedDaysAgo(int days);

  /// No description provided for @updatedHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'Updated {hours} hours ago'**
  String updatedHoursAgo(int hours);

  /// No description provided for @hasUpdateData.
  ///
  /// In en, this message translates to:
  /// **'Has update data'**
  String get hasUpdateData;

  /// No description provided for @usingStaticRates.
  ///
  /// In en, this message translates to:
  /// **'Using static rates'**
  String get usingStaticRates;

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

  /// No description provided for @cacheTypeCalculatorTools.
  ///
  /// In en, this message translates to:
  /// **'Calculator Tools'**
  String get cacheTypeCalculatorTools;

  /// No description provided for @cacheTypeCalculatorToolsDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculation history, graphing calculator data, BMI data, and settings'**
  String get cacheTypeCalculatorToolsDesc;

  /// No description provided for @cacheTypeConverterTools.
  ///
  /// In en, this message translates to:
  /// **'Converter Tools'**
  String get cacheTypeConverterTools;

  /// No description provided for @cacheTypeConverterToolsDesc.
  ///
  /// In en, this message translates to:
  /// **'Currency/length states, presets and exchange rates cache'**
  String get cacheTypeConverterToolsDesc;

  /// No description provided for @cardName.
  ///
  /// In en, this message translates to:
  /// **'Card Name'**
  String get cardName;

  /// No description provided for @cardNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter card name (max 20 characters)'**
  String get cardNameHint;

  /// No description provided for @converterCardNameDefault.
  ///
  /// In en, this message translates to:
  /// **'Card {position}'**
  String converterCardNameDefault(Object position);

  /// No description provided for @unitSelectedStatus.
  ///
  /// In en, this message translates to:
  /// **'Selected {count} of {max}'**
  String unitSelectedStatus(Object count, Object max);

  /// No description provided for @unitVisibleStatus.
  ///
  /// In en, this message translates to:
  /// **'{count} units visible'**
  String unitVisibleStatus(Object count);

  /// No description provided for @moveDown.
  ///
  /// In en, this message translates to:
  /// **'Move Down'**
  String get moveDown;

  /// No description provided for @moveUp.
  ///
  /// In en, this message translates to:
  /// **'Move Up'**
  String get moveUp;

  /// No description provided for @moveToFirst.
  ///
  /// In en, this message translates to:
  /// **'Move to First'**
  String get moveToFirst;

  /// No description provided for @moveToLast.
  ///
  /// In en, this message translates to:
  /// **'Move to Last'**
  String get moveToLast;

  /// No description provided for @cardActions.
  ///
  /// In en, this message translates to:
  /// **'Card Actions'**
  String get cardActions;

  /// No description provided for @lengthUnits.
  ///
  /// In en, this message translates to:
  /// **'Length Units'**
  String get lengthUnits;

  /// No description provided for @angstroms.
  ///
  /// In en, this message translates to:
  /// **'Angstroms'**
  String get angstroms;

  /// No description provided for @nanometers.
  ///
  /// In en, this message translates to:
  /// **'Nanometers'**
  String get nanometers;

  /// No description provided for @microns.
  ///
  /// In en, this message translates to:
  /// **'Microns'**
  String get microns;

  /// No description provided for @nauticalMiles.
  ///
  /// In en, this message translates to:
  /// **'Nautical Miles'**
  String get nauticalMiles;

  /// No description provided for @customizeLengthUnits.
  ///
  /// In en, this message translates to:
  /// **'Customize Length Units'**
  String get customizeLengthUnits;

  /// No description provided for @selectLengthUnits.
  ///
  /// In en, this message translates to:
  /// **'Select length units to display'**
  String get selectLengthUnits;

  /// No description provided for @lengthConverterInfo.
  ///
  /// In en, this message translates to:
  /// **'Length Converter Information'**
  String get lengthConverterInfo;

  /// Title for weight converter tool
  ///
  /// In en, this message translates to:
  /// **'Weight Converter'**
  String get weightConverter;

  /// Title for weight converter info dialog
  ///
  /// In en, this message translates to:
  /// **'Weight Converter Info'**
  String get weightConverterInfo;

  /// Title for weight unit customization dialog
  ///
  /// In en, this message translates to:
  /// **'Customize Weight Units'**
  String get customizeWeightUnits;

  /// Title for mass converter tool
  ///
  /// In en, this message translates to:
  /// **'Mass Converter'**
  String get massConverter;

  /// Title for mass converter info dialog
  ///
  /// In en, this message translates to:
  /// **'Mass Converter Info'**
  String get massConverterInfo;

  /// Description for mass converter tool
  ///
  /// In en, this message translates to:
  /// **'Convert between mass units (kg, lb, oz)'**
  String get massConverterDesc;

  /// Title for mass unit customization dialog
  ///
  /// In en, this message translates to:
  /// **'Customize Mass Units'**
  String get customizeMassUnits;

  /// No description provided for @availableUnits.
  ///
  /// In en, this message translates to:
  /// **'Available Units'**
  String get availableUnits;

  /// No description provided for @scientificNotation.
  ///
  /// In en, this message translates to:
  /// **'Scientific notation supported for extreme values'**
  String get scientificNotation;

  /// No description provided for @dragging.
  ///
  /// In en, this message translates to:
  /// **'Dragging...'**
  String get dragging;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get editName;

  /// No description provided for @editCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Edit currencies'**
  String get editCurrencies;

  /// No description provided for @tableWith.
  ///
  /// In en, this message translates to:
  /// **'Table {count} cards'**
  String tableWith(int count);

  /// No description provided for @noUnitsSelected.
  ///
  /// In en, this message translates to:
  /// **'No units selected'**
  String get noUnitsSelected;

  /// No description provided for @maximumSelectionExceeded.
  ///
  /// In en, this message translates to:
  /// **'Maximum selection exceeded'**
  String get maximumSelectionExceeded;

  /// No description provided for @presetSaved.
  ///
  /// In en, this message translates to:
  /// **'Preset saved successfully'**
  String get presetSaved;

  /// No description provided for @errorSavingPreset.
  ///
  /// In en, this message translates to:
  /// **'Error saving preset: {error}'**
  String errorSavingPreset(String error);

  /// No description provided for @errorLoadingPresets.
  ///
  /// In en, this message translates to:
  /// **'Error loading presets: {error}'**
  String errorLoadingPresets(String error);

  /// No description provided for @maximumSelectionReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum selection reached'**
  String get maximumSelectionReached;

  /// No description provided for @minimumSelectionRequired.
  ///
  /// In en, this message translates to:
  /// **'Minimum {count} selection(s) required'**
  String minimumSelectionRequired(int count);

  /// No description provided for @renamePreset.
  ///
  /// In en, this message translates to:
  /// **'Rename Preset'**
  String get renamePreset;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @presetRenamedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Preset renamed successfully'**
  String get presetRenamedSuccessfully;

  /// No description provided for @chooseFromSavedPresets.
  ///
  /// In en, this message translates to:
  /// **'Choose from your saved presets'**
  String get chooseFromSavedPresets;

  /// No description provided for @currencyConverterDetailedInfo.
  ///
  /// In en, this message translates to:
  /// **'Currency Converter - Detailed Information'**
  String get currencyConverterDetailedInfo;

  /// No description provided for @currencyConverterOverview.
  ///
  /// In en, this message translates to:
  /// **'This powerful currency converter allows you to convert between different currencies with live exchange rates.'**
  String get currencyConverterOverview;

  /// No description provided for @keyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get keyFeatures;

  /// No description provided for @multipleCards.
  ///
  /// In en, this message translates to:
  /// **'Multiple Cards'**
  String get multipleCards;

  /// No description provided for @multipleCardsDesc.
  ///
  /// In en, this message translates to:
  /// **'Create multiple converter cards, each with its own set of currencies and amounts.'**
  String get multipleCardsDesc;

  /// No description provided for @liveRates.
  ///
  /// In en, this message translates to:
  /// **'Live Exchange Rates'**
  String get liveRates;

  /// No description provided for @liveRatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Get real-time exchange rates from reliable financial sources.'**
  String get liveRatesDesc;

  /// No description provided for @customizeCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Customize Currencies'**
  String get customizeCurrencies;

  /// No description provided for @customizeCurrenciesDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose which currencies to display and save custom presets.'**
  String get customizeCurrenciesDesc;

  /// No description provided for @dragAndDrop.
  ///
  /// In en, this message translates to:
  /// **'Drag & Drop'**
  String get dragAndDrop;

  /// No description provided for @dragAndDropDesc.
  ///
  /// In en, this message translates to:
  /// **'Reorder your converter cards by dragging them.'**
  String get dragAndDropDesc;

  /// No description provided for @cardAndTableView.
  ///
  /// In en, this message translates to:
  /// **'Card & Table View'**
  String get cardAndTableView;

  /// No description provided for @cardAndTableViewDesc.
  ///
  /// In en, this message translates to:
  /// **'Switch between card view for easy use or table view for comparison.'**
  String get cardAndTableViewDesc;

  /// No description provided for @stateManagement.
  ///
  /// In en, this message translates to:
  /// **'State Management'**
  String get stateManagement;

  /// No description provided for @stateManagementDesc.
  ///
  /// In en, this message translates to:
  /// **'Your converter state is automatically saved and restored.'**
  String get stateManagementDesc;

  /// No description provided for @howToUse.
  ///
  /// In en, this message translates to:
  /// **'How to Use'**
  String get howToUse;

  /// No description provided for @step1.
  ///
  /// In en, this message translates to:
  /// **'1. Add Cards'**
  String get step1;

  /// No description provided for @step1Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Add Card\' to create new converter cards.'**
  String get step1Desc;

  /// No description provided for @step2.
  ///
  /// In en, this message translates to:
  /// **'2. Enter Amount'**
  String get step2;

  /// No description provided for @step2Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount in any currency field.'**
  String get step2Desc;

  /// No description provided for @step3.
  ///
  /// In en, this message translates to:
  /// **'3. Select Base Currency'**
  String get step3;

  /// No description provided for @step3Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the dropdown to select which currency you\'re converting from.'**
  String get step3Desc;

  /// No description provided for @step4.
  ///
  /// In en, this message translates to:
  /// **'4. View Results'**
  String get step4;

  /// No description provided for @step4Desc.
  ///
  /// In en, this message translates to:
  /// **'See instant conversions to all other currencies in the card.'**
  String get step4Desc;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @tip1.
  ///
  /// In en, this message translates to:
  /// **'• Tap the edit icon next to card names to rename them'**
  String get tip1;

  /// No description provided for @tip2.
  ///
  /// In en, this message translates to:
  /// **'• Use the currency icon to customize which currencies appear'**
  String get tip2;

  /// No description provided for @tip3.
  ///
  /// In en, this message translates to:
  /// **'• Save currency presets for quick access'**
  String get tip3;

  /// No description provided for @tip4.
  ///
  /// In en, this message translates to:
  /// **'• Check the status indicator for exchange rate freshness'**
  String get tip4;

  /// No description provided for @tip5.
  ///
  /// In en, this message translates to:
  /// **'• Use table view to compare multiple cards side by side'**
  String get tip5;

  /// No description provided for @rateUpdate.
  ///
  /// In en, this message translates to:
  /// **'Rate Updates'**
  String get rateUpdate;

  /// No description provided for @rateUpdateDesc.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates are updated based on your settings. Check Settings > Converter Tools to configure update frequency and retry behavior.'**
  String get rateUpdateDesc;

  /// No description provided for @poweredBy.
  ///
  /// In en, this message translates to:
  /// **'Powered by {service}'**
  String poweredBy(String service);

  /// No description provided for @exchangeRatesBy.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates by {service}'**
  String exchangeRatesBy(String service);

  /// No description provided for @dataAttribution.
  ///
  /// In en, this message translates to:
  /// **'Data Attribution'**
  String get dataAttribution;

  /// No description provided for @apiProviderAttribution.
  ///
  /// In en, this message translates to:
  /// **'Exchange rate data provided by ExchangeRate-API'**
  String get apiProviderAttribution;

  /// No description provided for @rateLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Rate limit reached'**
  String get rateLimitReached;

  /// No description provided for @rateLimitMessage.
  ///
  /// In en, this message translates to:
  /// **'You can only fetch currency rates once every 6 hours. Please try again later.'**
  String get rateLimitMessage;

  /// No description provided for @nextFetchAllowedIn.
  ///
  /// In en, this message translates to:
  /// **'Next fetch allowed in: {timeRemaining}'**
  String nextFetchAllowedIn(String timeRemaining);

  /// No description provided for @rateLimitInfo.
  ///
  /// In en, this message translates to:
  /// **'Rate limiting helps prevent API abuse and ensures service availability for everyone.'**
  String get rateLimitInfo;

  /// No description provided for @understood.
  ///
  /// In en, this message translates to:
  /// **'Understood'**
  String get understood;

  /// No description provided for @focusMode.
  ///
  /// In en, this message translates to:
  /// **'Focus Mode'**
  String get focusMode;

  /// Focus mode setting label
  ///
  /// In en, this message translates to:
  /// **'Focus Mode'**
  String get focusModeEnabled;

  /// Focus mode setting description
  ///
  /// In en, this message translates to:
  /// **'Hide UI elements for distraction-free experience'**
  String get focusModeEnabledDesc;

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

  /// No description provided for @focusModeDisabled.
  ///
  /// In en, this message translates to:
  /// **'Focus mode disabled'**
  String get focusModeDisabled;

  /// No description provided for @enableFocusMode.
  ///
  /// In en, this message translates to:
  /// **'Enable Focus Mode'**
  String get enableFocusMode;

  /// No description provided for @disableFocusMode.
  ///
  /// In en, this message translates to:
  /// **'Disable Focus Mode'**
  String get disableFocusMode;

  /// No description provided for @focusModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Hide interface elements to focus on your conversions'**
  String get focusModeDescription;

  /// No description provided for @focusModeEnabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Focus mode activated. {exitInstruction}'**
  String focusModeEnabledMessage(String exitInstruction);

  /// No description provided for @focusModeDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Focus mode deactivated. All interface elements are now visible.'**
  String get focusModeDisabledMessage;

  /// No description provided for @exitFocusModeDesktop.
  ///
  /// In en, this message translates to:
  /// **'Tap the focus icon in the app bar to exit'**
  String get exitFocusModeDesktop;

  /// No description provided for @exitFocusModeMobile.
  ///
  /// In en, this message translates to:
  /// **'Zoom out or tap the focus icon to exit'**
  String get exitFocusModeMobile;

  /// No description provided for @zoomToEnterFocusMode.
  ///
  /// In en, this message translates to:
  /// **'Zoom in to enter focus mode'**
  String get zoomToEnterFocusMode;

  /// No description provided for @zoomToExitFocusMode.
  ///
  /// In en, this message translates to:
  /// **'Zoom out to exit focus mode'**
  String get zoomToExitFocusMode;

  /// No description provided for @focusModeGesture.
  ///
  /// In en, this message translates to:
  /// **'Use zoom gestures to toggle focus mode'**
  String get focusModeGesture;

  /// No description provided for @focusModeButton.
  ///
  /// In en, this message translates to:
  /// **'Use the focus button to toggle focus mode'**
  String get focusModeButton;

  /// No description provided for @focusModeHidesElements.
  ///
  /// In en, this message translates to:
  /// **'Focus mode hides status widgets, add buttons, view mode buttons, and statistics'**
  String get focusModeHidesElements;

  /// No description provided for @focusModeHelp.
  ///
  /// In en, this message translates to:
  /// **'Focus Mode Help'**
  String get focusModeHelp;

  /// No description provided for @focusModeHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus Mode'**
  String get focusModeHelpTitle;

  /// No description provided for @focusModeHelpDescription.
  ///
  /// In en, this message translates to:
  /// **'Focus mode helps you concentrate on your conversions by hiding non-essential interface elements.'**
  String get focusModeHelpDescription;

  /// No description provided for @focusModeHelpHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden in Focus Mode:'**
  String get focusModeHelpHidden;

  /// No description provided for @focusModeHelpHiddenStatus.
  ///
  /// In en, this message translates to:
  /// **'• Status indicators and widgets'**
  String get focusModeHelpHiddenStatus;

  /// No description provided for @focusModeHelpHiddenButtons.
  ///
  /// In en, this message translates to:
  /// **'• Add card/row buttons'**
  String get focusModeHelpHiddenButtons;

  /// No description provided for @focusModeHelpHiddenViewMode.
  ///
  /// In en, this message translates to:
  /// **'• View mode toggle buttons (Card/Table)'**
  String get focusModeHelpHiddenViewMode;

  /// No description provided for @focusModeHelpHiddenStats.
  ///
  /// In en, this message translates to:
  /// **'• Statistics and count information'**
  String get focusModeHelpHiddenStats;

  /// No description provided for @focusModeHelpActivation.
  ///
  /// In en, this message translates to:
  /// **'Activation:'**
  String get focusModeHelpActivation;

  /// No description provided for @focusModeHelpActivationDesktop.
  ///
  /// In en, this message translates to:
  /// **'• Desktop: Click the focus icon in the app bar'**
  String get focusModeHelpActivationDesktop;

  /// No description provided for @focusModeHelpActivationMobile.
  ///
  /// In en, this message translates to:
  /// **'• Mobile: Use zoom in gesture or tap focus icon'**
  String get focusModeHelpActivationMobile;

  /// No description provided for @focusModeHelpDeactivation.
  ///
  /// In en, this message translates to:
  /// **'Deactivation:'**
  String get focusModeHelpDeactivation;

  /// No description provided for @focusModeHelpDeactivationDesktop.
  ///
  /// In en, this message translates to:
  /// **'• Desktop: Click the focus icon again'**
  String get focusModeHelpDeactivationDesktop;

  /// No description provided for @focusModeHelpDeactivationMobile.
  ///
  /// In en, this message translates to:
  /// **'• Mobile: Use zoom out gesture or tap focus icon again'**
  String get focusModeHelpDeactivationMobile;

  /// No description provided for @moreActions.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get moreActions;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More Options'**
  String get moreOptions;

  /// No description provided for @lengthConverterDetailedInfo.
  ///
  /// In en, this message translates to:
  /// **'Length Converter - Detailed Information'**
  String get lengthConverterDetailedInfo;

  /// No description provided for @lengthConverterOverview.
  ///
  /// In en, this message translates to:
  /// **'This precision length converter supports multiple units with high accuracy calculations for professional and scientific use.'**
  String get lengthConverterOverview;

  /// No description provided for @precisionCalculations.
  ///
  /// In en, this message translates to:
  /// **'Precision Calculations'**
  String get precisionCalculations;

  /// No description provided for @precisionCalculationsDesc.
  ///
  /// In en, this message translates to:
  /// **'High-precision arithmetic with up to 15 decimal places for scientific accuracy.'**
  String get precisionCalculationsDesc;

  /// No description provided for @multipleUnits.
  ///
  /// In en, this message translates to:
  /// **'Multiple Length Units'**
  String get multipleUnits;

  /// No description provided for @multipleUnitsDesc.
  ///
  /// In en, this message translates to:
  /// **'Support for metric, imperial, and scientific units including nanometers to kilometers.'**
  String get multipleUnitsDesc;

  /// No description provided for @instantConversion.
  ///
  /// In en, this message translates to:
  /// **'Instant Conversion'**
  String get instantConversion;

  /// No description provided for @instantConversionDesc.
  ///
  /// In en, this message translates to:
  /// **'Real-time conversion across all visible units as you type values.'**
  String get instantConversionDesc;

  /// No description provided for @customizableInterface.
  ///
  /// In en, this message translates to:
  /// **'Customizable Interface'**
  String get customizableInterface;

  /// No description provided for @customizableInterfaceDesc.
  ///
  /// In en, this message translates to:
  /// **'Hide or show specific units, arrange cards, and switch between views.'**
  String get customizableInterfaceDesc;

  /// No description provided for @statePersistence.
  ///
  /// In en, this message translates to:
  /// **'State Persistence:'**
  String get statePersistence;

  /// No description provided for @statePersistenceDesc.
  ///
  /// In en, this message translates to:
  /// **'Your settings and card configurations are saved automatically.'**
  String get statePersistenceDesc;

  /// No description provided for @scientificNotationSupport.
  ///
  /// In en, this message translates to:
  /// **'Scientific Notation'**
  String get scientificNotationSupport;

  /// No description provided for @scientificNotationSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'Support for very large and very small values using scientific notation.'**
  String get scientificNotationSupportDesc;

  /// No description provided for @step1Length.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Add Cards'**
  String get step1Length;

  /// No description provided for @step1LengthDesc.
  ///
  /// In en, this message translates to:
  /// **'Add multiple converter cards to work with different length values simultaneously.'**
  String get step1LengthDesc;

  /// No description provided for @step2Length.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Select Units'**
  String get step2Length;

  /// No description provided for @step2LengthDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose which length units to display by customizing each card\'s visible units.'**
  String get step2LengthDesc;

  /// No description provided for @step3Length.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Enter Values'**
  String get step3Length;

  /// No description provided for @step3LengthDesc.
  ///
  /// In en, this message translates to:
  /// **'Type any length value and see instant conversions to all other units.'**
  String get step3LengthDesc;

  /// No description provided for @step4Length.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Organize Layout'**
  String get step4Length;

  /// No description provided for @step4LengthDesc.
  ///
  /// In en, this message translates to:
  /// **'Drag cards to reorder, switch to table view, or use focus mode for distraction-free work.'**
  String get step4LengthDesc;

  /// No description provided for @tip1Length.
  ///
  /// In en, this message translates to:
  /// **'• Use scientific notation (1.5e6) for very large or small measurements'**
  String get tip1Length;

  /// No description provided for @tip2Length.
  ///
  /// In en, this message translates to:
  /// **'• Double-tap a unit field to select all text for quick editing'**
  String get tip2Length;

  /// No description provided for @tip3Length.
  ///
  /// In en, this message translates to:
  /// **'• Cards remember their individual unit selections and names'**
  String get tip3Length;

  /// No description provided for @tip4Length.
  ///
  /// In en, this message translates to:
  /// **'• Table view is ideal for comparing multiple measurements at once'**
  String get tip4Length;

  /// No description provided for @tip5Length.
  ///
  /// In en, this message translates to:
  /// **'• Focus mode hides distractions for concentrated conversion work'**
  String get tip5Length;

  /// No description provided for @tip6Length.
  ///
  /// In en, this message translates to:
  /// **'• Use the search function to quickly find specific units in customization'**
  String get tip6Length;

  /// No description provided for @lengthUnitRange.
  ///
  /// In en, this message translates to:
  /// **'Supported Units Range'**
  String get lengthUnitRange;

  /// No description provided for @lengthUnitRangeDesc.
  ///
  /// In en, this message translates to:
  /// **'From subatomic (angstroms) to astronomical (light years) measurements with precision maintained throughout.'**
  String get lengthUnitRangeDesc;

  /// No description provided for @weightConverterDetailedInfo.
  ///
  /// In en, this message translates to:
  /// **'Weight Converter - Detailed Information'**
  String get weightConverterDetailedInfo;

  /// No description provided for @weightConverterOverview.
  ///
  /// In en, this message translates to:
  /// **'This precision weight/force converter supports multiple unit systems with high accuracy calculations for engineering, physics, and scientific applications.'**
  String get weightConverterOverview;

  /// No description provided for @step1Weight.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Add Cards'**
  String get step1Weight;

  /// No description provided for @step1WeightDesc.
  ///
  /// In en, this message translates to:
  /// **'Add multiple converter cards to work with different force/weight values simultaneously.'**
  String get step1WeightDesc;

  /// No description provided for @step2Weight.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Select Units'**
  String get step2Weight;

  /// No description provided for @step2WeightDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose which force/weight units to display by customizing each card\'s visible units.'**
  String get step2WeightDesc;

  /// No description provided for @step3Weight.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Enter Values'**
  String get step3Weight;

  /// No description provided for @step3WeightDesc.
  ///
  /// In en, this message translates to:
  /// **'Type any force/weight value and see instant conversions to all other units.'**
  String get step3WeightDesc;

  /// No description provided for @step4Weight.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Organize Layout'**
  String get step4Weight;

  /// No description provided for @step4WeightDesc.
  ///
  /// In en, this message translates to:
  /// **'Drag cards to reorder, switch to table view, or use focus mode for distraction-free work.'**
  String get step4WeightDesc;

  /// No description provided for @tip1Weight.
  ///
  /// In en, this message translates to:
  /// **'• Newton (N) is the base SI unit for force with highest precision'**
  String get tip1Weight;

  /// No description provided for @tip2Weight.
  ///
  /// In en, this message translates to:
  /// **'• Kilogram-force (kgf) represents gravitational force on 1 kg mass'**
  String get tip2Weight;

  /// No description provided for @tip3Weight.
  ///
  /// In en, this message translates to:
  /// **'• Use scientific notation for very large or small force values'**
  String get tip3Weight;

  /// No description provided for @tip4Weight.
  ///
  /// In en, this message translates to:
  /// **'• Dyne is useful for small forces in CGS system calculations'**
  String get tip4Weight;

  /// No description provided for @tip5Weight.
  ///
  /// In en, this message translates to:
  /// **'• Troy units are specialized for precious metals and jewelry'**
  String get tip5Weight;

  /// No description provided for @tip6Weight.
  ///
  /// In en, this message translates to:
  /// **'• Focus mode helps concentrate on complex force calculations'**
  String get tip6Weight;

  /// No description provided for @weightUnitCategories.
  ///
  /// In en, this message translates to:
  /// **'Unit Categories'**
  String get weightUnitCategories;

  /// No description provided for @commonUnits.
  ///
  /// In en, this message translates to:
  /// **'Common Units'**
  String get commonUnits;

  /// No description provided for @commonUnitsWeightDesc.
  ///
  /// In en, this message translates to:
  /// **'Newton (N), Kilogram-force (kgf), Pound-force (lbf) - most frequently used in engineering and physics.'**
  String get commonUnitsWeightDesc;

  /// No description provided for @lessCommonUnits.
  ///
  /// In en, this message translates to:
  /// **'Less Common Units'**
  String get lessCommonUnits;

  /// No description provided for @lessCommonUnitsWeightDesc.
  ///
  /// In en, this message translates to:
  /// **'Dyne (dyn), Kilopond (kp) - specialized scientific and technical applications.'**
  String get lessCommonUnitsWeightDesc;

  /// No description provided for @uncommonUnits.
  ///
  /// In en, this message translates to:
  /// **'Uncommon Units'**
  String get uncommonUnits;

  /// No description provided for @uncommonUnitsWeightDesc.
  ///
  /// In en, this message translates to:
  /// **'Ton-force (tf) - for very large force measurements in heavy industry.'**
  String get uncommonUnitsWeightDesc;

  /// No description provided for @specialUnits.
  ///
  /// In en, this message translates to:
  /// **'Special Units'**
  String get specialUnits;

  /// No description provided for @specialUnitsWeightDesc.
  ///
  /// In en, this message translates to:
  /// **'Gram-force (gf), Troy pound-force - for precision measurements and precious metals.'**
  String get specialUnitsWeightDesc;

  /// No description provided for @practicalApplicationsWeightDesc.
  ///
  /// In en, this message translates to:
  /// **'Useful for engineering calculations, physics experiments, and applications requiring force measurements.'**
  String get practicalApplicationsWeightDesc;

  /// No description provided for @practicalApplications.
  ///
  /// In en, this message translates to:
  /// **'Practical Applications'**
  String get practicalApplications;

  /// No description provided for @practicalApplicationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Helpful for everyday measurements and unit conversions in various contexts.'**
  String get practicalApplicationsDesc;

  /// No description provided for @massConverterDetailedInfo.
  ///
  /// In en, this message translates to:
  /// **'Mass Converter - Detailed Information'**
  String get massConverterDetailedInfo;

  /// No description provided for @massConverterOverview.
  ///
  /// In en, this message translates to:
  /// **'This precise mass converter supports multiple unit systems with high accuracy calculations for scientific, medical, and commercial applications.'**
  String get massConverterOverview;

  /// No description provided for @step1Mass.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Add Cards'**
  String get step1Mass;

  /// No description provided for @step1MassDesc.
  ///
  /// In en, this message translates to:
  /// **'Add multiple converter cards to work with different mass values simultaneously.'**
  String get step1MassDesc;

  /// No description provided for @step2Mass.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Select Units'**
  String get step2Mass;

  /// No description provided for @step2MassDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose which mass units to display from metric, imperial, troy, and apothecaries systems.'**
  String get step2MassDesc;

  /// No description provided for @step3Mass.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Enter Values'**
  String get step3Mass;

  /// No description provided for @step3MassDesc.
  ///
  /// In en, this message translates to:
  /// **'Type any mass value and see instant conversions to all other units.'**
  String get step3MassDesc;

  /// No description provided for @step4Mass.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Organize Layout'**
  String get step4Mass;

  /// No description provided for @step4MassDesc.
  ///
  /// In en, this message translates to:
  /// **'Drag cards to reorder, switch to table view, or use focus mode for distraction-free work.'**
  String get step4MassDesc;

  /// No description provided for @tip1Mass.
  ///
  /// In en, this message translates to:
  /// **'• Use scientific notation (1.5e-12) for very small masses like atomic units'**
  String get tip1Mass;

  /// No description provided for @tip2Mass.
  ///
  /// In en, this message translates to:
  /// **'• Troy system is ideal for precious metals calculations'**
  String get tip2Mass;

  /// No description provided for @tip3Mass.
  ///
  /// In en, this message translates to:
  /// **'• Apothecaries system is used in pharmacy and medicine'**
  String get tip3Mass;

  /// No description provided for @tip4Mass.
  ///
  /// In en, this message translates to:
  /// **'• Table view is perfect for comparing multiple measurements'**
  String get tip4Mass;

  /// No description provided for @tip5Mass.
  ///
  /// In en, this message translates to:
  /// **'• Focus mode hides distractions for concentrated conversion work'**
  String get tip5Mass;

  /// No description provided for @tip6Mass.
  ///
  /// In en, this message translates to:
  /// **'• Use presets to save your favorite unit combinations'**
  String get tip6Mass;

  /// No description provided for @massUnitSystems.
  ///
  /// In en, this message translates to:
  /// **'Supported Unit Systems'**
  String get massUnitSystems;

  /// No description provided for @massUnitSystemsDesc.
  ///
  /// In en, this message translates to:
  /// **'Metric (ng to tonnes), Imperial (grains to tons), Troy (precious metals), Apothecaries (pharmacy), and special units (carats, slugs, atomic mass units).'**
  String get massUnitSystemsDesc;

  /// No description provided for @practicalApplicationsMassDesc.
  ///
  /// In en, this message translates to:
  /// **'Useful for cooking measurements, basic scientific calculations, and everyday mass conversions.'**
  String get practicalApplicationsMassDesc;

  /// Title for area converter info dialog
  ///
  /// In en, this message translates to:
  /// **'Area Converter Info'**
  String get areaConverterInfo;

  /// Title for area unit customization dialog
  ///
  /// In en, this message translates to:
  /// **'Customize Area Units'**
  String get customizeAreaUnits;

  /// No description provided for @areaConverterDetailedInfo.
  ///
  /// In en, this message translates to:
  /// **'Area Converter - Detailed Information'**
  String get areaConverterDetailedInfo;

  /// No description provided for @areaConverterOverview.
  ///
  /// In en, this message translates to:
  /// **'This precision area converter supports multiple unit systems with high accuracy calculations for real estate, agriculture, engineering, and scientific applications.'**
  String get areaConverterOverview;

  /// No description provided for @step1Area.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Add Cards'**
  String get step1Area;

  /// No description provided for @step1AreaDesc.
  ///
  /// In en, this message translates to:
  /// **'Add multiple converter cards to work with different area values simultaneously.'**
  String get step1AreaDesc;

  /// No description provided for @step2Area.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Select Units'**
  String get step2Area;

  /// No description provided for @step2AreaDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose which area units to display by customizing each card\'s visible units.'**
  String get step2AreaDesc;

  /// No description provided for @step3Area.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Enter Values'**
  String get step3Area;

  /// No description provided for @step3AreaDesc.
  ///
  /// In en, this message translates to:
  /// **'Type any area value and see instant conversions to all other units.'**
  String get step3AreaDesc;

  /// No description provided for @step4Area.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Organize Layout'**
  String get step4Area;

  /// No description provided for @step4AreaDesc.
  ///
  /// In en, this message translates to:
  /// **'Drag cards to reorder, switch to table view, or use focus mode for distraction-free work.'**
  String get step4AreaDesc;

  /// No description provided for @tip1Area.
  ///
  /// In en, this message translates to:
  /// **'• Square meter (m²) is the base SI unit for area with highest precision'**
  String get tip1Area;

  /// No description provided for @tip2Area.
  ///
  /// In en, this message translates to:
  /// **'• Hectare is commonly used for large land areas and agriculture'**
  String get tip2Area;

  /// No description provided for @tip3Area.
  ///
  /// In en, this message translates to:
  /// **'• Acre is standard in real estate and land measurement in the US'**
  String get tip3Area;

  /// No description provided for @tip4Area.
  ///
  /// In en, this message translates to:
  /// **'• Use scientific notation for very large or small area values'**
  String get tip4Area;

  /// No description provided for @tip5Area.
  ///
  /// In en, this message translates to:
  /// **'• Square feet and square inches are common in construction and design'**
  String get tip5Area;

  /// No description provided for @tip6Area.
  ///
  /// In en, this message translates to:
  /// **'• Focus mode helps concentrate on complex area calculations'**
  String get tip6Area;

  /// No description provided for @areaUnitCategories.
  ///
  /// In en, this message translates to:
  /// **'Unit Categories'**
  String get areaUnitCategories;

  /// No description provided for @commonUnitsAreaDesc.
  ///
  /// In en, this message translates to:
  /// **'Square meter (m²), Square kilometer (km²), Square centimeter (cm²) - most frequently used metric units.'**
  String get commonUnitsAreaDesc;

  /// No description provided for @lessCommonUnitsAreaDesc.
  ///
  /// In en, this message translates to:
  /// **'Hectare (ha), Acre (ac), Square foot (ft²), Square inch (in²) - specialized applications in agriculture and construction.'**
  String get lessCommonUnitsAreaDesc;

  /// No description provided for @uncommonUnitsAreaDesc.
  ///
  /// In en, this message translates to:
  /// **'Square yard (yd²), Square mile (mi²), Rood - for specific regional or historical measurements.'**
  String get uncommonUnitsAreaDesc;

  /// No description provided for @practicalApplicationsAreaDesc.
  ///
  /// In en, this message translates to:
  /// **'Helpful for home improvement projects, gardening, and basic area calculations.'**
  String get practicalApplicationsAreaDesc;

  /// No description provided for @timeConverterDetailedInfo.
  ///
  /// In en, this message translates to:
  /// **'Time Converter - Detailed Information'**
  String get timeConverterDetailedInfo;

  /// No description provided for @timeConverterOverview.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive time unit conversion with precision calculations and multiple unit support.'**
  String get timeConverterOverview;

  /// No description provided for @step1Time.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Select Time Units'**
  String get step1Time;

  /// No description provided for @step1TimeDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose from seconds, minutes, hours, days, weeks, months, years, and specialized units like milliseconds and nanoseconds.'**
  String get step1TimeDesc;

  /// No description provided for @step2Time.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Enter Time Value'**
  String get step2Time;

  /// No description provided for @step2TimeDesc.
  ///
  /// In en, this message translates to:
  /// **'Input the time duration you want to convert. Supports decimal values and scientific notation for precise calculations.'**
  String get step2TimeDesc;

  /// No description provided for @step3Time.
  ///
  /// In en, this message translates to:
  /// **'Step 3: View Conversions'**
  String get step3Time;

  /// No description provided for @step3TimeDesc.
  ///
  /// In en, this message translates to:
  /// **'See instant conversions across all selected time units with high precision calculations.'**
  String get step3TimeDesc;

  /// No description provided for @step4Time.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Customize & Save'**
  String get step4Time;

  /// No description provided for @step4TimeDesc.
  ///
  /// In en, this message translates to:
  /// **'Add multiple cards, customize visible units, and save your preferred layout for future use.'**
  String get step4TimeDesc;

  /// No description provided for @tip1Time.
  ///
  /// In en, this message translates to:
  /// **'• Use scientific notation for very small or large time values'**
  String get tip1Time;

  /// No description provided for @tip2Time.
  ///
  /// In en, this message translates to:
  /// **'• Milliseconds and nanoseconds are perfect for technical calculations'**
  String get tip2Time;

  /// No description provided for @tip3Time.
  ///
  /// In en, this message translates to:
  /// **'• Years and months use average values for consistency'**
  String get tip3Time;

  /// No description provided for @tip4Time.
  ///
  /// In en, this message translates to:
  /// **'• Add multiple cards to compare different time scales'**
  String get tip4Time;

  /// No description provided for @tip5Time.
  ///
  /// In en, this message translates to:
  /// **'• Customize visible units to show only what you need'**
  String get tip5Time;

  /// No description provided for @tip6Time.
  ///
  /// In en, this message translates to:
  /// **'• Focus mode helps concentrate on complex time calculations'**
  String get tip6Time;

  /// No description provided for @timeUnitSystems.
  ///
  /// In en, this message translates to:
  /// **'Time Unit Systems'**
  String get timeUnitSystems;

  /// No description provided for @timeUnitSystemsDesc.
  ///
  /// In en, this message translates to:
  /// **'Supports standard time units (s, min, h, d, wk, mo, yr), precision units (ms, μs, ns), and extended units (decades, centuries, millennia) for comprehensive time measurement across all scales.'**
  String get timeUnitSystemsDesc;

  /// No description provided for @practicalApplicationsTimeDesc.
  ///
  /// In en, this message translates to:
  /// **'Useful for scheduling, time zone conversions, and everyday time calculations.'**
  String get practicalApplicationsTimeDesc;

  /// No description provided for @volumeConverterDetailedInfo.
  ///
  /// In en, this message translates to:
  /// **'Volume Converter - Detailed Information'**
  String get volumeConverterDetailedInfo;

  /// No description provided for @volumeConverterOverview.
  ///
  /// In en, this message translates to:
  /// **'This precision volume converter supports multiple unit systems with high accuracy calculations for cooking, chemistry, engineering, and scientific applications.'**
  String get volumeConverterOverview;

  /// No description provided for @step1Volume.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Add Cards'**
  String get step1Volume;

  /// No description provided for @step1VolumeDesc.
  ///
  /// In en, this message translates to:
  /// **'Add multiple converter cards to work with different volume values simultaneously.'**
  String get step1VolumeDesc;

  /// No description provided for @step2Volume.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Select Units'**
  String get step2Volume;

  /// No description provided for @step2VolumeDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose which volume units to display from metric, imperial, and US systems.'**
  String get step2VolumeDesc;

  /// No description provided for @step3Volume.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Enter Values'**
  String get step3Volume;

  /// No description provided for @step3VolumeDesc.
  ///
  /// In en, this message translates to:
  /// **'Type any volume value and see instant conversions to all other units.'**
  String get step3VolumeDesc;

  /// No description provided for @step4Volume.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Organize Layout'**
  String get step4Volume;

  /// No description provided for @step4VolumeDesc.
  ///
  /// In en, this message translates to:
  /// **'Drag cards to reorder, switch to table view, or use focus mode for distraction-free work.'**
  String get step4VolumeDesc;

  /// No description provided for @tip1Volume.
  ///
  /// In en, this message translates to:
  /// **'• Cubic meter (m³) is the base SI unit for volume with highest precision'**
  String get tip1Volume;

  /// No description provided for @tip2Volume.
  ///
  /// In en, this message translates to:
  /// **'• Liter is commonly used for liquid measurements in everyday applications'**
  String get tip2Volume;

  /// No description provided for @tip3Volume.
  ///
  /// In en, this message translates to:
  /// **'• Milliliter and cubic centimeter are equivalent and interchangeable'**
  String get tip3Volume;

  /// No description provided for @tip4Volume.
  ///
  /// In en, this message translates to:
  /// **'• US and UK gallons are different units, choose carefully'**
  String get tip4Volume;

  /// No description provided for @tip5Volume.
  ///
  /// In en, this message translates to:
  /// **'• Use scientific notation for very large or small volume values'**
  String get tip5Volume;

  /// No description provided for @tip6Volume.
  ///
  /// In en, this message translates to:
  /// **'• Focus mode helps concentrate on complex volume calculations'**
  String get tip6Volume;

  /// No description provided for @volumeUnitCategories.
  ///
  /// In en, this message translates to:
  /// **'Unit Categories'**
  String get volumeUnitCategories;

  /// No description provided for @commonUnitsVolumeDesc.
  ///
  /// In en, this message translates to:
  /// **'Cubic meter (m³), Liter (L), Milliliter (mL) - most frequently used metric units.'**
  String get commonUnitsVolumeDesc;

  /// No description provided for @lessCommonUnitsVolumeDesc.
  ///
  /// In en, this message translates to:
  /// **'Gallon (US/UK), Cubic foot (ft³), Quart, Pint - imperial and US customary units.'**
  String get lessCommonUnitsVolumeDesc;

  /// No description provided for @uncommonUnitsVolumeDesc.
  ///
  /// In en, this message translates to:
  /// **'Hectoliter (hL), Barrel (bbl), Cup, Fluid ounce - specialized applications.'**
  String get uncommonUnitsVolumeDesc;

  /// No description provided for @specialUnitsVolumeDesc.
  ///
  /// In en, this message translates to:
  /// **'Cubic centimeter (cm³), Cubic inch (in³), Cubic yard (yd³) - engineering and construction units.'**
  String get specialUnitsVolumeDesc;

  /// No description provided for @practicalApplicationsVolumeDesc.
  ///
  /// In en, this message translates to:
  /// **'Helpful for cooking, baking, and basic volume measurements.'**
  String get practicalApplicationsVolumeDesc;

  /// No description provided for @volumeConverterInfo.
  ///
  /// In en, this message translates to:
  /// **'Volume Converter Information'**
  String get volumeConverterInfo;

  /// No description provided for @customizeVolumeUnits.
  ///
  /// In en, this message translates to:
  /// **'Customize Volume Units'**
  String get customizeVolumeUnits;

  /// No description provided for @selectVolumeUnits.
  ///
  /// In en, this message translates to:
  /// **'Select volume units to display'**
  String get selectVolumeUnits;

  /// No description provided for @volumeUnits.
  ///
  /// In en, this message translates to:
  /// **'Volume Units'**
  String get volumeUnits;

  /// No description provided for @cubicMeter.
  ///
  /// In en, this message translates to:
  /// **'Cubic Meter'**
  String get cubicMeter;

  /// No description provided for @liter.
  ///
  /// In en, this message translates to:
  /// **'Liter'**
  String get liter;

  /// No description provided for @milliliter.
  ///
  /// In en, this message translates to:
  /// **'Milliliter'**
  String get milliliter;

  /// No description provided for @cubicCentimeter.
  ///
  /// In en, this message translates to:
  /// **'Cubic Centimeter'**
  String get cubicCentimeter;

  /// No description provided for @hectoliter.
  ///
  /// In en, this message translates to:
  /// **'Hectoliter'**
  String get hectoliter;

  /// No description provided for @gallonUS.
  ///
  /// In en, this message translates to:
  /// **'Gallon (US)'**
  String get gallonUS;

  /// No description provided for @gallonUK.
  ///
  /// In en, this message translates to:
  /// **'Gallon (UK)'**
  String get gallonUK;

  /// No description provided for @quartUS.
  ///
  /// In en, this message translates to:
  /// **'Quart (US)'**
  String get quartUS;

  /// No description provided for @pintUS.
  ///
  /// In en, this message translates to:
  /// **'Pint (US)'**
  String get pintUS;

  /// No description provided for @cup.
  ///
  /// In en, this message translates to:
  /// **'Cup'**
  String get cup;

  /// No description provided for @fluidOunceUS.
  ///
  /// In en, this message translates to:
  /// **'Fluid Ounce (US)'**
  String get fluidOunceUS;

  /// No description provided for @cubicInch.
  ///
  /// In en, this message translates to:
  /// **'Cubic Inch'**
  String get cubicInch;

  /// No description provided for @cubicFoot.
  ///
  /// In en, this message translates to:
  /// **'Cubic Foot'**
  String get cubicFoot;

  /// No description provided for @cubicYard.
  ///
  /// In en, this message translates to:
  /// **'Cubic Yard'**
  String get cubicYard;

  /// No description provided for @barrel.
  ///
  /// In en, this message translates to:
  /// **'Barrel (Oil)'**
  String get barrel;

  /// No description provided for @numberSystemConverterDetailedInfo.
  ///
  /// In en, this message translates to:
  /// **'Number System Converter - Detailed Information'**
  String get numberSystemConverterDetailedInfo;

  /// No description provided for @numberSystemConverterOverview.
  ///
  /// In en, this message translates to:
  /// **'This precision number system converter supports multiple base systems with high accuracy calculations for programming, computer science, and mathematical applications.'**
  String get numberSystemConverterOverview;

  /// No description provided for @step1NumberSystem.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Add Cards'**
  String get step1NumberSystem;

  /// No description provided for @step1NumberSystemDesc.
  ///
  /// In en, this message translates to:
  /// **'Add multiple converter cards to work with different number base values simultaneously.'**
  String get step1NumberSystemDesc;

  /// No description provided for @step2NumberSystem.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Select Bases'**
  String get step2NumberSystem;

  /// No description provided for @step2NumberSystemDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose which number bases to display from binary, decimal, hexadecimal, and other systems.'**
  String get step2NumberSystemDesc;

  /// No description provided for @step3NumberSystem.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Enter Values'**
  String get step3NumberSystem;

  /// No description provided for @step3NumberSystemDesc.
  ///
  /// In en, this message translates to:
  /// **'Type any number value and see instant conversions to all other base systems.'**
  String get step3NumberSystemDesc;

  /// No description provided for @step4NumberSystem.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Organize Layout'**
  String get step4NumberSystem;

  /// No description provided for @step4NumberSystemDesc.
  ///
  /// In en, this message translates to:
  /// **'Drag cards to reorder, switch to table view, or use focus mode for distraction-free work.'**
  String get step4NumberSystemDesc;

  /// No description provided for @tip1NumberSystem.
  ///
  /// In en, this message translates to:
  /// **'• Decimal (Base 10) is the standard counting system with highest precision'**
  String get tip1NumberSystem;

  /// No description provided for @tip2NumberSystem.
  ///
  /// In en, this message translates to:
  /// **'• Binary (Base 2) is fundamental for computer science and digital electronics'**
  String get tip2NumberSystem;

  /// No description provided for @tip3NumberSystem.
  ///
  /// In en, this message translates to:
  /// **'• Hexadecimal (Base 16) is commonly used in programming and memory addressing'**
  String get tip3NumberSystem;

  /// No description provided for @tip4NumberSystem.
  ///
  /// In en, this message translates to:
  /// **'• Octal (Base 8) was historically important in computing systems'**
  String get tip4NumberSystem;

  /// No description provided for @tip5NumberSystem.
  ///
  /// In en, this message translates to:
  /// **'• Base 32 and Base 64 are used for data encoding and transmission'**
  String get tip5NumberSystem;

  /// No description provided for @tip6NumberSystem.
  ///
  /// In en, this message translates to:
  /// **'• Focus mode helps concentrate on complex base calculations'**
  String get tip6NumberSystem;

  /// No description provided for @numberSystemUnitCategories.
  ///
  /// In en, this message translates to:
  /// **'Base Systems'**
  String get numberSystemUnitCategories;

  /// No description provided for @commonBasesDesc.
  ///
  /// In en, this message translates to:
  /// **'Binary (Base 2), Decimal (Base 10), Hexadecimal (Base 16) - most frequently used in computing and mathematics.'**
  String get commonBasesDesc;

  /// No description provided for @lessCommonBasesDesc.
  ///
  /// In en, this message translates to:
  /// **'Octal (Base 8), Base 32, Base 64 - specialized applications in programming and data encoding.'**
  String get lessCommonBasesDesc;

  /// No description provided for @uncommonBasesDesc.
  ///
  /// In en, this message translates to:
  /// **'Base 128, Base 256 - for advanced data representation and specialized algorithms.'**
  String get uncommonBasesDesc;

  /// No description provided for @practicalApplicationsNumberSystemDesc.
  ///
  /// In en, this message translates to:
  /// **'Useful for basic programming, learning number systems, and simple base conversions.'**
  String get practicalApplicationsNumberSystemDesc;

  /// No description provided for @numberSystemConverterInfo.
  ///
  /// In en, this message translates to:
  /// **'Number System Converter Information'**
  String get numberSystemConverterInfo;

  /// No description provided for @customizeNumberSystemBases.
  ///
  /// In en, this message translates to:
  /// **'Customize Number System Bases'**
  String get customizeNumberSystemBases;

  /// No description provided for @selectNumberSystemBases.
  ///
  /// In en, this message translates to:
  /// **'Select number bases to display'**
  String get selectNumberSystemBases;

  /// No description provided for @numberSystemBases.
  ///
  /// In en, this message translates to:
  /// **'Number Bases'**
  String get numberSystemBases;

  /// No description provided for @base32.
  ///
  /// In en, this message translates to:
  /// **'Base 32'**
  String get base32;

  /// No description provided for @base64.
  ///
  /// In en, this message translates to:
  /// **'Base 64'**
  String get base64;

  /// No description provided for @base128.
  ///
  /// In en, this message translates to:
  /// **'Base 128'**
  String get base128;

  /// No description provided for @base256.
  ///
  /// In en, this message translates to:
  /// **'Base 256'**
  String get base256;

  /// No description provided for @speedConverterDetailedInfo.
  ///
  /// In en, this message translates to:
  /// **'Speed Converter - Detailed Information'**
  String get speedConverterDetailedInfo;

  /// No description provided for @speedConverterOverview.
  ///
  /// In en, this message translates to:
  /// **'This precision speed converter supports multiple unit systems with high accuracy calculations for automotive, aviation, maritime, and scientific applications.'**
  String get speedConverterOverview;

  /// No description provided for @step1Speed.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Add Cards'**
  String get step1Speed;

  /// No description provided for @step1SpeedDesc.
  ///
  /// In en, this message translates to:
  /// **'Add multiple converter cards to work with different speed values simultaneously.'**
  String get step1SpeedDesc;

  /// No description provided for @step2Speed.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Select Units'**
  String get step2Speed;

  /// No description provided for @step2SpeedDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose which speed units to display from metric, imperial, maritime, and aviation systems.'**
  String get step2SpeedDesc;

  /// No description provided for @step3Speed.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Enter Values'**
  String get step3Speed;

  /// No description provided for @step3SpeedDesc.
  ///
  /// In en, this message translates to:
  /// **'Type any speed value and see instant conversions to all other units.'**
  String get step3SpeedDesc;

  /// No description provided for @step4Speed.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Organize Layout'**
  String get step4Speed;

  /// No description provided for @step4SpeedDesc.
  ///
  /// In en, this message translates to:
  /// **'Drag cards to reorder, switch to table view, or use focus mode for distraction-free work.'**
  String get step4SpeedDesc;

  /// No description provided for @tip1Speed.
  ///
  /// In en, this message translates to:
  /// **'• Meters per second (m/s) is the base SI unit for speed with highest precision'**
  String get tip1Speed;

  /// No description provided for @tip2Speed.
  ///
  /// In en, this message translates to:
  /// **'• Kilometers per hour (km/h) is commonly used for vehicle speeds'**
  String get tip2Speed;

  /// No description provided for @tip3Speed.
  ///
  /// In en, this message translates to:
  /// **'• Miles per hour (mph) is standard in the US for road speeds'**
  String get tip3Speed;

  /// No description provided for @tip4Speed.
  ///
  /// In en, this message translates to:
  /// **'• Knots are standard for maritime and aviation navigation'**
  String get tip4Speed;

  /// No description provided for @tip5Speed.
  ///
  /// In en, this message translates to:
  /// **'• Mach number represents speed relative to sound (343 m/s at sea level)'**
  String get tip5Speed;

  /// No description provided for @tip6Speed.
  ///
  /// In en, this message translates to:
  /// **'• Focus mode helps concentrate on complex speed calculations'**
  String get tip6Speed;

  /// No description provided for @speedUnitCategories.
  ///
  /// In en, this message translates to:
  /// **'Unit Categories'**
  String get speedUnitCategories;

  /// No description provided for @multipleSpeedUnits.
  ///
  /// In en, this message translates to:
  /// **'Multiple Speed Units'**
  String get multipleSpeedUnits;

  /// No description provided for @multipleSpeedUnitsDesc.
  ///
  /// In en, this message translates to:
  /// **'Support for metric, imperial, maritime, and aviation units including m/s to Mach numbers.'**
  String get multipleSpeedUnitsDesc;

  /// No description provided for @speedUnitRange.
  ///
  /// In en, this message translates to:
  /// **'Supported Speed Range'**
  String get speedUnitRange;

  /// No description provided for @speedUnitRangeDesc.
  ///
  /// In en, this message translates to:
  /// **'From millimeters per second to supersonic speeds (Mach numbers) with precision maintained throughout the range.'**
  String get speedUnitRangeDesc;

  /// No description provided for @commonUnitsSpeedDesc.
  ///
  /// In en, this message translates to:
  /// **'Kilometers per hour (km/h), Meters per second (m/s), Miles per hour (mph) - most frequently used for ground transportation.'**
  String get commonUnitsSpeedDesc;

  /// No description provided for @lessCommonUnitsSpeedDesc.
  ///
  /// In en, this message translates to:
  /// **'Knots (kn), Feet per second (ft/s) - specialized for maritime, aviation, and ballistics applications.'**
  String get lessCommonUnitsSpeedDesc;

  /// No description provided for @uncommonUnitsSpeedDesc.
  ///
  /// In en, this message translates to:
  /// **'Mach (M) - for supersonic and hypersonic speeds in aerospace applications.'**
  String get uncommonUnitsSpeedDesc;

  /// No description provided for @practicalApplicationsSpeedDesc.
  ///
  /// In en, this message translates to:
  /// **'Helpful for travel planning, sports activities, and basic speed conversions.'**
  String get practicalApplicationsSpeedDesc;

  /// No description provided for @speedConverterInfo.
  ///
  /// In en, this message translates to:
  /// **'Speed Converter Information'**
  String get speedConverterInfo;

  /// No description provided for @customizeSpeedUnits.
  ///
  /// In en, this message translates to:
  /// **'Customize Speed Units'**
  String get customizeSpeedUnits;

  /// No description provided for @selectSpeedUnits.
  ///
  /// In en, this message translates to:
  /// **'Select speed units to display'**
  String get selectSpeedUnits;

  /// No description provided for @speedUnits.
  ///
  /// In en, this message translates to:
  /// **'Speed Units'**
  String get speedUnits;

  /// No description provided for @temperatureConverterDetailedInfo.
  ///
  /// In en, this message translates to:
  /// **'Temperature Converter - Detailed Information'**
  String get temperatureConverterDetailedInfo;

  /// No description provided for @temperatureConverterOverview.
  ///
  /// In en, this message translates to:
  /// **'This precision temperature converter supports multiple temperature scales with high accuracy calculations for scientific, engineering, cooking, and everyday applications.'**
  String get temperatureConverterOverview;

  /// No description provided for @step1Temperature.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Add Cards'**
  String get step1Temperature;

  /// No description provided for @step1TemperatureDesc.
  ///
  /// In en, this message translates to:
  /// **'Add multiple converter cards to work with different temperature values simultaneously.'**
  String get step1TemperatureDesc;

  /// No description provided for @step2Temperature.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Select Scales'**
  String get step2Temperature;

  /// No description provided for @step2TemperatureDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose which temperature scales to display from Celsius, Fahrenheit, Kelvin, and other systems.'**
  String get step2TemperatureDesc;

  /// No description provided for @step3Temperature.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Enter Values'**
  String get step3Temperature;

  /// No description provided for @step3TemperatureDesc.
  ///
  /// In en, this message translates to:
  /// **'Type any temperature value and see instant conversions to all other scales.'**
  String get step3TemperatureDesc;

  /// No description provided for @step4Temperature.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Organize Layout'**
  String get step4Temperature;

  /// No description provided for @step4TemperatureDesc.
  ///
  /// In en, this message translates to:
  /// **'Drag cards to reorder, switch to table view, or use focus mode for distraction-free work.'**
  String get step4TemperatureDesc;

  /// No description provided for @tip1Temperature.
  ///
  /// In en, this message translates to:
  /// **'• Celsius (°C) is the most widely used temperature scale globally'**
  String get tip1Temperature;

  /// No description provided for @tip2Temperature.
  ///
  /// In en, this message translates to:
  /// **'• Fahrenheit (°F) is commonly used in the United States'**
  String get tip2Temperature;

  /// No description provided for @tip3Temperature.
  ///
  /// In en, this message translates to:
  /// **'• Kelvin (K) is the absolute temperature scale used in science'**
  String get tip3Temperature;

  /// No description provided for @tip4Temperature.
  ///
  /// In en, this message translates to:
  /// **'• Rankine (°R) is the absolute Fahrenheit scale'**
  String get tip4Temperature;

  /// No description provided for @tip5Temperature.
  ///
  /// In en, this message translates to:
  /// **'• Réaumur (°Ré) is historically used in some European countries'**
  String get tip5Temperature;

  /// No description provided for @tip6Temperature.
  ///
  /// In en, this message translates to:
  /// **'• Focus mode helps concentrate on complex temperature calculations'**
  String get tip6Temperature;

  /// No description provided for @temperatureUnitCategories.
  ///
  /// In en, this message translates to:
  /// **'Temperature Scale Categories'**
  String get temperatureUnitCategories;

  /// No description provided for @temperatureCommonUnits.
  ///
  /// In en, this message translates to:
  /// **'Common Scales'**
  String get temperatureCommonUnits;

  /// No description provided for @temperatureCommonUnitsDesc.
  ///
  /// In en, this message translates to:
  /// **'Celsius (°C), Fahrenheit (°F) - most frequently used for weather, cooking, and everyday temperature measurements.'**
  String get temperatureCommonUnitsDesc;

  /// No description provided for @temperatureLessCommonUnits.
  ///
  /// In en, this message translates to:
  /// **'Scientific Scale'**
  String get temperatureLessCommonUnits;

  /// No description provided for @temperatureLessCommonUnitsDesc.
  ///
  /// In en, this message translates to:
  /// **'Kelvin (K) - absolute temperature scale used in scientific and engineering applications.'**
  String get temperatureLessCommonUnitsDesc;

  /// No description provided for @temperatureRareUnits.
  ///
  /// In en, this message translates to:
  /// **'Specialized Scales'**
  String get temperatureRareUnits;

  /// No description provided for @temperatureRareUnitsDesc.
  ///
  /// In en, this message translates to:
  /// **'Rankine (°R), Réaumur (°Ré), Delisle (°De) - historical and specialized temperature scales for specific applications.'**
  String get temperatureRareUnitsDesc;

  /// No description provided for @temperaturePracticalApplicationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Useful for cooking, weather understanding, and basic temperature conversions.'**
  String get temperaturePracticalApplicationsDesc;

  /// No description provided for @temperatureConverterInfo.
  ///
  /// In en, this message translates to:
  /// **'Temperature Converter Information'**
  String get temperatureConverterInfo;

  /// No description provided for @customizeTemperatureUnits.
  ///
  /// In en, this message translates to:
  /// **'Customize Temperature Scales'**
  String get customizeTemperatureUnits;

  /// No description provided for @selectTemperatureUnits.
  ///
  /// In en, this message translates to:
  /// **'Select temperature scales to display'**
  String get selectTemperatureUnits;

  /// No description provided for @temperatureUnits.
  ///
  /// In en, this message translates to:
  /// **'Temperature Scales'**
  String get temperatureUnits;

  /// No description provided for @dataConverterDetailedInfo.
  ///
  /// In en, this message translates to:
  /// **'Data Storage Converter - Detailed Information'**
  String get dataConverterDetailedInfo;

  /// No description provided for @dataConverterOverview.
  ///
  /// In en, this message translates to:
  /// **'This precision data storage converter supports multiple data units with high accuracy calculations for computer science, IT management, file handling, and digital storage applications.'**
  String get dataConverterOverview;

  /// No description provided for @step1Data.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Add Cards'**
  String get step1Data;

  /// No description provided for @step1DataDesc.
  ///
  /// In en, this message translates to:
  /// **'Add multiple converter cards to work with different data storage values simultaneously.'**
  String get step1DataDesc;

  /// No description provided for @step2Data.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Select Units'**
  String get step2Data;

  /// No description provided for @step2DataDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose which data storage units to display from bytes, kilobytes, gigabytes, and other systems.'**
  String get step2DataDesc;

  /// No description provided for @step3Data.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Enter Values'**
  String get step3Data;

  /// No description provided for @step3DataDesc.
  ///
  /// In en, this message translates to:
  /// **'Type any data storage value and see instant conversions to all other units.'**
  String get step3DataDesc;

  /// No description provided for @step4Data.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Organize Layout'**
  String get step4Data;

  /// No description provided for @step4DataDesc.
  ///
  /// In en, this message translates to:
  /// **'Drag cards to reorder, switch to table view, or use focus mode for distraction-free work.'**
  String get step4DataDesc;

  /// No description provided for @tip1Data.
  ///
  /// In en, this message translates to:
  /// **'• Byte (B) is the fundamental unit of digital information storage'**
  String get tip1Data;

  /// No description provided for @tip2Data.
  ///
  /// In en, this message translates to:
  /// **'• Kilobyte (KB), Megabyte (MB), Gigabyte (GB) are standard for file sizes'**
  String get tip2Data;

  /// No description provided for @tip3Data.
  ///
  /// In en, this message translates to:
  /// **'• Terabyte (TB) and Petabyte (PB) are used for large-scale storage systems'**
  String get tip3Data;

  /// No description provided for @tip4Data.
  ///
  /// In en, this message translates to:
  /// **'• Bit units (Kbit, Mbit, Gbit) are commonly used for network speeds'**
  String get tip4Data;

  /// No description provided for @tip5Data.
  ///
  /// In en, this message translates to:
  /// **'• Binary prefixes (1024-based) provide more accurate computer calculations'**
  String get tip5Data;

  /// No description provided for @tip6Data.
  ///
  /// In en, this message translates to:
  /// **'• Focus mode helps concentrate on complex data storage calculations'**
  String get tip6Data;

  /// No description provided for @dataUnitCategories.
  ///
  /// In en, this message translates to:
  /// **'Data Storage Unit Categories'**
  String get dataUnitCategories;

  /// No description provided for @dataCommonUnits.
  ///
  /// In en, this message translates to:
  /// **'Common Units'**
  String get dataCommonUnits;

  /// No description provided for @dataCommonUnitsDesc.
  ///
  /// In en, this message translates to:
  /// **'Kilobyte (KB), Megabyte (MB), Gigabyte (GB) - most frequently used storage units for everyday file sizes and device capacities.'**
  String get dataCommonUnitsDesc;

  /// No description provided for @dataLessCommonUnits.
  ///
  /// In en, this message translates to:
  /// **'Large Storage Units'**
  String get dataLessCommonUnits;

  /// No description provided for @dataLessCommonUnitsDesc.
  ///
  /// In en, this message translates to:
  /// **'Terabyte (TB), Petabyte (PB), and basic Byte (B) units for specialized storage applications and very large or very small data measurements.'**
  String get dataLessCommonUnitsDesc;

  /// No description provided for @dataRareUnits.
  ///
  /// In en, this message translates to:
  /// **'Network Units'**
  String get dataRareUnits;

  /// No description provided for @dataRareUnitsDesc.
  ///
  /// In en, this message translates to:
  /// **'Bit, Kilobit (Kbit), Megabit (Mbit), Gigabit (Gbit) are primarily used for network speeds and data transmission rates.'**
  String get dataRareUnitsDesc;

  /// No description provided for @dataPracticalApplicationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Helpful for understanding file sizes, storage needs, and basic data unit conversions.'**
  String get dataPracticalApplicationsDesc;

  /// No description provided for @dataConverterInfo.
  ///
  /// In en, this message translates to:
  /// **'Data Storage Converter Information'**
  String get dataConverterInfo;

  /// No description provided for @customizeDataUnits.
  ///
  /// In en, this message translates to:
  /// **'Customize Data Storage Units'**
  String get customizeDataUnits;

  /// No description provided for @selectDataUnits.
  ///
  /// In en, this message translates to:
  /// **'Select data storage units to display'**
  String get selectDataUnits;

  /// No description provided for @dataUnits.
  ///
  /// In en, this message translates to:
  /// **'Data Storage Units'**
  String get dataUnits;

  /// No description provided for @drafts.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get drafts;

  /// No description provided for @noDraftsYet.
  ///
  /// In en, this message translates to:
  /// **'No drafts yet'**
  String get noDraftsYet;

  /// No description provided for @createDraftsHint.
  ///
  /// In en, this message translates to:
  /// **'Drafts are temporary saves of your work. They\'re automatically created when you exit editing without saving.'**
  String get createDraftsHint;

  /// No description provided for @draftSaved.
  ///
  /// In en, this message translates to:
  /// **'Draft saved'**
  String get draftSaved;

  /// No description provided for @draftDeleted.
  ///
  /// In en, this message translates to:
  /// **'Draft deleted'**
  String get draftDeleted;

  /// No description provided for @saveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get saveDraft;

  /// No description provided for @stayHere.
  ///
  /// In en, this message translates to:
  /// **'Stay Here'**
  String get stayHere;

  /// No description provided for @exitWithoutSaving.
  ///
  /// In en, this message translates to:
  /// **'Exit Without Saving'**
  String get exitWithoutSaving;

  /// No description provided for @unsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get unsavedChanges;

  /// No description provided for @unsavedChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. What would you like to do?'**
  String get unsavedChangesMessage;

  /// No description provided for @continueDraft.
  ///
  /// In en, this message translates to:
  /// **'Continue Draft'**
  String get continueDraft;

  /// No description provided for @publishDraft.
  ///
  /// In en, this message translates to:
  /// **'Publish Draft'**
  String get publishDraft;

  /// No description provided for @deleteDraft.
  ///
  /// In en, this message translates to:
  /// **'Delete Draft'**
  String get deleteDraft;

  /// No description provided for @confirmDeleteDraft.
  ///
  /// In en, this message translates to:
  /// **'Delete Draft?'**
  String get confirmDeleteDraft;

  /// No description provided for @confirmDeleteDraftMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this draft? This action cannot be undone.'**
  String get confirmDeleteDraftMessage;

  /// No description provided for @draftPublished.
  ///
  /// In en, this message translates to:
  /// **'Draft published as template'**
  String get draftPublished;

  /// No description provided for @newDraft.
  ///
  /// In en, this message translates to:
  /// **'New Draft'**
  String get newDraft;

  /// No description provided for @editDraft.
  ///
  /// In en, this message translates to:
  /// **'Edit Draft'**
  String get editDraft;

  /// No description provided for @draftCreatedOn.
  ///
  /// In en, this message translates to:
  /// **'Created on {date}'**
  String draftCreatedOn(Object date);

  /// No description provided for @draftUpdatedOn.
  ///
  /// In en, this message translates to:
  /// **'Updated on {date}'**
  String draftUpdatedOn(Object date);

  /// No description provided for @autoSaved.
  ///
  /// In en, this message translates to:
  /// **'Auto-saved'**
  String get autoSaved;

  /// No description provided for @viewDrafts.
  ///
  /// In en, this message translates to:
  /// **'View Drafts'**
  String get viewDrafts;

  /// No description provided for @manageDrafts.
  ///
  /// In en, this message translates to:
  /// **'Manage Drafts'**
  String get manageDrafts;

  /// No description provided for @draftsExpireAfter.
  ///
  /// In en, this message translates to:
  /// **'Drafts expire after 7 days'**
  String get draftsExpireAfter;

  /// No description provided for @expiredDraft.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expiredDraft;

  /// No description provided for @draftCount.
  ///
  /// In en, this message translates to:
  /// **'{count} drafts'**
  String draftCount(Object count);

  /// No description provided for @graphingFunction.
  ///
  /// In en, this message translates to:
  /// **'f(x) = '**
  String get graphingFunction;

  /// No description provided for @enterFunction.
  ///
  /// In en, this message translates to:
  /// **'Enter function (e.g., x^2, sin(x), etc.)'**
  String get enterFunction;

  /// No description provided for @plot.
  ///
  /// In en, this message translates to:
  /// **'Plot'**
  String get plot;

  /// No description provided for @aspectRatio.
  ///
  /// In en, this message translates to:
  /// **'Aspect Ratio'**
  String get aspectRatio;

  /// No description provided for @aspectRatioXY.
  ///
  /// In en, this message translates to:
  /// **'Aspect Ratio (X:Y)'**
  String get aspectRatioXY;

  /// No description provided for @currentRatio.
  ///
  /// In en, this message translates to:
  /// **'Current ratio: {ratio}:1'**
  String currentRatio(String ratio);

  /// No description provided for @resetPlot.
  ///
  /// In en, this message translates to:
  /// **'Reset Plot'**
  String get resetPlot;

  /// No description provided for @resetZoom.
  ///
  /// In en, this message translates to:
  /// **'Reset Zoom'**
  String get resetZoom;

  /// No description provided for @zoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom In'**
  String get zoomIn;

  /// No description provided for @zoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom Out'**
  String get zoomOut;

  /// No description provided for @returnToCenter.
  ///
  /// In en, this message translates to:
  /// **'Return to Center'**
  String get returnToCenter;

  /// No description provided for @panning.
  ///
  /// In en, this message translates to:
  /// **'Panning'**
  String get panning;

  /// No description provided for @joystickControl.
  ///
  /// In en, this message translates to:
  /// **'Joystick Control'**
  String get joystickControl;

  /// No description provided for @enableJoystick.
  ///
  /// In en, this message translates to:
  /// **'Enable Joystick'**
  String get enableJoystick;

  /// No description provided for @disableJoystick.
  ///
  /// In en, this message translates to:
  /// **'Disable Joystick'**
  String get disableJoystick;

  /// No description provided for @joystickMode.
  ///
  /// In en, this message translates to:
  /// **'Joystick Mode'**
  String get joystickMode;

  /// No description provided for @joystickModeActive.
  ///
  /// In en, this message translates to:
  /// **'Joystick Mode Active'**
  String get joystickModeActive;

  /// No description provided for @useJoystickToNavigateGraph.
  ///
  /// In en, this message translates to:
  /// **'Use joystick to navigate the graph'**
  String get useJoystickToNavigateGraph;

  /// No description provided for @equalXYRatio.
  ///
  /// In en, this message translates to:
  /// **'Equal X:Y ratio'**
  String get equalXYRatio;

  /// No description provided for @yAxisWiderThanX.
  ///
  /// In en, this message translates to:
  /// **'Y-axis will be {ratio}× wider than X-axis'**
  String yAxisWiderThanX(String ratio);

  /// No description provided for @xAxisWiderThanY.
  ///
  /// In en, this message translates to:
  /// **'X-axis will be {ratio}× wider than Y-axis'**
  String xAxisWiderThanY(String ratio);

  /// No description provided for @invalidFunction.
  ///
  /// In en, this message translates to:
  /// **'Invalid function: {error}'**
  String invalidFunction(String error);

  /// No description provided for @enterFunctionToPlot.
  ///
  /// In en, this message translates to:
  /// **'Enter a function to plot'**
  String get enterFunctionToPlot;

  /// No description provided for @functionLabel.
  ///
  /// In en, this message translates to:
  /// **'Function {number}'**
  String functionLabel(int number);

  /// Button to confirm reset
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @graphPanel.
  ///
  /// In en, this message translates to:
  /// **'Graph'**
  String get graphPanel;

  /// No description provided for @functionsPanel.
  ///
  /// In en, this message translates to:
  /// **'Functions'**
  String get functionsPanel;

  /// No description provided for @historyPanel.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyPanel;

  /// No description provided for @activeFunctions.
  ///
  /// In en, this message translates to:
  /// **'Active Functions'**
  String get activeFunctions;

  /// No description provided for @noActiveFunctions.
  ///
  /// In en, this message translates to:
  /// **'No active functions'**
  String get noActiveFunctions;

  /// No description provided for @addFunction.
  ///
  /// In en, this message translates to:
  /// **'Add Function'**
  String get addFunction;

  /// No description provided for @removeFunction.
  ///
  /// In en, this message translates to:
  /// **'Remove Function'**
  String get removeFunction;

  /// No description provided for @toggleFunction.
  ///
  /// In en, this message translates to:
  /// **'Toggle Function'**
  String get toggleFunction;

  /// No description provided for @functionVisible.
  ///
  /// In en, this message translates to:
  /// **'Function visible'**
  String get functionVisible;

  /// No description provided for @functionHidden.
  ///
  /// In en, this message translates to:
  /// **'Function hidden'**
  String get functionHidden;

  /// No description provided for @functionInputHelp.
  ///
  /// In en, this message translates to:
  /// **'Function Input Help'**
  String get functionInputHelp;

  /// No description provided for @functionInputHelpDesc.
  ///
  /// In en, this message translates to:
  /// **'Get help with mathematical function syntax'**
  String get functionInputHelpDesc;

  /// No description provided for @commonFunctions.
  ///
  /// In en, this message translates to:
  /// **'Common Functions'**
  String get commonFunctions;

  /// No description provided for @polynomialFunctions.
  ///
  /// In en, this message translates to:
  /// **'Polynomial Functions'**
  String get polynomialFunctions;

  /// No description provided for @insertFunction.
  ///
  /// In en, this message translates to:
  /// **'Insert'**
  String get insertFunction;

  /// No description provided for @functionSyntaxError.
  ///
  /// In en, this message translates to:
  /// **'Invalid function syntax'**
  String get functionSyntaxError;

  /// No description provided for @functionSyntaxErrorDesc.
  ///
  /// In en, this message translates to:
  /// **'Please check your function syntax and try again'**
  String get functionSyntaxErrorDesc;

  /// No description provided for @advancedFunctions.
  ///
  /// In en, this message translates to:
  /// **'Advanced Functions'**
  String get advancedFunctions;

  /// No description provided for @askBeforeLoadingHistory.
  ///
  /// In en, this message translates to:
  /// **'Ask before loading history'**
  String get askBeforeLoadingHistory;

  /// No description provided for @askBeforeLoadingHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Show confirmation dialog when loading function groups from history'**
  String get askBeforeLoadingHistoryDesc;

  /// No description provided for @rememberCalculationHistory.
  ///
  /// In en, this message translates to:
  /// **'Remember calculation history'**
  String get rememberCalculationHistory;

  /// No description provided for @rememberCalculationHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Save function groups to history for later use'**
  String get rememberCalculationHistoryDesc;

  /// No description provided for @saveCurrentToHistory.
  ///
  /// In en, this message translates to:
  /// **'Save current group to history'**
  String get saveCurrentToHistory;

  /// No description provided for @loadHistoryGroup.
  ///
  /// In en, this message translates to:
  /// **'Load History Group'**
  String get loadHistoryGroup;

  /// No description provided for @saveCurrentGroupQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to save the current function group to history?'**
  String get saveCurrentGroupQuestion;

  /// No description provided for @dontAskAgain.
  ///
  /// In en, this message translates to:
  /// **'Don\'t ask again'**
  String get dontAskAgain;

  /// No description provided for @rememberChoice.
  ///
  /// In en, this message translates to:
  /// **'Remember choice'**
  String get rememberChoice;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

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

  /// No description provided for @functionGroup.
  ///
  /// In en, this message translates to:
  /// **'Function Group'**
  String get functionGroup;

  /// No description provided for @savedOn.
  ///
  /// In en, this message translates to:
  /// **'Saved on {date}'**
  String savedOn(String date);

  /// No description provided for @functionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} functions'**
  String functionsCount(int count);

  /// No description provided for @editFunctionColor.
  ///
  /// In en, this message translates to:
  /// **'Edit function color'**
  String get editFunctionColor;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get selectColor;

  /// No description provided for @noHistoryAvailable.
  ///
  /// In en, this message translates to:
  /// **'No history available'**
  String get noHistoryAvailable;

  /// No description provided for @removeFromHistory.
  ///
  /// In en, this message translates to:
  /// **'Remove from history'**
  String get removeFromHistory;

  /// No description provided for @selectedColor.
  ///
  /// In en, this message translates to:
  /// **'Selected Color'**
  String get selectedColor;

  /// No description provided for @predefinedColors.
  ///
  /// In en, this message translates to:
  /// **'Predefined Colors'**
  String get predefinedColors;

  /// No description provided for @customColor.
  ///
  /// In en, this message translates to:
  /// **'Custom Color'**
  String get customColor;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @hue.
  ///
  /// In en, this message translates to:
  /// **'Hue'**
  String get hue;

  /// No description provided for @saturation.
  ///
  /// In en, this message translates to:
  /// **'Saturation'**
  String get saturation;

  /// No description provided for @lightness.
  ///
  /// In en, this message translates to:
  /// **'Lightness'**
  String get lightness;

  /// No description provided for @debugCache.
  ///
  /// In en, this message translates to:
  /// **'Debug Cache'**
  String get debugCache;

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

  /// No description provided for @mobileCacheDebug.
  ///
  /// In en, this message translates to:
  /// **'Mobile Cache Debug'**
  String get mobileCacheDebug;

  /// No description provided for @runningCacheDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Running cache diagnostics...'**
  String get runningCacheDiagnostics;

  /// No description provided for @cacheDiagnosticsResults.
  ///
  /// In en, this message translates to:
  /// **'Cache Diagnostics Results'**
  String get cacheDiagnosticsResults;

  /// No description provided for @cacheStatus.
  ///
  /// In en, this message translates to:
  /// **'Cache Status:'**
  String get cacheStatus;

  /// No description provided for @reliability.
  ///
  /// In en, this message translates to:
  /// **'Reliability'**
  String get reliability;

  /// No description provided for @reliable.
  ///
  /// In en, this message translates to:
  /// **'Reliable'**
  String get reliable;

  /// No description provided for @unreliable.
  ///
  /// In en, this message translates to:
  /// **'Unreliable'**
  String get unreliable;

  /// No description provided for @hasCache.
  ///
  /// In en, this message translates to:
  /// **'Has Cache'**
  String get hasCache;

  /// No description provided for @currencyState.
  ///
  /// In en, this message translates to:
  /// **'Currency State'**
  String get currencyState;

  /// No description provided for @lengthState.
  ///
  /// In en, this message translates to:
  /// **'Length State'**
  String get lengthState;

  /// No description provided for @timeState.
  ///
  /// In en, this message translates to:
  /// **'Time State'**
  String get timeState;

  /// No description provided for @defaultState.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultState;

  /// Generic error message with details
  ///
  /// In en, this message translates to:
  /// **'Error: {details}'**
  String errorWithDetails(String details);

  /// No description provided for @stateLoadingIssuesDetected.
  ///
  /// In en, this message translates to:
  /// **'⚠️ State Loading Issues Detected'**
  String get stateLoadingIssuesDetected;

  /// No description provided for @stateLoadingIssuesDesc.
  ///
  /// In en, this message translates to:
  /// **'This usually happens after app updates that change data structure.'**
  String get stateLoadingIssuesDesc;

  /// No description provided for @clearAllStateData.
  ///
  /// In en, this message translates to:
  /// **'Clear All State Data'**
  String get clearAllStateData;

  /// No description provided for @clearingStateData.
  ///
  /// In en, this message translates to:
  /// **'Clearing all converter state data...'**
  String get clearingStateData;

  /// No description provided for @clearingAllConverterStateData.
  ///
  /// In en, this message translates to:
  /// **'Clearing all converter state data...'**
  String get clearingAllConverterStateData;

  /// No description provided for @allStateDataCleared.
  ///
  /// In en, this message translates to:
  /// **'All state data has been cleared. The app will restart to complete the process.'**
  String get allStateDataCleared;

  /// Error message when diagnostics fail
  ///
  /// In en, this message translates to:
  /// **'Failed to run diagnostics: {error}'**
  String failedToRunDiagnostics(String error);

  /// Error message when clearing state data fails
  ///
  /// In en, this message translates to:
  /// **'Failed to clear state data: {error}'**
  String failedToClearStateData(String error);

  /// No description provided for @stateDataClearedSuccess.
  ///
  /// In en, this message translates to:
  /// **'All state data has been cleared. The app will restart to complete the process.'**
  String get stateDataClearedSuccess;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @bmiUnderweightInterpretation.
  ///
  /// In en, this message translates to:
  /// **'Your BMI indicates that you are underweight. This may suggest you need to gain weight for optimal health.'**
  String get bmiUnderweightInterpretation;

  /// No description provided for @bmiElderlyNote.
  ///
  /// In en, this message translates to:
  /// **'For adults over 65, slightly higher BMI ranges (22-27) may be acceptable and protective.'**
  String get bmiElderlyNote;

  /// No description provided for @bmiYouthNote.
  ///
  /// In en, this message translates to:
  /// **'For individuals under 20, BMI should be evaluated using age and gender-specific percentile charts.'**
  String get bmiYouthNote;

  /// No description provided for @bmiLimitationReminder.
  ///
  /// In en, this message translates to:
  /// **'Remember: BMI is a screening tool and doesn\'t account for muscle mass, bone density, or body composition.'**
  String get bmiLimitationReminder;

  /// No description provided for @bmiElderlyRec.
  ///
  /// In en, this message translates to:
  /// **'As an older adult, focus on maintaining muscle mass through resistance training and adequate protein intake.'**
  String get bmiElderlyRec;

  /// No description provided for @bmiYouthRec.
  ///
  /// In en, this message translates to:
  /// **'For young adults, focus on establishing healthy eating patterns and regular physical activity habits.'**
  String get bmiYouthRec;

  /// No description provided for @bmiFemaleRec.
  ///
  /// In en, this message translates to:
  /// **'Women of reproductive age should ensure adequate nutrition, especially iron and calcium intake.'**
  String get bmiFemaleRec;

  /// No description provided for @bmiConsultationRec.
  ///
  /// In en, this message translates to:
  /// **'Consider consulting with healthcare professionals for personalized health assessment and guidance.'**
  String get bmiConsultationRec;

  /// No description provided for @bmiFormula.
  ///
  /// In en, this message translates to:
  /// **'BMI = Weight (kg) / [Height (m)]²'**
  String get bmiFormula;

  /// No description provided for @bmiLimitation1.
  ///
  /// In en, this message translates to:
  /// **'Does not reflect body composition (muscle vs. fat ratio)'**
  String get bmiLimitation1;

  /// No description provided for @bmiLimitation2.
  ///
  /// In en, this message translates to:
  /// **'May not be accurate for athletes, elderly, or certain ethnic groups'**
  String get bmiLimitation2;

  /// No description provided for @bmiLimitation3.
  ///
  /// In en, this message translates to:
  /// **'Does not assess other health factors like blood pressure, cholesterol, or blood sugar'**
  String get bmiLimitation3;

  /// No description provided for @bmiLimitation4.
  ///
  /// In en, this message translates to:
  /// **'Not suitable for pregnant women, children under 18, or individuals with certain medical conditions'**
  String get bmiLimitation4;

  /// No description provided for @bmiConsult1.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive health checkups and necessary tests'**
  String get bmiConsult1;

  /// No description provided for @bmiConsult2.
  ///
  /// In en, this message translates to:
  /// **'Professional medical consultation and guidance'**
  String get bmiConsult2;

  /// No description provided for @bmiConsult3.
  ///
  /// In en, this message translates to:
  /// **'Personalized care recommendations from healthcare specialists'**
  String get bmiConsult3;

  /// No description provided for @bmiPediatricTitle.
  ///
  /// In en, this message translates to:
  /// **'BMI Classification for Children and Adolescents (Under 18)'**
  String get bmiPediatricTitle;

  /// No description provided for @bmiAdultTitle.
  ///
  /// In en, this message translates to:
  /// **'BMI Classification for Adults (18 and Over)'**
  String get bmiAdultTitle;

  /// No description provided for @bmiPercentileNote.
  ///
  /// In en, this message translates to:
  /// **'Based on CDC growth charts with age and gender-specific percentiles'**
  String get bmiPercentileNote;

  /// No description provided for @bmiPercentileUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Below 5th percentile'**
  String get bmiPercentileUnderweight;

  /// No description provided for @bmiPercentileNormal.
  ///
  /// In en, this message translates to:
  /// **'5th to 85th percentile'**
  String get bmiPercentileNormal;

  /// No description provided for @bmiPediatricInterpretation.
  ///
  /// In en, this message translates to:
  /// **'Your BMI percentile is {percentile} for your age and gender. This indicates {category}.'**
  String bmiPediatricInterpretation(Object category, Object percentile);

  /// No description provided for @bmiPediatricNote.
  ///
  /// In en, this message translates to:
  /// **'For children and adolescents, BMI is compared to others of the same age and gender using percentile charts.'**
  String get bmiPediatricNote;

  /// No description provided for @bmiGrowthPattern.
  ///
  /// In en, this message translates to:
  /// **'Consult with pediatrician to evaluate growth patterns and overall health.'**
  String get bmiGrowthPattern;

  /// No description provided for @ageYears.
  ///
  /// In en, this message translates to:
  /// **'Age (years)'**
  String get ageYears;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @bmiCalculatorTab.
  ///
  /// In en, this message translates to:
  /// **'Calculator'**
  String get bmiCalculatorTab;

  /// No description provided for @bmiHistoryTab.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get bmiHistoryTab;

  /// No description provided for @bmiDetailedInfo.
  ///
  /// In en, this message translates to:
  /// **'BMI Calculator Information'**
  String get bmiDetailedInfo;

  /// No description provided for @bmiOverview.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive Body Mass Index calculator with health insights and recommendations'**
  String get bmiOverview;

  /// No description provided for @financialCalculator.
  ///
  /// In en, this message translates to:
  /// **'Financial Calculator'**
  String get financialCalculator;

  /// No description provided for @financialCalculatorDesc.
  ///
  /// In en, this message translates to:
  /// **'Advanced financial calculations for loans, investments, and compound interest'**
  String get financialCalculatorDesc;

  /// No description provided for @financialCalculatorDetailedInfo.
  ///
  /// In en, this message translates to:
  /// **'Financial Calculator Information'**
  String get financialCalculatorDetailedInfo;

  /// No description provided for @financialCalculatorOverview.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive financial calculator for loan payments, investment planning, and compound interest calculations'**
  String get financialCalculatorOverview;

  /// No description provided for @loanCalculator.
  ///
  /// In en, this message translates to:
  /// **'Loan Calculator'**
  String get loanCalculator;

  /// No description provided for @investmentCalculator.
  ///
  /// In en, this message translates to:
  /// **'Investment Calculator'**
  String get investmentCalculator;

  /// No description provided for @compoundInterestCalculator.
  ///
  /// In en, this message translates to:
  /// **'Compound Interest Calculator'**
  String get compoundInterestCalculator;

  /// No description provided for @loanAmount.
  ///
  /// In en, this message translates to:
  /// **'Loan Amount (\$)'**
  String get loanAmount;

  /// No description provided for @loanAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter loan amount'**
  String get loanAmountHint;

  /// No description provided for @annualInterestRate.
  ///
  /// In en, this message translates to:
  /// **'Annual Interest Rate (%)'**
  String get annualInterestRate;

  /// No description provided for @annualInterestRateHint.
  ///
  /// In en, this message translates to:
  /// **'Enter interest rate'**
  String get annualInterestRateHint;

  /// No description provided for @loanTerm.
  ///
  /// In en, this message translates to:
  /// **'Loan Term (years)'**
  String get loanTerm;

  /// No description provided for @loanTermHint.
  ///
  /// In en, this message translates to:
  /// **'Enter loan term'**
  String get loanTermHint;

  /// No description provided for @calculateLoan.
  ///
  /// In en, this message translates to:
  /// **'Calculate Loan'**
  String get calculateLoan;

  /// No description provided for @initialInvestment.
  ///
  /// In en, this message translates to:
  /// **'Initial Investment (\$)'**
  String get initialInvestment;

  /// No description provided for @initialInvestmentHint.
  ///
  /// In en, this message translates to:
  /// **'Enter initial amount'**
  String get initialInvestmentHint;

  /// No description provided for @monthlyContribution.
  ///
  /// In en, this message translates to:
  /// **'Monthly Contribution (\$)'**
  String get monthlyContribution;

  /// No description provided for @monthlyContributionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter monthly contribution'**
  String get monthlyContributionHint;

  /// No description provided for @annualReturn.
  ///
  /// In en, this message translates to:
  /// **'Annual Return (%)'**
  String get annualReturn;

  /// No description provided for @annualReturnHint.
  ///
  /// In en, this message translates to:
  /// **'Enter expected return'**
  String get annualReturnHint;

  /// No description provided for @investmentPeriod.
  ///
  /// In en, this message translates to:
  /// **'Investment Period (years)'**
  String get investmentPeriod;

  /// No description provided for @investmentPeriodHint.
  ///
  /// In en, this message translates to:
  /// **'Enter investment period'**
  String get investmentPeriodHint;

  /// No description provided for @calculateInvestment.
  ///
  /// In en, this message translates to:
  /// **'Calculate Investment'**
  String get calculateInvestment;

  /// No description provided for @principalAmount.
  ///
  /// In en, this message translates to:
  /// **'Principal Amount (\$)'**
  String get principalAmount;

  /// No description provided for @principalAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter principal amount'**
  String get principalAmountHint;

  /// No description provided for @timePeriod.
  ///
  /// In en, this message translates to:
  /// **'Time Period (years)'**
  String get timePeriod;

  /// No description provided for @timePeriodHint.
  ///
  /// In en, this message translates to:
  /// **'Enter time period'**
  String get timePeriodHint;

  /// No description provided for @compoundingFrequency.
  ///
  /// In en, this message translates to:
  /// **'Compounding Frequency (per year)'**
  String get compoundingFrequency;

  /// No description provided for @compoundingFrequencyHint.
  ///
  /// In en, this message translates to:
  /// **'Enter frequency (12 for monthly)'**
  String get compoundingFrequencyHint;

  /// No description provided for @calculateCompoundInterest.
  ///
  /// In en, this message translates to:
  /// **'Calculate Compound Interest'**
  String get calculateCompoundInterest;

  /// No description provided for @monthlyPayment.
  ///
  /// In en, this message translates to:
  /// **'Monthly Payment'**
  String get monthlyPayment;

  /// No description provided for @totalPayment.
  ///
  /// In en, this message translates to:
  /// **'Total Payment'**
  String get totalPayment;

  /// No description provided for @totalInterest.
  ///
  /// In en, this message translates to:
  /// **'Total Interest'**
  String get totalInterest;

  /// No description provided for @futureValue.
  ///
  /// In en, this message translates to:
  /// **'Future Value'**
  String get futureValue;

  /// No description provided for @totalContributions.
  ///
  /// In en, this message translates to:
  /// **'Total Contributions'**
  String get totalContributions;

  /// No description provided for @totalEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get totalEarnings;

  /// No description provided for @finalAmount.
  ///
  /// In en, this message translates to:
  /// **'Final Amount'**
  String get finalAmount;

  /// No description provided for @interestEarned.
  ///
  /// In en, this message translates to:
  /// **'Interest Earned'**
  String get interestEarned;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @financialHistory.
  ///
  /// In en, this message translates to:
  /// **'Financial History'**
  String get financialHistory;

  /// No description provided for @historyTab.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTab;

  /// No description provided for @loanTab.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get loanTab;

  /// No description provided for @investmentTab.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get investmentTab;

  /// No description provided for @compoundTab.
  ///
  /// In en, this message translates to:
  /// **'Compound'**
  String get compoundTab;

  /// No description provided for @inputError.
  ///
  /// In en, this message translates to:
  /// **'Input Error'**
  String get inputError;

  /// No description provided for @pleaseEnterValidNumbers.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid positive numbers for all fields.'**
  String get pleaseEnterValidNumbers;

  /// No description provided for @pleaseEnterValidReturnAndTerm.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid positive numbers for return rate and term.'**
  String get pleaseEnterValidReturnAndTerm;

  /// No description provided for @financialCalculationHistory.
  ///
  /// In en, this message translates to:
  /// **'Financial calculation history and saved calculations'**
  String get financialCalculationHistory;

  /// No description provided for @financialHistoryCleared.
  ///
  /// In en, this message translates to:
  /// **'Financial history cleared'**
  String get financialHistoryCleared;

  /// No description provided for @confirmClearFinancialHistory.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all financial calculation history?'**
  String get confirmClearFinancialHistory;

  /// No description provided for @loanCalculationSaved.
  ///
  /// In en, this message translates to:
  /// **'Loan calculation saved to history'**
  String get loanCalculationSaved;

  /// No description provided for @investmentCalculationSaved.
  ///
  /// In en, this message translates to:
  /// **'Investment calculation saved to history'**
  String get investmentCalculationSaved;

  /// No description provided for @compoundCalculationSaved.
  ///
  /// In en, this message translates to:
  /// **'Compound interest calculation saved to history'**
  String get compoundCalculationSaved;

  /// No description provided for @restoreCalculation.
  ///
  /// In en, this message translates to:
  /// **'Restore Calculation'**
  String get restoreCalculation;

  /// No description provided for @copyResult.
  ///
  /// In en, this message translates to:
  /// **'Copy Result'**
  String get copyResult;

  /// No description provided for @copyInputs.
  ///
  /// In en, this message translates to:
  /// **'Copy Inputs'**
  String get copyInputs;

  /// No description provided for @removeFromFinancialHistory.
  ///
  /// In en, this message translates to:
  /// **'Remove from history'**
  String get removeFromFinancialHistory;

  /// No description provided for @financialCalculationDate.
  ///
  /// In en, this message translates to:
  /// **'Calculated on {date}'**
  String financialCalculationDate(String date);

  /// No description provided for @noFinancialHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No calculations yet'**
  String get noFinancialHistoryYet;

  /// No description provided for @startCalculatingHint.
  ///
  /// In en, this message translates to:
  /// **'Start making financial calculations to see them here'**
  String get startCalculatingHint;

  /// No description provided for @financialResultsSummary.
  ///
  /// In en, this message translates to:
  /// **'{type}: {result}'**
  String financialResultsSummary(String type, String result);

  /// No description provided for @saveToFinancialHistory.
  ///
  /// In en, this message translates to:
  /// **'Save to history'**
  String get saveToFinancialHistory;

  /// No description provided for @financialCalculationTypes.
  ///
  /// In en, this message translates to:
  /// **'Financial Calculation Types'**
  String get financialCalculationTypes;

  /// No description provided for @loanCalculationDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate monthly payments, total cost, and interest for loans'**
  String get loanCalculationDesc;

  /// No description provided for @investmentCalculationDesc.
  ///
  /// In en, this message translates to:
  /// **'Plan future value of investments with regular contributions'**
  String get investmentCalculationDesc;

  /// No description provided for @compoundInterestDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate compound interest growth over time'**
  String get compoundInterestDesc;

  /// No description provided for @practicalFinancialApplications.
  ///
  /// In en, this message translates to:
  /// **'Practical Applications'**
  String get practicalFinancialApplications;

  /// No description provided for @financialApplicationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Mortgage planning, auto loans, retirement savings, education funding, business investments, and general financial planning.'**
  String get financialApplicationsDesc;

  /// No description provided for @financialTips.
  ///
  /// In en, this message translates to:
  /// **'Financial Tips'**
  String get financialTips;

  /// No description provided for @financialTip1.
  ///
  /// In en, this message translates to:
  /// **'Compare different loan terms to find the best option'**
  String get financialTip1;

  /// No description provided for @financialTip2.
  ///
  /// In en, this message translates to:
  /// **'Start investing early to maximize compound interest'**
  String get financialTip2;

  /// No description provided for @financialTip3.
  ///
  /// In en, this message translates to:
  /// **'Consider additional payments to reduce loan interest'**
  String get financialTip3;

  /// No description provided for @financialTip4.
  ///
  /// In en, this message translates to:
  /// **'Regular contributions can significantly boost investment growth'**
  String get financialTip4;

  /// No description provided for @financialTip5.
  ///
  /// In en, this message translates to:
  /// **'Higher compounding frequency increases returns'**
  String get financialTip5;

  /// No description provided for @selectedDate.
  ///
  /// In en, this message translates to:
  /// **'Selected Date'**
  String get selectedDate;

  /// No description provided for @weekdayName.
  ///
  /// In en, this message translates to:
  /// **'Day of Week'**
  String get weekdayName;

  /// No description provided for @dayInMonth.
  ///
  /// In en, this message translates to:
  /// **'Day in Month'**
  String get dayInMonth;

  /// No description provided for @dayInYear.
  ///
  /// In en, this message translates to:
  /// **'Day in Year'**
  String get dayInYear;

  /// No description provided for @weekInMonth.
  ///
  /// In en, this message translates to:
  /// **'Week in Month'**
  String get weekInMonth;

  /// No description provided for @weekInYear.
  ///
  /// In en, this message translates to:
  /// **'Week in Year'**
  String get weekInYear;

  /// No description provided for @monthName.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get monthName;

  /// No description provided for @monthOfYear.
  ///
  /// In en, this message translates to:
  /// **'Month Of Year'**
  String get monthOfYear;

  /// No description provided for @yearValue.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearValue;

  /// No description provided for @quarter.
  ///
  /// In en, this message translates to:
  /// **'Quarter'**
  String get quarter;

  /// No description provided for @quarterOfYear.
  ///
  /// In en, this message translates to:
  /// **'Quarter Of Year'**
  String get quarterOfYear;

  /// No description provided for @isLeapYear.
  ///
  /// In en, this message translates to:
  /// **'Leap Year'**
  String get isLeapYear;

  /// No description provided for @daysInMonth.
  ///
  /// In en, this message translates to:
  /// **'Days in Month'**
  String get daysInMonth;

  /// No description provided for @daysInYear.
  ///
  /// In en, this message translates to:
  /// **'Days in Year'**
  String get daysInYear;

  /// No description provided for @dateInfoResults.
  ///
  /// In en, this message translates to:
  /// **'Date Information Results'**
  String get dateInfoResults;

  /// Quarter number format
  ///
  /// In en, this message translates to:
  /// **'Q{number}'**
  String quarterValue(int number);

  /// Leap year status
  ///
  /// In en, this message translates to:
  /// **'{status}'**
  String leapYearStatus(String status);

  /// No description provided for @dateDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get dateDistance;

  /// No description provided for @dateCalculatorInfoHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Date Calculator Information'**
  String get dateCalculatorInfoHeaderTitle;

  /// No description provided for @dateCalculatorInfoHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A powerful tool for all your date and time calculations.'**
  String get dateCalculatorInfoHeaderSubtitle;

  /// No description provided for @dateCalculatorMainFeatures.
  ///
  /// In en, this message translates to:
  /// **'Main Features'**
  String get dateCalculatorMainFeatures;

  /// No description provided for @dateCalculatorUsage.
  ///
  /// In en, this message translates to:
  /// **'How to Use'**
  String get dateCalculatorUsage;

  /// No description provided for @dateCalculatorDetailedInfo.
  ///
  /// In en, this message translates to:
  /// **'Date Calculator Information'**
  String get dateCalculatorDetailedInfo;

  /// No description provided for @dateCalculatorOverview.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive tool for all date, time, and age calculations with many useful features'**
  String get dateCalculatorOverview;

  /// No description provided for @dateKeyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get dateKeyFeatures;

  /// No description provided for @comprehensiveDateCalc.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive Calculations'**
  String get comprehensiveDateCalc;

  /// No description provided for @comprehensiveDateCalcDesc.
  ///
  /// In en, this message translates to:
  /// **'Full support for date, time, and age calculations'**
  String get comprehensiveDateCalcDesc;

  /// No description provided for @multipleCalculationModes.
  ///
  /// In en, this message translates to:
  /// **'Multiple Calculation Modes'**
  String get multipleCalculationModes;

  /// No description provided for @multipleCalculationModesDesc.
  ///
  /// In en, this message translates to:
  /// **'4 different modes: date info, date difference, add/subtract dates, age calculation'**
  String get multipleCalculationModesDesc;

  /// No description provided for @detailedDateInfo.
  ///
  /// In en, this message translates to:
  /// **'Detailed Information'**
  String get detailedDateInfo;

  /// No description provided for @detailedDateInfoDesc.
  ///
  /// In en, this message translates to:
  /// **'Display complete date information: weekday, week, quarter, leap year'**
  String get detailedDateInfoDesc;

  /// No description provided for @flexibleDateInput.
  ///
  /// In en, this message translates to:
  /// **'Flexible Input'**
  String get flexibleDateInput;

  /// No description provided for @flexibleDateInputDesc.
  ///
  /// In en, this message translates to:
  /// **'Support multiple ways to input dates with easy adjustments'**
  String get flexibleDateInputDesc;

  /// No description provided for @dateHowToUse.
  ///
  /// In en, this message translates to:
  /// **'How to Use'**
  String get dateHowToUse;

  /// No description provided for @step1Date.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Select calculation mode'**
  String get step1Date;

  /// No description provided for @step1DateDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose appropriate tab: Date Info, Date Difference, Add/Subtract Date, or Age Calculator'**
  String get step1DateDesc;

  /// No description provided for @step2Date.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Input dates'**
  String get step2Date;

  /// No description provided for @step2DateDesc.
  ///
  /// In en, this message translates to:
  /// **'Use date picker or stepper to input the dates for calculation'**
  String get step2DateDesc;

  /// No description provided for @step3Date.
  ///
  /// In en, this message translates to:
  /// **'Step 3: View results'**
  String get step3Date;

  /// No description provided for @step3DateDesc.
  ///
  /// In en, this message translates to:
  /// **'Results will be displayed immediately with detailed information'**
  String get step3DateDesc;

  /// No description provided for @step4Date.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Save to history'**
  String get step4Date;

  /// No description provided for @step4DateDesc.
  ///
  /// In en, this message translates to:
  /// **'Results are automatically saved to history for future reference'**
  String get step4DateDesc;

  /// No description provided for @dateCalculationModes.
  ///
  /// In en, this message translates to:
  /// **'Calculation Modes'**
  String get dateCalculationModes;

  /// No description provided for @dateInfoMode.
  ///
  /// In en, this message translates to:
  /// **'Date Information'**
  String get dateInfoMode;

  /// No description provided for @dateInfoModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Display detailed information about a specific date'**
  String get dateInfoModeDesc;

  /// No description provided for @dateDifferenceMode.
  ///
  /// In en, this message translates to:
  /// **'Date Difference'**
  String get dateDifferenceMode;

  /// No description provided for @dateDifferenceModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate the difference between any two dates'**
  String get dateDifferenceModeDesc;

  /// No description provided for @addSubtractMode.
  ///
  /// In en, this message translates to:
  /// **'Add/Subtract Date'**
  String get addSubtractMode;

  /// No description provided for @addSubtractModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Add or subtract days/months/years from a date'**
  String get addSubtractModeDesc;

  /// No description provided for @ageCalculatorMode.
  ///
  /// In en, this message translates to:
  /// **'Age Calculator'**
  String get ageCalculatorMode;

  /// No description provided for @ageCalculatorModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate exact age from birth date to present or another date'**
  String get ageCalculatorModeDesc;

  /// No description provided for @dateTips.
  ///
  /// In en, this message translates to:
  /// **'Usage Tips'**
  String get dateTips;

  /// No description provided for @dateTip1.
  ///
  /// In en, this message translates to:
  /// **'Use date picker to select dates quickly'**
  String get dateTip1;

  /// No description provided for @dateTip2.
  ///
  /// In en, this message translates to:
  /// **'Use stepper to adjust individual date/month/year components'**
  String get dateTip2;

  /// No description provided for @dateTip3.
  ///
  /// In en, this message translates to:
  /// **'Check history to review previous calculations'**
  String get dateTip3;

  /// No description provided for @dateTip4.
  ///
  /// In en, this message translates to:
  /// **'Pay attention to leap years when calculating long periods'**
  String get dateTip4;

  /// No description provided for @dateTip5.
  ///
  /// In en, this message translates to:
  /// **'Use date info mode to check weekday of important dates'**
  String get dateTip5;

  /// No description provided for @dateLimitations.
  ///
  /// In en, this message translates to:
  /// **'Important Notes'**
  String get dateLimitations;

  /// No description provided for @dateLimitationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Some important points to consider when using the date calculator:'**
  String get dateLimitationsDesc;

  /// No description provided for @dateLimitation1.
  ///
  /// In en, this message translates to:
  /// **'Results are based on the Gregorian calendar'**
  String get dateLimitation1;

  /// No description provided for @dateLimitation2.
  ///
  /// In en, this message translates to:
  /// **'Does not account for time zones in calculations'**
  String get dateLimitation2;

  /// No description provided for @dateLimitation3.
  ///
  /// In en, this message translates to:
  /// **'Leap years are calculated according to international standards'**
  String get dateLimitation3;

  /// No description provided for @dateLimitation4.
  ///
  /// In en, this message translates to:
  /// **'Results may differ from other calendar systems'**
  String get dateLimitation4;

  /// No description provided for @dateLimitation5.
  ///
  /// In en, this message translates to:
  /// **'Should double-check results for important calculations'**
  String get dateLimitation5;

  /// No description provided for @dateDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This tool provides date information based on the standard Gregorian calendar. Results are for reference only and may require additional verification for important applications.'**
  String get dateDisclaimer;

  /// No description provided for @discountCalculator.
  ///
  /// In en, this message translates to:
  /// **'Discount Calculator'**
  String get discountCalculator;

  /// No description provided for @discountCalculatorDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate discounts, tips, taxes, and markups quickly and accurately'**
  String get discountCalculatorDesc;

  /// No description provided for @discountTab.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discountTab;

  /// No description provided for @tipTab.
  ///
  /// In en, this message translates to:
  /// **'Tip'**
  String get tipTab;

  /// No description provided for @taxTab.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get taxTab;

  /// No description provided for @markupTab.
  ///
  /// In en, this message translates to:
  /// **'Markup'**
  String get markupTab;

  /// No description provided for @originalPrice.
  ///
  /// In en, this message translates to:
  /// **'Original Price (\$)'**
  String get originalPrice;

  /// No description provided for @enterOriginalPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter original price'**
  String get enterOriginalPrice;

  /// No description provided for @discountPercent.
  ///
  /// In en, this message translates to:
  /// **'Discount Percent (%)'**
  String get discountPercent;

  /// No description provided for @enterDiscountPercent.
  ///
  /// In en, this message translates to:
  /// **'Enter discount percent'**
  String get enterDiscountPercent;

  /// No description provided for @discountAmount.
  ///
  /// In en, this message translates to:
  /// **'Discount Amount'**
  String get discountAmount;

  /// No description provided for @finalPrice.
  ///
  /// In en, this message translates to:
  /// **'Final Price'**
  String get finalPrice;

  /// No description provided for @savedAmount.
  ///
  /// In en, this message translates to:
  /// **'Saved Amount'**
  String get savedAmount;

  /// No description provided for @billAmount.
  ///
  /// In en, this message translates to:
  /// **'Bill Amount (\$)'**
  String get billAmount;

  /// No description provided for @enterBillAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter bill amount'**
  String get enterBillAmount;

  /// No description provided for @tipPercent.
  ///
  /// In en, this message translates to:
  /// **'Tip Percent (%)'**
  String get tipPercent;

  /// No description provided for @enterTipPercent.
  ///
  /// In en, this message translates to:
  /// **'Enter tip percent'**
  String get enterTipPercent;

  /// No description provided for @numberOfPeople.
  ///
  /// In en, this message translates to:
  /// **'Number of People'**
  String get numberOfPeople;

  /// No description provided for @enterNumberOfPeople.
  ///
  /// In en, this message translates to:
  /// **'Enter number of people'**
  String get enterNumberOfPeople;

  /// No description provided for @tipAmount.
  ///
  /// In en, this message translates to:
  /// **'Tip Amount'**
  String get tipAmount;

  /// No description provided for @totalBill.
  ///
  /// In en, this message translates to:
  /// **'Total Bill'**
  String get totalBill;

  /// No description provided for @perPersonAmount.
  ///
  /// In en, this message translates to:
  /// **'Per Person Amount'**
  String get perPersonAmount;

  /// No description provided for @priceBeforeTax.
  ///
  /// In en, this message translates to:
  /// **'Price Before Tax (\$)'**
  String get priceBeforeTax;

  /// No description provided for @enterPriceBeforeTax.
  ///
  /// In en, this message translates to:
  /// **'Enter price before tax'**
  String get enterPriceBeforeTax;

  /// No description provided for @taxRate.
  ///
  /// In en, this message translates to:
  /// **'Tax Rate (%)'**
  String get taxRate;

  /// No description provided for @enterTaxRate.
  ///
  /// In en, this message translates to:
  /// **'Enter tax rate'**
  String get enterTaxRate;

  /// No description provided for @taxAmount.
  ///
  /// In en, this message translates to:
  /// **'Tax Amount'**
  String get taxAmount;

  /// No description provided for @priceAfterTax.
  ///
  /// In en, this message translates to:
  /// **'Price After Tax'**
  String get priceAfterTax;

  /// No description provided for @costPrice.
  ///
  /// In en, this message translates to:
  /// **'Cost Price (\$)'**
  String get costPrice;

  /// No description provided for @enterCostPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter cost price'**
  String get enterCostPrice;

  /// No description provided for @markupPercent.
  ///
  /// In en, this message translates to:
  /// **'Markup Percent (%)'**
  String get markupPercent;

  /// No description provided for @enterMarkupPercent.
  ///
  /// In en, this message translates to:
  /// **'Enter markup percent'**
  String get enterMarkupPercent;

  /// No description provided for @markupAmount.
  ///
  /// In en, this message translates to:
  /// **'Markup Amount'**
  String get markupAmount;

  /// No description provided for @sellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling Price'**
  String get sellingPrice;

  /// No description provided for @profitMargin.
  ///
  /// In en, this message translates to:
  /// **'Profit Margin (%)'**
  String get profitMargin;

  /// No description provided for @calculateDiscount.
  ///
  /// In en, this message translates to:
  /// **'Calculate Discount'**
  String get calculateDiscount;

  /// No description provided for @calculateTip.
  ///
  /// In en, this message translates to:
  /// **'Calculate Tip'**
  String get calculateTip;

  /// No description provided for @calculateTax.
  ///
  /// In en, this message translates to:
  /// **'Calculate Tax'**
  String get calculateTax;

  /// No description provided for @calculateMarkup.
  ///
  /// In en, this message translates to:
  /// **'Calculate Markup'**
  String get calculateMarkup;

  /// No description provided for @discountCalculatorResults.
  ///
  /// In en, this message translates to:
  /// **'Discount Calculator Results'**
  String get discountCalculatorResults;

  /// No description provided for @tipCalculatorResults.
  ///
  /// In en, this message translates to:
  /// **'Tip Calculation Results'**
  String get tipCalculatorResults;

  /// No description provided for @taxCalculatorResults.
  ///
  /// In en, this message translates to:
  /// **'Tax Calculation Results'**
  String get taxCalculatorResults;

  /// No description provided for @markupCalculatorResults.
  ///
  /// In en, this message translates to:
  /// **'Markup Calculation Results'**
  String get markupCalculatorResults;

  /// No description provided for @discountCalculatorDetailedInfo.
  ///
  /// In en, this message translates to:
  /// **'Discount Calculator Information'**
  String get discountCalculatorDetailedInfo;

  /// No description provided for @discountCalculatorOverview.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive tool for discount, tip, tax, and markup calculations with many useful features'**
  String get discountCalculatorOverview;

  /// No description provided for @discountKeyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get discountKeyFeatures;

  /// No description provided for @comprehensiveDiscountCalc.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive Calculations'**
  String get comprehensiveDiscountCalc;

  /// No description provided for @comprehensiveDiscountCalcDesc.
  ///
  /// In en, this message translates to:
  /// **'Full support for discount, tip, tax, and markup calculations'**
  String get comprehensiveDiscountCalcDesc;

  /// No description provided for @multipleDiscountModes.
  ///
  /// In en, this message translates to:
  /// **'Multiple Calculation Modes'**
  String get multipleDiscountModes;

  /// No description provided for @multipleDiscountModesDesc.
  ///
  /// In en, this message translates to:
  /// **'4 different modes: discount, tip, tax, markup'**
  String get multipleDiscountModesDesc;

  /// No description provided for @realTimeDiscountResults.
  ///
  /// In en, this message translates to:
  /// **'Real-time Results'**
  String get realTimeDiscountResults;

  /// No description provided for @realTimeDiscountResultsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get detailed results instantly as you input data'**
  String get realTimeDiscountResultsDesc;

  /// No description provided for @discountHistorySaving.
  ///
  /// In en, this message translates to:
  /// **'History Saving'**
  String get discountHistorySaving;

  /// No description provided for @discountHistorySavingDesc.
  ///
  /// In en, this message translates to:
  /// **'Save and review previous calculations for reference'**
  String get discountHistorySavingDesc;

  /// No description provided for @discountHowToUse.
  ///
  /// In en, this message translates to:
  /// **'How to Use'**
  String get discountHowToUse;

  /// No description provided for @step1Discount.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Select calculation type'**
  String get step1Discount;

  /// No description provided for @step1DiscountDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose appropriate tab: Discount, Tip, Tax, or Markup'**
  String get step1DiscountDesc;

  /// No description provided for @step2Discount.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Enter information'**
  String get step2Discount;

  /// No description provided for @step2DiscountDesc.
  ///
  /// In en, this message translates to:
  /// **'Fill in required information like price, percentage, quantity'**
  String get step2DiscountDesc;

  /// No description provided for @step3Discount.
  ///
  /// In en, this message translates to:
  /// **'Step 3: View results'**
  String get step3Discount;

  /// No description provided for @step3DiscountDesc.
  ///
  /// In en, this message translates to:
  /// **'Results will be displayed immediately with detailed information'**
  String get step3DiscountDesc;

  /// No description provided for @step4Discount.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Save to history'**
  String get step4Discount;

  /// No description provided for @step4DiscountDesc.
  ///
  /// In en, this message translates to:
  /// **'Results are automatically saved to history for future reference'**
  String get step4DiscountDesc;

  /// No description provided for @discountCalculationModes.
  ///
  /// In en, this message translates to:
  /// **'Calculation Modes'**
  String get discountCalculationModes;

  /// No description provided for @discountMode.
  ///
  /// In en, this message translates to:
  /// **'Discount Calculator'**
  String get discountMode;

  /// No description provided for @discountModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate final price after discount and savings amount'**
  String get discountModeDesc;

  /// No description provided for @tipMode.
  ///
  /// In en, this message translates to:
  /// **'Tip Calculator'**
  String get tipMode;

  /// No description provided for @tipModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate tip and split bill among multiple people'**
  String get tipModeDesc;

  /// No description provided for @taxMode.
  ///
  /// In en, this message translates to:
  /// **'Tax Calculator'**
  String get taxMode;

  /// No description provided for @taxModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate tax amount and final price after tax'**
  String get taxModeDesc;

  /// No description provided for @markupMode.
  ///
  /// In en, this message translates to:
  /// **'Markup Calculator'**
  String get markupMode;

  /// No description provided for @markupModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate selling price and profit margin from cost price'**
  String get markupModeDesc;

  /// No description provided for @discountTips.
  ///
  /// In en, this message translates to:
  /// **'Usage Tips'**
  String get discountTips;

  /// No description provided for @discountTip1.
  ///
  /// In en, this message translates to:
  /// **'Use discount calculator when shopping to know real prices'**
  String get discountTip1;

  /// No description provided for @discountTip2.
  ///
  /// In en, this message translates to:
  /// **'Calculate appropriate tip based on service quality'**
  String get discountTip2;

  /// No description provided for @discountTip3.
  ///
  /// In en, this message translates to:
  /// **'Check tax to know actual total cost'**
  String get discountTip3;

  /// No description provided for @discountTip4.
  ///
  /// In en, this message translates to:
  /// **'Use markup calculator for business pricing'**
  String get discountTip4;

  /// No description provided for @discountTip5.
  ///
  /// In en, this message translates to:
  /// **'Save calculations for comparison and reference'**
  String get discountTip5;

  /// No description provided for @discountLimitations.
  ///
  /// In en, this message translates to:
  /// **'Important Notes'**
  String get discountLimitations;

  /// No description provided for @discountLimitationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Some important points to consider when using the discount calculator:'**
  String get discountLimitationsDesc;

  /// No description provided for @discountLimitation1.
  ///
  /// In en, this message translates to:
  /// **'Results are for reference only'**
  String get discountLimitation1;

  /// No description provided for @discountLimitation2.
  ///
  /// In en, this message translates to:
  /// **'Tax rates may vary by location'**
  String get discountLimitation2;

  /// No description provided for @discountLimitation3.
  ///
  /// In en, this message translates to:
  /// **'Tip amounts may vary by culture'**
  String get discountLimitation3;

  /// No description provided for @discountLimitation4.
  ///
  /// In en, this message translates to:
  /// **'Markup may be affected by other costs'**
  String get discountLimitation4;

  /// No description provided for @discountLimitation5.
  ///
  /// In en, this message translates to:
  /// **'Should verify with actual receipts'**
  String get discountLimitation5;

  /// No description provided for @discountDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This tool is for calculation assistance only and does not replace professional financial advice. Results may differ from reality due to other factors.'**
  String get discountDisclaimer;

  /// No description provided for @financialKeyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get financialKeyFeatures;

  /// No description provided for @comprehensiveFinancialCalc.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive Calculations'**
  String get comprehensiveFinancialCalc;

  /// No description provided for @comprehensiveFinancialCalcDesc.
  ///
  /// In en, this message translates to:
  /// **'Versatile financial calculator for loans, investments, and compound interest'**
  String get comprehensiveFinancialCalcDesc;

  /// No description provided for @multipleCalculationTypes.
  ///
  /// In en, this message translates to:
  /// **'Multiple Calculation Types'**
  String get multipleCalculationTypes;

  /// No description provided for @multipleCalculationTypesDesc.
  ///
  /// In en, this message translates to:
  /// **'Support for loan, investment, and compound interest calculations in one app'**
  String get multipleCalculationTypesDesc;

  /// No description provided for @realTimeResults.
  ///
  /// In en, this message translates to:
  /// **'Real-time Results'**
  String get realTimeResults;

  /// No description provided for @realTimeResultsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get detailed results instantly as you input data'**
  String get realTimeResultsDesc;

  /// No description provided for @historySaving.
  ///
  /// In en, this message translates to:
  /// **'History Saving'**
  String get historySaving;

  /// No description provided for @historySavingDesc.
  ///
  /// In en, this message translates to:
  /// **'Save and review previous calculations for reference'**
  String get historySavingDesc;

  /// No description provided for @financialHowToUse.
  ///
  /// In en, this message translates to:
  /// **'How to Use'**
  String get financialHowToUse;

  /// No description provided for @step1Financial.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Select calculation type'**
  String get step1Financial;

  /// No description provided for @step1FinancialDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose Loan, Investment, or Compound Interest tab based on your needs'**
  String get step1FinancialDesc;

  /// No description provided for @step2Financial.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Enter information'**
  String get step2Financial;

  /// No description provided for @step2FinancialDesc.
  ///
  /// In en, this message translates to:
  /// **'Fill in required information like amount, interest rate, time period'**
  String get step2FinancialDesc;

  /// No description provided for @step3Financial.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Calculate'**
  String get step3Financial;

  /// No description provided for @step3FinancialDesc.
  ///
  /// In en, this message translates to:
  /// **'Press the calculate button to view detailed results'**
  String get step3FinancialDesc;

  /// No description provided for @step4Financial.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Save results'**
  String get step4Financial;

  /// No description provided for @step4FinancialDesc.
  ///
  /// In en, this message translates to:
  /// **'Save results to history for future reference'**
  String get step4FinancialDesc;

  /// No description provided for @financialFormulas.
  ///
  /// In en, this message translates to:
  /// **'Financial Formulas'**
  String get financialFormulas;

  /// No description provided for @loanFormula.
  ///
  /// In en, this message translates to:
  /// **'Loan Formula'**
  String get loanFormula;

  /// No description provided for @loanFormulaText.
  ///
  /// In en, this message translates to:
  /// **'M = P × [r(1+r)ⁿ] / [(1+r)ⁿ-1]'**
  String get loanFormulaText;

  /// No description provided for @loanFormulaDesc.
  ///
  /// In en, this message translates to:
  /// **'M: Monthly payment, P: Loan amount, r: Monthly interest rate, n: Number of months'**
  String get loanFormulaDesc;

  /// No description provided for @investmentFormula.
  ///
  /// In en, this message translates to:
  /// **'Investment Formula'**
  String get investmentFormula;

  /// No description provided for @investmentFormulaText.
  ///
  /// In en, this message translates to:
  /// **'FV = PV(1+r)ⁿ + PMT × [((1+r)ⁿ-1)/r]'**
  String get investmentFormulaText;

  /// No description provided for @investmentFormulaDesc.
  ///
  /// In en, this message translates to:
  /// **'FV: Future value, PV: Initial investment, PMT: Monthly contribution, r: Interest rate, n: Number of periods'**
  String get investmentFormulaDesc;

  /// No description provided for @compoundInterestFormula.
  ///
  /// In en, this message translates to:
  /// **'Compound Interest Formula'**
  String get compoundInterestFormula;

  /// No description provided for @compoundInterestFormulaText.
  ///
  /// In en, this message translates to:
  /// **'A = P(1 + r/n)^(nt)'**
  String get compoundInterestFormulaText;

  /// No description provided for @compoundInterestFormulaDesc.
  ///
  /// In en, this message translates to:
  /// **'A: Final amount, P: Principal, r: Interest rate, n: Compounding frequency, t: Time'**
  String get compoundInterestFormulaDesc;

  /// No description provided for @financialLimitations.
  ///
  /// In en, this message translates to:
  /// **'Important Notes'**
  String get financialLimitations;

  /// No description provided for @financialLimitationsDesc.
  ///
  /// In en, this message translates to:
  /// **'The calculation results are for reference only and may not accurately reflect real-world situations:'**
  String get financialLimitationsDesc;

  /// No description provided for @financialLimitation1.
  ///
  /// In en, this message translates to:
  /// **'Does not account for inflation and market volatility'**
  String get financialLimitation1;

  /// No description provided for @financialLimitation2.
  ///
  /// In en, this message translates to:
  /// **'Interest rates may change over time'**
  String get financialLimitation2;

  /// No description provided for @financialLimitation3.
  ///
  /// In en, this message translates to:
  /// **'Does not include fees and additional costs'**
  String get financialLimitation3;

  /// No description provided for @financialLimitation4.
  ///
  /// In en, this message translates to:
  /// **'Results may differ based on actual terms and conditions'**
  String get financialLimitation4;

  /// No description provided for @financialLimitation5.
  ///
  /// In en, this message translates to:
  /// **'Should consult financial professionals for advice'**
  String get financialLimitation5;

  /// No description provided for @financialDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This tool is for calculation assistance only and does not replace professional financial advice. Please consult experts before making important financial decisions.'**
  String get financialDisclaimer;

  /// No description provided for @discountResultSavedToHistory.
  ///
  /// In en, this message translates to:
  /// **'Discount result saved to history'**
  String get discountResultSavedToHistory;

  /// No description provided for @tipResultSavedToHistory.
  ///
  /// In en, this message translates to:
  /// **'Tip result saved to history'**
  String get tipResultSavedToHistory;

  /// No description provided for @taxResultSavedToHistory.
  ///
  /// In en, this message translates to:
  /// **'Tax result saved to history'**
  String get taxResultSavedToHistory;

  /// No description provided for @markupResultSavedToHistory.
  ///
  /// In en, this message translates to:
  /// **'Markup result saved to history'**
  String get markupResultSavedToHistory;

  /// No description provided for @startCalculatingToSeeHistory.
  ///
  /// In en, this message translates to:
  /// **'Start calculating to see history'**
  String get startCalculatingToSeeHistory;

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

  /// No description provided for @networkSecurityWarning.
  ///
  /// In en, this message translates to:
  /// **'Network Security Warning'**
  String get networkSecurityWarning;

  /// No description provided for @unsecureNetworkDetected.
  ///
  /// In en, this message translates to:
  /// **'Unsecure network detected'**
  String get unsecureNetworkDetected;

  /// No description provided for @currentNetwork.
  ///
  /// In en, this message translates to:
  /// **'Current Network'**
  String get currentNetwork;

  /// No description provided for @securityLevel.
  ///
  /// In en, this message translates to:
  /// **'Security Level'**
  String get securityLevel;

  /// No description provided for @securityRisks.
  ///
  /// In en, this message translates to:
  /// **'Security Risks'**
  String get securityRisks;

  /// No description provided for @unsecureNetworkRisks.
  ///
  /// In en, this message translates to:
  /// **'On unsecure networks, your data transmissions may be intercepted by malicious users. Only proceed if you trust the network and other users.'**
  String get unsecureNetworkRisks;

  /// No description provided for @proceedAnyway.
  ///
  /// In en, this message translates to:
  /// **'Proceed Anyway'**
  String get proceedAnyway;

  /// No description provided for @secureNetwork.
  ///
  /// In en, this message translates to:
  /// **'Secure (WPA/WPA2)'**
  String get secureNetwork;

  /// No description provided for @unsecureNetwork.
  ///
  /// In en, this message translates to:
  /// **'Unsecure (Open/No Password)'**
  String get unsecureNetwork;

  /// No description provided for @unknownSecurity.
  ///
  /// In en, this message translates to:
  /// **'Unknown Security'**
  String get unknownSecurity;

  /// No description provided for @startNetworking.
  ///
  /// In en, this message translates to:
  /// **'Start Networking'**
  String get startNetworking;

  /// No description provided for @stopNetworking.
  ///
  /// In en, this message translates to:
  /// **'Stop Networking'**
  String get stopNetworking;

  /// No description provided for @pairingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pairing Requests'**
  String get pairingRequests;

  /// No description provided for @devices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devices;

  /// No description provided for @transfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get transfers;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @connectionStatus.
  ///
  /// In en, this message translates to:
  /// **'Connection Status'**
  String get connectionStatus;

  /// No description provided for @autoConnect.
  ///
  /// In en, this message translates to:
  /// **'Auto Connect'**
  String get autoConnect;

  /// No description provided for @networkInfo.
  ///
  /// In en, this message translates to:
  /// **'Network Info'**
  String get networkInfo;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @discoveredDevices.
  ///
  /// In en, this message translates to:
  /// **'Discovered devices'**
  String get discoveredDevices;

  /// No description provided for @pairedDevices.
  ///
  /// In en, this message translates to:
  /// **'Paired devices'**
  String get pairedDevices;

  /// No description provided for @activeTransfers.
  ///
  /// In en, this message translates to:
  /// **'Active transfers'**
  String get activeTransfers;

  /// No description provided for @noDevicesFound.
  ///
  /// In en, this message translates to:
  /// **'No devices found'**
  String get noDevicesFound;

  /// No description provided for @searchingForDevices.
  ///
  /// In en, this message translates to:
  /// **'Searching for devices...'**
  String get searchingForDevices;

  /// No description provided for @startNetworkingToDiscover.
  ///
  /// In en, this message translates to:
  /// **'Start networking to discover devices'**
  String get startNetworkingToDiscover;

  /// No description provided for @noActiveTransfers.
  ///
  /// In en, this message translates to:
  /// **'No active transfers'**
  String get noActiveTransfers;

  /// No description provided for @transfersWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Data transfers will appear here'**
  String get transfersWillAppearHere;

  /// No description provided for @paired.
  ///
  /// In en, this message translates to:
  /// **'Paired'**
  String get paired;

  /// No description provided for @lastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last Seen'**
  String get lastSeen;

  /// No description provided for @pairedSince.
  ///
  /// In en, this message translates to:
  /// **'Paired Since'**
  String get pairedSince;

  /// No description provided for @trusted.
  ///
  /// In en, this message translates to:
  /// **'Trusted {name}'**
  String trusted(String name);

  /// No description provided for @pair.
  ///
  /// In en, this message translates to:
  /// **'Pair'**
  String get pair;

  /// No description provided for @sendFile.
  ///
  /// In en, this message translates to:
  /// **'Send File'**
  String get sendFile;

  /// No description provided for @cancelTransfer.
  ///
  /// In en, this message translates to:
  /// **'Cancel Transfer'**
  String get cancelTransfer;

  /// No description provided for @confirmCancelTransfer.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this transfer?'**
  String get confirmCancelTransfer;

  /// No description provided for @p2pPairingRequest.
  ///
  /// In en, this message translates to:
  /// **'P2P Pairing Request'**
  String get p2pPairingRequest;

  /// No description provided for @p2pPairingResponse.
  ///
  /// In en, this message translates to:
  /// **'P2P Pairing Response'**
  String get p2pPairingResponse;

  /// No description provided for @p2pHeartbeat.
  ///
  /// In en, this message translates to:
  /// **'P2P Heartbeat'**
  String get p2pHeartbeat;

  /// Title for the permission request dialog
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get p2pPermissionRequiredTitle;

  /// Explanation for why location permission is needed for P2P
  ///
  /// In en, this message translates to:
  /// **'To discover nearby devices using WiFi, this app needs access to your location. This is an Android requirement for scanning WiFi networks. Your location data is not stored or shared. The app is client-side and we do not collect any user data.'**
  String get p2pPermissionExplanation;

  /// Button text to continue with granting permission
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get p2pPermissionContinue;

  /// Button text to cancel the permission request
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get p2pPermissionCancel;

  /// Title for the nearby devices permission request dialog
  ///
  /// In en, this message translates to:
  /// **'Nearby Devices Permission Required'**
  String get p2pNearbyDevicesPermissionTitle;

  /// Explanation for why nearby WiFi devices permission is needed for P2P
  ///
  /// In en, this message translates to:
  /// **'To discover nearby devices on modern Android versions, this app needs access to nearby WiFi devices. This permission allows the app to scan for WiFi networks without accessing your location. Your data is not stored or shared. The app is client-side and we do not collect any user data.'**
  String get p2pNearbyDevicesPermissionExplanation;

  /// No description provided for @dataTransferRequest.
  ///
  /// In en, this message translates to:
  /// **'Data Transfer Request'**
  String get dataTransferRequest;

  /// No description provided for @dataTransferResponse.
  ///
  /// In en, this message translates to:
  /// **'Data Transfer Response'**
  String get dataTransferResponse;

  /// No description provided for @sendData.
  ///
  /// In en, this message translates to:
  /// **'Send Data'**
  String get sendData;

  /// No description provided for @savedDevices.
  ///
  /// In en, this message translates to:
  /// **'Saved Devices'**
  String get savedDevices;

  /// No description provided for @availableDevices.
  ///
  /// In en, this message translates to:
  /// **'Available Devices'**
  String get availableDevices;

  /// Title for the P2Lan Transfer screen
  ///
  /// In en, this message translates to:
  /// **'P2Lan Transfer'**
  String get p2lanTransfer;

  /// Notification type for P2LAN active status
  ///
  /// In en, this message translates to:
  /// **'P2LAN Status'**
  String get p2lanStatus;

  /// Notification type for detailed file transfer status
  ///
  /// In en, this message translates to:
  /// **'File Transfer Status'**
  String get fileTransferStatus;

  /// Notification title when P2LAN is running
  ///
  /// In en, this message translates to:
  /// **'P2LAN Active'**
  String get p2lanActive;

  /// Status when P2LAN is ready to accept connections
  ///
  /// In en, this message translates to:
  /// **'Ready for connections'**
  String get readyForConnections;

  /// Number of devices connected to P2LAN
  ///
  /// In en, this message translates to:
  /// **'{count} devices connected'**
  String devicesConnected(int count);

  /// One device connected to P2LAN
  ///
  /// In en, this message translates to:
  /// **'{count} device connected'**
  String deviceConnected(int count);

  /// Action button to stop P2LAN from notification
  ///
  /// In en, this message translates to:
  /// **'Stop P2LAN'**
  String get stopP2lan;

  /// Message when P2LAN has been stopped
  ///
  /// In en, this message translates to:
  /// **'P2LAN stopped'**
  String get p2lanStopped;

  /// No description provided for @quickActionsManage.
  ///
  /// In en, this message translates to:
  /// **'Manage Quick Actions'**
  String get quickActionsManage;

  /// No description provided for @cacheDetailsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Cache Details'**
  String get cacheDetailsDialogTitle;

  /// No description provided for @randomGeneratorsCacheDesc.
  ///
  /// In en, this message translates to:
  /// **'Generation history and settings'**
  String get randomGeneratorsCacheDesc;

  /// No description provided for @calculatorToolsCacheDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculation history, graphing calculator data, BMI data, and settings'**
  String get calculatorToolsCacheDesc;

  /// No description provided for @converterToolsCacheDesc.
  ///
  /// In en, this message translates to:
  /// **'Currency/length states, presets and exchange rates cache'**
  String get converterToolsCacheDesc;

  /// Description for the P2P cache entry in the cache details dialog
  ///
  /// In en, this message translates to:
  /// **'Settings, saved device profiles, and temporary file transfer cache.'**
  String get p2pDataTransferCacheDesc;

  /// No description provided for @totalCacheSize.
  ///
  /// In en, this message translates to:
  /// **'Total: {count} items, {size}'**
  String totalCacheSize(Object count, Object size);

  /// No description provided for @clearSelectedCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Selected Cache'**
  String get clearSelectedCache;

  /// Question in user pairing dialog
  ///
  /// In en, this message translates to:
  /// **'Do you want to pair with this device?'**
  String get pairWithDevice;

  /// Label for device ID field
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get deviceId;

  /// Label for when device was discovered
  ///
  /// In en, this message translates to:
  /// **'Discovery Time'**
  String get discoveryTime;

  /// Checkbox label to save connection
  ///
  /// In en, this message translates to:
  /// **'Save Connection'**
  String get saveConnection;

  /// Description for save connection option
  ///
  /// In en, this message translates to:
  /// **'Automatically reconnect when both devices are online'**
  String get autoReconnectDescription;

  /// Information about pairing process
  ///
  /// In en, this message translates to:
  /// **'The other user will receive a pairing request and needs to accept to complete the pairing.'**
  String get pairingNotificationInfo;

  /// Button to send pairing request
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get sendRequest;

  /// Time indication for very recent actions
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String minutesAgo(int minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} hr ago'**
  String hoursAgo(int hours);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String daysAgo(int days);

  /// Text when there are no pairing requests
  ///
  /// In en, this message translates to:
  /// **'No pairing requests'**
  String get noPairingRequests;

  /// Text indicating source of pairing request
  ///
  /// In en, this message translates to:
  /// **'Pairing request from:'**
  String get pairingRequestFrom;

  /// Label for when request was sent
  ///
  /// In en, this message translates to:
  /// **'Sent Time'**
  String get sentTime;

  /// Message when sender wants to save connection
  ///
  /// In en, this message translates to:
  /// **'This person wants to save the connection'**
  String get wantsSaveConnection;

  /// Checkbox to trust user
  ///
  /// In en, this message translates to:
  /// **'Trust this user'**
  String get trustThisUser;

  /// Description for trust user option
  ///
  /// In en, this message translates to:
  /// **'Allow file transfers without confirmation'**
  String get allowFileTransfersWithoutConfirmation;

  /// Security warning about pairing
  ///
  /// In en, this message translates to:
  /// **'Only accept pairing from devices you trust.'**
  String get onlyAcceptFromTrustedDevices;

  /// Tooltip for previous request button
  ///
  /// In en, this message translates to:
  /// **'Previous request'**
  String get previousRequest;

  /// Tooltip for next request button
  ///
  /// In en, this message translates to:
  /// **'Next request'**
  String get nextRequest;

  /// Button to reject pairing/transfer request
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// Button to accept pairing/transfer request
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Title for incoming file transfer dialog
  ///
  /// In en, this message translates to:
  /// **'Incoming Files'**
  String get incomingFiles;

  /// Text showing sender wants to send files
  ///
  /// In en, this message translates to:
  /// **'wants to send you {count} file(s)'**
  String wantsToSendYouFiles(int count);

  /// Header for list of files to receive
  ///
  /// In en, this message translates to:
  /// **'Files to receive:'**
  String get filesToReceive;

  /// Label for total file size
  ///
  /// In en, this message translates to:
  /// **'Total size:'**
  String get totalSize;

  /// Tooltip for local files button
  ///
  /// In en, this message translates to:
  /// **'Local Files'**
  String get localFiles;

  /// Tooltip and label for manual discovery
  ///
  /// In en, this message translates to:
  /// **'Manual Discovery'**
  String get manualDiscovery;

  /// Tooltip for transfer settings button
  ///
  /// In en, this message translates to:
  /// **'Transfer Settings'**
  String get transferSettings;

  /// Subtitle for saved devices section
  ///
  /// In en, this message translates to:
  /// **'Saved devices currently available'**
  String get savedDevicesCurrentlyAvailable;

  /// Subtitle for discovered devices section
  ///
  /// In en, this message translates to:
  /// **'Recently discovered devices'**
  String get recentlyDiscoveredDevices;

  /// Menu option to view device info
  ///
  /// In en, this message translates to:
  /// **'View Info'**
  String get viewInfo;

  /// Menu option to trust device
  ///
  /// In en, this message translates to:
  /// **'Trust'**
  String get trust;

  /// Menu option to remove trust
  ///
  /// In en, this message translates to:
  /// **'Remove Trust'**
  String get removeTrust;

  /// Menu option to unpair device
  ///
  /// In en, this message translates to:
  /// **'Unpair'**
  String get unpair;

  /// Label for current device
  ///
  /// In en, this message translates to:
  /// **'This Device'**
  String get thisDevice;

  /// Label for file cache section
  ///
  /// In en, this message translates to:
  /// **'File Cache'**
  String get fileCache;

  /// Button to reload cache size
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reload;

  /// Button to clear cache
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Description of file cache content
  ///
  /// In en, this message translates to:
  /// **'Temporary files from P2Lan file transfers'**
  String get temporaryFilesFromTransfers;

  /// Debug button label
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get debug;

  /// Title for clear file cache dialog
  ///
  /// In en, this message translates to:
  /// **'Clear File Cache'**
  String get clearFileCache;

  /// Success message for cache clear
  ///
  /// In en, this message translates to:
  /// **'File cache cleared successfully'**
  String get fileCacheClearedSuccessfully;

  /// No description provided for @failedToClearCache.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear cache: {error}'**
  String failedToClearCache(String error);

  /// Error message for settings update failure
  ///
  /// In en, this message translates to:
  /// **'Failed to update settings'**
  String get failedToUpdateSettings;

  /// Error message for settings load failure
  ///
  /// In en, this message translates to:
  /// **'Failed to load settings: {error}'**
  String failedToLoadSettings(String error);

  /// Confirmation to remove trust from device
  ///
  /// In en, this message translates to:
  /// **'Remove trust from {deviceName}?'**
  String removeTrustFrom(String deviceName);

  /// Button to remove/delete
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Title for unpair dialog
  ///
  /// In en, this message translates to:
  /// **'Unpair from {deviceName}'**
  String unpairFrom(String deviceName);

  /// Description of unpair action
  ///
  /// In en, this message translates to:
  /// **'This will remove the pairing completely from both devices. You will need to pair again in the future.\n\nThe other device will also be notified and their connection will be removed.'**
  String get unpairDescription;

  /// Button text for unpair confirmation
  ///
  /// In en, this message translates to:
  /// **'Hold to Unpair'**
  String get holdToUnpair;

  /// Text shown during unpair process
  ///
  /// In en, this message translates to:
  /// **'Unpairing...'**
  String get unpairing;

  /// Instruction for unpair confirmation
  ///
  /// In en, this message translates to:
  /// **'Hold the button for 1 second to confirm unpair'**
  String get holdButtonToConfirmUnpair;

  /// Success message when task and file are deleted
  ///
  /// In en, this message translates to:
  /// **'Task and file deleted successfully'**
  String get taskAndFileDeletedSuccessfully;

  /// Message when task is cleared
  ///
  /// In en, this message translates to:
  /// **'Task cleared'**
  String get taskCleared;

  /// Status when not connected
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get notConnected;

  /// Status text during file sending
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// Button to send selected files
  ///
  /// In en, this message translates to:
  /// **'Send files'**
  String get sendFiles;

  /// Button to add files
  ///
  /// In en, this message translates to:
  /// **'Add Files'**
  String get addFiles;

  /// Error message for file selection
  ///
  /// In en, this message translates to:
  /// **'Error selecting files: {error}'**
  String errorSelectingFiles(String error);

  /// Error message for file sending
  ///
  /// In en, this message translates to:
  /// **'Error sending files: {error}'**
  String errorSendingFiles(String error);

  /// Message when no files are selected
  ///
  /// In en, this message translates to:
  /// **'No files selected'**
  String get noFilesSelected;

  /// Instructions for file options
  ///
  /// In en, this message translates to:
  /// **'Tap or right-click for options'**
  String get tapRightClickForOptions;

  /// Title for transfer summary section
  ///
  /// In en, this message translates to:
  /// **'Transfer Summary'**
  String get transferSummary;

  /// Option for unlimited size/count
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// TCP protocol option
  ///
  /// In en, this message translates to:
  /// **'TCP'**
  String get tcpProtocol;

  /// Description of TCP protocol
  ///
  /// In en, this message translates to:
  /// **'More reliable, better for important files'**
  String get tcpDescription;

  /// UDP protocol option
  ///
  /// In en, this message translates to:
  /// **'UDP'**
  String get udpProtocol;

  /// Description of UDP protocol
  ///
  /// In en, this message translates to:
  /// **'Faster but less reliable, good for large files'**
  String get udpDescription;

  /// No file organization option
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noFileOrganization;

  /// Option to create folders by date
  ///
  /// In en, this message translates to:
  /// **'Create date folders'**
  String get createDateFolders;

  /// Description of date organization
  ///
  /// In en, this message translates to:
  /// **'Organize files by date received'**
  String get organizeFoldersByDate;

  /// Option to create folders by sender
  ///
  /// In en, this message translates to:
  /// **'Create sender folders'**
  String get createSenderFolders;

  /// Option for immediate UI updates
  ///
  /// In en, this message translates to:
  /// **'Immediate'**
  String get immediate;

  /// Default device name
  ///
  /// In en, this message translates to:
  /// **'My Device'**
  String get myDevice;

  /// File organization by sender name
  ///
  /// In en, this message translates to:
  /// **'By Sender Name'**
  String get bySenderName;

  /// File organization by date
  ///
  /// In en, this message translates to:
  /// **'By Date'**
  String get byDate;

  /// No organization option
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// Button and dialog title to reset settings
  ///
  /// In en, this message translates to:
  /// **'Reset to Defaults'**
  String get resetToDefaults;

  /// Confirmation message for reset
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all settings to their default values?'**
  String get resetConfirmation;

  /// Tab label for general settings
  ///
  /// In en, this message translates to:
  /// **'Generic'**
  String get generic;

  /// Tab label for storage settings
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// Tab label for network settings
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// Button to save settings
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettings;

  /// Section header for device profile
  ///
  /// In en, this message translates to:
  /// **'Device Profile'**
  String get deviceProfile;

  /// Label for device name input field
  ///
  /// In en, this message translates to:
  /// **'Device Display Name'**
  String get deviceDisplayName;

  /// Section header for user preferences
  ///
  /// In en, this message translates to:
  /// **'User Preferences'**
  String get userPreferences;

  /// Setting to enable notifications
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// Section header for UI performance settings
  ///
  /// In en, this message translates to:
  /// **'User Interface Performance'**
  String get userInterfacePerformance;

  /// Label for UI refresh rate setting
  ///
  /// In en, this message translates to:
  /// **'UI Refresh Rate'**
  String get uiRefreshRate;

  /// Section header for current config display
  ///
  /// In en, this message translates to:
  /// **'Current Configuration'**
  String get currentConfiguration;

  /// Label for protocol setting
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get protocol;

  /// Label for maximum file size setting
  ///
  /// In en, this message translates to:
  /// **'Max File Size'**
  String get maxFileSize;

  /// Label for maximum total size setting
  ///
  /// In en, this message translates to:
  /// **'Maximum total size (per transfer batch)'**
  String get maxTotalSize;

  /// Label for concurrent tasks setting
  ///
  /// In en, this message translates to:
  /// **'Concurrent Tasks'**
  String get concurrentTasks;

  /// Label for chunk size setting
  ///
  /// In en, this message translates to:
  /// **'Chunk Size'**
  String get chunkSize;

  /// Label for file organization setting
  ///
  /// In en, this message translates to:
  /// **'File Organization'**
  String get fileOrganization;

  /// Section header for storage info
  ///
  /// In en, this message translates to:
  /// **'Storage Information'**
  String get storageInformation;

  /// Label for download path
  ///
  /// In en, this message translates to:
  /// **'Download Path'**
  String get downloadPath;

  /// Label for total disk space
  ///
  /// In en, this message translates to:
  /// **'Total Space'**
  String get totalSpace;

  /// Label for free disk space
  ///
  /// In en, this message translates to:
  /// **'Free Space'**
  String get freeSpace;

  /// Label for used disk space
  ///
  /// In en, this message translates to:
  /// **'Used Space'**
  String get usedSpace;

  /// Message when no download path is configured
  ///
  /// In en, this message translates to:
  /// **'No Download Path Set'**
  String get noDownloadPathSet;

  /// Section header for download location settings
  ///
  /// In en, this message translates to:
  /// **'Download Location'**
  String get downloadLocation;

  /// Label for download folder setting
  ///
  /// In en, this message translates to:
  /// **'Download Folder'**
  String get downloadFolder;

  /// Section header for Android storage permissions
  ///
  /// In en, this message translates to:
  /// **'Android Storage Access'**
  String get androidStorageAccess;

  /// Button to use app-specific folder
  ///
  /// In en, this message translates to:
  /// **'Use App Folder'**
  String get useAppFolder;

  /// Section header for size limit settings
  ///
  /// In en, this message translates to:
  /// **'Size Limits'**
  String get sizeLimits;

  /// Description for total size limit
  ///
  /// In en, this message translates to:
  /// **'Total size limit for all files in a single transfer request'**
  String get totalSizeLimitDescription;

  /// Section header for protocol settings
  ///
  /// In en, this message translates to:
  /// **'Transfer Protocol'**
  String get transferProtocolSection;

  /// Section header for performance settings
  ///
  /// In en, this message translates to:
  /// **'Performance Tuning'**
  String get performanceTuning;

  /// Description for concurrent transfers setting
  ///
  /// In en, this message translates to:
  /// **' = faster overall but higher CPU usage'**
  String get concurrentTransfersDescription;

  /// Description for chunk size setting
  ///
  /// In en, this message translates to:
  /// **'Higher sizes = faster transfers but more memory usage'**
  String get transferChunkSizeDescription;

  /// Error message when permissions are missing
  ///
  /// In en, this message translates to:
  /// **'Permissions are required to start P2P networking'**
  String get permissionsRequiredForP2P;

  /// Error message for networking start failure
  ///
  /// In en, this message translates to:
  /// **'Error in starting networking: {error}'**
  String errorInStartNetworking(String error);

  /// Error message for file selection from category
  ///
  /// In en, this message translates to:
  /// **'Error selecting files from {category}: {error}'**
  String errorSelectingFilesFromCategory(String category, String error);

  /// No description provided for @loadingDeviceInfo.
  ///
  /// In en, this message translates to:
  /// **'Loading device information...'**
  String get loadingDeviceInfo;

  /// No description provided for @tempFilesDescription.
  ///
  /// In en, this message translates to:
  /// **'Temporary files from P2Lan file transfers'**
  String get tempFilesDescription;

  /// No description provided for @networkDebugCompleted.
  ///
  /// In en, this message translates to:
  /// **'Network debug completed. Check logs for details.'**
  String get networkDebugCompleted;

  /// No description provided for @lastRefresh.
  ///
  /// In en, this message translates to:
  /// **'Last refresh: {time}'**
  String lastRefresh(String time);

  /// No description provided for @p2pNetworkingPaused.
  ///
  /// In en, this message translates to:
  /// **'P2P networking is paused due to internet connection loss. It will automatically resume when connection is restored.'**
  String get p2pNetworkingPaused;

  /// No description provided for @noDevicesInRange.
  ///
  /// In en, this message translates to:
  /// **'No devices in range. Try refreshing.'**
  String get noDevicesInRange;

  /// No description provided for @initialDiscoveryInProgress.
  ///
  /// In en, this message translates to:
  /// **'Initial discovery in progress...'**
  String get initialDiscoveryInProgress;

  /// No description provided for @refreshing.
  ///
  /// In en, this message translates to:
  /// **'Refreshing...'**
  String get refreshing;

  /// No description provided for @pausedNoInternet.
  ///
  /// In en, this message translates to:
  /// **'Paused (No Internet)'**
  String get pausedNoInternet;

  /// No description provided for @trustRemoved.
  ///
  /// In en, this message translates to:
  /// **'Trust removed from {name}'**
  String trustRemoved(String name);

  /// No description provided for @removeTrustConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove trust from {name}?'**
  String removeTrustConfirm(String name);

  /// No description provided for @unpairFromDevice.
  ///
  /// In en, this message translates to:
  /// **'Unpair from {name}'**
  String unpairFromDevice(String name);

  /// No description provided for @holdUnpairInstruction.
  ///
  /// In en, this message translates to:
  /// **'Hold the button for 1 second to confirm unpair'**
  String get holdUnpairInstruction;

  /// No description provided for @unpaired.
  ///
  /// In en, this message translates to:
  /// **'Unpaired from {name}'**
  String unpaired(String name);

  /// No description provided for @taskAndFileDeleted.
  ///
  /// In en, this message translates to:
  /// **'Task and file deleted successfully'**
  String get taskAndFileDeleted;

  /// No description provided for @clearFileCacheConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will clear temporary files from P2Lan transfers. This action cannot be undone.'**
  String get clearFileCacheConfirm;

  /// No description provided for @fileCacheClearedSuccess.
  ///
  /// In en, this message translates to:
  /// **'File cache cleared successfully'**
  String get fileCacheClearedSuccess;

  /// No description provided for @permissionsRequired.
  ///
  /// In en, this message translates to:
  /// **'Permissions are required to start P2P networking'**
  String get permissionsRequired;

  /// No description provided for @startedSending.
  ///
  /// In en, this message translates to:
  /// **'Started sending {count} files to {name}'**
  String startedSending(int count, String name);

  /// No description provided for @transferSettingsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Transfer settings updated successfully'**
  String get transferSettingsUpdated;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @discoveringDevices.
  ///
  /// In en, this message translates to:
  /// **'Discovering devices...'**
  String get discoveringDevices;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @pairing.
  ///
  /// In en, this message translates to:
  /// **'Pairing...'**
  String get pairing;

  /// No description provided for @checkingNetwork.
  ///
  /// In en, this message translates to:
  /// **'Checking network...'**
  String get checkingNetwork;

  /// No description provided for @connectedViaMobileData.
  ///
  /// In en, this message translates to:
  /// **'Connected via mobile data (secure)'**
  String get connectedViaMobileData;

  /// No description provided for @connectedToWifi.
  ///
  /// In en, this message translates to:
  /// **'Connected to {name} ({security})'**
  String connectedToWifi(String name, String security);

  /// No description provided for @secure.
  ///
  /// In en, this message translates to:
  /// **'secure'**
  String get secure;

  /// No description provided for @unsecure.
  ///
  /// In en, this message translates to:
  /// **'unsecure'**
  String get unsecure;

  /// No description provided for @connectedViaEthernet.
  ///
  /// In en, this message translates to:
  /// **'Connected via Ethernet (secure)'**
  String get connectedViaEthernet;

  /// No description provided for @noNetworkConnection.
  ///
  /// In en, this message translates to:
  /// **'No network connection'**
  String get noNetworkConnection;

  /// No description provided for @unknownWifi.
  ///
  /// In en, this message translates to:
  /// **'Unknown WiFi'**
  String get unknownWifi;

  /// No description provided for @tcpReliable.
  ///
  /// In en, this message translates to:
  /// **'TCP (Reliable)'**
  String get tcpReliable;

  /// No description provided for @udpFast.
  ///
  /// In en, this message translates to:
  /// **'UDP (Fast)'**
  String get udpFast;

  /// No description provided for @createDateFoldersDescription.
  ///
  /// In en, this message translates to:
  /// **'Organize by date (YYYY-MM-DD)'**
  String get createDateFoldersDescription;

  /// No description provided for @createSenderFoldersDescription.
  ///
  /// In en, this message translates to:
  /// **'Organize by sender display name'**
  String get createSenderFoldersDescription;

  /// No description provided for @maxConcurrentTasks.
  ///
  /// In en, this message translates to:
  /// **'Max Concurrent Tasks'**
  String get maxConcurrentTasks;

  /// No description provided for @defaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultLabel;

  /// No description provided for @customDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Custom Display Name'**
  String get customDisplayName;

  /// No description provided for @deviceName.
  ///
  /// In en, this message translates to:
  /// **'Device Name'**
  String get deviceName;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @hasUnsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Do you want to discard them?'**
  String get hasUnsavedChanges;

  /// No description provided for @selectFolder.
  ///
  /// In en, this message translates to:
  /// **'Select Folder'**
  String get selectFolder;

  /// No description provided for @permissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// No description provided for @grantStoragePermission.
  ///
  /// In en, this message translates to:
  /// **'Grant storage permission to select download folder'**
  String get grantStoragePermission;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @notificationPermissionInfo.
  ///
  /// In en, this message translates to:
  /// **'Notification permission allows you to receive updates about file transfers and connection status.'**
  String get notificationPermissionInfo;

  /// No description provided for @secondsLabel.
  ///
  /// In en, this message translates to:
  /// **'second'**
  String get secondsLabel;

  /// No description provided for @secondsPlural.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get secondsPlural;

  /// No description provided for @networkInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Network Information'**
  String get networkInfoTitle;

  /// No description provided for @deviceSections.
  ///
  /// In en, this message translates to:
  /// **'Device Sections'**
  String get deviceSections;

  /// No description provided for @onlineDevices.
  ///
  /// In en, this message translates to:
  /// **'Online Devices'**
  String get onlineDevices;

  /// No description provided for @newDevices.
  ///
  /// In en, this message translates to:
  /// **'New Devices'**
  String get newDevices;

  /// No description provided for @addTrust.
  ///
  /// In en, this message translates to:
  /// **'Add Trust'**
  String get addTrust;

  /// No description provided for @emptyDevicesStateTitle.
  ///
  /// In en, this message translates to:
  /// **'No Devices Found'**
  String get emptyDevicesStateTitle;

  /// No description provided for @viewDeviceInfo.
  ///
  /// In en, this message translates to:
  /// **'View device information'**
  String get viewDeviceInfo;

  /// No description provided for @trustUser.
  ///
  /// In en, this message translates to:
  /// **'Trust user'**
  String get trustUser;

  /// No description provided for @menuSendFiles.
  ///
  /// In en, this message translates to:
  /// **'Send Files'**
  String get menuSendFiles;

  /// No description provided for @menuViewInfo.
  ///
  /// In en, this message translates to:
  /// **'View Info'**
  String get menuViewInfo;

  /// No description provided for @menuPair.
  ///
  /// In en, this message translates to:
  /// **'Pair'**
  String get menuPair;

  /// No description provided for @menuTrust.
  ///
  /// In en, this message translates to:
  /// **'Trust'**
  String get menuTrust;

  /// No description provided for @menuUntrust.
  ///
  /// In en, this message translates to:
  /// **'Remove Trust'**
  String get menuUntrust;

  /// No description provided for @menuUnpair.
  ///
  /// In en, this message translates to:
  /// **'Unpair'**
  String get menuUnpair;

  /// No description provided for @deviceActions.
  ///
  /// In en, this message translates to:
  /// **'Device Actions'**
  String get deviceActions;

  /// No description provided for @p2pTemporarilyDisabled.
  ///
  /// In en, this message translates to:
  /// **'P2P temporarily disabled - waiting for internet connection'**
  String get p2pTemporarilyDisabled;

  /// No description provided for @fileOrgNoneDescription.
  ///
  /// In en, this message translates to:
  /// **'Files go directly to download folder'**
  String get fileOrgNoneDescription;

  /// No description provided for @fileOrgDateDescription.
  ///
  /// In en, this message translates to:
  /// **'Organize by date (YYYY-MM-DD)'**
  String get fileOrgDateDescription;

  /// No description provided for @fileOrgSenderDescription.
  ///
  /// In en, this message translates to:
  /// **'Organize by sender display name'**
  String get fileOrgSenderDescription;

  /// No description provided for @basic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basic;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @p2lanTransferSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'P2Lan Transfer Settings'**
  String get p2lanTransferSettingsTitle;

  /// No description provided for @settingsTabGeneric.
  ///
  /// In en, this message translates to:
  /// **'Generic'**
  String get settingsTabGeneric;

  /// No description provided for @settingsTabStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get settingsTabStorage;

  /// No description provided for @settingsTabNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get settingsTabNetwork;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// No description provided for @displayNameDescription.
  ///
  /// In en, this message translates to:
  /// **'Customize how your device appears to other users'**
  String get displayNameDescription;

  /// No description provided for @deviceDisplayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Device Display Name'**
  String get deviceDisplayNameLabel;

  /// No description provided for @deviceDisplayNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter custom display name...'**
  String get deviceDisplayNameHint;

  /// No description provided for @defaultDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Default: {name}'**
  String defaultDisplayName(String name);

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notSupportedOnWindows.
  ///
  /// In en, this message translates to:
  /// **'Not supported on Windows'**
  String get notSupportedOnWindows;

  /// No description provided for @uiPerformance.
  ///
  /// In en, this message translates to:
  /// **'User Interface Performance'**
  String get uiPerformance;

  /// No description provided for @uiRefreshRateDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose how often transfer progress updates in the UI. Higher frequencies work better on powerful devices.'**
  String get uiRefreshRateDescription;

  /// No description provided for @savedDevicesCount.
  ///
  /// In en, this message translates to:
  /// **'Saved Devices ({count})'**
  String savedDevicesCount(int count);

  /// No description provided for @previouslyPairedOffline.
  ///
  /// In en, this message translates to:
  /// **'Previously paired devices (offline)'**
  String get previouslyPairedOffline;

  /// No description provided for @statusSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get statusSaved;

  /// No description provided for @statusTrusted.
  ///
  /// In en, this message translates to:
  /// **'Trusted'**
  String get statusTrusted;

  /// No description provided for @thisDeviceCardTitle.
  ///
  /// In en, this message translates to:
  /// **'This Device'**
  String get thisDeviceCardTitle;

  /// No description provided for @appInstallationId.
  ///
  /// In en, this message translates to:
  /// **'App Installation ID'**
  String get appInstallationId;

  /// No description provided for @ipAddress.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ipAddress;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// No description provided for @statusOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get statusOffline;

  /// No description provided for @selectDownloadFolder.
  ///
  /// In en, this message translates to:
  /// **'Select download folder...'**
  String get selectDownloadFolder;

  /// No description provided for @maxFileSizePerFile.
  ///
  /// In en, this message translates to:
  /// **'Maximum file size (per file)'**
  String get maxFileSizePerFile;

  /// No description provided for @transferProtocol.
  ///
  /// In en, this message translates to:
  /// **'Transfer Protocol'**
  String get transferProtocol;

  /// No description provided for @concurrentTransfers.
  ///
  /// In en, this message translates to:
  /// **'Concurrent transfers'**
  String get concurrentTransfers;

  /// No description provided for @transferChunkSize.
  ///
  /// In en, this message translates to:
  /// **'Transfer chunk size'**
  String get transferChunkSize;

  /// No description provided for @defaultValue.
  ///
  /// In en, this message translates to:
  /// **'(Default)'**
  String get defaultValue;

  /// No description provided for @androidStorageAccessDescription.
  ///
  /// In en, this message translates to:
  /// **'For security, it\'s recommended to use the app-specific folder. You can select other folders, but this may require additional permissions.'**
  String get androidStorageAccessDescription;

  /// No description provided for @storageInfo.
  ///
  /// In en, this message translates to:
  /// **'Storage Information'**
  String get storageInfo;

  /// No description provided for @noDownloadPathSetDescription.
  ///
  /// In en, this message translates to:
  /// **'Please select a download folder in the Storage tab to see storage information.'**
  String get noDownloadPathSetDescription;

  /// No description provided for @enableNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Get notified about transfer events'**
  String get enableNotificationsDescription;

  /// No description provided for @maxFileSizePerFileDescription.
  ///
  /// In en, this message translates to:
  /// **'Larger files will be automatically rejected'**
  String get maxFileSizePerFileDescription;

  /// No description provided for @maxTotalSizeDescription.
  ///
  /// In en, this message translates to:
  /// **'Total size limit for all files in a single transfer request'**
  String get maxTotalSizeDescription;

  /// No description provided for @concurrentTransfersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'More transfers = faster overall but higher CPU usage'**
  String get concurrentTransfersSubtitle;

  /// No description provided for @transferChunkSizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Higher sizes = faster transfers but more memory usage'**
  String get transferChunkSizeSubtitle;

  /// No description provided for @protocolTcpReliable.
  ///
  /// In en, this message translates to:
  /// **'TCP (Reliable)'**
  String get protocolTcpReliable;

  /// No description provided for @protocolTcpDescription.
  ///
  /// In en, this message translates to:
  /// **'More reliable, better for important files'**
  String get protocolTcpDescription;

  /// No description provided for @protocolUdpFast.
  ///
  /// In en, this message translates to:
  /// **'UDP (Fast)'**
  String get protocolUdpFast;

  /// No description provided for @fileOrgNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get fileOrgNone;

  /// No description provided for @fileOrgDate.
  ///
  /// In en, this message translates to:
  /// **'By Date'**
  String get fileOrgDate;

  /// No description provided for @fileOrgSender.
  ///
  /// In en, this message translates to:
  /// **'By Sender Name'**
  String get fileOrgSender;

  /// No description provided for @transferSettingsUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Transfer settings updated successfully'**
  String get transferSettingsUpdatedSuccessfully;

  /// No description provided for @selectOperation.
  ///
  /// In en, this message translates to:
  /// **'Select Operation'**
  String get selectOperation;

  /// No description provided for @filterAndSort.
  ///
  /// In en, this message translates to:
  /// **'Filter and Sort'**
  String get filterAndSort;

  /// No description provided for @tapToSelectAgain.
  ///
  /// In en, this message translates to:
  /// **'Tap to select again'**
  String get tapToSelectAgain;

  /// No description provided for @notSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get notSelected;

  /// No description provided for @selectDestinationFolder.
  ///
  /// In en, this message translates to:
  /// **'Select destination folder'**
  String get selectDestinationFolder;

  /// No description provided for @openInApp.
  ///
  /// In en, this message translates to:
  /// **'Open in App'**
  String get openInApp;

  /// No description provided for @copyTo.
  ///
  /// In en, this message translates to:
  /// **'Copy to'**
  String get copyTo;

  /// No description provided for @moveTo.
  ///
  /// In en, this message translates to:
  /// **'Move to'**
  String get moveTo;

  /// No description provided for @moveOrCopyAndRename.
  ///
  /// In en, this message translates to:
  /// **'Move or Copy and Rename'**
  String get moveOrCopyAndRename;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete file'**
  String get confirmDelete;

  /// No description provided for @removeSelected.
  ///
  /// In en, this message translates to:
  /// **'Remove selected content'**
  String get removeSelected;

  /// No description provided for @noFilesFound.
  ///
  /// In en, this message translates to:
  /// **'No files found'**
  String get noFilesFound;

  /// No description provided for @emptyFolder.
  ///
  /// In en, this message translates to:
  /// **'Empty folder'**
  String get emptyFolder;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'file'**
  String get file;

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
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
