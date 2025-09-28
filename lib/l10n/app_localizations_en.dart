// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'Random Please';

  @override
  String get helpAndGuides => 'Help & User Guides';

  @override
  String get pressBackAgainToExit => 'Press back again to exit';

  @override
  String get appVersion => 'App Version';

  @override
  String get versionType => 'Version Type';

  @override
  String get versionTypeDev => 'Development';

  @override
  String get versionTypeBeta => 'Beta';

  @override
  String get versionTypeRelease => 'Release';

  @override
  String get versionTypeDevDisplay => 'Development Version';

  @override
  String get versionTypeBetaDisplay => 'Beta Version';

  @override
  String get versionTypeReleaseDisplay => 'Release Version';

  @override
  String get githubRepo => 'GitHub Repository';

  @override
  String get githubRepoDesc => 'View source code of the application on GitHub';

  @override
  String get creditAck => 'Credits & Acknowledgements';

  @override
  String get creditAckDesc => 'Libraries and resources used in this app';

  @override
  String get supportDesc =>
      'Random Please helps you generate random data easily, conveniently, and at no cost. If you find it useful, consider supporting me to maintain and improve it. Thank you very much!';

  @override
  String get supportOnGitHub => 'Support on GitHub';

  @override
  String get donate => 'Donate';

  @override
  String get donateDesc => 'Support me if you find this app useful';

  @override
  String get oneTimeDonation => 'One-time Donation';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get userInterface => 'User Interface';

  @override
  String get userInterfaceDesc =>
      'Customize the theme, language, and display style';

  @override
  String get randomTools => 'Random Tools';

  @override
  String get randomToolsDesc =>
      'History, status, tools arrangement, and data protection';

  @override
  String get dataManager => 'Data Managerment';

  @override
  String get dataManagerDesc => 'Delete all data';

  @override
  String get autoCleanupHistoryLimit => 'Auto-cleanup old history records';

  @override
  String get autoCleanupHistoryLimitDesc =>
      'Automatically delete oldest unpinned records when limit is exceeded';

  @override
  String historyLimitRecords(int count) {
    return '$count records';
  }

  @override
  String get noLimit => 'No limit';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get english => 'English';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get cache => 'Cache';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get cacheSize => 'Cache size';

  @override
  String get clearAllCache => 'Clear All Cache';

  @override
  String get viewLogs => 'View Logs';

  @override
  String get clearLogs => 'Clear Logs';

  @override
  String get logRetention => 'Log Retention';

  @override
  String logRetentionDays(int days) {
    return '$days days';
  }

  @override
  String get logRetentionForever => 'Keep forever';

  @override
  String get historyManager => 'History Managerment';

  @override
  String get logRetentionDescDetail =>
      'Choose log retention period (5-30 days in 5-day intervals, or forever)';

  @override
  String get dataAndStorage => 'Data & Storage';

  @override
  String get confirmClearAllCache =>
      'Are you sure you want to clear ALL cache data? This will remove all history from all tools but preserve your settings.';

  @override
  String get cannotClearFollowingCaches =>
      'The following caches cannot be cleared because they are currently in use:';

  @override
  String get allCacheCleared => 'All cache cleared successfully';

  @override
  String get close => 'Close';

  @override
  String get options => 'Options';

  @override
  String get about => 'About';

  @override
  String get add => 'Add';

  @override
  String get copy => 'Copy';

  @override
  String get cancel => 'Cancel';

  @override
  String get history => 'History';

  @override
  String get random => 'Random Generator';

  @override
  String get randomDesc =>
      'Generate random passwords, numbers, dates, and more';

  @override
  String get textTemplateGen => 'Text Template Generator';

  @override
  String get textTemplateGenDesc =>
      'Create documents from templates. You can create reusable templates with fields like text, number, date.';

  @override
  String get holdToDeleteInstruction =>
      'Hold the delete button for 5 seconds to confirm';

  @override
  String get holdToDelete => 'Hold to delete...';

  @override
  String get deleting => 'Deleting...';

  @override
  String get holdToClearCache => 'Hold to clear...';

  @override
  String get clearingCache => 'Clearing cache...';

  @override
  String get batchDelete => 'Delete Selected';

  @override
  String get passwordGenerator => 'Password Generator';

  @override
  String get passwordGeneratorDesc => 'Generate secure random passwords';

  @override
  String get numCharacters => 'Number of characters';

  @override
  String get includeLowercase => 'Lowercase letters';

  @override
  String get includeLowercaseDesc => 'a-z';

  @override
  String get includeUppercase => 'Uppercase letters';

  @override
  String get includeUppercaseDesc => 'A-Z';

  @override
  String get includeNumbers => 'Numbers';

  @override
  String get includeNumbersDesc => '0-9';

  @override
  String get includeSpecial => 'Special characters';

  @override
  String get includeSpecialDesc => 'e.g. !@#\$%^&*';

  @override
  String get generate => 'Generate';

  @override
  String generatedAtTime(String time) {
    return 'Generated at $time';
  }

  @override
  String get generatedPassword => 'Generated Password';

  @override
  String get copyToClipboard => 'Copy to Clipboard';

  @override
  String get copied => 'Copied!';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get year => 'Year';

  @override
  String get month => 'Month';

  @override
  String get first => 'First';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get noHistoryYet => 'No history yet';

  @override
  String get confirmClearHistory => 'Are you sure you want to clear history?';

  @override
  String get confirmClearHistoryMessage =>
      'This will remove all saved history items. This action cannot be undone.\nMake sure you have saved any important results before proceeding.';

  @override
  String get historyCleared => 'History cleared successfully';

  @override
  String get pinnedHistoryCleared => 'Pinned history cleared successfully';

  @override
  String get unpinnedHistoryCleared => 'Unpinned history cleared successfully';

  @override
  String get numberGenerator => 'Number Generator';

  @override
  String get numberGeneratorDesc => 'Generate random numbers and sequences';

  @override
  String get integers => 'Integers';

  @override
  String get floatingPoint => 'Floating Point';

  @override
  String get minValue => 'Minimum Value';

  @override
  String get maxValue => 'Maximum Value';

  @override
  String get quantity => 'Quantity';

  @override
  String get allowDuplicates => 'Allow Duplicates';

  @override
  String get allowDuplicatesDesc =>
      'Allow picking the same item multiple times';

  @override
  String get includeSeconds => 'Include Seconds';

  @override
  String get generatedNumbers => 'Generated Numbers';

  @override
  String get yesNo => 'Yes or No?';

  @override
  String get yesNoDesc => 'Random Yes or No decision';

  @override
  String get flipCoin => 'Flip Coin';

  @override
  String get flipCoinDesc => 'Random coin flip result';

  @override
  String get rockPaperScissors => 'Rock Paper Scissors';

  @override
  String get rockPaperScissorsDesc => 'Play the classic hand game';

  @override
  String get rollDice => 'Roll Dice';

  @override
  String get rollDiceDesc => 'Roll virtual dice with custom sides';

  @override
  String get diceCount => 'Number of dice';

  @override
  String get diceSides => 'Sides per die';

  @override
  String get colorGenerator => 'Color Generator';

  @override
  String get colorGeneratorDesc => 'Generate random colors and palettes';

  @override
  String get generatedColor => 'Generated Color';

  @override
  String get latinLetters => 'Latin Letters';

  @override
  String get latinLettersDesc => 'Generate random alphabet letters';

  @override
  String get letterCount => 'Number of letters';

  @override
  String get letters => 'letters';

  @override
  String get playingCards => 'Playing Cards';

  @override
  String get playingCardsDesc => 'Draw random playing cards';

  @override
  String get includeJokers => 'Include Jokers';

  @override
  String get includeJokersDesc => 'Include jokers in the deck';

  @override
  String get cardCount => 'Number of cards';

  @override
  String get from => 'From';

  @override
  String get actions => 'Actions';

  @override
  String get delete => 'Delete';

  @override
  String get dateGenerator => 'Date Generator';

  @override
  String get dateGeneratorDesc => 'Generate random dates within ranges';

  @override
  String get dateCount => 'Number of dates';

  @override
  String get timeGenerator => 'Time Generator';

  @override
  String get timeGeneratorDesc => 'Generate random times of day';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get timeCount => 'Number of times';

  @override
  String get dateTimeGenerator => 'Date & Time Generator';

  @override
  String get dateTimeGeneratorDesc =>
      'Generate random date and time combinations';

  @override
  String get heads => 'Heads';

  @override
  String get tails => 'Tails';

  @override
  String get rock => 'Rock';

  @override
  String get paper => 'Paper';

  @override
  String get scissors => 'Scissors';

  @override
  String get randomResult => 'Result';

  @override
  String get skipAnimation => 'Skip Animation';

  @override
  String get skipAnimationDesc =>
      'Show result immediately without visual effects';

  @override
  String latinLetterGenerationError(int count, int max) {
    return 'Cannot generate $count unique letters. Maximum available: $max letters. Please reduce the count or allow duplicates.';
  }

  @override
  String get saveGenerationHistory => 'Save Generation History';

  @override
  String get saveGenerationHistoryDesc =>
      'Remember and display history of generated items';

  @override
  String get generationHistory => 'Generation History';

  @override
  String get generatedAt => 'Generated at';

  @override
  String get noHistoryMessage =>
      'Your generation history items will appear here';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get clearAllItems => 'Clear All History';

  @override
  String get confirmClearAllHistory =>
      'Are you sure you want to clear ALL history? This will remove all history of this tool even your pinned items.\nMake sure you have saved any important results before proceeding.';

  @override
  String get clearPinnedItems => 'Clear Pinned Items';

  @override
  String get clearPinnedItemsDesc =>
      'Remove all pinned items from history? This will not affect unpinned items.\nMake sure you have saved any important results before proceeding.';

  @override
  String get clearUnpinnedItems => 'Clear Unpinned Items';

  @override
  String get clearUnpinnedItemsDesc =>
      'Remove all unpinned items from history? This will not affect pinned items.\nMake sure you have saved any important results before proceeding.';

  @override
  String get typeConfirmToProceed => 'Type \"confirm\" to proceed:';

  @override
  String get clearAll => 'Clear All';

  @override
  String get converterTools => 'Converter Tools';

  @override
  String get converterToolsDesc =>
      'Convert between different units and systems';

  @override
  String get calculatorTools => 'Calculator Tools';

  @override
  String get calculatorToolsDesc =>
      'Specialized calculators for health, finance, and more';

  @override
  String get value => 'Value';

  @override
  String get success => 'Success';

  @override
  String get calculate => 'Calculate';

  @override
  String get calculating => 'Calculating...';

  @override
  String get unknown => 'Unknown';

  @override
  String get logsAvailable => 'Logs available';

  @override
  String get scrollToTop => 'Scroll to Top';

  @override
  String get scrollToBottom => 'Scroll to Bottom';

  @override
  String get logActions => 'Log Actions';

  @override
  String get logApplication => 'Log Application';

  @override
  String get previousChunk => 'Previous Chunk';

  @override
  String get nextChunk => 'Next Chunk';

  @override
  String get loadAll => 'Load All';

  @override
  String get firstPart => 'First Part';

  @override
  String get lastPart => 'Last Part';

  @override
  String get largeFile => 'Large File';

  @override
  String get loadingLargeFile => 'Loading large file...';

  @override
  String get loadingLogContent => 'Loading log content...';

  @override
  String get largeFileDetected =>
      'Large file detected. Using optimized loading...';

  @override
  String get focusModeEnabled => 'Focus Mode';

  @override
  String get saveRandomToolsState => 'Reset Tools State At Startup';

  @override
  String get saveRandomToolsStateDesc =>
      'Reset all tool states to default when the app starts';

  @override
  String get resetCounterOnToggle => 'Reset Counter on Toggle';

  @override
  String get resetCounterOnToggleDesc =>
      'Reset counter statistics when disabling Counter Mode';

  @override
  String get aspectRatio => 'Aspect Ratio';

  @override
  String get reset => 'Reset';

  @override
  String get info => 'Info';

  @override
  String get deletingOldLogs => 'Deleting old logs...';

  @override
  String deletedOldLogFiles(int count) {
    return 'Deleted $count old log files';
  }

  @override
  String get noOldLogFilesToDelete => 'No old log files to delete';

  @override
  String errorDeletingLogs(String error) {
    return 'Error deleting logs: $error';
  }

  @override
  String get p2pDataTransfer => 'P2P File Transfer';

  @override
  String get p2pDataTransferDesc =>
      'Transfer files between devices on the same local network.';

  @override
  String get clear => 'Clear';

  @override
  String get debug => 'Debug';

  @override
  String get remove => 'Remove';

  @override
  String get none => 'None';

  @override
  String get storage => 'Storage';

  @override
  String get moveTo => 'Move to';

  @override
  String get share => 'Share';

  @override
  String get quickAccess => 'Quick Access';

  @override
  String get colorFormat => 'Color Format';

  @override
  String get aboutToOpenUrlOutsideApp =>
      'You are about to open a URL outside the app. Do you want to proceed?';

  @override
  String get ccontinue => 'Continue';

  @override
  String get errorOpeningUrl => 'Error opening URL';

  @override
  String get canNotOpenUrl => 'Cannot open URL';

  @override
  String get linkCopiedToClipboard => 'Link copied to clipboard';

  @override
  String get refresh => 'Refresh';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get supporterS => 'Supporter(s)';

  @override
  String get thanksLibAuthor => 'Thank You, Library Authors!';

  @override
  String get thanksLibAuthorDesc =>
      'This app uses several open-source libraries that make it possible. We are grateful to all the authors for their hard work and dedication.';

  @override
  String get thanksDonors => 'Thank You, Supporters!';

  @override
  String get thanksDonorsDesc =>
      'Special thanks to our supporters who support the development of this app. Your contributions help us keep improving and maintaining the project.';

  @override
  String get thanksForUrSupport => 'Thank you for your support!';

  @override
  String get checkingForUpdates => 'Checking for updates...';

  @override
  String get minimum => 'Min';

  @override
  String get maximum => 'Max';

  @override
  String get average => 'Avg';

  @override
  String get total => 'Total';

  @override
  String get leastFrequent => 'Least';

  @override
  String get mostFrequent => 'Most';

  @override
  String get leastFrequentRank => 'Least frequent rank';

  @override
  String get mostFrequentRank => 'Most frequent rank';

  @override
  String get leastFrequentSuit => 'Least frequent suit';

  @override
  String get mostFrequentSuit => 'Most frequent suit';

  @override
  String get minGap => 'Min Gap';

  @override
  String get maxGap => 'Max Gap';

  @override
  String get statistics => 'Statistics';

  @override
  String get expandStatistics => 'Expand statistics';

  @override
  String get collapseStatistics => 'Collapse statistics';

  @override
  String get autoScrollToResults => 'Auto Scroll to Results';

  @override
  String get autoScrollToResultsDesc =>
      'Automatically scroll down to show results after generation';

  @override
  String get earliest => 'Earliest';

  @override
  String get latest => 'Latest';

  @override
  String get shortestGap => 'Shortest Gap';

  @override
  String get longestGap => 'Longest Gap';

  @override
  String get characters => 'Characters';

  @override
  String get dice => 'Dice';

  @override
  String get passwordStrength => 'Password Strength';

  @override
  String get strengthWeak => 'Weak';

  @override
  String get strengthFair => 'Fair';

  @override
  String get strengthGood => 'Good';

  @override
  String get strengthStrong => 'Strong';

  @override
  String get strengthVeryStrong => 'Very Strong';

  @override
  String get clickToCopy => 'Click to copy';

  @override
  String get noNewUpdates => 'No new updates';

  @override
  String updateCheckError(String errorMessage) {
    return 'Error checking updates: $errorMessage';
  }

  @override
  String get usingLatestVersion => 'You are using the latest version';

  @override
  String get newVersionAvailable => 'New version available';

  @override
  String currentVersion(String version) {
    return 'Current: $version';
  }

  @override
  String publishDate(String publishDate) {
    return 'Publish date: $publishDate';
  }

  @override
  String get releaseNotes => 'Release notes';

  @override
  String get noReleaseNotes => 'No release notes';

  @override
  String get alreadyLatestVersion => 'Already the latest version';

  @override
  String get download => 'Download';

  @override
  String get selectVersionToDownload => 'Select version to download';

  @override
  String get selectPlatform => 'Select platform';

  @override
  String downloadPlatform(String platform) {
    return 'Download for $platform';
  }

  @override
  String get noDownloadsAvailable => 'No downloads available';

  @override
  String get downloadApp => 'Download App';

  @override
  String get downloadAppDesc =>
      'Download app for offline use when no internet connection is available';

  @override
  String filteredForPlatform(String getPlatformName) {
    return 'Filtered for $getPlatformName';
  }

  @override
  String sizeInMB(String sizeInMB) {
    return 'Size: $sizeInMB';
  }

  @override
  String uploadDate(String updatedAt) {
    return 'Upload date: $updatedAt';
  }

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get confirmDownload => 'Confirm download';

  @override
  String confirmDownloadMessage(String name, String sizeInMB) {
    return 'Are you sure you want to download this version?\n\nFile name: $name\nSize: $sizeInMB';
  }

  @override
  String get currentPlatform => 'Current platform';

  @override
  String get eerror => 'Error';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get termsOfUseView => 'View Terms of Use of this application';

  @override
  String get versionInfo => 'Version Information';

  @override
  String get checkForNewVersion => 'Check for New Version';

  @override
  String get checkForNewVersionDesc =>
      'Check if there is a new version of the app and download the latest version if available';

  @override
  String get platform => 'Platform';

  @override
  String get fileS => 'File(s)';

  @override
  String get alsoViewAuthorOtherProducts =>
      'Also view author\'s other products';

  @override
  String get authorProducts => 'Other Products';

  @override
  String get authorProductsDesc =>
      'View other products by the author, maybe you\'ll find something interesting!';

  @override
  String get authorProductsMessage =>
      'Hi there! Here are some of my other products. If you\'re interested, feel free to check them out! I hope you\'ll find something useful among them. Thank you for visiting!';

  @override
  String get noOtherProducts => 'No other products available';

  @override
  String get loadingProducts => 'Loading products...';

  @override
  String get failedToLoadProducts => 'Failed to load products';

  @override
  String get retryLoadProducts => 'Retry loading products';

  @override
  String get visitProduct => 'Visit Product';

  @override
  String productCount(int count) {
    return '$count product(s)';
  }

  @override
  String get deleteHistoryItem => 'Delete item';

  @override
  String get tapDeleteAgainToConfirm => 'Tap delete again to confirm removal';

  @override
  String get historyItemDeleted => 'History item deleted';

  @override
  String get pinHistoryItem => 'Pin item';

  @override
  String get unpinHistoryItem => 'Unpin item';

  @override
  String get historyItemPinned => 'Item pinned';

  @override
  String get historyItemUnpinned => 'Item unpinned';

  @override
  String get securitySetupTitle => 'App Security Setup';

  @override
  String get securitySetupMessage =>
      'Would you like to set up a master password to protect your data?\nThis will secure your history from unauthorized access and protect it from data theft.';

  @override
  String get setMasterPassword => 'Set Master Password';

  @override
  String get skipSecurity => 'Skip (Use without password)';

  @override
  String get createMasterPasswordTitle => 'Create Master Password';

  @override
  String get createMasterPasswordMessage =>
      'Please create a strong master password.\nRemember this password carefully.\nIf you forget it, all your data will be lost.';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get enterMasterPasswordTitle => 'Enter Master Password';

  @override
  String get enterMasterPasswordMessage =>
      'Please enter your master password to access the app.';

  @override
  String get wrongPassword => 'Wrong password. Please try again.';

  @override
  String get forgotPasswordButton =>
      'I forgot my password and accept data loss';

  @override
  String get confirm => 'Confirm';

  @override
  String get confirmDataLossTitle => 'Confirm Data Loss';

  @override
  String get confirmDataLossMessage =>
      'You will be able to continue using the app without entering a password, but all your history data will be permanently deleted.\nThis action cannot be undone.';

  @override
  String get holdToConfirm => 'Hold to confirm';

  @override
  String get dataProtectionSettings => 'Data Protection Settings';

  @override
  String get enableDataProtection => 'Enable Data Protection';

  @override
  String get disableDataProtection => 'Disable Data Protection';

  @override
  String get dataProtectionEnabled => 'Data protection is currently enabled';

  @override
  String get dataProtectionDisabled => 'Data protection is currently disabled';

  @override
  String get enterCurrentPassword =>
      'Enter current password to disable protection';

  @override
  String get securityEnabled => 'Security enabled successfully';

  @override
  String get securityDisabled => 'Security disabled successfully';

  @override
  String get migrationInProgress => 'Migrating data...';

  @override
  String get migrationCompleted => 'Data migration completed';

  @override
  String get migrationFailed => 'Data migration failed';

  @override
  String get solid => 'Solid';

  @override
  String get includeAlpha => 'Include Alpha';

  @override
  String totalANumber(int total) {
    return 'Total: $total';
  }

  @override
  String get numberType => 'Number Type';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get dateErrStartEndConflict => 'Start date cannot be after end date';

  @override
  String get arrangeTools => 'Arrange Tools';

  @override
  String get arrangeToolsDesc =>
      'Customize the order of tools in the interface';

  @override
  String get howToArrangeTools => 'How to arrange tools';

  @override
  String get dragAndDropToReorder =>
      'Drag and drop to reorder the tools as you prefer';

  @override
  String get defaultOrder => 'Default Order';

  @override
  String get save => 'Save';

  @override
  String get reloadTools => 'Reload Tools';

  @override
  String get compactTabLayout => 'Compact Tab Layout';

  @override
  String get compactTabLayoutDesc =>
      'Hide icons in tabs for a more compact look';

  @override
  String get letterCountRange => 'Letter Count Range';

  @override
  String numberRangeFromTo(String from, String to) {
    return 'Number Range: From $from to $to';
  }

  @override
  String get loremIpsumGenerator => 'Lorem Ipsum Generator';

  @override
  String get loremIpsumGeneratorDesc => 'Lorem Ipsum';

  @override
  String get generationType => 'Generation Type';

  @override
  String get words => 'Words';

  @override
  String get sentences => 'Sentences';

  @override
  String get paragraphs => 'Paragraphs';

  @override
  String get wordCount => 'Word Count';

  @override
  String get numberOfWordsToGenerate => 'Number of words to generate';

  @override
  String get sentenceCount => 'Sentence Count';

  @override
  String get numberOfSentencesToGenerate => 'Number of sentences to generate';

  @override
  String get paragraphCount => 'Paragraph Count';

  @override
  String get numberOfParagraphsToGenerate => 'Number of paragraphs to generate';

  @override
  String get startWithLorem => 'Start with Lorem';

  @override
  String get startWithLoremDesc =>
      'Begin with classic \'Lorem ipsum dolor sit amet...\'';

  @override
  String get listPicker => 'Pick from List';

  @override
  String get listPickerDesc => 'Pick from custom lists';

  @override
  String get selectList => 'Select List';

  @override
  String get createNewList => 'Create New List';

  @override
  String get noListsAvailable => 'No lists available';

  @override
  String get selectOrCreateList => 'Select or create a list to start picking';

  @override
  String get manageList => 'Manage List';

  @override
  String get addItem => 'Add Item';

  @override
  String get items => 'Items';

  @override
  String get generatorOptions => 'Generator Options';

  @override
  String get results => 'Results';

  @override
  String get generateRandom => 'Pick Random';

  @override
  String get listName => 'List Name';

  @override
  String get create => 'Create';

  @override
  String get listPickerMode => 'Mode';

  @override
  String get modeRandom => 'Random';

  @override
  String get modeRandomDesc => 'Pick random items from the list';

  @override
  String get modeShuffle => 'Shuffle';

  @override
  String get modeShuffleDesc => 'Shuffle and pick items in order';

  @override
  String get modeTeam => 'Team';

  @override
  String get modeTeamDesc => 'Divide items into teams';

  @override
  String get team => 'Team';

  @override
  String get createListDialog => 'Create New List';

  @override
  String get enterListName => 'Enter list name (max 30 characters)';

  @override
  String get listNameRequired => 'List name is required';

  @override
  String get listNameTooLong => 'List name is too long (max 30 characters)';

  @override
  String get listNameExists => 'A list with this name already exists';

  @override
  String get teams => 'Teams';

  @override
  String get itemsPerTeam => 'Items per team';

  @override
  String get addSingleItem => 'Add single item';

  @override
  String get addMultipleItems => 'Add multiple items';

  @override
  String get addBatchItems => 'Add Multiple Items';

  @override
  String get enterItemsOneLine => 'Enter items, one per line:';

  @override
  String get batchItemsPlaceholder => 'Item 1\nItem 2\nItem 3\n...';

  @override
  String previewItems(int count) {
    return 'Preview: $count items';
  }

  @override
  String get addItems => 'Add Items';

  @override
  String get confirmAddItems => 'Confirm Add Items';

  @override
  String confirmAddItemsMessage(int count, String listName) {
    return 'Add $count items to \"$listName\"?';
  }

  @override
  String addedItemsSuccessfully(int count) {
    return 'Added $count items successfully';
  }

  @override
  String get enterAtLeastOneItem => 'Please enter at least one item';

  @override
  String get maximumItemsAllowed => 'Maximum 100 items allowed';

  @override
  String get itemName => 'Item name';

  @override
  String get itemNameRequired => 'Item name is required';

  @override
  String get itemNameTooLong => 'Item name is too long (max 30 characters)';

  @override
  String get deleteList => 'Delete List';

  @override
  String deleteListConfirm(String listName) {
    return 'Are you sure you want to delete \"$listName\"? This action cannot be undone.';
  }

  @override
  String get expand => 'Expand';

  @override
  String get collapse => 'Collapse';

  @override
  String get minimize => 'Minimize';

  @override
  String get collapseToLimitedView => 'Collapse to limited view';

  @override
  String get minimizeToHeaderOnly => 'Minimize to header only';

  @override
  String get expandToFullView => 'Expand to full view';

  @override
  String get viewDetails => 'View Details';

  @override
  String get renameList => 'Rename List';

  @override
  String get renameItem => 'Rename Item';

  @override
  String get renameListDialog => 'Rename List';

  @override
  String get renameItemDialog => 'Rename Item';

  @override
  String get enterNewListName => 'Enter new list name (max 30 characters)';

  @override
  String get enterNewItemName => 'Enter new item name (max 30 characters)';

  @override
  String get rename => 'Rename';

  @override
  String get newNameRequired => 'New name is required';

  @override
  String get newNameTooLong => 'New name is too long (max 30 characters)';

  @override
  String get template => 'Template';

  @override
  String get templates => 'Templates';

  @override
  String get cloudTemplates => 'Cloud Templates';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get pleaseConnectAndTryAgain =>
      'Please connect to the internet and try again';

  @override
  String get languageCode => 'Language';

  @override
  String itemsCount(int count) {
    return '$count items';
  }

  @override
  String get import => 'Import';

  @override
  String get languageNotMatch => 'Language Mismatch';

  @override
  String get templateNotDesignedForLanguage =>
      'This template is not designed for your language.\nDo you want to continue?';

  @override
  String get fetchingTemplates => 'Fetching templates...';

  @override
  String get noTemplatesAvailable => 'No templates available';

  @override
  String get selectTemplate => 'Select a template to import';

  @override
  String get templateImported => 'Template imported successfully';

  @override
  String get continueButton => 'Continue';

  @override
  String get importingTemplate => 'Importing template...';

  @override
  String get errorImportingTemplate => 'Error importing template';

  @override
  String get remoteListTemplateTitle => 'Remote List Template Sources';

  @override
  String get fetchAll => 'Fetch All';

  @override
  String get fetchLatestDefaults => 'Fetch Latest Defaults';

  @override
  String get defaultSourcesUpdated => 'Default sources updated successfully';

  @override
  String get addCustomSource => 'Add Custom Source';

  @override
  String get whatIsThis => 'What is this?';

  @override
  String get defaultSources => 'Default Sources';

  @override
  String get customSources => 'Custom Sources';

  @override
  String get allSources => 'All Sources';

  @override
  String get noSourcesToDisplay => 'No sources to display';

  @override
  String get errorSavingData => 'Error saving data';

  @override
  String get cannotOpenUrl => 'Cannot open URL';

  @override
  String get viewSourceUrl => 'View source URL';

  @override
  String get disable => 'Disable';

  @override
  String get enable => 'Enable';

  @override
  String get edit => 'Edit';

  @override
  String get fetch => 'Fetch';

  @override
  String get lastFetch => 'Last fetch';

  @override
  String get fetchTemplate => 'Fetch Template';

  @override
  String get cannotOpenHelpPage => 'Cannot open help page';

  @override
  String get errorLoadingSources => 'Error loading sources';

  @override
  String get name => 'Name';

  @override
  String get myCustomSource => 'My Custom Source';

  @override
  String get pleaseEnterName => 'Please enter a name';

  @override
  String get url => 'URL';

  @override
  String get pleaseEnterUrl => 'Please enter a URL';

  @override
  String get pleaseEnterValidUrl => 'Please enter a valid URL';

  @override
  String get editSource => 'Edit Source';

  @override
  String get errorUpdatingDefaults => 'Error updating defaults';

  @override
  String get urlHintText => 'https://example.com/list.json';

  @override
  String get fetchListTemplates => 'Fetch List Templates';

  @override
  String get fetchingData => 'Fetching data...';

  @override
  String get preparing => 'Preparing...';

  @override
  String get inAppBrowser => 'In-App Browser';

  @override
  String get loadUrlError => 'Error loading URL';

  @override
  String get copyUrl => 'Copy URL';

  @override
  String get goBack => 'Go Back';

  @override
  String get goForward => 'Go Forward';

  @override
  String get noSourceSelected => 'No source selected';

  @override
  String get failedToFetchData => 'Failed to fetch data';

  @override
  String get unknownError => 'Unknown error';

  @override
  String templatesCount(int count) {
    return 'Templates ($count)';
  }

  @override
  String andMoreItems(int count) {
    return '... and $count more items';
  }

  @override
  String get enter => 'Enter';

  @override
  String get increase => 'Increase';

  @override
  String get decrease => 'Decrease';

  @override
  String get range => 'Range';

  @override
  String get between => 'Between';

  @override
  String get and => 'and';

  @override
  String get browseLink => 'Browse link';

  @override
  String get copyLink => 'Copy link';

  @override
  String get openInBrowser => 'Open in browser';

  @override
  String get failedToLoadWebpage => 'Failed to load webpage';

  @override
  String get urlOptions => 'URL Options';

  @override
  String get currentUrl => 'Current URL:';

  @override
  String get urlCopied => 'URL copied to clipboard';

  @override
  String get importTemplate => 'Import Template';

  @override
  String get customizeData => 'Customize Data';

  @override
  String get fetchTemplatesFirst => 'Fetch templates from sources first';

  @override
  String get templateItems => 'Template Items';

  @override
  String get back => 'Back';

  @override
  String get importedList => 'Imported List';

  @override
  String get imported => 'Imported';

  @override
  String get error => 'Error';

  @override
  String get continueText => 'Continue';

  @override
  String get setListName => 'Set List Name';

  @override
  String get preview => 'Preview';

  @override
  String get importing => 'Importing';

  @override
  String get pleaseWait => 'Please wait';

  @override
  String get importFromFile => 'Import from File';

  @override
  String get selectFileToImport => 'Select a file to import';

  @override
  String get supportedFormat =>
      'Supported format: .txt files with one item per line';

  @override
  String get selectFile => 'Select File';

  @override
  String get previewData => 'Preview Data';

  @override
  String get readyToImport => 'Ready to Import';

  @override
  String get importConfirmation =>
      'Click Import to add this data to your lists';

  @override
  String get importData => 'Import Data';

  @override
  String get next => 'Next';

  @override
  String get itemCount => 'Item Count';

  @override
  String get importEmptyFileError =>
      'The selected file is empty or contains no valid items';

  @override
  String get importFileError => 'Failed to read file';

  @override
  String get importError => 'Import failed';

  @override
  String get importSuccess => 'Data imported successfully';

  @override
  String get dragDropHint => 'Or drag and drop a file here';

  @override
  String get enterManually => 'Enter manually';

  @override
  String get useElementAsName => 'Use an element as name';

  @override
  String get elementNumber => 'Element number';

  @override
  String get removeElementFromList => 'Remove this element from the list';

  @override
  String get removeElementDescription =>
      'The selected element will not be included in the final list';

  @override
  String get listPreview => 'List Preview';

  @override
  String get noNameSet => 'No name set';

  @override
  String get listNamingOptions => 'List Naming Options';

  @override
  String get processingFile => 'Processing file...';

  @override
  String get largeFileWarning => 'Large File Warning';

  @override
  String largeFileWarningMessage(int count) {
    return 'This file contains $count lines. Processing large amounts of data may cause slowdowns or crashes on low-end devices. Do you want to continue?';
  }

  @override
  String get remoteListTemplateSource => 'Remote List Template Source';

  @override
  String get remoteListTemplateSourceDesc =>
      'Manage cloud template sources for Pick From List';

  @override
  String get yesNoGenerator => 'Yes/No Generator';

  @override
  String get yesNoGeneratorDesc => 'Generate random Yes or No answers';

  @override
  String get counterMode => 'Counter Mode';

  @override
  String get counterModeDesc => 'Track statistics of Yes/No results';

  @override
  String get rockPaperScissorsCounterMode => 'Counter Mode';

  @override
  String get rockPaperScissorsCounterModeDesc =>
      'Track statistics of Rock/Paper/Scissors results';

  @override
  String get rockCount => 'Rock Count';

  @override
  String get paperCount => 'Paper Count';

  @override
  String get scissorsCount => 'Scissors Count';

  @override
  String get batchCount => 'Batch Count';

  @override
  String get batchCountDesc => 'Number of results to generate at once';

  @override
  String get counterStatistics => 'Counter Statistics';

  @override
  String get totalGenerations => 'Total Generations';

  @override
  String get yesCount => 'Yes Count';

  @override
  String get noCount => 'No Count';

  @override
  String get yesPercentage => 'Yes Percentage';

  @override
  String get noPercentage => 'No Percentage';

  @override
  String get headsCount => 'Heads Count';

  @override
  String get headsPercentage => 'Heads Percentage';

  @override
  String get tailsCount => 'Tails Count';

  @override
  String get tailsPercentage => 'Tails Percentage';
}
