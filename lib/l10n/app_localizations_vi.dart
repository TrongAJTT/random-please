// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get title => 'Random Please';

  @override
  String get settings => 'Cài đặt';

  @override
  String get theme => 'Chủ đề';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get userInterface => 'Giao diện người dùng';

  @override
  String get system => 'Theo hệ thống';

  @override
  String get light => 'Sáng';

  @override
  String get dark => 'Tối';

  @override
  String get english => 'Tiếng Anh';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get cache => 'Bộ nhớ đệm';

  @override
  String get clearCache => 'Xóa bộ nhớ đệm';

  @override
  String get cacheDetails => 'Chi tiết bộ nhớ đệm';

  @override
  String get viewCacheDetails => 'Xem chi tiết';

  @override
  String cacheSize(String size) {
    return 'Kích thước bộ nhớ đệm';
  }

  @override
  String get cacheItems => 'Mục';

  @override
  String get clearAllCache => 'Xóa tất cả bộ nhớ đệm';

  @override
  String get logs => 'Nhật ký ứng dụng';

  @override
  String get viewLogs => 'Xem nhật ký';

  @override
  String get clearLogs => 'Xóa nhật ký';

  @override
  String get logRetention => 'Thời gian lưu nhật ký';

  @override
  String logRetentionDays(int days) {
    return '$days ngày';
  }

  @override
  String get logRetentionForever => 'Vĩnh viễn';

  @override
  String get logRetentionDesc => 'Tự động xóa các file nhật ký cũ hơn số ngày đã chỉ định';

  @override
  String get logRetentionDescDetail => 'Nhật ký sẽ được lưu trữ trong bộ nhớ đệm và có thể được xóa tự động sau một khoảng thời gian nhất định. Bạn có thể đặt thời gian lưu giữ nhật ký từ 5 đến 30 ngày (bước nhảy 5 ngày) hoặc chọn lưu vĩnh viễn.';

  @override
  String get logRetentionAutoDelete => 'Tự động xóa sau một khoảng thời gian';

  @override
  String get logManagement => 'Quản lý nhật ký';

  @override
  String get logManagementDesc => 'Quản lý các file nhật ký ứng dụng và thông tin debug';

  @override
  String get logStatus => 'Trạng thái nhật ký';

  @override
  String get logsDesc => 'Các file nhật ký ứng dụng và thông tin debug';

  @override
  String get dataAndStorage => 'Dữ liệu & Lưu trữ';

  @override
  String confirmClearCache(Object cacheName) {
    return 'Bạn có chắc chắn muốn xóa bộ nhớ đệm \"$cacheName\"?';
  }

  @override
  String get confirmClearAllCache => 'Bạn có chắc chắn muốn xóa TẤT CẢ dữ liệu trong bộ nhớ đệm không? Thao tác này sẽ xóa tất cả các mẫu đã lưu nhưng vẫn giữ lại cài đặt của bạn.';

  @override
  String get cannotClearFollowingCaches => 'Không thể xóa các bộ nhớ đệm sau vì chúng đang được sử dụng:';

  @override
  String cacheCleared(Object cacheName) {
    return 'Đã xóa thành công bộ nhớ đệm $cacheName';
  }

  @override
  String get allCacheCleared => 'Đã xóa tất cả bộ nhớ đệm thành công';

  @override
  String errorClearingCache(Object error) {
    return 'Lỗi khi xóa bộ nhớ đệm: $error';
  }

  @override
  String get close => 'Đóng';

  @override
  String get custom => 'Tùy chỉnh';

  @override
  String get online => 'Trực tuyến';

  @override
  String get offline => 'Ngoại tuyến';

  @override
  String get options => 'Tùy chọn';

  @override
  String get about => 'Giới thiệu';

  @override
  String get add => 'Thêm';

  @override
  String get save => 'Lưu';

  @override
  String get saved => 'Đã lưu';

  @override
  String get saveToHistory => 'Lưu vào lịch sử';

  @override
  String get edit => 'Sửa';

  @override
  String get copy => 'Sao chép';

  @override
  String get move => 'Di chuyển';

  @override
  String get destination => 'Đích đến';

  @override
  String get fileName => 'Tên file';

  @override
  String get overwrite => 'Ghi đè';

  @override
  String get cancel => 'Hủy';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get searchHint => 'Tìm kiếm...';

  @override
  String get history => 'Lịch sử';

  @override
  String get total => 'Tổng cộng';

  @override
  String get selectTool => 'Chọn một chức năng ở thanh bên';

  @override
  String get selectToolDesc => 'Chọn một công cụ từ thanh bên trái để bắt đầu';

  @override
  String get settingsDesc => 'Cá nhân hóa trải nghiệm sử dụng ứng dụng';

  @override
  String get random => 'Trình tạo ngẫu nhiên';

  @override
  String get randomDesc => 'Tạo mật khẩu, số, ngày và nhiều thứ ngẫu nhiên khác';

  @override
  String get textTemplateGen => 'Tạo văn bản theo mẫu';

  @override
  String get textTemplateGenDesc => 'Tạo văn bản theo biểu mẫu có sẵn. Bạn có thể tạo các mẫu văn bản với các trường thông tin cần điền như văn bản, số, ngày tháng để sử dụng lại nhiều lần.';

  @override
  String get editTemplate => 'Sửa mẫu';

  @override
  String get createTemplate => 'Tạo mẫu mới';

  @override
  String get templateEditSuccessMessage => 'Mẫu đã được lưu thành công! Bạn có thể thoát màn hình này.';

  @override
  String get contentTab => 'Nội dung';

  @override
  String get structureTab => 'Cấu trúc';

  @override
  String get templateTitleLabel => 'Tiêu đề mẫu *';

  @override
  String get templateTitleHint => 'Nhập tiêu đề cho mẫu này';

  @override
  String get pleaseEnterTitle => 'Vui lòng nhập tiêu đề';

  @override
  String get addDataField => 'Thêm trường dữ liệu';

  @override
  String get addDataLoop => 'Thêm vòng lặp dữ liệu';

  @override
  String get fieldTypeText => 'Văn bản';

  @override
  String get fieldTypeLargeText => 'Văn bản nhiều dòng';

  @override
  String get fieldTypeNumber => 'Số';

  @override
  String get fieldTypeDate => 'Ngày';

  @override
  String get fieldTypeTime => 'Giờ';

  @override
  String get fieldTypeDateTime => 'Ngày & Giờ';

  @override
  String get fieldTitleLabel => 'Tiêu đề trường *';

  @override
  String get fieldTitleHint => 'VD: Tên khách hàng';

  @override
  String get pleaseEnterFieldTitle => 'Vui lòng nhập tiêu đề trường';

  @override
  String get copyAndClose => 'Sao chép và đóng';

  @override
  String get insertAtCursor => 'Chèn tại vị trí con trỏ';

  @override
  String get appendToEnd => 'Thêm vào cuối';

  @override
  String get loopTitleLabel => 'Tiêu đề vòng lặp *';

  @override
  String get loopTitleHint => 'VD: Danh sách sản phẩm';

  @override
  String get pleaseFixDuplicateIds => 'Vui lòng sửa các ID trùng lặp không nhất quán trước khi lưu';

  @override
  String errorSavingTemplate(Object error) {
    return 'Lỗi khi lưu mẫu: $error';
  }

  @override
  String get templateContentLabel => 'Nội dung mẫu *';

  @override
  String get templateContentHint => 'Nhập nội dung mẫu và thêm trường dữ liệu...';

  @override
  String get pleaseEnterTemplateContent => 'Vui lòng nhập nội dung mẫu';

  @override
  String get templateStructure => 'Cấu trúc mẫu';

  @override
  String get templateStructureOverview => 'Xem tổng quan các trường và vòng lặp trong mẫu.';

  @override
  String get textTemplatesTitle => 'Các mẫu văn bản';

  @override
  String get addNewTemplate => 'Thêm mẫu mới';

  @override
  String get noTemplatesYet => 'Chưa có mẫu nào';

  @override
  String get createTemplatesHint => 'Tạo mẫu đầu tiên để bắt đầu.';

  @override
  String get createNewTemplate => 'Tạo mẫu mới';

  @override
  String get exportToJson => 'Xuất ra JSON';

  @override
  String get confirmDeletion => 'Xác nhận xóa';

  @override
  String confirmDeleteTemplateMsg(Object title) {
    return 'Bạn có chắc muốn xóa \"$title\"?';
  }

  @override
  String get holdToDeleteInstruction => 'Nhấn giữ nút xóa trong 5 giây để xác nhận';

  @override
  String get holdToDelete => 'Nhấn giữ để xóa...';

  @override
  String get deleting => 'Đang xóa...';

  @override
  String get holdToClearCache => 'Nhấn giữ để xóa...';

  @override
  String get clearingCache => 'Đang xóa cache...';

  @override
  String get holdToClearCacheInstruction => 'Nhấn giữ nút xóa trong 10 giây để xác nhận';

  @override
  String get templateDeleted => 'Đã xóa mẫu.';

  @override
  String errorDeletingTemplate(Object error) {
    return 'Lỗi khi xóa mẫu: $error';
  }

  @override
  String get help => 'Trợ giúp';

  @override
  String get usageGuide => 'Hướng dẫn sử dụng';

  @override
  String get textTemplateToolIntro => 'Công cụ này giúp bạn quản lý và sử dụng các mẫu văn bản hiệu quả.';

  @override
  String get helpCreateNewTemplate => 'Tạo mẫu mới bằng nút +.';

  @override
  String get helpTapToUseTemplate => 'Nhấn vào mẫu để sử dụng.';

  @override
  String get helpTapMenuForActions => 'Nhấn vào menu (⋮) để xem thêm tùy chọn.';

  @override
  String get textTemplateScreenHint => 'Các mẫu được lưu cục bộ trên thiết bị của bạn.';

  @override
  String get gotIt => 'Đã hiểu';

  @override
  String get addTemplate => 'Thêm mẫu';

  @override
  String get addManually => 'Thêm thủ công';

  @override
  String get createTemplateFromScratch => 'Tạo mẫu từ đầu';

  @override
  String get addFromFile => 'Thêm từ file';

  @override
  String get importTemplateFromJson => 'Nhập nhiều template từ file JSON';

  @override
  String get templateImported => 'Nhập template thành công.';

  @override
  String templatesImported(Object count) {
    return 'Đã nhập $count template thành công.';
  }

  @override
  String get importResults => 'Kết quả nhập';

  @override
  String importSummary(Object failCount, Object successCount) {
    return '$successCount thành công, $failCount thất bại';
  }

  @override
  String successfulImports(Object count) {
    return 'Nhập thành công ($count)';
  }

  @override
  String failedImports(Object count) {
    return 'Nhập thất bại ($count)';
  }

  @override
  String get noImportsAttempted => 'Không có file nào được chọn để nhập';

  @override
  String invalidTemplateFormat(Object error) {
    return 'Định dạng template không hợp lệ: $error';
  }

  @override
  String errorImportingTemplate(Object error) {
    return 'Lỗi khi nhập mẫu: $error';
  }

  @override
  String get copySuffix => 'bản sao';

  @override
  String get templateCopied => 'Đã sao chép mẫu.';

  @override
  String errorCopyingTemplate(Object error) {
    return 'Lỗi khi sao chép mẫu: $error';
  }

  @override
  String get saveTemplateAsJson => 'Lưu mẫu thành file JSON';

  @override
  String templateExported(Object path) {
    return 'Đã xuất mẫu ra $path';
  }

  @override
  String errorExportingTemplate(Object error) {
    return 'Lỗi khi xuất mẫu: $error';
  }

  @override
  String generateDocumentTitle(Object title) {
    return 'Tạo tài liệu: $title';
  }

  @override
  String get fillDataTab => 'Điền dữ liệu';

  @override
  String get previewTab => 'Xem trước';

  @override
  String get showDocument => 'Hiển thị tài liệu';

  @override
  String get fillInformation => 'Điền thông tin';

  @override
  String get dataLoops => 'Vòng lặp dữ liệu';

  @override
  String get generateDocument => 'Tạo tài liệu';

  @override
  String get preview => 'Xem trước';

  @override
  String get addNewRow => 'Thêm dòng mới';

  @override
  String rowNumber(Object number) {
    return 'Dòng $number';
  }

  @override
  String get deleteThisRow => 'Xóa dòng này';

  @override
  String enterField(Object field) {
    return 'Nhập $field';
  }

  @override
  String unsupportedFieldType(Object type) {
    return 'Không hỗ trợ kiểu trường $type';
  }

  @override
  String get selectDate => 'Chọn ngày';

  @override
  String get selectTime => 'Chọn giờ';

  @override
  String get selectDateTime => 'Chọn ngày và giờ';

  @override
  String get copiedToClipboard => 'Đã sao chép vào clipboard';

  @override
  String get completedDocument => 'Tài liệu đã hoàn thành';

  @override
  String fieldCount(Object count) {
    return 'Trường dữ liệu: $count';
  }

  @override
  String get basicFieldCount => 'trường dữ liệu cơ bản';

  @override
  String get loopFieldCount => 'trường dữ liệu trong vòng lặp';

  @override
  String loopDataCount(Object count) {
    return 'Vòng lặp dữ liệu: $count';
  }

  @override
  String duplicateIdWarning(Object count) {
    return 'Phát hiện $count ID trùng lặp không nhất quán. Element có cùng ID phải có cùng loại và tiêu đề.';
  }

  @override
  String get normalFields => 'Trường dữ liệu thông thường:';

  @override
  String loopLabel(Object title) {
    return 'Vòng lặp: $title';
  }

  @override
  String get structureDetail => 'Chi tiết cấu trúc';

  @override
  String get basicFields => 'Trường dữ liệu cơ bản';

  @override
  String get loopContent => 'Nội dung vòng lặp';

  @override
  String fieldInLoop(Object field, Object loop) {
    return 'Trường \"$field\" thuộc vòng lặp \"$loop\"';
  }

  @override
  String characterCount(Object count) {
    return '$count ký tự';
  }

  @override
  String fieldsAndLoops(Object fields, Object loops) {
    return '$fields trường, $loops vòng lặp';
  }

  @override
  String get longPressToSelect => 'Nhấn giữ để chọn mẫu';

  @override
  String selectedTemplates(Object count) {
    return 'Đã chọn $count';
  }

  @override
  String get selectAll => 'Chọn tất cả';

  @override
  String get deselectAll => 'Bỏ chọn tất cả';

  @override
  String get batchExport => 'Xuất đã chọn';

  @override
  String get batchDelete => 'Xóa đã chọn';

  @override
  String get exportTemplates => 'Xuất mẫu';

  @override
  String get editFilenames => 'Chỉnh sửa tên tệp trước khi xuất:';

  @override
  String filenameFor(Object title) {
    return 'Tên tệp cho \"$title\":';
  }

  @override
  String get confirmBatchDelete => 'Xác nhận xóa hàng loạt';

  @override
  String typeConfirmToDelete(Object count) {
    return 'Gõ \"confirm\" để xóa $count mẫu đã chọn:';
  }

  @override
  String get confirmText => 'confirm';

  @override
  String get confirmationRequired => 'Vui lòng gõ \"confirm\" để tiếp tục';

  @override
  String batchExportCompleted(Object count) {
    return 'Đã xuất $count mẫu thành công';
  }

  @override
  String batchDeleteCompleted(Object count) {
    return 'Đã xóa $count mẫu thành công';
  }

  @override
  String errorDuringBatchExport(Object errors) {
    return 'Lỗi khi xuất một số mẫu: $errors';
  }

  @override
  String get passwordGenerator => 'Tạo mật khẩu';

  @override
  String get passwordGeneratorDesc => 'Tạo mật khẩu ngẫu nhiên an toàn';

  @override
  String get numCharacters => 'Số ký tự';

  @override
  String get includeLowercase => 'Bao gồm chữ thường';

  @override
  String get includeUppercase => 'Bao gồm chữ hoa';

  @override
  String get includeNumbers => 'Bao gồm số';

  @override
  String get includeSpecial => 'Bao gồm ký tự đặc biệt';

  @override
  String get generate => 'Tạo';

  @override
  String get generatedPassword => 'Mật khẩu đã tạo';

  @override
  String get copyToClipboard => 'Sao chép';

  @override
  String get copied => 'Đã sao chép!';

  @override
  String get restored => 'Đã khôi phục!';

  @override
  String get dateCalculator => 'Máy tính ngày';

  @override
  String get dateCalculatorDesc => 'Một công cụ linh hoạt để xử lý mọi tính toán liên quan đến ngày tháng của bạn. Dưới đây là tổng quan về các tính năng của nó:';

  @override
  String get dateInfoTabDescription => 'Cung cấp thông tin chi tiết cho một ngày bất kỳ, bao gồm thứ trong tuần, ngày trong năm, số tuần, quý và trạng thái năm nhuận.';

  @override
  String get dateDifferenceTabDescription => 'Tính toán khoảng thời gian giữa hai ngày, hiển thị kết quả dưới dạng kết hợp năm, tháng, ngày, cũng như trong các đơn vị tổng cộng như tháng, tuần, ngày, v.v.';

  @override
  String get addSubtractTabDescription => 'Thêm hoặc bớt một số năm, tháng, và ngày cụ thể từ một ngày cho trước để xác định ngày kết quả.';

  @override
  String get ageCalculatorTabDescription => 'Tính tuổi từ ngày sinh và hiển thị tổng số ngày đã sống, số ngày còn lại đến sinh nhật tiếp theo và ngày sinh nhật tiếp theo.';

  @override
  String get dateCalculatorHistory => 'Lịch sử Máy tính Ngày';

  @override
  String get dateDifference => 'Chênh lệch';

  @override
  String get addSubtractDate => 'Thêm/bớt';

  @override
  String get ageCalculator => 'Sinh nhật';

  @override
  String get ageCalculatorDesc => 'Tính tuổi và theo dõi các ngày sinh nhật sắp tới.';

  @override
  String get workingDays => 'Ngày làm việc';

  @override
  String get timezoneConverter => 'Múi giờ';

  @override
  String get recurringDates => 'Ngày định kỳ';

  @override
  String get countdown => 'Đếm ngược';

  @override
  String get dateInfo => 'Chi tiết';

  @override
  String get dateInfoDesc => 'Nhận thông tin chi tiết về bất kỳ ngày nào được chọn';

  @override
  String get timeUnitConverter => 'Đơn vị thời gian';

  @override
  String get nthWeekday => 'Nth Weekday';

  @override
  String get allCalculations => 'All Calculations';

  @override
  String get filterByType => 'Lọc theo loại file';

  @override
  String get clearCalculationHistory => 'Clear History';

  @override
  String get bookmarkResult => 'Bookmark Result';

  @override
  String get resultBookmarked => 'Result bookmarked to history';

  @override
  String get clearTabData => 'Clear Data';

  @override
  String get tabDataCleared => 'Data cleared for current tab';

  @override
  String get showCalculatorInfo => 'Xem thông tin máy tính';

  @override
  String get startDate => 'Ngày bắt đầu';

  @override
  String get endDate => 'Ngày kết thúc';

  @override
  String get baseDate => 'Ngày cơ sở';

  @override
  String get birthDate => 'Ngày sinh';

  @override
  String get targetDate => 'Target Date';

  @override
  String get selectDateToView => 'Chọn một ngày để xem thông tin chi tiết';

  @override
  String get duration => 'Thời lượng';

  @override
  String get dateDistanceSection => 'Khoảng cách ngày';

  @override
  String get unitConversionSection => 'Chuyển đổi sang từng đơn vị';

  @override
  String get totalMonths => 'Tổng số tháng';

  @override
  String get totalWeeks => 'Tổng số tuần';

  @override
  String get totalDays => 'Tổng số ngày';

  @override
  String get totalHours => 'Tổng số giờ';

  @override
  String get totalMinutes => 'Tổng số phút';

  @override
  String get resultDate => 'Ngày kết quả';

  @override
  String get dayOfWeek => 'Ngày trong tuần';

  @override
  String get years => 'Năm';

  @override
  String get months => 'Tháng';

  @override
  String get days => 'Ngày';

  @override
  String get hours => 'Giờ';

  @override
  String get minutes => 'Phút';

  @override
  String get seconds => 'Giây';

  @override
  String get weeks => 'tuần';

  @override
  String get addSubtractValues => 'Thêm/bớt giá trị';

  @override
  String get addSubtractResultsTitle => 'Kết quả';

  @override
  String get ageCalculatorResultsTitle => 'Chi tiết sinh nhật';

  @override
  String get age => 'Tuổi';

  @override
  String get daysLived => 'Tổng số ngày đã sống';

  @override
  String get nextBirthday => 'Sinh nhật tiếp theo';

  @override
  String get daysUntilBirthday => 'Số ngày đến sinh nhật';

  @override
  String get workingDaysCount => 'Working Days';

  @override
  String get excludeWeekends => 'Exclude Weekends';

  @override
  String get customHolidays => 'Custom Holidays';

  @override
  String get addHoliday => 'Add Holiday';

  @override
  String get removeHoliday => 'Remove Holiday';

  @override
  String get fromTimezone => 'From Timezone';

  @override
  String get toTimezone => 'To Timezone';

  @override
  String get convertedTime => 'Converted Time';

  @override
  String get recurringPattern => 'Pattern';

  @override
  String get interval => 'Interval';

  @override
  String get occurrences => 'Occurrences';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get generatedDates => 'Generated Dates';

  @override
  String get eventName => 'Event Name';

  @override
  String timeRemaining(Object seconds) {
    return 'Thời gian còn lại: ${seconds}s';
  }

  @override
  String get expired => 'Expired';

  @override
  String get daysRemaining => 'Days Remaining';

  @override
  String get hoursRemaining => 'Hours Remaining';

  @override
  String get minutesRemaining => 'Minutes Remaining';

  @override
  String get currentWeek => 'Current Week';

  @override
  String weekOf(int year) {
    return 'Week of $year';
  }

  @override
  String get currentDay => 'Current Day';

  @override
  String dayOf(int day, int year) {
    return 'Day $day of $year';
  }

  @override
  String get convertValue => 'Convert Value';

  @override
  String get toUnit => 'To Unit';

  @override
  String get convertedValue => 'Converted Value';

  @override
  String get timeUnits => 'Time Units';

  @override
  String get findWeekday => 'Find Weekday';

  @override
  String get year => 'Year';

  @override
  String get month => 'Month';

  @override
  String get weekday => 'Weekday';

  @override
  String get occurrence => 'Occurrence';

  @override
  String get first => 'First';

  @override
  String get second => 'Second';

  @override
  String get third => 'Third';

  @override
  String get fourth => 'Fourth';

  @override
  String get last => 'Last';

  @override
  String get monday => 'Thứ hai';

  @override
  String get tuesday => 'Thứ ba';

  @override
  String get wednesday => 'Thứ tư';

  @override
  String get thursday => 'Thứ năm';

  @override
  String get friday => 'Thứ sáu';

  @override
  String get saturday => 'Thứ bảy';

  @override
  String get sunday => 'Chủ nhật';

  @override
  String get january => 'Tháng 1';

  @override
  String get february => 'Tháng 2';

  @override
  String get march => 'Tháng 3';

  @override
  String get april => 'Tháng 4';

  @override
  String get may => 'Tháng 5';

  @override
  String get june => 'Tháng 6';

  @override
  String get july => 'Tháng 7';

  @override
  String get august => 'Tháng 8';

  @override
  String get september => 'Tháng 9';

  @override
  String get october => 'Tháng 10';

  @override
  String get november => 'Tháng 11';

  @override
  String get december => 'Tháng 12';

  @override
  String get dateNotFound => 'Date not found';

  @override
  String get invalidDate => 'Invalid date';

  @override
  String get calculationError => 'Calculation error';

  @override
  String get noHistoryYet => 'Chưa có lịch sử';

  @override
  String get performCalculation => 'Perform your first calculation to see history here';

  @override
  String get confirmClearHistory => 'Bạn có chắc chắn muốn xóa lịch sử không?';

  @override
  String get confirmClearHistoryMessage => 'Điều này sẽ xóa tất cả các mục lịch sử đã lưu. Hành động này không thể hoàn tác.\nHãy chắc chắn rằng bạn đã lưu bất kỳ kết quả quan trọng nào trước khi tiếp tục.';

  @override
  String get historyCleared => 'Đã xóa lịch sử tính toán';

  @override
  String get historyItem => 'History Item';

  @override
  String get loadFromHistory => 'Load from History';

  @override
  String get deleteFromHistory => 'Delete from History';

  @override
  String get historyItemDeleted => 'History item deleted';

  @override
  String get restoreExpression => 'Khôi phục biểu thức';

  @override
  String get restoreResult => 'Khôi phục kết quả';

  @override
  String get numberGenerator => 'Tạo số ngẫu nhiên';

  @override
  String get numberGeneratorDesc => 'Tạo dãy số và chuỗi số ngẫu nhiên';

  @override
  String get integers => 'Số nguyên';

  @override
  String get floatingPoint => 'Số thực';

  @override
  String get minValue => 'Giá trị tối thiểu';

  @override
  String get maxValue => 'Giá trị tối đa';

  @override
  String get quantity => 'Số lượng';

  @override
  String get allowDuplicates => 'Cho phép trùng lặp';

  @override
  String get includeSeconds => 'Hiển thị số giây';

  @override
  String get generatedNumbers => 'Số đã tạo';

  @override
  String get other => 'Khác';

  @override
  String get yesNo => 'Có hay Không?';

  @override
  String get yesNoDesc => 'Nhận quyết định có/không nhanh chóng';

  @override
  String get flipCoin => 'Tung đồng xu';

  @override
  String get flipCoinDesc => 'Tung đồng xu ảo để chọn lựa ngẫu nhiên';

  @override
  String get flipCoinInstruction => 'Lật đồng xu để xem kết quả';

  @override
  String get rockPaperScissors => 'Kéo búa bao';

  @override
  String get rockPaperScissorsDesc => 'Chơi trò chơi kinh điển bằng tay';

  @override
  String get rollDice => 'Tung xúc xắc';

  @override
  String get rollDiceDesc => 'Tung xúc xắc ảo với số mặt tùy chỉnh';

  @override
  String get diceCount => 'Số lượng xúc xắc';

  @override
  String get diceSides => 'Số mặt mỗi xúc xắc';

  @override
  String get colorGenerator => 'Tạo màu ngẫu nhiên';

  @override
  String get colorGeneratorDesc => 'Tạo màu sắc và bảng màu ngẫu nhiên';

  @override
  String get hex6 => 'HEX (6 chữ số)';

  @override
  String get hex8 => 'HEX (8 chữ số với alpha)';

  @override
  String get generatedColor => 'Màu đã tạo';

  @override
  String get latinLetters => 'Chữ cái Latin';

  @override
  String get latinLettersDesc => 'Tạo chữ cái alphabet ngẫu nhiên';

  @override
  String get letterCount => 'Số lượng chữ cái';

  @override
  String get tens => 'Chục';

  @override
  String get units => 'Đơn vị';

  @override
  String get playingCards => 'Bài tây';

  @override
  String get playingCardsDesc => 'Rút thẻ bài ngẫu nhiên';

  @override
  String get includeJokers => 'Bao gồm lá Joker';

  @override
  String get cardCount => 'Số lượng lá bài';

  @override
  String get currencyConverter => 'Quy đổi tiền tệ';

  @override
  String get updatingRates => 'Đang cập nhật tỷ giá tiền tệ...';

  @override
  String lastUpdatedAt(Object date, Object time) {
    return 'Cập nhật lần cuối: $date lúc $time';
  }

  @override
  String get noRatesAvailable => 'Chưa có thông tin tỷ giá tiền tệ, đang lấy tỷ giá...';

  @override
  String get staticRates => 'Tĩnh';

  @override
  String get refreshRates => 'Làm mới tỷ giá';

  @override
  String get resetLayout => 'Đặt lại bố cục';

  @override
  String get confirmResetLayout => 'Xác nhận đặt lại bố cục';

  @override
  String get confirmResetLayoutMessage => 'Bạn có chắc chắn muốn đặt lại bố cục? Điều này sẽ xóa tất cả thẻ và khôi phục cài đặt mặc định.';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get addCard => 'Thêm thẻ';

  @override
  String get addRow => 'Thêm dòng';

  @override
  String get cardView => 'Chế độ thẻ';

  @override
  String get cards => 'Thẻ';

  @override
  String get rows => 'Dòng';

  @override
  String get converter => 'Bộ chuyển đổi';

  @override
  String get amount => 'Số tiền';

  @override
  String get from => 'Từ';

  @override
  String get fromCurrency => 'Từ loại tiền';

  @override
  String get convertedTo => 'Chuyển đổi thành';

  @override
  String get removeCard => 'Xóa thẻ';

  @override
  String get removeRow => 'Xóa dòng';

  @override
  String get liveRatesUpdated => 'Đã cập nhật tỷ giá trực tiếp thành công';

  @override
  String get staticRatesUsed => 'Đang sử dụng tỷ giá tĩnh (không có dữ liệu trực tiếp)';

  @override
  String get failedToUpdateRates => 'Không thể cập nhật tỷ giá';

  @override
  String get actions => 'Hành động';

  @override
  String get customizeCurrenciesDialog => 'Tùy chỉnh tiền tệ';

  @override
  String get searchCurrencies => 'Tìm kiếm tiền tệ...';

  @override
  String get noCurrenciesFound => 'Không tìm thấy tiền tệ';

  @override
  String currenciesSelected(Object count) {
    return 'Đã chọn $count loại tiền';
  }

  @override
  String get applyChanges => 'Áp dụng thay đổi';

  @override
  String get currencyStatusSuccess => 'Tỷ giá trực tiếp';

  @override
  String get currencyStatusFailed => 'Lỗi lấy dữ liệu';

  @override
  String get currencyStatusTimeout => 'Hết thời gian';

  @override
  String get currencyStatusNotSupported => 'Không hỗ trợ';

  @override
  String get currencyStatusStatic => 'Tỷ giá tĩnh';

  @override
  String get currencyStatusFetchedRecently => 'Đã fetch gần đây';

  @override
  String get currencyStatusSuccessDesc => 'Đã lấy tỷ giá trực tiếp thành công';

  @override
  String get currencyStatusFailedDesc => 'Không thể lấy tỷ giá trực tiếp, sử dụng tỷ giá tĩnh';

  @override
  String get currencyStatusTimeoutDesc => 'Hết thời gian chờ, sử dụng tỷ giá tĩnh';

  @override
  String get currencyStatusNotSupportedDesc => 'API không hỗ trợ loại tiền này';

  @override
  String get currencyStatusStaticDesc => 'Đang sử dụng tỷ giá tĩnh';

  @override
  String get currencyStatusFetchedRecentlyDesc => 'Đã fetch thành công trong vòng 1 giờ qua';

  @override
  String get currencyConverterInfo => 'Thông tin chuyển đổi tiền tệ';

  @override
  String get aboutThisFeature => 'Về chức năng này';

  @override
  String get aboutThisFeatureDesc => 'Chuyển đổi tiền tệ cho phép bạn quy đổi giữa các loại tiền khác nhau bằng tỷ giá trực tiếp hoặc tỷ giá tĩnh. Hỗ trợ hơn 80 loại tiền tệ trên thế giới.';

  @override
  String get howToUseDesc => '• Thêm hoặc xóa thẻ/dòng cho nhiều phép chuyển đổi\n• Tùy chỉnh các loại tiền hiển thị\n• Chuyển đổi giữa chế độ thẻ và bảng\n• Tỷ giá tự động cập nhật theo cài đặt của bạn';

  @override
  String get staticRatesInfo => 'Tỷ giá tĩnh';

  @override
  String get staticRatesInfoDesc => 'Tỷ giá tĩnh là giá trị dự phòng được sử dụng khi không thể lấy tỷ giá trực tiếp. Các tỷ giá này được cập nhật định kỳ và có thể không phản ánh giá thị trường thời gian thực.';

  @override
  String get viewStaticRates => 'Xem tỷ giá tĩnh';

  @override
  String get lastStaticUpdate => 'Lần cập nhật tỷ giá tĩnh cuối: Tháng 5/2025';

  @override
  String get staticRatesList => 'Danh sách tỷ giá tĩnh';

  @override
  String get rateBasedOnUSD => 'Tất cả tỷ giá dựa trên 1 USD';

  @override
  String get maxCurrenciesSelected => 'Tối đa 10 loại tiền có thể được chọn';

  @override
  String get savePreset => 'Lưu Cấu Hình';

  @override
  String get loadPreset => 'Lấy Cấu Hình';

  @override
  String get presetName => 'Tên Cấu Hình';

  @override
  String get enterPresetName => 'Nhập tên cấu hình';

  @override
  String get presetNameRequired => 'Tên cấu hình là bắt buộc';

  @override
  String get presetLoaded => 'Cấu hình đã được tải thành công';

  @override
  String get presetDeleted => 'Cấu hình đã được xóa thành công';

  @override
  String get deletePreset => 'Xóa Cấu Hình';

  @override
  String get confirmDeletePreset => 'Bạn có chắc chắn muốn xóa cấu hình này không?';

  @override
  String get sortBy => 'Sắp xếp theo';

  @override
  String get sortByName => 'Tên';

  @override
  String get sortByDate => 'Ngày tạo';

  @override
  String get noPresetsFound => 'Không tìm thấy cấu hình nào';

  @override
  String get delete => 'Xóa';

  @override
  String createdOn(Object date) {
    return 'Tạo vào $date';
  }

  @override
  String currencies(Object count) {
    return '$count loại tiền';
  }

  @override
  String currenciesCount(Object count) {
    return '$count loại tiền';
  }

  @override
  String createdDate(Object date) {
    return 'Tạo: $date';
  }

  @override
  String get sortByLabel => 'Sắp xếp theo:';

  @override
  String get selectPreset => 'Chọn';

  @override
  String get selected => 'Đã chọn';

  @override
  String get deletePresetAction => 'Xóa';

  @override
  String get deletePresetTitle => 'Xóa Cấu Hình';

  @override
  String get deletePresetConfirm => 'Bạn có chắc chắn muốn xóa cấu hình này không?';

  @override
  String get presetDeletedSuccess => 'Đã xóa cấu hình';

  @override
  String get errorLabel => 'Lỗi:';

  @override
  String get fetchTimeout => 'Thời Gian Chờ Fetch';

  @override
  String get fetchTimeoutDesc => 'Thiết lập thời gian chờ khi lấy tỷ giá (5-20 giây)';

  @override
  String fetchTimeoutSeconds(Object seconds) {
    return '${seconds}s';
  }

  @override
  String get fetchRetryIncomplete => 'Thử lại khi chưa hoàn tất';

  @override
  String get fetchRetryIncompleteDesc => 'Tự động thử lại các loại tiền bị lỗi/timeout trong quá trình fetch';

  @override
  String fetchRetryTimes(int times) {
    return '$times lần thử';
  }

  @override
  String get fetchingRates => 'Đang Lấy Tỷ Giá';

  @override
  String fetchingProgress(Object completed, Object total) {
    return 'Tiến độ: $completed/$total';
  }

  @override
  String get fetchingStatus => 'Tình Trạng';

  @override
  String fetchingCurrency(Object currency) {
    return 'Đang lấy $currency...';
  }

  @override
  String get fetchComplete => 'Hoàn Thành';

  @override
  String get fetchCancelled => 'Đã Hủy';

  @override
  String get dateGenerator => 'Tạo ngày ngẫu nhiên';

  @override
  String get dateGeneratorDesc => 'Tạo ngày tháng ngẫu nhiên trong khoảng';

  @override
  String get dateCount => 'Số lượng ngày';

  @override
  String get timeGenerator => 'Tạo giờ ngẫu nhiên';

  @override
  String get timeGeneratorDesc => 'Tạo thời gian trong ngày ngẫu nhiên';

  @override
  String get startTime => 'Giờ bắt đầu';

  @override
  String get endTime => 'Giờ kết thúc';

  @override
  String get timeCount => 'Số lượng giờ';

  @override
  String get dateTimeGenerator => 'Tạo ngày giờ ngẫu nhiên';

  @override
  String get dateTimeGeneratorDesc => 'Tạo kết hợp ngày và giờ ngẫu nhiên';

  @override
  String get heads => 'Sấp';

  @override
  String get tails => 'Ngửa';

  @override
  String get rock => 'Búa';

  @override
  String get paper => 'Bao';

  @override
  String get scissors => 'Kéo';

  @override
  String get randomResult => 'Kết quả';

  @override
  String get flipping => 'Đang lật...';

  @override
  String get skipAnimation => 'Bỏ qua hoạt ảnh';

  @override
  String get skipAnimationDesc => 'Tắt hoạt ảnh để có kết quả nhanh hơn';

  @override
  String latinLetterGenerationError(Object count) {
    return 'Không thể tạo $count chữ cái duy nhất từ bộ có sẵn. Vui lòng giảm số lượng hoặc cho phép trùng lặp.';
  }

  @override
  String get quickActions => 'Tác vụ nhanh';

  @override
  String get quickActionsDesc => 'Tùy chỉnh các phím tắt xuất hiện khi bạn nhấn giữ biểu tượng ứng dụng.';

  @override
  String get cacheTypeTextTemplates => 'Mẫu văn bản';

  @override
  String get cacheTypeTextTemplatesDesc => 'Các mẫu văn bản và nội dung đã lưu';

  @override
  String get cacheTypeAppSettings => 'Cài đặt ứng dụng';

  @override
  String get cacheTypeAppSettingsDesc => 'Giao diện, ngôn ngữ và tùy chọn người dùng';

  @override
  String get cacheTypeRandomGenerators => 'Trình tạo ngẫu nhiên';

  @override
  String get cacheTypeRandomGeneratorsDesc => 'Lịch sử tạo và cài đặt';

  @override
  String get saveGenerationHistory => 'Ghi nhớ lịch sử tạo';

  @override
  String get saveGenerationHistoryDesc => 'Ghi nhớ và hiển thị lịch sử các mục đã tạo';

  @override
  String get generationHistory => 'Lịch sử tạo';

  @override
  String get generatedAt => 'Tạo lúc';

  @override
  String get noHistoryMessage => 'Tạo một số kết quả ngẫu nhiên để xem chúng ở đây';

  @override
  String get clearHistory => 'Xóa lịch sử';

  @override
  String get calculationHistory => 'Lịch sử tính toán';

  @override
  String get noCalculationHistory => 'Chưa có lịch sử tính toán';

  @override
  String get saveCalculationHistory => 'Ghi nhớ lịch sử tính toán';

  @override
  String get saveCalculationHistoryDesc => 'Ghi nhớ và hiển thị lịch sử các phép tính';

  @override
  String get typeConfirmToProceed => 'Nhập \"confirm\" để tiếp tục:';

  @override
  String get toolsShortcuts => 'Công cụ & Phím tắt';

  @override
  String get displayArrangeTools => 'Hiển thị và sắp xếp công cụ';

  @override
  String get displayArrangeToolsDesc => 'Điều khiển công cụ nào hiển thị và thứ tự của chúng';

  @override
  String get manageToolVisibility => 'Quản lý Hiển thị và Thứ tự Công cụ';

  @override
  String get dragToReorder => 'Kéo để sắp xếp lại công cụ';

  @override
  String get allToolsHidden => 'Tất cả công cụ đã ẩn';

  @override
  String get allToolsHiddenDesc => 'Vui lòng bật ít nhất một công cụ để tiếp tục sử dụng ứng dụng';

  @override
  String get enableAtLeastOneTool => 'Vui lòng bật ít nhất một công cụ.';

  @override
  String get toolVisibilityChanged => 'Thứ tự và hiển thị công cụ đã được cập nhật.';

  @override
  String get errorMinOneTool => 'Phải có ít nhất một công cụ được hiển thị.';

  @override
  String get resetToDefault => 'Đặt lại mặc định';

  @override
  String get manageQuickActions => 'Quản lý Thao tác nhanh';

  @override
  String get manageQuickActionsDesc => 'Cấu hình phím tắt để truy cập nhanh các công cụ';

  @override
  String get quickActionsDialogTitle => 'Thao tác nhanh';

  @override
  String get quickActionsDialogDesc => 'Chọn tối đa 4 công cụ để truy cập nhanh qua biểu tượng ứng dụng hoặc thanh tác vụ';

  @override
  String get quickActionsLimit => 'Tối đa 4 thao tác nhanh được phép';

  @override
  String get quickActionsLimitReached => 'Bạn chỉ có thể chọn tối đa 4 công cụ cho thao tác nhanh';

  @override
  String get clearAllQuickActions => 'Xóa tất cả';

  @override
  String get quickActionsCleared => 'Đã xóa thao tác nhanh';

  @override
  String get quickActionsUpdated => 'Đã cập nhật thao tác nhanh';

  @override
  String get quickActionsInfo => 'Thao tác nhanh';

  @override
  String get selectUpTo4Tools => 'Chọn tối đa 4 công cụ để truy cập nhanh.';

  @override
  String get quickActionsEnableDesc => 'Thao tác nhanh sẽ xuất hiện khi bạn nhấn giữ biểu tượng ứng dụng trên Android hoặc nhấp chuột phải vào biểu tượng thanh tác vụ trên Windows.';

  @override
  String get quickActionsEnableDescMobile => 'Thao tác nhanh sẽ xuất hiện khi bạn nhấn giữ biểu tượng ứng dụng (chỉ Android/iOS).';

  @override
  String selectedCount(int current, int max) {
    return 'Đã chọn: $current trong $max';
  }

  @override
  String get maxQuickActionsReached => 'Đã đạt tối đa 4 thao tác nhanh';

  @override
  String get clearAll => 'Xóa tất cả';

  @override
  String get converterTools => 'Công cụ chuyển đổi';

  @override
  String get converterToolsDesc => 'Chuyển đổi giữa các đơn vị và hệ thống khác nhau';

  @override
  String get calculatorTools => 'Công cụ tính toán';

  @override
  String get calculatorToolsDesc => 'Các máy tính chuyên dụng cho sức khỏe, tài chính và hơn thế nữa';

  @override
  String get lengthConverter => 'Chuyển đổi Chiều dài';

  @override
  String get temperatureConverter => 'Chuyển đổi Nhiệt độ';

  @override
  String get volumeConverter => 'Chuyển đổi Thể tích';

  @override
  String get areaConverter => 'Chuyển đổi Diện tích';

  @override
  String get speedConverter => 'Chuyển đổi Tốc độ';

  @override
  String get timeConverter => 'Chuyển đổi Thời gian';

  @override
  String get dataConverter => 'Chuyển đổi Dung lượng';

  @override
  String get numberSystemConverter => 'Chuyển đổi Hệ số';

  @override
  String get tables => 'Bảng';

  @override
  String get tableView => 'Chế độ bảng';

  @override
  String get listView => 'Chế độ danh sách';

  @override
  String get customizeUnits => 'Tùy chỉnh Đơn vị';

  @override
  String get visibleUnits => 'Đơn vị hiển thị';

  @override
  String get selectUnitsToShow => 'Chọn đơn vị để hiển thị';

  @override
  String get enterValue => 'Nhập giá trị';

  @override
  String get conversionResults => 'Kết quả chuyển đổi';

  @override
  String get meters => 'Mét';

  @override
  String get kilometers => 'Kilômét';

  @override
  String get centimeters => 'Xentimét';

  @override
  String get millimeters => 'Milimét';

  @override
  String get inches => 'Inch';

  @override
  String get feet => 'Feet';

  @override
  String get yards => 'Yard';

  @override
  String get miles => 'Dặm';

  @override
  String get grams => 'Gram';

  @override
  String get kilograms => 'Kilogram';

  @override
  String get pounds => 'Pound';

  @override
  String get ounces => 'Ounce';

  @override
  String get tons => 'Tấn';

  @override
  String get celsius => 'Độ C';

  @override
  String get fahrenheit => 'Độ F';

  @override
  String get kelvin => 'Kelvin';

  @override
  String get liters => 'Lít';

  @override
  String get milliliters => 'Mililít';

  @override
  String get gallons => 'Gallon';

  @override
  String get quarts => 'Quart';

  @override
  String get pints => 'Pint';

  @override
  String get cups => 'Cốc';

  @override
  String get squareMeters => 'Mét vuông';

  @override
  String get squareKilometers => 'Kilômét vuông';

  @override
  String get squareFeet => 'Feet vuông';

  @override
  String get squareInches => 'Inch vuông';

  @override
  String get acres => 'Acre';

  @override
  String get hectares => 'Hecta';

  @override
  String get metersPerSecond => 'Mét/giây';

  @override
  String get kilometersPerHour => 'Kilômét/giờ';

  @override
  String get milesPerHour => 'Dặm/giờ';

  @override
  String get knots => 'Hải lý/giờ';

  @override
  String get bytes => 'Byte';

  @override
  String get kilobytes => 'Kilobyte';

  @override
  String get megabytes => 'Megabyte';

  @override
  String get gigabytes => 'Gigabyte';

  @override
  String get terabytes => 'Terabyte';

  @override
  String get bits => 'Bit';

  @override
  String get decimal => 'Thập phân (Cơ số 10)';

  @override
  String get binary => 'Nhị phân (Cơ số 2)';

  @override
  String get octal => 'Bát phân (Cơ số 8)';

  @override
  String get hexadecimal => 'Thập lục phân (Cơ số 16)';

  @override
  String get usd => 'Đô la Mỹ';

  @override
  String get eur => 'Euro';

  @override
  String get gbp => 'Bảng Anh';

  @override
  String get jpy => 'Yên Nhật';

  @override
  String get cad => 'Đô la Canada';

  @override
  String get aud => 'Đô la Úc';

  @override
  String get vnd => 'Đồng Việt Nam';

  @override
  String get currencyConverterDesc => 'Quy đổi giữa các loại tiền tệ với tỷ giá thời gian thực';

  @override
  String get lengthConverterDesc => 'Chuyển đổi giữa các đơn vị chiều dài khác nhau';

  @override
  String get weightConverterDesc => 'Chuyển đổi giữa các đơn vị trọng lượng khác nhau';

  @override
  String get temperatureConverterDesc => 'Chuyển đổi giữa các thang đo nhiệt độ khác nhau';

  @override
  String get volumeConverterDesc => 'Chuyển đổi giữa các đơn vị thể tích khác nhau';

  @override
  String get areaConverterDesc => 'Chuyển đổi giữa các đơn vị diện tích (m², km², ha, acres, ft²)';

  @override
  String get speedConverterDesc => 'Chuyển đổi giữa các đơn vị tốc độ khác nhau';

  @override
  String get timeConverterDesc => 'Chuyển đổi giữa các đơn vị thời gian khác nhau';

  @override
  String get dataConverterDesc => 'Chuyển đổi giữa các đơn vị lưu trữ dữ liệu khác nhau';

  @override
  String get numberSystemConverterDesc => 'Chuyển đổi giữa các hệ cơ số (nhị phân, thập phân, thập lục phân, v.v.)';

  @override
  String get fromUnit => 'Từ đơn vị';

  @override
  String get unit => 'Đơn vị';

  @override
  String get value => 'Giá trị';

  @override
  String get showAll => 'Hiển thị tất cả';

  @override
  String get apply => 'Áp dụng';

  @override
  String get bmiCalculator => 'Máy tính BMI';

  @override
  String get bmiCalculatorDesc => 'Tính chỉ số khối cơ thể và phân loại sức khỏe';

  @override
  String get scientificCalculator => 'Máy tính Khoa học';

  @override
  String get scientificCalculatorDesc => 'Máy tính nâng cao với các hàm lượng giác, logarit';

  @override
  String get graphingCalculator => 'Máy tính Vẽ đồ thị';

  @override
  String get graphingCalculatorDesc => 'Vẽ và hiển thị các hàm toán học';

  @override
  String get graphingCalculatorDetailedInfo => 'Thông tin Máy tính Vẽ đồ thị';

  @override
  String get graphingCalculatorOverview => 'Công cụ vẽ và trực quan hóa hàm toán học chuyên nghiệp';

  @override
  String get graphingKeyFeatures => 'Tính năng chính';

  @override
  String get realTimePlotting => 'Vẽ đồ thị thời gian thực';

  @override
  String get realTimePlottingDesc => 'Hiển thị hàm số ngay lập tức khi bạn nhập với đường cong mượt mà';

  @override
  String get multipleFunction => 'Nhiều hàm số';

  @override
  String get multipleFunctionDesc => 'Vẽ và so sánh nhiều hàm số cùng lúc với mã màu khác nhau';

  @override
  String get interactiveControls => 'Điều khiển tương tác';

  @override
  String get interactiveControlsDesc => 'Zoom, di chuyển và điều hướng đồ thị bằng thao tác chạm và chuột trực quan';

  @override
  String get aspectRatioControl => 'Điều khiển tỷ lệ khung hình';

  @override
  String get aspectRatioControlDesc => 'Tùy chỉnh tỷ lệ trục X:Y để hiển thị hàm số tối ưu';

  @override
  String get functionHistory => 'Lịch sử hàm số';

  @override
  String get functionHistoryDesc => 'Lưu và tải nhóm hàm số với tự động lưu trạng thái';

  @override
  String get mathExpressionSupport => 'Hỗ trợ toán học nâng cao';

  @override
  String get mathExpressionSupportDesc => 'Hỗ trợ hàm lượng giác, logarit và đa thức';

  @override
  String get graphingHowToUse => 'Cách sử dụng';

  @override
  String get step1Graph => 'Bước 1: Nhập hàm số';

  @override
  String get step1GraphDesc => 'Gõ hàm toán học vào ô nhập (ví dụ: x^2, sin(x), log(x))';

  @override
  String get step2Graph => 'Bước 2: Vẽ hàm số';

  @override
  String get step2GraphDesc => 'Nhấn Enter hoặc nút thêm để vẽ hàm số lên đồ thị';

  @override
  String get step3Graph => 'Bước 3: Điều hướng đồ thị';

  @override
  String get step3GraphDesc => 'Dùng các nút zoom, thao tác kéo hoặc điều chỉnh tỷ lệ để xem tốt hơn';

  @override
  String get step4Graph => 'Bước 4: Thêm nhiều hàm số';

  @override
  String get step4GraphDesc => 'Thêm nhiều hàm số để so sánh và phân tích hành vi của chúng';

  @override
  String get graphingTips => 'Mẹo chuyên nghiệp';

  @override
  String get tip1Graph => 'Dùng dấu ngoặc cho biểu thức phức tạp: sin(x^2) thay vì sin x^2';

  @override
  String get tip2Graph => 'Hàm thông dụng: sin(x), cos(x), tan(x), log(x), sqrt(x), abs(x)';

  @override
  String get tip3Graph => 'Dùng hằng số π và e: sin(π*x), e^x';

  @override
  String get tip4Graph => 'Di chuyển bằng cách kéo vùng đồ thị bằng chuột hoặc chạm';

  @override
  String get tip5Graph => 'Lưu nhóm hàm số vào lịch sử để truy cập nhanh sau này';

  @override
  String get tip6Graph => 'Bật/tắt hiển thị hàm số bằng biểu tượng mắt mà không cần xóa';

  @override
  String get tip7Graph => 'Dùng điều khiển tỷ lệ cho xem chuyên biệt (1:1 cho hình tròn, 5:1 cho dao động)';

  @override
  String get supportedFunctions => 'Hàm số được hỗ trợ';

  @override
  String get basicOperations => 'Phép toán cơ bản';

  @override
  String get basicOperationsDesc => 'Cộng (+), Trừ (-), Nhân (*), Chia (/), Lũy thừa (^)';

  @override
  String get trigonometricFunctions => 'Hàm lượng giác';

  @override
  String get trigonometricFunctionsDesc => 'sin(x), cos(x), tan(x) và các hàm nghịch đảo';

  @override
  String get logarithmicFunctions => 'Hàm logarit';

  @override
  String get logarithmicFunctionsDesc => 'Logarit tự nhiên log(x), hàm mũ e^x';

  @override
  String get otherFunctions => 'Hàm khác';

  @override
  String get otherFunctionsDesc => 'Căn bậc hai sqrt(x), giá trị tuyệt đối abs(x), hàm đa thức';

  @override
  String get navigationControls => 'Điều khiển điều hướng';

  @override
  String get zoomControls => 'Điều khiển zoom';

  @override
  String get zoomControlsDesc => 'Dùng nút + và - hoặc thao tác véo để phong to và thu nhỏ';

  @override
  String get panControls => 'Điều khiển di chuyển';

  @override
  String get panControlsDesc => 'Kéo đồ thị để di chuyển và khám phá các vùng khác nhau';

  @override
  String get resetControls => 'Điều khiển đặt lại';

  @override
  String get resetControlsDesc => 'Quay về giữa hoặc đặt lại toàn bộ đồ thị về trạng thái mặc định';

  @override
  String get aspectRatioDialog => 'Tỷ lệ khung hình';

  @override
  String get aspectRatioDialogDesc => 'Điều chỉnh tỷ lệ trục X:Y từ 0.1:1 đến 10:1 để xem tối ưu';

  @override
  String get graphingPracticalApplications => 'Ứng dụng thực tế';

  @override
  String get graphingPracticalApplicationsDesc => 'Hữu ích cho học sinh học đại số và giải tích, trực quan hóa hành vi hàm số và khám phá các khái niệm toán học qua đồ thị tương tác.';

  @override
  String get scientificCalculatorDetailedInfo => 'Thông tin Máy tính Khoa học';

  @override
  String get scientificCalculatorOverview => 'Máy tính khoa học nâng cao với các hàm toán học toàn diện';

  @override
  String get scientificKeyFeatures => 'Tính năng chính';

  @override
  String get realTimeCalculation => 'Tính toán thời gian thực';

  @override
  String get realTimeCalculationDesc => 'Xem kết quả xem trước ngay lập tức khi bạn nhập biểu thức';

  @override
  String get comprehensiveFunctions => 'Hàm số toàn diện';

  @override
  String get comprehensiveFunctionsDesc => 'Bộ đầy đủ các hàm lượng giác, logarit và đại số';

  @override
  String get dualAngleModes => 'Chế độ góc kép';

  @override
  String get dualAngleModesDesc => 'Chuyển đổi giữa radian và độ cho tính toán lượng giác';

  @override
  String get secondaryFunctions => 'Hàm phụ';

  @override
  String get secondaryFunctionsDesc => 'Truy cập các hàm mở rộng với nút chuyển đổi 2nd';

  @override
  String get calculationHistoryDesc => 'Tự động lưu và duyệt các phép tính trước đó';

  @override
  String get memoryOperations => 'Thao tác bộ nhớ';

  @override
  String get memoryOperationsDesc => 'Lưu trữ và gọi lại giá trị với các hàm quản lý bộ nhớ';

  @override
  String get scientificHowToUse => 'Cách sử dụng';

  @override
  String get step1Scientific => 'Bước 1: Nhập biểu thức';

  @override
  String get step1ScientificDesc => 'Gõ số và sử dụng các nút hàm để xây dựng biểu thức toán học';

  @override
  String get step2Scientific => 'Bước 2: Sử dụng hàm';

  @override
  String get step2ScientificDesc => 'Truy cập các hàm lượng giác, logarit và đại số từ bàn phím';

  @override
  String get step3Scientific => 'Bước 3: Chuyển đổi chế độ';

  @override
  String get step3ScientificDesc => 'Chuyển đổi giữa radian/độ và hàm chính/phụ khi cần';

  @override
  String get step4Scientific => 'Bước 4: Xem kết quả';

  @override
  String get step4ScientificDesc => 'Nhấn = để tính toán hoặc xem xem trước thời gian thực khi nhập';

  @override
  String get scientificTips => 'Mẹo chuyên nghiệp';

  @override
  String get tip1Scientific => 'Dùng dấu ngoặc để kiểm soát thứ tự tính toán: sin(π/2) thay vì sin π/2';

  @override
  String get tip2Scientific => 'Nhấn 2nd để truy cập hàm phụ như asin, acos, atan';

  @override
  String get tip3Scientific => 'Chuyển chế độ Rad/Deg cho hàm lượng giác (mặc định là radian)';

  @override
  String get tip4Scientific => 'Dùng hàm bộ nhớ để lưu kết quả trung gian';

  @override
  String get tip5Scientific => 'Xem lịch sử tính toán để xem lại và tái sử dụng biểu thức trước đó';

  @override
  String get tip6Scientific => 'Xem trước thời gian thực hiển thị kết quả trước khi nhấn bằng';

  @override
  String get tip7Scientific => 'Dùng hằng số π và e cho tính toán toán học chính xác';

  @override
  String get basicArithmetic => 'Số học cơ bản';

  @override
  String get trigonometricFunctionsScientific => 'Hàm lượng giác';

  @override
  String get logarithmicFunctionsScientific => 'Hàm logarit';

  @override
  String get algebraicFunctions => 'Hàm đại số';

  @override
  String get scientificFunctionCategories => 'Danh mục hàm';

  @override
  String get basicArithmeticDesc => 'Cộng (+), Trừ (-), Nhân (*), Chia (/)';

  @override
  String get trigonometricFunctionsScientificDesc => 'sin, cos, tan và các hàm nghịch đảo (asin, acos, atan)';

  @override
  String get logarithmicFunctionsScientificDesc => 'Logarit tự nhiên (ln), logarit thường (log), mũ (exp, eˣ, 10ˣ)';

  @override
  String get algebraicFunctionsDesc => 'Lũy thừa (x², x³, xʸ), căn (√, ∛), giai thừa (n!), giá trị tuyệt đối (|x|)';

  @override
  String get angleMode => 'Chế độ góc';

  @override
  String get functionToggle => 'Chuyển đổi hàm';

  @override
  String get memoryFunctions => 'Hàm bộ nhớ';

  @override
  String get historyAccess => 'Truy cập lịch sử';

  @override
  String get scientificCalculatorPracticalApplications => 'Ứng dụng thực tế';

  @override
  String get scientificCalculatorPracticalApplicationsDesc => 'Hữu ích cho học sinh trong các khóa học toán và khoa học, tính toán kỹ thuật cơ bản và giải quyết vấn đề hàng ngày liên quan đến các phép toán phức tạp.';

  @override
  String cacheWithLogSize(String cacheSize, String logSize) {
    return 'Bộ nhớ đệm: $cacheSize (+$logSize nhật ký)';
  }

  @override
  String get scientificModeControls => 'Điều khiển chế độ';

  @override
  String get angleModeDesc => 'Chuyển đổi giữa Radian và Độ cho tính toán lượng giác';

  @override
  String get functionToggleDesc => 'Nhấn 2nd để chuyển đổi giữa bộ hàm chính và phụ';

  @override
  String get memoryFunctionsDesc => 'Lưu trữ, gọi lại và quản lý giá trị trong bộ nhớ máy tính';

  @override
  String get historyAccessDesc => 'Duyệt các phép tính trước đó và tái sử dụng biểu thức';

  @override
  String get scientificPracticalApplications => 'Ứng dụng thực tế';

  @override
  String get scientificPracticalApplicationsDesc => 'Hữu ích cho học sinh trong các môn toán và khoa học, thực hiện phép tính cần các hàm lượng giác, logarit và đại số.';

  @override
  String get metric => 'Hệ mét';

  @override
  String get imperial => 'Hệ Anh';

  @override
  String get enterMeasurements => 'Nhập số đo của bạn';

  @override
  String get heightCm => 'Chiều cao (cm)';

  @override
  String get heightInches => 'Chiều cao (inches)';

  @override
  String get weightKg => 'Cân nặng (kg)';

  @override
  String get weightPounds => 'Cân nặng (pounds)';

  @override
  String get yourBMI => 'BMI của bạn';

  @override
  String get bmiScale => 'Thang đo BMI';

  @override
  String get underweight => 'Thiếu cân';

  @override
  String get normalWeight => 'Bình thường';

  @override
  String get overweight => 'Thừa cân';

  @override
  String get overweightI => 'Thừa cân I';

  @override
  String get overweightII => 'Thừa cân II';

  @override
  String get obese => 'Béo phì';

  @override
  String get obeseI => 'Béo phì I';

  @override
  String get obeseII => 'Béo phì II';

  @override
  String get obeseIII => 'Béo phì III';

  @override
  String get bmiPercentileOverweight => 'Từ phân vị thứ 85 đến 95';

  @override
  String get bmiPercentileOverweightI => 'Phân vị 85-95';

  @override
  String get bmiPercentileObese => 'Trên phân vị thứ 95';

  @override
  String get bmiPercentileObeseI => '≥ Phân vị 95';

  @override
  String bmiNormalInterpretation(String bmi) {
    return 'BMI của bạn nằm trong phạm vi cân nặng bình thường. Điều này cho thấy cân nặng khỏe mạnh cho chiều cao của bạn.';
  }

  @override
  String bmiOverweightInterpretation(String bmi) {
    return 'Chỉ số BMI cho thấy bạn bị thừa cân. Hãy cân nhắc thay đổi lối sống để đạt được cân nặng khỏe mạnh hơn.';
  }

  @override
  String bmiObeseInterpretation(String bmi) {
    return 'Chỉ số BMI cho thấy bạn bị béo phì. Điều quan trọng là tham khảo ý kiến chuyên gia y tế để được hướng dẫn phù hợp.';
  }

  @override
  String get bmiUnderweightRec1 => 'Tăng lượng calo nạp vào với thực phẩm bổ dưỡng, nhiều calo';

  @override
  String get bmiUnderweightRec2 => 'Bao gồm chất béo lành mạnh, protein và carbohydrate phức tạp trong chế độ ăn';

  @override
  String get bmiUnderweightRec3 => 'Tham khảo ý kiến nhà cung cấp chăm sóc sức khỏe để loại trừ các vấn đề sức khỏe tiềm ẩn';

  @override
  String get bmiNormalRec1 => 'Duy trì chế độ ăn cân bằng với nhiều loại chất dinh dưỡng';

  @override
  String get bmiNormalRec2 => 'Tiếp tục hoạt động thể chất thường xuyên và thói quen tập thể dục';

  @override
  String get bmiNormalRec3 => 'Theo dõi cân nặng thường xuyên để duy trì trong phạm vi khỏe mạnh';

  @override
  String get bmiOverweightRec1 => 'Tạo ra sự thiếu hụt calo vừa phải thông qua chế độ ăn và tập thể dục';

  @override
  String get bmiOverweightRec2 => 'Tập trung vào kiểm soát khẩu phần và chọn thực phẩm giàu chất dinh dưỡng';

  @override
  String get bmiOverweightRec3 => 'Tăng hoạt động thể chất với cả cardio và tập luyện sức mạnh';

  @override
  String get bmiObeseRec1 => 'Làm việc với các chuyên gia chăm sóc sức khỏe để phát triển kế hoạch giảm cân an toàn';

  @override
  String get bmiObeseRec2 => 'Cân nhắc thay đổi lối sống toàn diện bao gồm chế độ ăn và tập thể dục';

  @override
  String get bmiObeseRec3 => 'Có thể cần thiết theo dõi y tế thường xuyên để có sức khỏe tối ưu';

  @override
  String get bmiUnderweightDesc => 'Có thể chỉ ra suy dinh dưỡng, rối loạn ăn uống, hoặc các vấn đề sức khỏe tiềm ẩn';

  @override
  String get bmiNormalDesc => 'Associated with lowest risk of weight-related health problems';

  @override
  String get bmiOverweightDesc => 'Increased risk of cardiovascular disease, diabetes, and other health issues';

  @override
  String get bmiObeseDesc => 'Significantly increased risk of serious health complications';

  @override
  String get bmiKeyFeatures => 'Tính năng chính';

  @override
  String get comprehensiveBmiCalc => 'Comprehensive BMI Calculation';

  @override
  String get comprehensiveBmiCalcDesc => 'Calculate BMI using height, weight, age, and gender for accurate results';

  @override
  String get multipleUnitSystems => 'Multiple Unit Systems';

  @override
  String get multipleUnitSystemsDesc => 'Support for both metric (cm/kg) and imperial (ft-in/lbs) measurements';

  @override
  String get healthInsights => 'Health Insights';

  @override
  String get healthInsightsDesc => 'Get personalized recommendations based on your BMI category';

  @override
  String get ageGenderConsideration => 'Age & Gender Consideration';

  @override
  String get ageGenderConsiderationDesc => 'BMI interpretation adjusted for age and gender factors';

  @override
  String get bmiHowToUse => 'How to Use';

  @override
  String get step1Bmi => 'Step 1: Select Unit System';

  @override
  String get step1BmiDesc => 'Choose between metric (cm/kg) or imperial (ft-in/lbs) measurements';

  @override
  String get step2Bmi => 'Step 2: Enter Your Information';

  @override
  String get step2BmiDesc => 'Input your height, weight, age, and gender for accurate calculation';

  @override
  String get step3Bmi => 'Step 3: View Results';

  @override
  String get step3BmiDesc => 'See your BMI value, category, and personalized health recommendations';

  @override
  String get step4Bmi => 'Step 4: Track Progress';

  @override
  String get step4BmiDesc => 'Save calculations to history and monitor changes over time';

  @override
  String get bmiTips => 'Health Tips';

  @override
  String get tip1Bmi => 'BMI is a screening tool - consult healthcare providers for complete health assessment';

  @override
  String get tip2Bmi => 'Regular monitoring helps track progress toward health goals';

  @override
  String get tip3Bmi => 'BMI may not accurately reflect body composition for athletes or elderly';

  @override
  String get tip4Bmi => 'Focus on healthy lifestyle changes rather than just the number';

  @override
  String get tip5Bmi => 'Combine BMI with other health indicators for better understanding';

  @override
  String get bmiLimitations => 'Understanding BMI Limitations';

  @override
  String get bmiLimitationsDesc => 'BMI is a useful screening tool but has limitations. It doesn\'t distinguish between muscle and fat mass, and may not be accurate for athletes, elderly, or certain ethnic groups. Always consult healthcare professionals for comprehensive health assessment.';

  @override
  String get bmiPracticalApplications => 'Practical Applications';

  @override
  String get bmiPracticalApplicationsDesc => 'Useful for health screening, weight management planning, fitness goal setting, and tracking health progress over time.';

  @override
  String get clearBmiHistory => 'Clear BMI History';

  @override
  String bmiResult(String bmi) {
    return 'BMI: $bmi';
  }

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get measurements => 'Measurements';

  @override
  String get bmiResults => 'BMI Results';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get autoSaveToHistory => 'Auto-save to History';

  @override
  String get autoSaveToHistoryDesc => 'Automatically save calculations to history';

  @override
  String get rememberLastValues => 'Remember Last Values';

  @override
  String get rememberLastValuesDesc => 'Remember your last entered values';

  @override
  String get currencyFetchMode => 'Tải tỷ giá Tiền tệ';

  @override
  String get currencyFetchModeDesc => 'Chọn cách cập nhật tỷ giá hối đoái';

  @override
  String get fetchModeManual => 'Thủ công';

  @override
  String get fetchModeManualDesc => 'Chỉ sử dụng tỷ giá đã lưu, cập nhật thủ công bằng nút làm mới (giới hạn 6 tiếng 1 lần)';

  @override
  String get fetchModeOnceADay => 'Một lần mỗi ngày';

  @override
  String get fetchModeOnceADayDesc => 'Tự động tải tỷ giá một lần mỗi ngày';

  @override
  String get currencyFetchStatus => 'Trạng thái tải tiền tệ';

  @override
  String get fetchStatusSummary => 'Tóm tắt trạng thái tải';

  @override
  String get success => 'Thành công';

  @override
  String get failed => 'Thất bại';

  @override
  String get timeout => 'Hết thời gian';

  @override
  String get static => 'Tĩnh';

  @override
  String get noCurrenciesInThisCategory => 'Không có tiền tệ nào trong danh mục này';

  @override
  String get saveFeatureState => 'Lưu trạng thái tính năng';

  @override
  String get saveFeatureStateDesc => 'Ghi nhớ trạng thái của các tính năng giữa các phiên sử dụng';

  @override
  String get testCache => 'Kiểm tra bộ nhớ đệm';

  @override
  String get viewDataStatus => 'Xem trạng thái dữ liệu';

  @override
  String retryAttempt(int current, int max) {
    return 'Thử lại lần $current/$max';
  }

  @override
  String ratesUpdatedWithErrors(int errorCount) {
    return 'Đã cập nhật tỷ giá với $errorCount lỗi';
  }

  @override
  String get newRatesAvailable => 'Có tỷ giá mới khả dụng. Bạn có muốn tải ngay bây giờ không?';

  @override
  String get progressDialogInfo => 'Điều này sẽ hiện dialog tiến trình trong khi tải tỷ giá.';

  @override
  String get calculate => 'Tính toán';

  @override
  String get calculating => 'Đang tính toán...';

  @override
  String get unknown => 'Không rõ';

  @override
  String get logsManagement => 'Quản lý log ứng dụng và cài đặt lưu trữ';

  @override
  String statusInfo(String info) {
    return 'Trạng thái: $info';
  }

  @override
  String get logsAvailable => 'Log khả dụng';

  @override
  String get noTimeData => '--:--:--';

  @override
  String get fetchStatusTab => 'Trạng thái fetch';

  @override
  String get currencyValueTab => 'Giá trị tiền tệ';

  @override
  String successfulCount(int count) {
    return 'Thành công ($count)';
  }

  @override
  String failedCount(int count) {
    return 'Thất bại ($count)';
  }

  @override
  String timeoutCount(int count) {
    return 'Timeout ($count)';
  }

  @override
  String recentlyUpdatedCount(int count) {
    return 'Cập nhật gần đây ($count)';
  }

  @override
  String updatedCount(int count) {
    return 'Đã cập nhật ($count)';
  }

  @override
  String staticCount(int count) {
    return 'Static ($count)';
  }

  @override
  String get noCurrenciesInCategory => 'Không có tiền tệ nào trong danh mục này';

  @override
  String get updatedWithinLastHour => 'Cập nhật trong vòng 1 giờ qua';

  @override
  String updatedDaysAgo(int days) {
    return 'Cập nhật $days ngày trước';
  }

  @override
  String updatedHoursAgo(int hours) {
    return 'Cập nhật $hours giờ trước';
  }

  @override
  String get hasUpdateData => 'Có dữ liệu cập nhật';

  @override
  String get usingStaticRates => 'Sử dụng tỷ giá tĩnh';

  @override
  String get scrollToTop => 'Lên đầu trang';

  @override
  String get scrollToBottom => 'Xuống cuối trang';

  @override
  String get logActions => 'Hành động log';

  @override
  String get logApplication => 'Nhật ký Ứng dụng';

  @override
  String get previousChunk => 'Phần trước';

  @override
  String get nextChunk => 'Phần sau';

  @override
  String get loadAll => 'Tải tất cả';

  @override
  String get firstPart => 'Phần đầu';

  @override
  String get lastPart => 'Phần cuối';

  @override
  String get largeFile => 'File lớn';

  @override
  String get loadingLargeFile => 'Đang tải file lớn...';

  @override
  String get loadingLogContent => 'Đang tải nội dung log...';

  @override
  String get largeFileDetected => 'Phát hiện file lớn. Đang sử dụng tải tối ưu...';

  @override
  String get cacheTypeCalculatorTools => 'Công cụ Tính toán';

  @override
  String get cacheTypeCalculatorToolsDesc => 'Lịch sử tính toán, dữ liệu máy tính đồ thị, dữ liệu BMI và cài đặt';

  @override
  String get cacheTypeConverterTools => 'Công cụ chuyển đổi';

  @override
  String get cacheTypeConverterToolsDesc => 'Trạng thái tiền tệ/chiều dài, cài đặt sẵn và bộ nhớ đệm tỷ giá';

  @override
  String get cardName => 'Tên Thẻ';

  @override
  String get cardNameHint => 'Nhập tên thẻ (tố đa 20 ký tự)';

  @override
  String converterCardNameDefault(Object position) {
    return 'Thẻ $position';
  }

  @override
  String unitSelectedStatus(Object count, Object max) {
    return 'Đã chọn $count trong $max';
  }

  @override
  String unitVisibleStatus(Object count) {
    return '$count đơn vị hiển thị';
  }

  @override
  String get moveDown => 'Di chuyển xuống';

  @override
  String get moveUp => 'Di chuyển lên';

  @override
  String get moveToFirst => 'Di chuyển lên đầu';

  @override
  String get moveToLast => 'Di chuyển xuống cuối';

  @override
  String get cardActions => 'Hành động thẻ';

  @override
  String get lengthUnits => 'Đơn vị chiều dài';

  @override
  String get angstroms => 'Angstrom';

  @override
  String get nanometers => 'Nanometer';

  @override
  String get microns => 'Micron';

  @override
  String get nauticalMiles => 'Hải lý';

  @override
  String get customizeLengthUnits => 'Tùy chỉnh đơn vị chiều dài';

  @override
  String get selectLengthUnits => 'Chọn đơn vị chiều dài để hiển thị';

  @override
  String get lengthConverterInfo => 'Thông tin bộ chuyển đổi chiều dài';

  @override
  String get weightConverter => 'Chuyển đổi Trọng lượng';

  @override
  String get weightConverterInfo => 'Thông tin Chuyển đổi Trọng lượng';

  @override
  String get customizeWeightUnits => 'Tùy chỉnh đơn vị trọng lượng';

  @override
  String get massConverter => 'Chuyển đổi Khối lượng';

  @override
  String get massConverterInfo => 'Thông tin Chuyển đổi Khối lượng';

  @override
  String get massConverterDesc => 'Chuyển đổi giữa các đơn vị khối lượng (kg, lb, oz)';

  @override
  String get customizeMassUnits => 'Tùy chỉnh đơn vị Khối lượng';

  @override
  String get availableUnits => 'Đơn vị có sẵn';

  @override
  String get scientificNotation => 'Hỗ trợ ký hiệu khoa học cho giá trị cực lớn/nhỏ';

  @override
  String get dragging => 'Đang kéo...';

  @override
  String get editName => 'Sửa tên';

  @override
  String get editCurrencies => 'Sửa tiền tệ';

  @override
  String tableWith(int count) {
    return 'Bảng $count thẻ';
  }

  @override
  String get noUnitsSelected => 'Chưa chọn đơn vị nào';

  @override
  String get maximumSelectionExceeded => 'Vượt quá giới hạn lựa chọn tối đa';

  @override
  String get presetSaved => 'Đã lưu cấu hình thành công';

  @override
  String errorSavingPreset(String error) {
    return 'Lỗi lưu cấu hình: $error';
  }

  @override
  String errorLoadingPresets(String error) {
    return 'Lỗi tải cấu hình: $error';
  }

  @override
  String get maximumSelectionReached => 'Đã đạt giới hạn lựa chọn tối đa';

  @override
  String minimumSelectionRequired(int count) {
    return 'Cần tối thiểu $count lựa chọn';
  }

  @override
  String get renamePreset => 'Đổi tên cấu hình';

  @override
  String get rename => 'Đổi tên';

  @override
  String get presetRenamedSuccessfully => 'Đã đổi tên cấu hình thành công';

  @override
  String get chooseFromSavedPresets => 'Chọn từ các cấu hình đã lưu';

  @override
  String get currencyConverterDetailedInfo => 'Bộ chuyển đổi tiền tệ - Thông Tin Chi Tiết';

  @override
  String get currencyConverterOverview => 'Bộ chuyển đổi tiền tệ mạnh mẽ này cho phép bạn chuyển đổi giữa các loại tiền tệ khác nhau với tỷ giá thời gian thực.';

  @override
  String get keyFeatures => 'Tính năng chính';

  @override
  String get multipleCards => 'Nhiều thẻ chuyển đổi';

  @override
  String get multipleCardsDesc => 'Tạo nhiều thẻ chuyển đổi, mỗi thẻ có bộ tiền tệ và số tiền riên.';

  @override
  String get liveRates => 'Tỷ giá thời gian thực';

  @override
  String get liveRatesDesc => 'Nhận tỷ giá hối đoái thời gian thực từ các nguồn tài chính đáng tin cậy.';

  @override
  String get customizeCurrencies => 'Tùy chỉnh tiền tệ';

  @override
  String get customizeCurrenciesDesc => 'Chọn tiền tệ hiển thị và lưu cấu hình tùy chỉnh.';

  @override
  String get dragAndDrop => 'Kéo thả';

  @override
  String get dragAndDropDesc => 'Sắp xếp lại thứ tự các thẻ chuyển đổi bằng cách kéo thả.';

  @override
  String get cardAndTableView => 'Chế độ thẻ & bảng';

  @override
  String get cardAndTableViewDesc => 'Chuyển đổi giữa chế độ thẻ để dễ sử dụng hoặc chế độ bảng để so sánh.';

  @override
  String get stateManagement => 'Quản lý trạng thái';

  @override
  String get stateManagementDesc => 'Trạng thái chuyển đổi của bạn được tự động lưu và khôi phục.';

  @override
  String get howToUse => 'Cách sử dụng';

  @override
  String get step1 => '1. Thêm thẻ';

  @override
  String get step1Desc => 'Nhấn \'Thêm thẻ\' để tạo thẻ chuyển đổi mới.';

  @override
  String get step2 => '2. Nhập số tiền';

  @override
  String get step2Desc => 'Nhập số tiền vào bất kỳ trường tiền tệ nào.';

  @override
  String get step3 => '3. Chọn tiền tệ gốc';

  @override
  String get step3Desc => 'Sử dụng menu thả xuống để chọn loại tiền tệ bạn muốn chuyển đổi từ đó.';

  @override
  String get step4 => '4. Xem kết quả';

  @override
  String get step4Desc => 'Xem kết quả chuyển đổi tức thì sang tất cả các loại tiền tệ khác trong thẻ.';

  @override
  String get tips => 'Mẹo sử dụng';

  @override
  String get tip1 => '• Nhấn vào biểu tượng chỉnh sửa để đổi tên thẻ';

  @override
  String get tip2 => '• Sử dụng biểu tượng tiền tệ để tùy chỉnh tiền tệ hiển thị';

  @override
  String get tip3 => '• Lưu cấu hình tiền tệ để truy cập nhanh';

  @override
  String get tip4 => '• Kiểm tra chỉ báo trạng thái để biết độ mới của tỷ giá';

  @override
  String get tip5 => '• Sử dụng chế độ bảng để so sánh nhiều thẻ cạnh nhau';

  @override
  String get rateUpdate => 'Cập nhật tỷ giá';

  @override
  String get rateUpdateDesc => 'Tỷ giá hối đoái được cập nhật dựa trên cài đặt của bạn. Kiểm tra Cài đặt > Công cụ chuyển đổi để cấu hình tần suất cập nhật và hành vi thử lại.';

  @override
  String poweredBy(String service) {
    return 'Được hỗ trợ bởi $service';
  }

  @override
  String exchangeRatesBy(String service) {
    return 'Tỷ giá hối đoái từ $service';
  }

  @override
  String get dataAttribution => 'Nguồn dữ liệu';

  @override
  String get apiProviderAttribution => 'Dữ liệu tỷ giá hối đoái được cung cấp bởi ExchangeRate-API.com';

  @override
  String get rateLimitReached => 'Đã đạt giới hạn tần suất';

  @override
  String get rateLimitMessage => 'Bạn chỉ có thể tải tỷ giá tiền tệ 6 tiếng 1 lần. Vui lòng thử lại sau.';

  @override
  String nextFetchAllowedIn(String timeRemaining) {
    return 'Có thể tải tiếp theo sau: $timeRemaining';
  }

  @override
  String get rateLimitInfo => 'Giới hạn tần suất giúp ngăn ngừa lạm dụng API và đảm bảo dịch vụ luôn khả dụng cho mọi người.';

  @override
  String get understood => 'Đã hiểu';

  @override
  String get focusMode => 'Chế độ tập trung';

  @override
  String get focusModeEnabled => 'Chế độ tập trung';

  @override
  String get focusModeEnabledDesc => 'Ẩn các thành phần UI để tập trung không bị phân tâm';

  @override
  String get saveRandomToolsState => 'Lưu trạng thái Random Tools';

  @override
  String get saveRandomToolsStateDesc => 'Tự động lưu cài đặt công cụ khi tạo kết quả';

  @override
  String get focusModeDisabled => 'Đã tắt chế độ tập trung';

  @override
  String get enableFocusMode => 'Bật chế độ tập trung';

  @override
  String get disableFocusMode => 'Tắt chế độ tập trung';

  @override
  String get focusModeDescription => 'Ẩn các thành phần giao diện để tập trung vào chuyển đổi';

  @override
  String focusModeEnabledMessage(String exitInstruction) {
    return 'Đã kích hoạt chế độ tập trung. $exitInstruction';
  }

  @override
  String get focusModeDisabledMessage => 'Đã tắt chế độ tập trung. Tất cả thành phần giao diện hiện đã hiển thị.';

  @override
  String get exitFocusModeDesktop => 'Nhấn biểu tượng tập trung trên thanh ứng dụng để thoát';

  @override
  String get exitFocusModeMobile => 'Zoom out hoặc nhấn biểu tượng tập trung để thoát';

  @override
  String get zoomToEnterFocusMode => 'Zoom in để vào chế độ tập trung';

  @override
  String get zoomToExitFocusMode => 'Zoom out để thoát chế độ tập trung';

  @override
  String get focusModeGesture => 'Sử dụng cử chỉ zoom để bật/tắt chế độ tập trung';

  @override
  String get focusModeButton => 'Sử dụng nút tập trung để bật/tắt chế độ tập trung';

  @override
  String get focusModeHidesElements => 'Chế độ tập trung ẩn widget trạng thái, nút thêm, nút chuyển chế độ xem và thống kê';

  @override
  String get focusModeHelp => 'Trợ giúp chế độ tập trung';

  @override
  String get focusModeHelpTitle => 'Chế độ tập trung';

  @override
  String get focusModeHelpDescription => 'Chế độ tập trung giúp bạn tập trung vào việc chuyển đổi bằng cách ẩn các thành phần giao diện không cần thiết.';

  @override
  String get focusModeHelpHidden => 'Được ẩn trong chế độ tập trung:';

  @override
  String get focusModeHelpHiddenStatus => '• Chỉ báo trạng thái và widget';

  @override
  String get focusModeHelpHiddenButtons => '• Nút thêm card/dòng';

  @override
  String get focusModeHelpHiddenViewMode => '• Nút chuyển chế độ xem (Card/Bảng)';

  @override
  String get focusModeHelpHiddenStats => '• Thông tin thống kê và đếm';

  @override
  String get focusModeHelpActivation => 'Kích hoạt:';

  @override
  String get focusModeHelpActivationDesktop => '• Desktop: Nhấn biểu tượng tập trung trên thanh ứng dụng';

  @override
  String get focusModeHelpActivationMobile => '• Mobile: Sử dụng cử chỉ zoom in hoặc nhấn biểu tượng tập trung';

  @override
  String get focusModeHelpDeactivation => 'Tắt:';

  @override
  String get focusModeHelpDeactivationDesktop => '• Desktop: Nhấn biểu tượng tập trung lần nữa';

  @override
  String get focusModeHelpDeactivationMobile => '• Mobile: Sử dụng cử chỉ zoom out hoặc nhấn biểu tượng tập trung lần nữa';

  @override
  String get moreActions => 'Thêm tùy chọn';

  @override
  String get moreOptions => 'Tùy chọn khác';

  @override
  String get lengthConverterDetailedInfo => 'Bộ Chuyển Đổi Độ Dài - Thông Tin Chi Tiết';

  @override
  String get lengthConverterOverview => 'Bộ chuyển đổi độ dài chính xác này hỗ trợ nhiều đơn vị với tính toán độ chính xác cao cho mục đích chuyên nghiệp và khoa học.';

  @override
  String get precisionCalculations => 'Tính Toán Chính Xác';

  @override
  String get precisionCalculationsDesc => 'Phép toán chính xác cao với tới 15 chữ số thập phân cho độ chính xác khoa học.';

  @override
  String get multipleUnits => 'Nhiều Đơn Vị Độ Dài';

  @override
  String get multipleUnitsDesc => 'Hỗ trợ hệ mét, hệ Anh và đơn vị khoa học từ nanomét đến kilomét.';

  @override
  String get instantConversion => 'Chuyển Đổi Tức Thì';

  @override
  String get instantConversionDesc => 'Chuyển đổi thời gian thực trên tất cả đơn vị hiển thị khi bạn nhập giá trị.';

  @override
  String get customizableInterface => 'Giao Diện Tùy Chỉnh';

  @override
  String get customizableInterfaceDesc => 'Ẩn hoặc hiển thị đơn vị cụ thể, sắp xếp thẻ và chuyển đổi giữa các chế độ xem.';

  @override
  String get statePersistence => 'Duy trì Trạng thái:';

  @override
  String get statePersistenceDesc => 'Cài đặt và cấu hình thẻ của bạn được lưu tự động.';

  @override
  String get scientificNotationSupport => 'Ký Hiệu Khoa Học';

  @override
  String get scientificNotationSupportDesc => 'Hỗ trợ giá trị rất lớn và rất nhỏ sử dụng ký hiệu khoa học.';

  @override
  String get step1Length => 'Bước 1: Thêm Thẻ';

  @override
  String get step1LengthDesc => 'Thêm nhiều thẻ chuyển đổi để làm việc với các giá trị độ dài khác nhau cùng lúc.';

  @override
  String get step2Length => 'Bước 2: Chọn Đơn Vị';

  @override
  String get step2LengthDesc => 'Chọn đơn vị độ dài nào hiển thị bằng cách tùy chỉnh đơn vị hiển thị của mỗi thẻ.';

  @override
  String get step3Length => 'Bước 3: Nhập Giá Trị';

  @override
  String get step3LengthDesc => 'Nhập bất kỳ giá trị độ dài nào và xem chuyển đổi tức thì sang tất cả đơn vị khác.';

  @override
  String get step4Length => 'Bước 4: Sắp Xếp Bố Cục';

  @override
  String get step4LengthDesc => 'Kéo thẻ để sắp xếp lại, chuyển sang chế độ bảng hoặc dùng chế độ tập trung để làm việc không bị phân tâm.';

  @override
  String get tip1Length => '• Sử dụng ký hiệu khoa học (1.5e6) cho các phép đo rất lớn hoặc rất nhỏ';

  @override
  String get tip2Length => '• Chạm đôi vào trường đơn vị để chọn tất cả văn bản để chỉnh sửa nhanh';

  @override
  String get tip3Length => '• Thẻ nhớ lựa chọn đơn vị và tên riêng của chúng';

  @override
  String get tip4Length => '• Chế độ bảng lý tưởng để so sánh nhiều phép đo cùng lúc';

  @override
  String get tip5Length => '• Chế độ tập trung ẩn các yếu tố gây phân tâm để làm việc chuyển đổi tập trung';

  @override
  String get tip6Length => '• Sử dụng chức năng tìm kiếm để nhanh chóng tìm đơn vị cụ thể trong tùy chỉnh';

  @override
  String get lengthUnitRange => 'Phạm Vi Đơn Vị Hỗ Trợ';

  @override
  String get lengthUnitRangeDesc => 'Từ phép đo dưới nguyên tử (angstrom) đến thiên văn (năm ánh sáng) với độ chính xác được duy trì xuyên suốt.';

  @override
  String get weightConverterDetailedInfo => 'Bộ Chuyển Đổi Trọng Lượng - Thông Tin Chi Tiết';

  @override
  String get weightConverterOverview => 'Bộ chuyển đổi trọng lượng/lực chính xác này hỗ trợ nhiều hệ thống đơn vị với tính toán độ chính xác cao cho ứng dụng kỹ thuật, vật lý và khoa học.';

  @override
  String get step1Weight => 'Bước 1: Thêm Thẻ';

  @override
  String get step1WeightDesc => 'Thêm nhiều thẻ chuyển đổi để làm việc với các giá trị lực/trọng lượng khác nhau cùng lúc.';

  @override
  String get step2Weight => 'Bước 2: Chọn Đơn Vị';

  @override
  String get step2WeightDesc => 'Chọn đơn vị lực/trọng lượng nào hiển thị bằng cách tùy chỉnh đơn vị hiển thị của mỗi thẻ.';

  @override
  String get step3Weight => 'Bước 3: Nhập Giá Trị';

  @override
  String get step3WeightDesc => 'Nhập bất kỳ giá trị lực/trọng lượng nào và xem chuyển đổi tức thì sang tất cả đơn vị khác.';

  @override
  String get step4Weight => 'Bước 4: Sắp Xếp Bố Cục';

  @override
  String get step4WeightDesc => 'Kéo thẻ để sắp xếp lại, chuyển sang chế độ bảng hoặc dùng chế độ tập trung để làm việc không bị phân tâm.';

  @override
  String get tip1Weight => '• Newton (N) là đơn vị SI cơ bản cho lực với độ chính xác cao nhất';

  @override
  String get tip2Weight => '• Kilogram-lực (kgf) biểu thị lực hấp dẫn tác dụng lên khối lượng 1 kg';

  @override
  String get tip3Weight => '• Sử dụng ký hiệu khoa học cho các giá trị lực rất lớn hoặc rất nhỏ';

  @override
  String get tip4Weight => '• Dyne hữu ích cho các lực nhỏ trong tính toán hệ CGS';

  @override
  String get tip5Weight => '• Đơn vị troy chuyên dụng cho kim loại quý và trang sức';

  @override
  String get tip6Weight => '• Chế độ tập trung giúp tập trung vào các phép tính lực phức tạp';

  @override
  String get weightUnitCategories => 'Danh Mục Đơn Vị';

  @override
  String get commonUnits => 'Đơn Vị Phổ Biến';

  @override
  String get commonUnitsWeightDesc => 'Newton (N), Kilogram-lực (kgf), Pound-lực (lbf) - được sử dụng thường xuyên nhất trong kỹ thuật và vật lý.';

  @override
  String get lessCommonUnits => 'Đơn Vị Ít Phổ Biến';

  @override
  String get lessCommonUnitsWeightDesc => 'Dyne (dyn), Kilopond (kp) - ứng dụng khoa học và kỹ thuật chuyên biệt.';

  @override
  String get uncommonUnits => 'Đơn Vị Không Phổ Biến';

  @override
  String get uncommonUnitsWeightDesc => 'Tấn-lực (tf) - cho các phép đo lực rất lớn trong công nghiệp nặng.';

  @override
  String get specialUnits => 'Đơn Vị Đặc Biệt';

  @override
  String get specialUnitsWeightDesc => 'Gram-lực (gf), Troy pound-lực - cho các phép đo chính xác và kim loại quý.';

  @override
  String get practicalApplicationsWeightDesc => 'Hữu ích cho các tính toán kỹ thuật, thí nghiệm vật lý và ứng dụng cần đo lực.';

  @override
  String get practicalApplications => 'Ứng Dụng Thực Tế';

  @override
  String get practicalApplicationsDesc => 'Hữu ích cho các phép đo hàng ngày và chuyển đổi đơn vị trong nhiều tình huống.';

  @override
  String get massConverterDetailedInfo => 'Bộ Chuyển Đổi Khối Lượng - Thông Tin Chi Tiết';

  @override
  String get massConverterOverview => 'Bộ chuyển đổi khối lượng chính xác này hỗ trợ nhiều hệ thống đơn vị với tính toán độ chính xác cao cho ứng dụng khoa học, y tế và thương mại.';

  @override
  String get step1Mass => 'Bước 1: Thêm Thẻ';

  @override
  String get step1MassDesc => 'Thêm nhiều thẻ chuyển đổi để làm việc với các giá trị khối lượng khác nhau cùng lúc.';

  @override
  String get step2Mass => 'Bước 2: Chọn Đơn Vị';

  @override
  String get step2MassDesc => 'Chọn đơn vị khối lượng nào hiển thị từ hệ mét, hệ Anh, hệ troy và hệ dược sĩ.';

  @override
  String get step3Mass => 'Bước 3: Nhập Giá Trị';

  @override
  String get step3MassDesc => 'Nhập bất kỳ giá trị khối lượng nào và xem chuyển đổi tức thì sang tất cả đơn vị khác.';

  @override
  String get step4Mass => 'Bước 4: Sắp Xếp Bố Cục';

  @override
  String get step4MassDesc => 'Kéo thẻ để sắp xếp lại, chuyển sang chế độ bảng hoặc dùng chế độ tập trung để làm việc không bị phân tâm.';

  @override
  String get tip1Mass => '• Sử dụng ký hiệu khoa học (1.5e-12) cho khối lượng rất nhỏ như đơn vị nguyên tử';

  @override
  String get tip2Mass => '• Hệ troy lý tưởng cho tính toán kim loại quý';

  @override
  String get tip3Mass => '• Hệ dược sĩ được sử dụng trong dược phẩm và y học';

  @override
  String get tip4Mass => '• Chế độ bảng hoàn hảo để so sánh nhiều phép đo';

  @override
  String get tip5Mass => '• Chế độ tập trung ẩn các yếu tố gây phân tâm để làm việc chuyển đổi tập trung';

  @override
  String get tip6Mass => '• Sử dụng cấu hình để lưu các tổ hợp đơn vị yêu thích';

  @override
  String get massUnitSystems => 'Hệ Thống Đơn Vị Hỗ Trợ';

  @override
  String get massUnitSystemsDesc => 'Hệ mét (ng đến tấn), hệ Anh (hạt đến tấn), troy (kim loại quý), dược sĩ (dược phẩm), và đơn vị đặc biệt (carat, slug, đơn vị khối lượng nguyên tử).';

  @override
  String get practicalApplicationsMassDesc => 'Hữu ích cho việc nấu ăn, tính toán khoa học cơ bản và chuyển đổi khối lượng hàng ngày.';

  @override
  String get areaConverterInfo => 'Thông tin Chuyển đổi Diện tích';

  @override
  String get customizeAreaUnits => 'Tùy chỉnh đơn vị diện tích';

  @override
  String get areaConverterDetailedInfo => 'Bộ Chuyển Đổi Diện Tích - Thông Tin Chi Tiết';

  @override
  String get areaConverterOverview => 'Bộ chuyển đổi diện tích chính xác này hỗ trợ nhiều hệ thống đơn vị với tính toán độ chính xác cao cho ứng dụng bất động sản, nông nghiệp, kỹ thuật và khoa học.';

  @override
  String get step1Area => 'Bước 1: Thêm Thẻ';

  @override
  String get step1AreaDesc => 'Thêm nhiều thẻ chuyển đổi để làm việc với các giá trị diện tích khác nhau cùng lúc.';

  @override
  String get step2Area => 'Bước 2: Chọn Đơn Vị';

  @override
  String get step2AreaDesc => 'Chọn đơn vị diện tích nào hiển thị bằng cách tùy chỉnh đơn vị hiển thị của mỗi thẻ.';

  @override
  String get step3Area => 'Bước 3: Nhập Giá Trị';

  @override
  String get step3AreaDesc => 'Nhập bất kỳ giá trị diện tích nào và xem chuyển đổi tức thì sang tất cả đơn vị khác.';

  @override
  String get step4Area => 'Bước 4: Sắp Xếp Bố Cục';

  @override
  String get step4AreaDesc => 'Kéo thẻ để sắp xếp lại, chuyển sang chế độ bảng hoặc dùng chế độ tập trung để làm việc không bị phân tâm.';

  @override
  String get tip1Area => '• Mét vuông (m²) là đơn vị SI cơ bản cho diện tích với độ chính xác cao nhất';

  @override
  String get tip2Area => '• Héc-ta thường được sử dụng cho diện tích đất lớn và nông nghiệp';

  @override
  String get tip3Area => '• Acre là tiêu chuẩn trong bất động sản và đo đạc đất đai ở Mỹ';

  @override
  String get tip4Area => '• Sử dụng ký hiệu khoa học cho các giá trị diện tích rất lớn hoặc rất nhỏ';

  @override
  String get tip5Area => '• Foot vuông và inch vuông phổ biến trong xây dựng và thiết kế';

  @override
  String get tip6Area => '• Chế độ tập trung giúp tập trung vào các phép tính diện tích phức tạp';

  @override
  String get areaUnitCategories => 'Danh Mục Đơn Vị';

  @override
  String get commonUnitsAreaDesc => 'Mét vuông (m²), Kilômét vuông (km²), Centimet vuông (cm²) - các đơn vị hệ mét được sử dụng thường xuyên nhất.';

  @override
  String get lessCommonUnitsAreaDesc => 'Héc-ta (ha), Acre (ac), Foot vuông (ft²), Inch vuông (in²) - ứng dụng chuyên biệt trong nông nghiệp và xây dựng.';

  @override
  String get uncommonUnitsAreaDesc => 'Yard vuông (yd²), Mile vuông (mi²), Rood - cho các phép đo khu vực hoặc lịch sử cụ thể.';

  @override
  String get practicalApplicationsAreaDesc => 'Hữu ích cho các dự án cải tạo nhà cửa, làm vườn và tính toán diện tích cơ bản.';

  @override
  String get timeConverterDetailedInfo => 'Chuyển đổi Thời gian - Thông tin Chi tiết';

  @override
  String get timeConverterOverview => 'Chuyển đổi đơn vị thời gian toàn diện với tính toán chính xác và hỗ trợ nhiều đơn vị.';

  @override
  String get step1Time => 'Bước 1: Chọn Đơn vị Thời gian';

  @override
  String get step1TimeDesc => 'Chọn từ giây, phút, giờ, ngày, tuần, tháng, năm và các đơn vị chuyên biệt như mili giây và nano giây.';

  @override
  String get step2Time => 'Bước 2: Nhập Giá trị Thời gian';

  @override
  String get step2TimeDesc => 'Nhập khoảng thời gian bạn muốn chuyển đổi. Hỗ trợ giá trị thập phân và ký hiệu khoa học cho tính toán chính xác.';

  @override
  String get step3Time => 'Bước 3: Xem Chuyển đổi';

  @override
  String get step3TimeDesc => 'Xem chuyển đổi tức thì trên tất cả các đơn vị thời gian đã chọn với tính toán độ chính xác cao.';

  @override
  String get step4Time => 'Bước 4: Tùy chỉnh & Lưu';

  @override
  String get step4TimeDesc => 'Thêm nhiều thẻ, tùy chỉnh đơn vị hiển thị và lưu bố cục ưa thích cho lần sử dụng sau.';

  @override
  String get tip1Time => '• Sử dụng ký hiệu khoa học cho giá trị thời gian rất nhỏ hoặc rất lớn';

  @override
  String get tip2Time => '• Mili giây và nano giây hoàn hảo cho tính toán kỹ thuật';

  @override
  String get tip3Time => '• Năm và tháng sử dụng giá trị trung bình để đảm bảo tính nhất quán';

  @override
  String get tip4Time => '• Thêm nhiều thẻ để so sánh các thang thời gian khác nhau';

  @override
  String get tip5Time => '• Tùy chỉnh đơn vị hiển thị để chỉ hiện những gì bạn cần';

  @override
  String get tip6Time => '• Chế độ tập trung giúp tập trung vào các phép tính thời gian phức tạp';

  @override
  String get timeUnitSystems => 'Hệ Thống Đơn vị Thời gian';

  @override
  String get timeUnitSystemsDesc => 'Hỗ trợ đơn vị thời gian tiêu chuẩn (s, min, h, d, wk, mo, yr), đơn vị chính xác (ms, μs, ns), và đơn vị mở rộng (thập kỷ, thế kỷ, thiên niên kỷ) để đo thời gian toàn diện trên mọi quy mô.';

  @override
  String get practicalApplicationsTimeDesc => 'Hữu ích cho việc lập lịch, chuyển đổi múi giờ và tính toán thời gian hàng ngày.';

  @override
  String get volumeConverterDetailedInfo => 'Bộ Chuyển Đổi Thể Tích - Thông Tin Chi Tiết';

  @override
  String get volumeConverterOverview => 'Bộ chuyển đổi thể tích chính xác này hỗ trợ nhiều hệ thống đơn vị với tính toán độ chính xác cao cho ứng dụng nấu ăn, hóa học, kỹ thuật và khoa học.';

  @override
  String get step1Volume => 'Bước 1: Thêm Thẻ';

  @override
  String get step1VolumeDesc => 'Thêm nhiều thẻ chuyển đổi để làm việc với các giá trị thể tích khác nhau cùng lúc.';

  @override
  String get step2Volume => 'Bước 2: Chọn Đơn Vị';

  @override
  String get step2VolumeDesc => 'Chọn đơn vị thể tích nào hiển thị từ hệ mét, hệ Anh và hệ Mỹ.';

  @override
  String get step3Volume => 'Bước 3: Nhập Giá Trị';

  @override
  String get step3VolumeDesc => 'Nhập bất kỳ giá trị thể tích nào và xem chuyển đổi tức thì sang tất cả đơn vị khác.';

  @override
  String get step4Volume => 'Bước 4: Sắp Xếp Bố Cục';

  @override
  String get step4VolumeDesc => 'Kéo thẻ để sắp xếp lại, chuyển sang chế độ bảng hoặc dùng chế độ tập trung để làm việc không bị phân tâm.';

  @override
  String get tip1Volume => '• Mét khối (m³) là đơn vị SI cơ bản cho thể tích với độ chính xác cao nhất';

  @override
  String get tip2Volume => '• Lít thường được sử dụng để đo chất lỏng trong ứng dụng hàng ngày';

  @override
  String get tip3Volume => '• Mililít và centimet khối là tương đương và có thể hoán đổi';

  @override
  String get tip4Volume => '• Gallon Mỹ và gallon Anh là các đơn vị khác nhau, hãy chọn cẩn thận';

  @override
  String get tip5Volume => '• Sử dụng ký hiệu khoa học cho các giá trị thể tích rất lớn hoặc rất nhỏ';

  @override
  String get tip6Volume => '• Chế độ tập trung giúp tập trung vào các phép tính thể tích phức tạp';

  @override
  String get volumeUnitCategories => 'Danh Mục Đơn Vị Tốc Độ';

  @override
  String get commonUnitsVolumeDesc => 'Mét khối (m³), Lít (L), Mililít (mL) - các đơn vị hệ mét được sử dụng thường xuyên nhất.';

  @override
  String get lessCommonUnitsVolumeDesc => 'Gallon (Mỹ/Anh), Foot khối (ft³), Quart, Pint - đơn vị hệ Anh và Mỹ.';

  @override
  String get uncommonUnitsVolumeDesc => 'Héc-tô-lít (hL), Thùng (bbl), Cup, Ounce chất lỏng - ứng dụng chuyên biệt.';

  @override
  String get specialUnitsVolumeDesc => 'Centimet khối (cm³), Inch khối (in³), Yard khối (yd³) - đơn vị kỹ thuật và xây dựng.';

  @override
  String get practicalApplicationsVolumeDesc => 'Hữu ích cho việc nấu ăn, làm bánh và đo thể tích cơ bản.';

  @override
  String get volumeConverterInfo => 'Volume Converter Information';

  @override
  String get customizeVolumeUnits => 'Customize Volume Units';

  @override
  String get selectVolumeUnits => 'Select volume units to display';

  @override
  String get volumeUnits => 'Volume Units';

  @override
  String get cubicMeter => 'Cubic Meter';

  @override
  String get liter => 'Liter';

  @override
  String get milliliter => 'Milliliter';

  @override
  String get cubicCentimeter => 'Cubic Centimeter';

  @override
  String get hectoliter => 'Hectoliter';

  @override
  String get gallonUS => 'Gallon (US)';

  @override
  String get gallonUK => 'Gallon (UK)';

  @override
  String get quartUS => 'Quart (US)';

  @override
  String get pintUS => 'Pint (US)';

  @override
  String get cup => 'Cup';

  @override
  String get fluidOunceUS => 'Fluid Ounce (US)';

  @override
  String get cubicInch => 'Cubic Inch';

  @override
  String get cubicFoot => 'Cubic Foot';

  @override
  String get cubicYard => 'Cubic Yard';

  @override
  String get barrel => 'Barrel (Oil)';

  @override
  String get numberSystemConverterDetailedInfo => 'Bộ Chuyển Đổi Hệ Số - Thông Tin Chi Tiết';

  @override
  String get numberSystemConverterOverview => 'Bộ chuyển đổi hệ số chính xác này hỗ trợ nhiều hệ cơ số với tính toán độ chính xác cao cho ứng dụng lập trình, khoa học máy tính và toán học.';

  @override
  String get step1NumberSystem => 'Bước 1: Thêm Thẻ';

  @override
  String get step1NumberSystemDesc => 'Thêm nhiều thẻ chuyển đổi để làm việc với các giá trị hệ cơ số khác nhau cùng lúc.';

  @override
  String get step2NumberSystem => 'Bước 2: Chọn Hệ Cơ Số';

  @override
  String get step2NumberSystemDesc => 'Chọn hệ cơ số nào hiển thị từ nhị phân, thập phân, thập lục phân và các hệ khác.';

  @override
  String get step3NumberSystem => 'Bước 3: Nhập Giá Trị';

  @override
  String get step3NumberSystemDesc => 'Nhập bất kỳ giá trị số nào và xem chuyển đổi tức thì sang tất cả hệ cơ số khác.';

  @override
  String get step4NumberSystem => 'Bước 4: Sắp Xếp Bố Cục';

  @override
  String get step4NumberSystemDesc => 'Kéo thẻ để sắp xếp lại, chuyển sang chế độ bảng hoặc dùng chế độ tập trung để làm việc không bị phân tâm.';

  @override
  String get tip1NumberSystem => '• Thập phân (Cơ số 10) là hệ đếm tiêu chuẩn với độ chính xác cao nhất';

  @override
  String get tip2NumberSystem => '• Nhị phân (Cơ số 2) là cơ bản cho khoa học máy tính và điện tử số';

  @override
  String get tip3NumberSystem => '• Thập lục phân (Cơ số 16) thường được sử dụng trong lập trình và địa chỉ bộ nhớ';

  @override
  String get tip4NumberSystem => '• Bát phân (Cơ số 8) có tầm quan trọng lịch sử trong hệ thống máy tính';

  @override
  String get tip5NumberSystem => '• Cơ số 32 và Cơ số 64 được sử dụng để mã hóa và truyền dữ liệu';

  @override
  String get tip6NumberSystem => '• Chế độ tập trung giúp tập trung vào các phép tính cơ số phức tạp';

  @override
  String get numberSystemUnitCategories => 'Hệ Cơ Số';

  @override
  String get commonBasesDesc => 'Nhị phân (Cơ số 2), Thập phân (Cơ số 10), Thập lục phân (Cơ số 16) - được sử dụng thường xuyên nhất trong máy tính và toán học.';

  @override
  String get lessCommonBasesDesc => 'Bát phân (Cơ số 8), Cơ số 32, Cơ số 64 - ứng dụng chuyên biệt trong lập trình và mã hóa dữ liệu.';

  @override
  String get uncommonBasesDesc => 'Cơ số 128, Cơ số 256 - cho biểu diễn dữ liệu nâng cao và thuật toán chuyên biệt.';

  @override
  String get practicalApplicationsNumberSystemDesc => 'Hữu ích cho lập trình cơ bản, học hệ số và chuyển đổi cơ số đơn giản.';

  @override
  String get numberSystemConverterInfo => 'Thông tin Chuyển đổi Hệ Số';

  @override
  String get customizeNumberSystemBases => 'Tùy chỉnh Hệ Cơ Số';

  @override
  String get selectNumberSystemBases => 'Chọn hệ cơ số để hiển thị';

  @override
  String get numberSystemBases => 'Hệ Cơ Số';

  @override
  String get base32 => 'Cơ số 32';

  @override
  String get base64 => 'Cơ số 64';

  @override
  String get base128 => 'Cơ số 128';

  @override
  String get base256 => 'Cơ số 256';

  @override
  String get speedConverterDetailedInfo => 'Chuyển Đổi Tốc Độ - Thông Tin Chi Tiết';

  @override
  String get speedConverterOverview => 'Bộ chuyển đổi tốc độ chính xác này hỗ trợ nhiều hệ thống đơn vị với tính toán độ chính xác cao cho ứng dụng ô tô, hàng không, hàng hải và khoa học.';

  @override
  String get step1Speed => 'Bước 1: Thêm Thẻ';

  @override
  String get step1SpeedDesc => 'Thêm nhiều thẻ chuyển đổi để làm việc với các giá trị tốc độ khác nhau cùng lúc.';

  @override
  String get step2Speed => 'Bước 2: Chọn Đơn Vị';

  @override
  String get step2SpeedDesc => 'Chọn đơn vị tốc độ nào hiển thị từ ô tô, hàng không, hàng hải và khoa học.';

  @override
  String get step3Speed => 'Bước 3: Nhập Giá Trị';

  @override
  String get step3SpeedDesc => 'Nhập bất kỳ giá trị tốc độ nào và xem chuyển đổi tức thì sang tất cả đơn vị khác.';

  @override
  String get step4Speed => 'Bước 4: Sắp Xếp Bố Cục';

  @override
  String get step4SpeedDesc => 'Kéo thẻ để sắp xếp lại, chuyển sang chế độ bảng hoặc dùng chế độ tập trung để làm việc không bị phân tâm.';

  @override
  String get tip1Speed => '• Mét trên giây (m/s) là đơn vị SI cơ bản cho tốc độ với độ chính xác cao nhất';

  @override
  String get tip2Speed => '• Kilometer per hour (km/h) thường được sử dụng cho tốc độ xe cộ và giao thông';

  @override
  String get tip3Speed => '• Miles per hour (mph) là tiêu chuẩn ở Mỹ và Anh cho tốc độ đường bộ';

  @override
  String get tip4Speed => '• Knots (hải lý/giờ) là tiêu chuẩn trong hàng không và hàng hải';

  @override
  String get tip5Speed => '• Feet per second (ft/s) hữu ích cho tính toán kỹ thuật và vật lý';

  @override
  String get tip6Speed => '• Mach biểu thị tốc độ âm thanh, quan trọng trong hàng không siêu âm';

  @override
  String get speedUnitCategories => 'Danh Mục Đơn Vị Tốc Độ';

  @override
  String get multipleSpeedUnits => 'Nhiều đơn vị tốc độ';

  @override
  String get multipleSpeedUnitsDesc => 'Hỗ trợ chuyển đổi giữa m/s, km/h, mph, knots, ft/s và Mach với độ chính xác cao';

  @override
  String get speedUnitRange => 'Phạm Vi Đơn Vị Hỗ Trợ';

  @override
  String get speedUnitRangeDesc => 'Từ tốc độ vi mô (mm/s) đến siêu âm (Mach) với độ chính xác được duy trì cho mọi ứng dụng.';

  @override
  String get commonUnitsSpeedDesc => 'Mét/giây (m/s), Kilômét/giờ (km/h), Dặm/giờ (mph) - các đơn vị được sử dụng thường xuyên nhất trong giao thông và đo lường hàng ngày.';

  @override
  String get lessCommonUnitsSpeedDesc => 'Knots (hải lý/giờ), Feet/giây (ft/s) - ứng dụng chuyên biệt trong hàng không, hàng hải và kỹ thuật.';

  @override
  String get uncommonUnitsSpeedDesc => 'Mach (tốc độ âm thanh) - cho các ứng dụng hàng không siêu âm và nghiên cứu vận tốc cao.';

  @override
  String get practicalApplicationsSpeedDesc => 'Hữu ích cho việc lập kế hoạch du lịch, hoạt động thể thao và chuyển đổi tốc độ cơ bản.';

  @override
  String get speedConverterInfo => 'Thông tin Chuyển Đổi Tốc Độ';

  @override
  String get customizeSpeedUnits => 'Tùy chỉnh đơn vị tốc độ';

  @override
  String get selectSpeedUnits => 'Chọn đơn vị tốc độ để hiển thị';

  @override
  String get speedUnits => 'Đơn vị Tốc độ';

  @override
  String get temperatureConverterDetailedInfo => 'Chuyển Đổi Nhiệt Độ - Thông Tin Chi Tiết';

  @override
  String get temperatureConverterOverview => 'Bộ chuyển đổi nhiệt độ chính xác này hỗ trợ nhiều thang đo nhiệt độ với tính toán độ chính xác cao cho ứng dụng khoa học, kỹ thuật, nấu ăn và hàng ngày.';

  @override
  String get step1Temperature => 'Bước 1: Thêm Thẻ';

  @override
  String get step1TemperatureDesc => 'Thêm nhiều thẻ chuyển đổi để làm việc với các giá trị nhiệt độ khác nhau cùng lúc.';

  @override
  String get step2Temperature => 'Bước 2: Chọn Thang Đo';

  @override
  String get step2TemperatureDesc => 'Chọn thang đo nhiệt độ nào hiển thị từ Celsius, Fahrenheit, Kelvin và các hệ khác.';

  @override
  String get step3Temperature => 'Bước 3: Nhập Giá Trị';

  @override
  String get step3TemperatureDesc => 'Nhập bất kỳ giá trị nhiệt độ nào và xem chuyển đổi tức thì sang tất cả thang đo khác.';

  @override
  String get step4Temperature => 'Bước 4: Sắp Xếp Bố Cục';

  @override
  String get step4TemperatureDesc => 'Kéo thẻ để sắp xếp lại, chuyển sang chế độ bảng hoặc dùng chế độ tập trung để làm việc không bị phân tâm.';

  @override
  String get tip1Temperature => '• Celsius (°C) là thang đo nhiệt độ được sử dụng rộng rãi nhất trên toàn cầu';

  @override
  String get tip2Temperature => '• Fahrenheit (°F) thường được sử dụng ở Hoa Kỳ';

  @override
  String get tip3Temperature => '• Kelvin (K) là thang đo nhiệt độ tuyệt đối được sử dụng trong khoa học';

  @override
  String get tip4Temperature => '• Rankine (°R) là thang đo Fahrenheit tuyệt đối';

  @override
  String get tip5Temperature => '• Réaumur (°Ré) được sử dụng trong lịch sử ở một số nước châu Âu';

  @override
  String get tip6Temperature => '• Chế độ tập trung giúp tập trung vào các phép tính nhiệt độ phức tạp';

  @override
  String get temperatureUnitCategories => 'Danh Mục Thang Đo Nhiệt Độ';

  @override
  String get temperatureCommonUnits => 'Thang Đo Phổ Biến';

  @override
  String get temperatureCommonUnitsDesc => 'Celsius (°C), Fahrenheit (°F) - được sử dụng thường xuyên nhất cho thời tiết, nấu ăn và đo nhiệt độ hàng ngày.';

  @override
  String get temperatureLessCommonUnits => 'Thang Đo Khoa Học';

  @override
  String get temperatureLessCommonUnitsDesc => 'Kelvin (K) - thang đo nhiệt độ tuyệt đối được sử dụng trong ứng dụng khoa học và kỹ thuật.';

  @override
  String get temperatureRareUnits => 'Thang Đo Chuyên Biệt';

  @override
  String get temperatureRareUnitsDesc => 'Rankine (°R), Réaumur (°Ré), Delisle (°De) - thang đo nhiệt độ lịch sử và chuyên biệt cho các ứng dụng cụ thể.';

  @override
  String get temperaturePracticalApplicationsDesc => 'Hữu ích cho việc nấu ăn, hiểu thời tiết và chuyển đổi nhiệt độ cơ bản.';

  @override
  String get temperatureConverterInfo => 'Thông Tin Chuyển Đổi Nhiệt Độ';

  @override
  String get customizeTemperatureUnits => 'Tùy Chỉnh Thang Đo Nhiệt Độ';

  @override
  String get selectTemperatureUnits => 'Chọn thang đo nhiệt độ để hiển thị';

  @override
  String get temperatureUnits => 'Thang Đo Nhiệt Độ';

  @override
  String get dataConverterDetailedInfo => 'Chuyển Đổi Dung Lượng Lưu Trữ - Thông Tin Chi Tiết';

  @override
  String get dataConverterOverview => 'Bộ chuyển đổi dung lượng lưu trữ chính xác này hỗ trợ nhiều đơn vị dữ liệu với tính toán độ chính xác cao cho ứng dụng khoa học máy tính, quản lý IT, xử lý file và lưu trữ kỹ thuật số.';

  @override
  String get step1Data => 'Bước 1: Thêm Thẻ';

  @override
  String get step1DataDesc => 'Thêm nhiều thẻ chuyển đổi để làm việc với các giá trị dung lượng lưu trữ khác nhau cùng lúc.';

  @override
  String get step2Data => 'Bước 2: Chọn Đơn Vị';

  @override
  String get step2DataDesc => 'Chọn đơn vị dung lượng lưu trữ nào hiển thị từ byte, kilobyte, gigabyte và các hệ khác.';

  @override
  String get step3Data => 'Bước 3: Nhập Giá Trị';

  @override
  String get step3DataDesc => 'Nhập bất kỳ giá trị dung lượng lưu trữ nào và xem chuyển đổi tức thì sang tất cả đơn vị khác.';

  @override
  String get step4Data => 'Bước 4: Sắp Xếp Bố Cục';

  @override
  String get step4DataDesc => 'Kéo thẻ để sắp xếp lại, chuyển sang chế độ bảng hoặc dùng chế độ tập trung để làm việc không bị phân tâm.';

  @override
  String get tip1Data => '• Byte (B) là đơn vị cơ bản của thông tin lưu trữ kỹ thuật số';

  @override
  String get tip2Data => '• Kilobyte (KB), Megabyte (MB), Gigabyte (GB) là tiêu chuẩn cho kích thước file';

  @override
  String get tip3Data => '• Terabyte (TB) và Petabyte (PB) được sử dụng cho hệ thống lưu trữ quy mô lớn';

  @override
  String get tip4Data => '• Đơn vị bit (Kbit, Mbit, Gbit) thường được sử dụng cho tốc độ mạng';

  @override
  String get tip5Data => '• Tiền tố nhị phân (cơ số 1024) cung cấp tính toán máy tính chính xác hơn';

  @override
  String get tip6Data => '• Chế độ tập trung giúp tập trung vào các phép tính dung lượng lưu trữ phức tạp';

  @override
  String get dataUnitCategories => 'Danh Mục Đơn Vị Dung Lượng Lưu Trữ';

  @override
  String get dataCommonUnits => 'Đơn Vị Phổ Biến';

  @override
  String get dataCommonUnitsDesc => 'Kilobyte (KB), Megabyte (MB), Gigabyte (GB) - đơn vị lưu trữ được sử dụng thường xuyên nhất cho kích thước file hàng ngày và dung lượng thiết bị.';

  @override
  String get dataLessCommonUnits => 'Đơn Vị Lưu Trữ Lớn';

  @override
  String get dataLessCommonUnitsDesc => 'Terabyte (TB), Petabyte (PB), và đơn vị Byte (B) cơ bản cho ứng dụng lưu trữ chuyên biệt và đo lường dữ liệu rất lớn hoặc rất nhỏ.';

  @override
  String get dataRareUnits => 'Đơn Vị Mạng';

  @override
  String get dataRareUnitsDesc => 'Bit, Kilobit (Kbit), Megabit (Mbit), Gigabit (Gbit) chủ yếu được sử dụng cho tốc độ mạng và tốc độ truyền dữ liệu.';

  @override
  String get dataPracticalApplicationsDesc => 'Hữu ích cho việc hiểu kích thước file, nhu cầu lưu trữ và chuyển đổi đơn vị dữ liệu cơ bản.';

  @override
  String get dataConverterInfo => 'Thông Tin Chuyển Đổi Dung Lượng Lưu Trữ';

  @override
  String get customizeDataUnits => 'Tùy Chỉnh Đơn Vị Dung Lượng Lưu Trữ';

  @override
  String get selectDataUnits => 'Chọn đơn vị dung lượng lưu trữ để hiển thị';

  @override
  String get dataUnits => 'Đơn Vị Dung Lượng Lưu Trữ';

  @override
  String get drafts => 'Bản nháp';

  @override
  String get noDraftsYet => 'Chưa có bản nháp nào';

  @override
  String get createDraftsHint => 'Bản nháp là bản lưu tạm thời công việc của bạn. Chúng được tạo tự động khi bạn thoát khỏi chế độ chỉnh sửa mà không lưu.';

  @override
  String get draftSaved => 'Đã lưu bản nháp';

  @override
  String get draftDeleted => 'Đã xóa bản nháp';

  @override
  String get saveDraft => 'Lưu nháp';

  @override
  String get stayHere => 'Ở lại';

  @override
  String get exitWithoutSaving => 'Thoát không lưu';

  @override
  String get unsavedChanges => 'Thay đổi chưa lưu';

  @override
  String get unsavedChangesMessage => 'Bạn có thay đổi chưa được lưu. Bạn muốn làm gì?';

  @override
  String get continueDraft => 'Tiếp tục nháp';

  @override
  String get publishDraft => 'Xuất bản nháp';

  @override
  String get deleteDraft => 'Xóa nháp';

  @override
  String get confirmDeleteDraft => 'Xóa bản nháp?';

  @override
  String get confirmDeleteDraftMessage => 'Bạn có chắc chắn muốn xóa bản nháp này? Hành động này không thể hoàn tác.';

  @override
  String get draftPublished => 'Đã xuất bản nháp thành mẫu';

  @override
  String get newDraft => 'Nháp mới';

  @override
  String get editDraft => 'Nháp chỉnh sửa';

  @override
  String draftCreatedOn(Object date) {
    return 'Tạo vào $date';
  }

  @override
  String draftUpdatedOn(Object date) {
    return 'Cập nhật vào $date';
  }

  @override
  String get autoSaved => 'Tự động lưu';

  @override
  String get viewDrafts => 'Xem nháp';

  @override
  String get manageDrafts => 'Quản lý nháp';

  @override
  String get draftsExpireAfter => 'Bản nháp hết hạn sau 7 ngày';

  @override
  String get expiredDraft => 'Đã hết hạn';

  @override
  String draftCount(Object count) {
    return '$count bản nháp';
  }

  @override
  String get graphingFunction => 'f(x) = ';

  @override
  String get enterFunction => 'Nhập hàm số (ví dụ: x^2, sin(x), v.v.)';

  @override
  String get plot => 'Vẽ';

  @override
  String get aspectRatio => 'Tỉ lệ khung hình';

  @override
  String get aspectRatioXY => 'Tỉ lệ khung hình (X:Y)';

  @override
  String currentRatio(String ratio) {
    return 'Tỉ lệ hiện tại: $ratio:1';
  }

  @override
  String get resetPlot => 'Đặt lại đồ thị';

  @override
  String get resetZoom => 'Đặt lại phóng to';

  @override
  String get zoomIn => 'Phóng to';

  @override
  String get zoomOut => 'Thu nhỏ';

  @override
  String get returnToCenter => 'Về giữa';

  @override
  String get panning => 'Di chuyển';

  @override
  String get joystickControl => 'Điều khiển Joystick';

  @override
  String get enableJoystick => 'Bật Joystick';

  @override
  String get disableJoystick => 'Tắt Joystick';

  @override
  String get joystickMode => 'Chế độ Joystick';

  @override
  String get joystickModeActive => 'Chế độ Joystick đang hoạt động';

  @override
  String get useJoystickToNavigateGraph => 'Sử dụng joystick để điều hướng đồ thị';

  @override
  String get equalXYRatio => 'Tỉ lệ X:Y bằng nhau';

  @override
  String yAxisWiderThanX(String ratio) {
    return 'Trục Y sẽ rộng hơn trục X $ratio lần';
  }

  @override
  String xAxisWiderThanY(String ratio) {
    return 'Trục X sẽ rộng hơn trục Y $ratio lần';
  }

  @override
  String invalidFunction(String error) {
    return 'Hàm không hợp lệ: $error';
  }

  @override
  String get enterFunctionToPlot => 'Nhập hàm số để vẽ đồ thị';

  @override
  String functionLabel(int number) {
    return 'Hàm $number';
  }

  @override
  String get reset => 'Đặt lại';

  @override
  String get graphPanel => 'Đồ thị';

  @override
  String get functionsPanel => 'Hàm số';

  @override
  String get historyPanel => 'Lịch sử';

  @override
  String get activeFunctions => 'Hàm đang hoạt động';

  @override
  String get noActiveFunctions => 'Không có hàm nào đang hoạt động';

  @override
  String get addFunction => 'Thêm hàm';

  @override
  String get removeFunction => 'Xóa hàm';

  @override
  String get toggleFunction => 'Bật/tắt hàm';

  @override
  String get functionVisible => 'Hàm đang hiển thị';

  @override
  String get functionHidden => 'Hàm đã ẩn';

  @override
  String get functionInputHelp => 'Trợ giúp nhập hàm';

  @override
  String get functionInputHelpDesc => 'Nhận trợ giúp về cú pháp hàm toán học';

  @override
  String get commonFunctions => 'Hàm thông dụng';

  @override
  String get polynomialFunctions => 'Hàm đa thức';

  @override
  String get insertFunction => 'Chèn';

  @override
  String get functionSyntaxError => 'Cú pháp hàm không hợp lệ';

  @override
  String get functionSyntaxErrorDesc => 'Vui lòng kiểm tra cú pháp hàm và thử lại';

  @override
  String get advancedFunctions => 'Hàm nâng cao';

  @override
  String get askBeforeLoadingHistory => 'Hỏi trước khi tải lịch sử';

  @override
  String get askBeforeLoadingHistoryDesc => 'Hiển thị dialog xác nhận khi tải nhóm hàm từ lịch sử';

  @override
  String get rememberCalculationHistory => 'Ghi nhớ lịch sử tính toán';

  @override
  String get rememberCalculationHistoryDesc => 'Lưu nhóm hàm số vào lịch sử để sử dụng sau';

  @override
  String get saveCurrentToHistory => 'Lưu nhóm hiện tại vào lịch sử';

  @override
  String get loadHistoryGroup => 'Tải nhóm lịch sử';

  @override
  String get saveCurrentGroupQuestion => 'Bạn có muốn lưu nhóm hàm hiện tại vào lịch sử không?';

  @override
  String get dontAskAgain => 'Không hỏi lại';

  @override
  String get rememberChoice => 'Ghi nhớ lựa chọn';

  @override
  String get info => 'Thông tin';

  @override
  String get yes => 'Có';

  @override
  String get no => 'Không';

  @override
  String get functionGroup => 'Nhóm hàm';

  @override
  String savedOn(String date) {
    return 'Đã lưu vào $date';
  }

  @override
  String functionsCount(int count) {
    return '$count hàm';
  }

  @override
  String get editFunctionColor => 'Chỉnh sửa màu hàm';

  @override
  String get selectColor => 'Chọn màu';

  @override
  String get noHistoryAvailable => 'Không có lịch sử';

  @override
  String get removeFromHistory => 'Xóa khỏi lịch sử';

  @override
  String get selectedColor => 'Màu đã chọn';

  @override
  String get predefinedColors => 'Màu có sẵn';

  @override
  String get customColor => 'Màu tùy chỉnh';

  @override
  String get select => 'Chọn';

  @override
  String get hue => 'Sắc độ';

  @override
  String get saturation => 'Độ bão hòa';

  @override
  String get lightness => 'Độ sáng';

  @override
  String get debugCache => 'Debug Cache';

  @override
  String get deletingOldLogs => 'Đang xóa log cũ...';

  @override
  String deletedOldLogFiles(int count) {
    return 'Đã xóa $count file log cũ';
  }

  @override
  String get noOldLogFilesToDelete => 'Không có file log cũ nào để xóa';

  @override
  String errorDeletingLogs(String error) {
    return 'Lỗi khi xóa log: $error';
  }

  @override
  String get mobileCacheDebug => 'Mobile Cache Debug';

  @override
  String get runningCacheDiagnostics => 'Đang chạy kiểm tra cache...';

  @override
  String get cacheDiagnosticsResults => 'Kết quả Kiểm tra Cache';

  @override
  String get cacheStatus => 'Trạng thái Cache:';

  @override
  String get reliability => 'Độ tin cậy';

  @override
  String get reliable => 'Tin cậy';

  @override
  String get unreliable => 'Không tin cậy';

  @override
  String get hasCache => 'Có Cache';

  @override
  String get currencyState => 'Trạng thái Tiền tệ';

  @override
  String get lengthState => 'Trạng thái Độ dài';

  @override
  String get timeState => 'Trạng thái Thời gian';

  @override
  String get defaultState => 'Mặc định';

  @override
  String errorWithDetails(String details) {
    return 'Lỗi: $details';
  }

  @override
  String get stateLoadingIssuesDetected => '⚠️ Phát hiện vấn đề tải trạng thái';

  @override
  String get stateLoadingIssuesDesc => 'Điều này thường xảy ra sau khi cập nhật ứng dụng thay đổi cấu trúc dữ liệu.';

  @override
  String get clearAllStateData => 'Xóa tất cả dữ liệu trạng thái';

  @override
  String get clearingStateData => 'Đang xóa tất cả dữ liệu trạng thái converter...';

  @override
  String get clearingAllConverterStateData => 'Đang xóa tất cả dữ liệu trạng thái converter...';

  @override
  String get allStateDataCleared => 'Tất cả dữ liệu trạng thái đã được xóa. Ứng dụng sẽ khởi động lại để hoàn tất quá trình.';

  @override
  String failedToRunDiagnostics(String error) {
    return 'Thất bại khi chạy kiểm tra: $error';
  }

  @override
  String failedToClearStateData(String error) {
    return 'Thất bại khi xóa dữ liệu trạng thái: $error';
  }

  @override
  String get stateDataClearedSuccess => 'Tất cả dữ liệu trạng thái đã được xóa. Ứng dụng sẽ khởi động lại để hoàn tất quá trình.';

  @override
  String get ok => 'OK';

  @override
  String get bmiUnderweightInterpretation => 'Chỉ số BMI của bạn cho thấy bạn bị thiếu cân. Điều này có thể gợi ý bạn cần tăng cân để có sức khỏe tối ưu.';

  @override
  String get bmiElderlyNote => 'Đối với người trên 65 tuổi, phạm vi BMI hơi cao hơn (22-27) có thể được chấp nhận và có tác dụng bảo vệ.';

  @override
  String get bmiYouthNote => 'Đối với người dưới 20 tuổi, BMI nên được đánh giá bằng biểu đồ phần trăm theo tuổi và giới tính.';

  @override
  String get bmiLimitationReminder => 'Lưu ý: BMI chỉ là công cụ sàng lọc và không tính đến khối lượng cơ, mật độ xương hay thành phần cơ thể.';

  @override
  String get bmiElderlyRec => 'Là người lớn tuổi, hãy tập trung duy trì khối lượng cơ thông qua tập luyện sức bền và đủ protein.';

  @override
  String get bmiYouthRec => 'Đối với thanh niên, hãy tập trung xây dựng thói quen ăn uống lành mạnh và hoạt động thể chất thường xuyên.';

  @override
  String get bmiFemaleRec => 'Phụ nữ trong độ tuổi sinh sản nên đảm bảo dinh dưỡng đầy đủ, đặc biệt là sắt và canxi.';

  @override
  String get bmiConsultationRec => 'Cân nhắc tham khảo ý kiến chuyên gia y tế để được đánh giá sức khỏe và hướng dẫn cá nhân hóa.';

  @override
  String get bmiFormula => 'BMI = Cân nặng (kg) / [Chiều cao (m)]²';

  @override
  String get bmiLimitation1 => 'Không phản ánh thành phần cơ thể (tỷ lệ cơ bắp/mỡ)';

  @override
  String get bmiLimitation2 => 'Có thể không chính xác cho vận động viên, người già, hoặc một số nhóm dân tộc';

  @override
  String get bmiLimitation3 => 'Không đánh giá các yếu tố sức khỏe khác như huyết áp, cholesterol, đường huyết';

  @override
  String get bmiLimitation4 => 'Không phù hợp cho phụ nữ mang thai, trẻ em dưới 18 tuổi, hoặc người có bệnh lý nhất định';

  @override
  String get bmiConsult1 => 'Khám sức khỏe toàn diện và làm các xét nghiệm cần thiết';

  @override
  String get bmiConsult2 => 'Tham khảo ý kiến chuyên gia y tế và được hướng dẫn';

  @override
  String get bmiConsult3 => 'Nhận tư vấn và hướng dẫn chăm sóc phù hợp từ bác sĩ chuyên khoa';

  @override
  String get bmiPediatricTitle => 'Phân loại BMI cho Trẻ em và Thanh thiếu niên (Dưới 18 tuổi)';

  @override
  String get bmiAdultTitle => 'Phân loại BMI cho Người lớn (Từ 18 tuổi trở lên)';

  @override
  String get bmiPercentileNote => 'Dựa trên biểu đồ tăng trưởng CDC với phần trăm phân vị theo tuổi và giới tính';

  @override
  String get bmiPercentileUnderweight => 'Dưới phân vị thứ 5';

  @override
  String get bmiPercentileNormal => 'Từ phân vị thứ 5 đến 85';

  @override
  String bmiPediatricInterpretation(Object category, Object percentile) {
    return 'Phân vị BMI của bạn là $percentile cho tuổi và giới tính của bạn. Điều này cho thấy $category.';
  }

  @override
  String get bmiPediatricNote => 'Đối với trẻ em và thanh thiếu niên, BMI được so sánh với những người cùng tuổi và giới tính bằng biểu đồ phân vị.';

  @override
  String get bmiGrowthPattern => 'Tham khảo ý kiến bác sĩ nhi khoa để đánh giá mô hình tăng trưởng và sức khỏe tổng thể.';

  @override
  String get ageYears => 'Tuổi';

  @override
  String get gender => 'Giới tính';

  @override
  String get male => 'Nam';

  @override
  String get female => 'Nữ';

  @override
  String get bmiCalculatorTab => 'Máy tính';

  @override
  String get bmiHistoryTab => 'Lịch sử';

  @override
  String get bmiDetailedInfo => 'Thông tin máy tính BMI';

  @override
  String get bmiOverview => 'Máy tính chỉ số khối cơ thể toàn diện với thông tin và khuyến nghị sức khỏe';

  @override
  String get financialCalculator => 'Máy tính Tài chính';

  @override
  String get financialCalculatorDesc => 'Tính toán tài chính nâng cao cho vay, đầu tư và lãi kép';

  @override
  String get financialCalculatorDetailedInfo => 'Thông tin Máy tính Tài chính';

  @override
  String get financialCalculatorOverview => 'Máy tính tài chính toàn diện cho thanh toán vay, kế hoạch đầu tư và tính toán lãi kép';

  @override
  String get loanCalculator => 'Máy tính Vay';

  @override
  String get investmentCalculator => 'Máy tính Đầu tư';

  @override
  String get compoundInterestCalculator => 'Máy tính Lãi kép';

  @override
  String get loanAmount => 'Số tiền vay (\$)';

  @override
  String get loanAmountHint => 'Nhập số tiền vay';

  @override
  String get annualInterestRate => 'Lãi suất hàng năm (%)';

  @override
  String get annualInterestRateHint => 'Nhập lãi suất';

  @override
  String get loanTerm => 'Thời hạn vay (năm)';

  @override
  String get loanTermHint => 'Nhập thời hạn vay';

  @override
  String get calculateLoan => 'Tính toán Vay';

  @override
  String get initialInvestment => 'Đầu tư ban đầu (\$)';

  @override
  String get initialInvestmentHint => 'Nhập số tiền ban đầu';

  @override
  String get monthlyContribution => 'Đóng góp hàng tháng (\$)';

  @override
  String get monthlyContributionHint => 'Nhập đóng góp hàng tháng';

  @override
  String get annualReturn => 'Lợi nhuận hàng năm (%)';

  @override
  String get annualReturnHint => 'Nhập lợi nhuận dự kiến';

  @override
  String get investmentPeriod => 'Thời gian đầu tư (năm)';

  @override
  String get investmentPeriodHint => 'Nhập thời gian đầu tư';

  @override
  String get calculateInvestment => 'Tính toán Đầu tư';

  @override
  String get principalAmount => 'Số tiền gốc (\$)';

  @override
  String get principalAmountHint => 'Nhập số tiền gốc';

  @override
  String get timePeriod => 'Thời gian (năm)';

  @override
  String get timePeriodHint => 'Nhập thời gian';

  @override
  String get compoundingFrequency => 'Tần suất tính lãi (lần/năm)';

  @override
  String get compoundingFrequencyHint => 'Nhập tần suất (12 cho hàng tháng)';

  @override
  String get calculateCompoundInterest => 'Tính toán Lãi kép';

  @override
  String get monthlyPayment => 'Thanh toán hàng tháng';

  @override
  String get totalPayment => 'Tổng thanh toán';

  @override
  String get totalInterest => 'Tổng lãi';

  @override
  String get futureValue => 'Giá trị tương lai';

  @override
  String get totalContributions => 'Tổng đóng góp';

  @override
  String get totalEarnings => 'Tổng thu nhập';

  @override
  String get finalAmount => 'Số tiền cuối cùng';

  @override
  String get interestEarned => 'Lãi kiếm được';

  @override
  String get results => 'Kết quả';

  @override
  String get financialHistory => 'Lịch sử Tài chính';

  @override
  String get historyTab => 'Lịch sử';

  @override
  String get loanTab => 'Vay';

  @override
  String get investmentTab => 'Đầu tư';

  @override
  String get compoundTab => 'Lãi kép';

  @override
  String get inputError => 'Lỗi nhập liệu';

  @override
  String get pleaseEnterValidNumbers => 'Vui lòng nhập các số dương hợp lệ cho tất cả các trường.';

  @override
  String get pleaseEnterValidReturnAndTerm => 'Vui lòng nhập các số dương hợp lệ cho tỷ lệ lợi nhuận và thời hạn.';

  @override
  String get financialCalculationHistory => 'Lịch sử tính toán tài chính và các phép tính đã lưu';

  @override
  String get financialHistoryCleared => 'Đã xóa lịch sử tài chính';

  @override
  String get confirmClearFinancialHistory => 'Bạn có chắc chắn muốn xóa tất cả lịch sử tính toán tài chính không?';

  @override
  String get loanCalculationSaved => 'Phép tính vay đã được lưu vào lịch sử';

  @override
  String get investmentCalculationSaved => 'Phép tính đầu tư đã được lưu vào lịch sử';

  @override
  String get compoundCalculationSaved => 'Phép tính lãi kép đã được lưu vào lịch sử';

  @override
  String get restoreCalculation => 'Khôi phục Tính toán';

  @override
  String get copyResult => 'Sao chép Kết quả';

  @override
  String get copyInputs => 'Sao chép Đầu vào';

  @override
  String get removeFromFinancialHistory => 'Xóa khỏi lịch sử';

  @override
  String financialCalculationDate(String date) {
    return 'Tính toán vào $date';
  }

  @override
  String get noFinancialHistoryYet => 'Chưa có phép tính nào';

  @override
  String get startCalculatingHint => 'Bắt đầu thực hiện tính toán tài chính để xem chúng tại đây';

  @override
  String financialResultsSummary(String type, String result) {
    return '$type: $result';
  }

  @override
  String get saveToFinancialHistory => 'Lưu vào lịch sử';

  @override
  String get financialCalculationTypes => 'Loại Tính toán Tài chính';

  @override
  String get loanCalculationDesc => 'Tính toán thanh toán hàng tháng, tổng chi phí và lãi cho các khoản vay';

  @override
  String get investmentCalculationDesc => 'Lập kế hoạch giá trị tương lai của đầu tư với đóng góp thường xuyên';

  @override
  String get compoundInterestDesc => 'Tính toán tăng trưởng lãi kép theo thời gian';

  @override
  String get practicalFinancialApplications => 'Ứng dụng Thực tế';

  @override
  String get financialApplicationsDesc => 'Kế hoạch thế chấp, vay mua xe, tiết kiệm hưu trí, quỹ giáo dục, đầu tư kinh doanh và lập kế hoạch tài chính tổng thể.';

  @override
  String get financialTips => 'Mẹo Tài chính';

  @override
  String get financialTip1 => 'So sánh các thời hạn vay khác nhau để tìm lựa chọn tốt nhất';

  @override
  String get financialTip2 => 'Bắt đầu đầu tư sớm để tối đa hóa lãi kép';

  @override
  String get financialTip3 => 'Cân nhắc thanh toán thêm để giảm lãi vay';

  @override
  String get financialTip4 => 'Đóng góp thường xuyên có thể tăng đáng kể tăng trưởng đầu tư';

  @override
  String get financialTip5 => 'Tần suất tính lãi cao hơn sẽ tăng lợi nhuận';

  @override
  String get selectedDate => 'Ngày được chọn';

  @override
  String get weekdayName => 'Thứ trong tuần';

  @override
  String get dayInMonth => 'Ngày trong tháng';

  @override
  String get dayInYear => 'Ngày trong năm';

  @override
  String get weekInMonth => 'Tuần trong tháng';

  @override
  String get weekInYear => 'Tuần trong năm';

  @override
  String get monthName => 'Tháng';

  @override
  String get monthOfYear => 'Tháng trong năm';

  @override
  String get yearValue => 'Năm';

  @override
  String get quarter => 'Quý';

  @override
  String get quarterOfYear => 'Quý trong năm';

  @override
  String get isLeapYear => 'Năm nhuận';

  @override
  String get daysInMonth => 'Số ngày trong tháng';

  @override
  String get daysInYear => 'Số ngày trong năm';

  @override
  String get dateInfoResults => 'Kết quả Thông tin Ngày';

  @override
  String quarterValue(int number) {
    return 'Q$number';
  }

  @override
  String leapYearStatus(String status) {
    return '$status';
  }

  @override
  String get dateDistance => 'Khoảng cách';

  @override
  String get dateCalculatorInfoHeaderTitle => 'Thông tin Máy tính Ngày';

  @override
  String get dateCalculatorInfoHeaderSubtitle => 'Công cụ mạnh mẽ cho mọi phép tính về ngày tháng và thời gian.';

  @override
  String get dateCalculatorMainFeatures => 'Tính năng chính';

  @override
  String get dateCalculatorUsage => 'Cách sử dụng';

  @override
  String get dateCalculatorDetailedInfo => 'Thông tin Máy tính Ngày';

  @override
  String get dateCalculatorOverview => 'Công cụ toàn diện cho mọi phép tính về ngày tháng, thời gian và tuổi với nhiều tính năng hữu ích';

  @override
  String get dateKeyFeatures => 'Tính năng chính';

  @override
  String get comprehensiveDateCalc => 'Tính toán Toàn diện';

  @override
  String get comprehensiveDateCalcDesc => 'Hỗ trợ đầy đủ các phép tính về ngày tháng, thời gian và tuổi';

  @override
  String get multipleCalculationModes => 'Nhiều chế độ Tính toán';

  @override
  String get multipleCalculationModesDesc => '4 chế độ khác nhau: thông tin ngày, hiệu số ngày, cộng/trừ ngày, tính tuổi';

  @override
  String get detailedDateInfo => 'Thông tin Chi tiết';

  @override
  String get detailedDateInfoDesc => 'Hiển thị đầy đủ thông tin về ngày: thứ, tuần, quý, năm nhuận';

  @override
  String get flexibleDateInput => 'Nhập linh hoạt';

  @override
  String get flexibleDateInputDesc => 'Hỗ trợ nhiều cách nhập ngày và điều chỉnh dễ dàng';

  @override
  String get dateHowToUse => 'Cách sử dụng';

  @override
  String get step1Date => 'Bước 1: Chọn chế độ tính toán';

  @override
  String get step1DateDesc => 'Chọn tab phù hợp: Thông tin ngày, Hiệu số ngày, Cộng/trừ ngày, hoặc Tính tuổi';

  @override
  String get step2Date => 'Bước 2: Nhập ngày tháng';

  @override
  String get step2DateDesc => 'Sử dụng date picker hoặc stepper để nhập ngày cần tính toán';

  @override
  String get step3Date => 'Bước 3: Xem kết quả';

  @override
  String get step3DateDesc => 'Kết quả sẽ được hiển thị ngay lập tức với thông tin chi tiết';

  @override
  String get step4Date => 'Bước 4: Lưu vào lịch sử';

  @override
  String get step4DateDesc => 'Kết quả được tự động lưu vào lịch sử để tham khảo sau này';

  @override
  String get dateCalculationModes => 'Chế độ Tính toán';

  @override
  String get dateInfoMode => 'Thông tin Ngày';

  @override
  String get dateInfoModeDesc => 'Hiển thị thông tin chi tiết về một ngày cụ thể';

  @override
  String get dateDifferenceMode => 'Hiệu số Ngày';

  @override
  String get dateDifferenceModeDesc => 'Tính khoảng cách giữa hai ngày bất kỳ';

  @override
  String get addSubtractMode => 'Cộng/Trừ Ngày';

  @override
  String get addSubtractModeDesc => 'Cộng hoặc trừ số ngày/tháng/năm từ một ngày';

  @override
  String get ageCalculatorMode => 'Tính Tuổi';

  @override
  String get ageCalculatorModeDesc => 'Tính tuổi chính xác từ ngày sinh đến hiện tại hoặc ngày khác';

  @override
  String get dateTips => 'Mẹo sử dụng';

  @override
  String get dateTip1 => 'Sử dụng date picker để chọn ngày nhanh chóng';

  @override
  String get dateTip2 => 'Dùng stepper để điều chỉnh từng thành phần ngày/tháng/năm';

  @override
  String get dateTip3 => 'Kiểm tra lịch sử để xem lại các tính toán trước đó';

  @override
  String get dateTip4 => 'Chú ý đến năm nhuận khi tính toán các khoảng thời gian dài';

  @override
  String get dateTip5 => 'Sử dụng chế độ thông tin để hiểu rõ hơn về các tính năng';

  @override
  String get dateLimitations => 'Lưu ý quan trọng';

  @override
  String get dateLimitationsDesc => 'Một số điểm cần lưu ý khi sử dụng máy tính ngày:';

  @override
  String get dateLimitation1 => 'Kết quả dựa trên lịch Gregorian (lịch dương)';

  @override
  String get dateLimitation2 => 'Không tính đến múi giờ trong các phép tính';

  @override
  String get dateLimitation3 => 'Năm nhuận được tính theo quy tắc chuẩn quốc tế';

  @override
  String get dateLimitation4 => 'Kết quả có thể khác biệt với một số hệ thống lịch khác';

  @override
  String get dateLimitation5 => 'Nên kiểm tra lại kết quả cho các tính toán quan trọng';

  @override
  String get dateDisclaimer => 'Công cụ này cung cấp thông tin ngày tháng dựa trên lịch Gregorian tiêu chuẩn. Kết quả chỉ mang tính chất tham khảo và có thể cần xác minh thêm cho các ứng dụng quan trọng.';

  @override
  String get discountCalculator => 'Máy tính Giảm giá';

  @override
  String get discountCalculatorDesc => 'Tính toán giảm giá, tip, thuế và lãi suất một cách nhanh chóng và chính xác';

  @override
  String get discountTab => 'Giảm giá';

  @override
  String get tipTab => 'Tip';

  @override
  String get taxTab => 'Thuế';

  @override
  String get markupTab => 'Lãi suất';

  @override
  String get originalPrice => 'Giá gốc (\$)';

  @override
  String get enterOriginalPrice => 'Nhập giá gốc';

  @override
  String get discountPercent => 'Phần trăm giảm giá (%)';

  @override
  String get enterDiscountPercent => 'Nhập phần trăm giảm giá';

  @override
  String get discountAmount => 'Số tiền giảm';

  @override
  String get finalPrice => 'Giá cuối cùng';

  @override
  String get savedAmount => 'Số tiền tiết kiệm';

  @override
  String get billAmount => 'Số tiền hóa đơn (\$)';

  @override
  String get enterBillAmount => 'Nhập số tiền hóa đơn';

  @override
  String get tipPercent => 'Phần trăm tip (%)';

  @override
  String get enterTipPercent => 'Nhập phần trăm tip';

  @override
  String get numberOfPeople => 'Số người';

  @override
  String get enterNumberOfPeople => 'Nhập số người';

  @override
  String get tipAmount => 'Số tiền tip';

  @override
  String get totalBill => 'Tổng hóa đơn';

  @override
  String get perPersonAmount => 'Số tiền mỗi người';

  @override
  String get priceBeforeTax => 'Giá trước thuế (\$)';

  @override
  String get enterPriceBeforeTax => 'Nhập giá trước thuế';

  @override
  String get taxRate => 'Tỷ lệ thuế (%)';

  @override
  String get enterTaxRate => 'Nhập tỷ lệ thuế';

  @override
  String get taxAmount => 'Số tiền thuế';

  @override
  String get priceAfterTax => 'Giá sau thuế';

  @override
  String get costPrice => 'Giá vốn (\$)';

  @override
  String get enterCostPrice => 'Nhập giá vốn';

  @override
  String get markupPercent => 'Phần trăm lãi (%)';

  @override
  String get enterMarkupPercent => 'Nhập phần trăm lãi';

  @override
  String get markupAmount => 'Số tiền lãi';

  @override
  String get sellingPrice => 'Giá bán';

  @override
  String get profitMargin => 'Biên lợi nhuận';

  @override
  String get calculateDiscount => 'Tính Giảm giá';

  @override
  String get calculateTip => 'Tính Tip';

  @override
  String get calculateTax => 'Tính Thuế';

  @override
  String get calculateMarkup => 'Tính Lãi suất';

  @override
  String get discountCalculatorResults => 'Kết quả tính toán';

  @override
  String get tipCalculatorResults => 'Kết quả tính Tip';

  @override
  String get taxCalculatorResults => 'Kết quả tính Thuế';

  @override
  String get markupCalculatorResults => 'Kết quả tính Lãi suất';

  @override
  String get discountCalculatorDetailedInfo => 'Discount Calculator Information';

  @override
  String get discountCalculatorOverview => 'Comprehensive tool for discount, tip, tax, and markup calculations with many useful features';

  @override
  String get discountKeyFeatures => 'Key Features';

  @override
  String get comprehensiveDiscountCalc => 'Comprehensive Calculations';

  @override
  String get comprehensiveDiscountCalcDesc => 'Full support for discount, tip, tax, and markup calculations';

  @override
  String get multipleDiscountModes => 'Multiple Calculation Modes';

  @override
  String get multipleDiscountModesDesc => '4 different modes: discount, tip, tax, markup';

  @override
  String get realTimeDiscountResults => 'Real-time Results';

  @override
  String get realTimeDiscountResultsDesc => 'Get detailed results instantly as you input data';

  @override
  String get discountHistorySaving => 'History Saving';

  @override
  String get discountHistorySavingDesc => 'Save and review previous calculations for reference';

  @override
  String get discountHowToUse => 'How to Use';

  @override
  String get step1Discount => 'Step 1: Select calculation type';

  @override
  String get step1DiscountDesc => 'Choose appropriate tab: Discount, Tip, Tax, or Markup';

  @override
  String get step2Discount => 'Step 2: Enter information';

  @override
  String get step2DiscountDesc => 'Fill in required information like price, percentage, quantity';

  @override
  String get step3Discount => 'Step 3: View results';

  @override
  String get step3DiscountDesc => 'Results will be displayed immediately with detailed information';

  @override
  String get step4Discount => 'Step 4: Save to history';

  @override
  String get step4DiscountDesc => 'Results are automatically saved to history for future reference';

  @override
  String get discountCalculationModes => 'Calculation Modes';

  @override
  String get discountMode => 'Discount Calculator';

  @override
  String get discountModeDesc => 'Calculate final price after discount and savings amount';

  @override
  String get tipMode => 'Tip Calculator';

  @override
  String get tipModeDesc => 'Calculate tip and split bill among multiple people';

  @override
  String get taxMode => 'Tax Calculator';

  @override
  String get taxModeDesc => 'Calculate tax amount and final price after tax';

  @override
  String get markupMode => 'Markup Calculator';

  @override
  String get markupModeDesc => 'Calculate selling price and profit margin from cost price';

  @override
  String get discountTips => 'Usage Tips';

  @override
  String get discountTip1 => 'Use discount calculator when shopping to know real prices';

  @override
  String get discountTip2 => 'Calculate appropriate tip based on service quality';

  @override
  String get discountTip3 => 'Check tax to know actual total cost';

  @override
  String get discountTip4 => 'Use markup calculator for business pricing';

  @override
  String get discountTip5 => 'Save calculations for comparison and reference';

  @override
  String get discountLimitations => 'Ghi chú Quan trọng';

  @override
  String get discountLimitationsDesc => 'Kết quả tính toán là tham khảo và có thể không phản ánh chính xác thực tế do các yếu tố khác:';

  @override
  String get discountLimitation1 => 'Kết quả chỉ mang tính chất tham khảo';

  @override
  String get discountLimitation2 => 'Thuế suất có thể khác nhau tùy địa phương';

  @override
  String get discountLimitation3 => 'Tiền tip có thể thay đổi theo văn hóa';

  @override
  String get discountLimitation4 => 'Lãi suất có thể bị ảnh hưởng bởi các chi phí khác';

  @override
  String get discountLimitation5 => 'Nên kiểm tra lại với hóa đơn thực tế';

  @override
  String get discountDisclaimer => 'Công cụ này chỉ hỗ trợ tính toán và không thay thế tư vấn tài chính chuyên nghiệp. Kết quả có thể khác thực tế do các yếu tố khác.';

  @override
  String get financialKeyFeatures => 'Tính năng chính';

  @override
  String get comprehensiveFinancialCalc => 'Tính toán toàn diện';

  @override
  String get comprehensiveFinancialCalcDesc => 'Máy tính tài chính đa năng cho vay, đầu tư và lãi kép';

  @override
  String get multipleCalculationTypes => 'Nhiều loại tính toán';

  @override
  String get multipleCalculationTypesDesc => 'Hỗ trợ tính toán vay, đầu tư và lãi kép trong một ứng dụng';

  @override
  String get realTimeResults => 'Kết quả thời gian thực';

  @override
  String get realTimeResultsDesc => 'Nhận kết quả chi tiết ngay lập tức khi bạn nhập dữ liệu';

  @override
  String get historySaving => 'Lưu lịch sử';

  @override
  String get historySavingDesc => 'Lưu và xem lại các phép tính trước đó để tham khảo';

  @override
  String get financialHowToUse => 'Cách sử dụng';

  @override
  String get step1Financial => 'Bước 1: Chọn loại tính toán';

  @override
  String get step1FinancialDesc => 'Chọn tab Vay, Đầu tư hoặc Lãi kép theo nhu cầu của bạn';

  @override
  String get step2Financial => 'Bước 2: Nhập thông tin';

  @override
  String get step2FinancialDesc => 'Điền các thông tin cần thiết như số tiền, lãi suất, thời gian';

  @override
  String get step3Financial => 'Bước 3: Tính toán';

  @override
  String get step3FinancialDesc => 'Nhấn nút tính toán để xem kết quả chi tiết';

  @override
  String get step4Financial => 'Bước 4: Lưu kết quả';

  @override
  String get step4FinancialDesc => 'Lưu kết quả vào lịch sử để tham khảo sau';

  @override
  String get financialFormulas => 'Công thức tài chính';

  @override
  String get loanFormula => 'Công thức vay';

  @override
  String get loanFormulaText => 'M = P × [r(1+r)ⁿ] / [(1+r)ⁿ-1]';

  @override
  String get loanFormulaDesc => 'M: Thanh toán hàng tháng, P: Số tiền vay, r: Lãi suất hàng tháng, n: Số tháng';

  @override
  String get investmentFormula => 'Công thức đầu tư';

  @override
  String get investmentFormulaText => 'FV = PV(1+r)ⁿ + PMT × [((1+r)ⁿ-1)/r]';

  @override
  String get investmentFormulaDesc => 'FV: Giá trị tương lai, PV: Đầu tư ban đầu, PMT: Đóng góp hàng tháng, r: Lãi suất, n: Số kỳ';

  @override
  String get compoundInterestFormula => 'Công thức lãi kép';

  @override
  String get compoundInterestFormulaText => 'A = P(1 + r/n)^(nt)';

  @override
  String get compoundInterestFormulaDesc => 'A: Số tiền cuối cùng, P: Số tiền gốc, r: Lãi suất, n: Số lần ghép lãi/năm, t: Thời gian';

  @override
  String get financialLimitations => 'Lưu ý quan trọng';

  @override
  String get financialLimitationsDesc => 'Kết quả tính toán chỉ mang tính chất tham khảo và có thể không phản ánh chính xác thực tế:';

  @override
  String get financialLimitation1 => 'Không tính đến lạm phát và biến động thị trường';

  @override
  String get financialLimitation2 => 'Lãi suất có thể thay đổi theo thời gian';

  @override
  String get financialLimitation3 => 'Không bao gồm phí và các chi phí bổ sung';

  @override
  String get financialLimitation4 => 'Kết quả có thể khác tùy theo điều khoản thực tế';

  @override
  String get financialLimitation5 => 'Nên tham khảo ý kiến chuyên gia tài chính';

  @override
  String get financialDisclaimer => 'Công cụ này chỉ hỗ trợ tính toán và không thay thế tư vấn tài chính chuyên nghiệp. Vui lòng tham khảo chuyên gia trước khi đưa ra quyết định tài chính quan trọng.';

  @override
  String get discountResultSavedToHistory => 'Kết quả tính giảm giá đã lưu vào lịch sử';

  @override
  String get tipResultSavedToHistory => 'Kết quả tính tiền tip đã lưu vào lịch sử';

  @override
  String get taxResultSavedToHistory => 'Kết quả tính thuế đã lưu vào lịch sử';

  @override
  String get markupResultSavedToHistory => 'Kết quả tính markup đã lưu vào lịch sử';

  @override
  String get startCalculatingToSeeHistory => 'Bắt đầu tính toán để xem lịch sử';

  @override
  String get p2pDataTransfer => 'Truyền Dữ Liệu P2P';

  @override
  String get p2pDataTransferDesc => 'Truyền tệp giữa các thiết bị trong cùng mạng cục bộ.';

  @override
  String get networkSecurityWarning => 'Cảnh báo Bảo mật Mạng';

  @override
  String get unsecureNetworkDetected => 'Phát hiện mạng không bảo mật';

  @override
  String get currentNetwork => 'Mạng hiện tại';

  @override
  String get securityLevel => 'Mức độ Bảo mật';

  @override
  String get securityRisks => 'Rủi ro Bảo mật';

  @override
  String get unsecureNetworkRisks => 'Trên mạng không bảo mật, dữ liệu của bạn có thể bị người dùng độc hại chặn bắt. Chỉ tiếp tục nếu bạn tin tưởng mạng và những người dùng khác.';

  @override
  String get proceedAnyway => 'Vẫn Tiếp tục';

  @override
  String get secureNetwork => 'Bảo mật (WPA/WPA2)';

  @override
  String get unsecureNetwork => 'Không bảo mật (Mở/Không mật khẩu)';

  @override
  String get unknownSecurity => 'Bảo mật Không rõ';

  @override
  String get startNetworking => 'Bắt đầu Mạng';

  @override
  String get stopNetworking => 'Dừng Mạng';

  @override
  String get pairingRequests => 'Yêu cầu Ghép nối';

  @override
  String get devices => 'Thiết bị';

  @override
  String get transfers => 'Truyền tải';

  @override
  String get status => 'Trạng thái';

  @override
  String get connectionStatus => 'Trạng thái kết nối';

  @override
  String get autoConnect => 'Tự động kết nối';

  @override
  String get networkInfo => 'Thông tin Mạng';

  @override
  String get statistics => 'Thống kê';

  @override
  String get discoveredDevices => 'Thiết bị đã phát hiện';

  @override
  String get pairedDevices => 'Thiết bị đã ghép nối';

  @override
  String get activeTransfers => 'Truyền tải đang hoạt động';

  @override
  String get noDevicesFound => 'Không tìm thấy thiết bị';

  @override
  String get searchingForDevices => 'Đang tìm kiếm thiết bị...';

  @override
  String get startNetworkingToDiscover => 'Bắt đầu mạng để phát hiện thiết bị';

  @override
  String get noActiveTransfers => 'Không có truyền tải đang hoạt động';

  @override
  String get transfersWillAppearHere => 'Các truyền tải file sẽ xuất hiện ở đây';

  @override
  String get paired => 'Đã ghép nối';

  @override
  String get lastSeen => 'Lần cuối xuất hiện';

  @override
  String get pairedSince => 'Ghép nối từ';

  @override
  String trusted(String name) {
    return 'Đã tin tưởng $name';
  }

  @override
  String get pair => 'Ghép Nối';

  @override
  String get sendFile => 'Gửi File';

  @override
  String get cancelTransfer => 'Hủy Truyền tải';

  @override
  String get confirmCancelTransfer => 'Bạn có chắc muốn hủy truyền tải này không?';

  @override
  String get p2pPairingRequest => 'Yêu cầu ghép nối P2P';

  @override
  String get p2pPairingResponse => 'Phản hồi ghép nối P2P';

  @override
  String get p2pHeartbeat => 'Nhịp tim P2P';

  @override
  String get p2pPermissionRequiredTitle => 'Yêu cầu quyền truy cập';

  @override
  String get p2pPermissionExplanation => 'Để khám phá các thiết bị lân cận bằng WiFi, ứng dụng này cần quyền truy cập vị trí của bạn. Đây là yêu cầu của Android để quét các mạng WiFi. Dữ liệu vị trí của bạn không được lưu trữ hoặc chia sẻ. Ứng dụng hoạt động phía máy khách và chúng tôi không thu thập bất kỳ dữ liệu người dùng nào.';

  @override
  String get p2pPermissionContinue => 'Tiếp tục';

  @override
  String get p2pPermissionCancel => 'Hủy';

  @override
  String get p2pNearbyDevicesPermissionTitle => 'Yêu cầu quyền truy cập thiết bị gần đó';

  @override
  String get p2pNearbyDevicesPermissionExplanation => 'Để khám phá các thiết bị lân cận trên các phiên bản Android hiện đại, ứng dụng này cần quyền truy cập các thiết bị WiFi gần đó. Quyền này cho phép ứng dụng quét các mạng WiFi mà không cần quyền truy cập vị trí. Dữ liệu của bạn không được lưu trữ hoặc chia sẻ. Ứng dụng hoạt động phía máy khách và chúng tôi không thu thập bất kỳ dữ liệu người dùng nào.';

  @override
  String get dataTransferRequest => 'Yêu cầu truyền dữ liệu';

  @override
  String get dataTransferResponse => 'Phản hồi truyền dữ liệu';

  @override
  String get sendData => 'Gửi Dữ Liệu';

  @override
  String get savedDevices => 'Thiết bị đã lưu';

  @override
  String get availableDevices => 'Thiết bị có sẵn';

  @override
  String get p2lanTransfer => 'Truyền dữ liệu P2Lan';

  @override
  String get p2lanStatus => 'Trạng thái P2LAN';

  @override
  String get fileTransferStatus => 'Trạng thái truyền dữ liệu';

  @override
  String get p2lanActive => 'P2LAN đang hoạt động';

  @override
  String get readyForConnections => 'Sẵn sàng kết nối';

  @override
  String devicesConnected(int count) {
    return '$count thiết bị đã kết nối';
  }

  @override
  String deviceConnected(int count) {
    return '$count thiết bị đã kết nối';
  }

  @override
  String get stopP2lan => 'Dừng P2LAN';

  @override
  String get p2lanStopped => 'P2LAN đã dừng';

  @override
  String get quickActionsManage => 'Manage Quick Actions';

  @override
  String get cacheDetailsDialogTitle => 'Cache Details';

  @override
  String get randomGeneratorsCacheDesc => 'Generation history and settings';

  @override
  String get calculatorToolsCacheDesc => 'Calculation history, graphing calculator data, BMI data, and settings';

  @override
  String get converterToolsCacheDesc => 'Trạng thái tiền tệ/độ dài, các cài đặt sẵn và bộ đệm tỷ giá hối đoái';

  @override
  String get p2pDataTransferCacheDesc => 'Cài đặt, hồ sơ thiết bị đã lưu và bộ đệm truyền tệp tạm thời.';

  @override
  String totalCacheSize(Object count, Object size) {
    return 'Tổng cộng: $count mục, $size';
  }

  @override
  String get clearSelectedCache => 'Xóa bộ nhớ đệm đã chọn';

  @override
  String get pairWithDevice => 'Bạn có muốn ghép nối với thiết bị này không?';

  @override
  String get deviceId => 'ID Thiết bị';

  @override
  String get discoveryTime => 'Thời gian phát hiện';

  @override
  String get saveConnection => 'Lưu kết nối';

  @override
  String get autoReconnectDescription => 'Tự động kết nối lại khi cả hai thiết bị trực tuyến';

  @override
  String get pairingNotificationInfo => 'Người dùng khác sẽ nhận được yêu cầu ghép nối và cần chấp nhận để hoàn tất ghép nối.';

  @override
  String get sendRequest => 'Gửi yêu cầu';

  @override
  String get justNow => 'Vừa xong';

  @override
  String minutesAgo(int minutes) {
    return '$minutes phút trước';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours giờ trước';
  }

  @override
  String daysAgo(int days) {
    return '$days ngày trước';
  }

  @override
  String get noPairingRequests => 'Không có yêu cầu ghép nối';

  @override
  String get pairingRequestFrom => 'Yêu cầu ghép nối từ:';

  @override
  String get sentTime => 'Thời gian gửi';

  @override
  String get wantsSaveConnection => 'Người này muốn lưu kết nối';

  @override
  String get trustThisUser => 'Tin tưởng người dùng này';

  @override
  String get allowFileTransfersWithoutConfirmation => 'Cho phép truyền file mà không cần xác nhận';

  @override
  String get onlyAcceptFromTrustedDevices => 'Chỉ chấp nhận ghép nối từ các thiết bị tin cậy.';

  @override
  String get previousRequest => 'Yêu cầu trước';

  @override
  String get nextRequest => 'Yêu cầu tiếp theo';

  @override
  String get reject => 'Từ chối';

  @override
  String get accept => 'Chấp nhận';

  @override
  String get incomingFiles => 'File đến';

  @override
  String wantsToSendYouFiles(int count) {
    return 'muốn gửi cho bạn $count file';
  }

  @override
  String get filesToReceive => 'File sẽ nhận:';

  @override
  String get totalSize => 'Tổng dung lượng:';

  @override
  String get localFiles => 'File cục bộ';

  @override
  String get manualDiscovery => 'Tìm kiếm thủ công';

  @override
  String get transferSettings => 'Cài đặt truyền file';

  @override
  String get savedDevicesCurrentlyAvailable => 'Thiết bị đã lưu hiện có sẵn';

  @override
  String get recentlyDiscoveredDevices => 'Thiết bị vừa phát hiện';

  @override
  String get viewInfo => 'Xem thông tin';

  @override
  String get trust => 'Tin tưởng';

  @override
  String get removeTrust => 'Bỏ tin tưởng';

  @override
  String get unpair => 'Hủy ghép nối';

  @override
  String get thisDevice => 'Thiết bị này';

  @override
  String get fileCache => 'Bộ nhớ đệm file';

  @override
  String get reload => 'Tải lại';

  @override
  String get clear => 'Xóa';

  @override
  String get temporaryFilesFromTransfers => 'File tạm thời từ truyền file P2Lan';

  @override
  String get debug => 'Gỡ lỗi';

  @override
  String get clearFileCache => 'Xóa bộ nhớ đệm file';

  @override
  String get fileCacheClearedSuccessfully => 'Đã xóa bộ nhớ đệm file thành công';

  @override
  String failedToClearCache(String error) {
    return 'Không thể xóa bộ nhớ đệm: $error';
  }

  @override
  String get failedToUpdateSettings => 'Không thể cập nhật cài đặt';

  @override
  String failedToLoadSettings(String error) {
    return 'Không thể tải cài đặt: $error';
  }

  @override
  String removeTrustFrom(String deviceName) {
    return 'Bỏ tin tưởng từ $deviceName?';
  }

  @override
  String get remove => 'Xóa';

  @override
  String unpairFrom(String deviceName) {
    return 'Hủy ghép nối từ $deviceName';
  }

  @override
  String get unpairDescription => 'Điều này sẽ xóa hoàn toàn ghép nối từ cả hai thiết bị. Bạn sẽ cần ghép nối lại trong tương lai.\n\nThiết bị kia cũng sẽ được thông báo và kết nối của họ sẽ bị xóa.';

  @override
  String get holdToUnpair => 'Giữ để hủy ghép nối';

  @override
  String get unpairing => 'Đang hủy ghép nối...';

  @override
  String get holdButtonToConfirmUnpair => 'Giữ nút trong 1 giây để xác nhận hủy ghép nối';

  @override
  String get taskAndFileDeletedSuccessfully => 'Đã xóa tác vụ và file thành công';

  @override
  String get taskCleared => 'Đã xóa tác vụ';

  @override
  String get notConnected => 'Chưa kết nối';

  @override
  String get sending => 'Đang gửi...';

  @override
  String get sendFiles => 'Gửi file';

  @override
  String get addFiles => 'Thêm file';

  @override
  String errorSelectingFiles(String error) {
    return 'Lỗi chọn file: $error';
  }

  @override
  String errorSendingFiles(String error) {
    return 'Lỗi gửi file: $error';
  }

  @override
  String get noFilesSelected => 'Chưa chọn file nào';

  @override
  String get tapRightClickForOptions => 'Nhấn hoặc chuột phải để xem tùy chọn';

  @override
  String get transferSummary => 'Tóm tắt truyền file';

  @override
  String get unlimited => 'Không giới hạn';

  @override
  String get tcpProtocol => 'TCP';

  @override
  String get tcpDescription => 'Đáng tin cậy hơn, tốt cho file quan trọng';

  @override
  String get udpProtocol => 'UDP';

  @override
  String get udpDescription => 'Nhanh hơn nhưng kém tin cậy hơn, tốt cho các file lớn';

  @override
  String get noFileOrganization => 'Không';

  @override
  String get createDateFolders => 'Tạo thư mục theo ngày';

  @override
  String get organizeFoldersByDate => 'Sắp xếp file theo ngày nhận';

  @override
  String get createSenderFolders => 'Tạo thư mục theo người gửi';

  @override
  String get immediate => 'Ngay lập tức';

  @override
  String get myDevice => 'Thiết bị của tôi';

  @override
  String get bySenderName => 'Theo tên người gửi';

  @override
  String get byDate => 'Theo ngày';

  @override
  String get none => 'Không';

  @override
  String get resetToDefaults => 'Đặt lại mặc định';

  @override
  String get resetConfirmation => 'Bạn có chắc muốn đặt lại tất cả cài đặt về giá trị mặc định không?';

  @override
  String get generic => 'Chung';

  @override
  String get storage => 'Lưu trữ';

  @override
  String get network => 'Mạng';

  @override
  String get saveSettings => 'Lưu cài đặt';

  @override
  String get deviceProfile => 'Hồ sơ thiết bị';

  @override
  String get deviceDisplayName => 'Tên hiển thị thiết bị';

  @override
  String get userPreferences => 'Tùy chọn người dùng';

  @override
  String get enableNotifications => 'Bật thông báo';

  @override
  String get userInterfacePerformance => 'Hiệu suất giao diện';

  @override
  String get uiRefreshRate => 'Tốc độ làm mới giao diện';

  @override
  String get currentConfiguration => 'Cấu hình hiện tại';

  @override
  String get protocol => 'Giao thức';

  @override
  String get maxFileSize => 'Kích thước file tối đa';

  @override
  String get maxTotalSize => 'Tổng kích thước tối đa';

  @override
  String get concurrentTasks => 'Tác vụ đồng thời';

  @override
  String get chunkSize => 'Kích thước khối';

  @override
  String get fileOrganization => 'Sắp xếp file';

  @override
  String get storageInformation => 'Thông tin lưu trữ';

  @override
  String get downloadPath => 'Đường dẫn tải về';

  @override
  String get totalSpace => 'Tổng dung lượng';

  @override
  String get freeSpace => 'Dung lượng trống';

  @override
  String get usedSpace => 'Dung lượng đã dùng';

  @override
  String get noDownloadPathSet => 'Chưa đặt đường dẫn tải về';

  @override
  String get downloadLocation => 'Vị trí tải về';

  @override
  String get downloadFolder => 'Thư mục tải về';

  @override
  String get androidStorageAccess => 'Quyền truy cập lưu trữ Android';

  @override
  String get useAppFolder => 'Dùng thư mục ứng dụng';

  @override
  String get sizeLimits => 'Giới hạn kích thước';

  @override
  String get totalSizeLimitDescription => 'Giới hạn tổng kích thước cho tất cả file trong một yêu cầu truyền';

  @override
  String get transferProtocolSection => 'Giao thức truyền';

  @override
  String get performanceTuning => 'Tinh chỉnh hiệu suất';

  @override
  String get concurrentTransfersDescription => 'Nhiều truyền = nhanh hơn tổng thể nhưng dùng CPU cao hơn';

  @override
  String get transferChunkSizeDescription => 'Kích thước cao hơn = truyền nhanh hơn nhưng dùng bộ nhớ nhiều hơn';

  @override
  String get permissionsRequiredForP2P => 'Cần quyền để khởi động mạng P2P';

  @override
  String errorInStartNetworking(String error) {
    return 'Lỗi khởi động mạng: $error';
  }

  @override
  String errorSelectingFilesFromCategory(String category, String error) {
    return 'Lỗi chọn file từ $category: $error';
  }

  @override
  String get loadingDeviceInfo => 'Đang tải thông tin thiết bị...';

  @override
  String get tempFilesDescription => 'File tạm thời từ truyền file P2Lan';

  @override
  String get networkDebugCompleted => 'Hoàn tất gỡ lỗi mạng. Kiểm tra log để biết chi tiết.';

  @override
  String lastRefresh(String time) {
    return 'Làm mới cuối: $time';
  }

  @override
  String get p2pNetworkingPaused => 'Mạng P2P tạm dừng do mất kết nối internet. Sẽ tự động khôi phục khi có kết nối.';

  @override
  String get noDevicesInRange => 'Không có thiết bị trong tầm. Thử làm mới.';

  @override
  String get initialDiscoveryInProgress => 'Đang tiến hành khám phá ban đầu...';

  @override
  String get refreshing => 'Đang làm mới...';

  @override
  String get pausedNoInternet => 'Tạm dừng (Không có Internet)';

  @override
  String trustRemoved(String name) {
    return 'Trust removed from $name';
  }

  @override
  String removeTrustConfirm(String name) {
    return 'Bỏ tin tưởng từ $name?';
  }

  @override
  String unpairFromDevice(String name) {
    return 'Hủy ghép nối từ $name';
  }

  @override
  String get holdUnpairInstruction => 'Giữ nút trong 1 giây để xác nhận hủy ghép nối';

  @override
  String unpaired(String name) {
    return 'Đã hủy ghép nối từ $name';
  }

  @override
  String get taskAndFileDeleted => 'Đã xóa tác vụ và file thành công';

  @override
  String get clearFileCacheConfirm => 'Điều này sẽ xóa file tạm thời từ truyền file P2Lan. Hành động này không thể hoàn tác.';

  @override
  String get fileCacheClearedSuccess => 'Đã xóa bộ nhớ đệm file thành công';

  @override
  String get permissionsRequired => 'Cần quyền để khởi động mạng P2P';

  @override
  String startedSending(int count, String name) {
    return 'Bắt đầu gửi $count file đến $name';
  }

  @override
  String get transferSettingsUpdated => 'Cập nhật cài đặt truyền file thành công';

  @override
  String get disconnected => 'Đã ngắt kết nối';

  @override
  String get discoveringDevices => 'Đang khám phá thiết bị...';

  @override
  String get connected => 'Đã kết nối';

  @override
  String get pairing => 'Pairing...';

  @override
  String get checkingNetwork => 'Đang kiểm tra mạng...';

  @override
  String get connectedViaMobileData => 'Kết nối qua dữ liệu di động (an toàn)';

  @override
  String connectedToWifi(String name, String security) {
    return 'Kết nối đến $name ($security)';
  }

  @override
  String get secure => 'secure';

  @override
  String get unsecure => 'unsecure';

  @override
  String get connectedViaEthernet => 'Kết nối qua Ethernet (an toàn)';

  @override
  String get noNetworkConnection => 'Không có kết nối mạng';

  @override
  String get unknownWifi => 'WiFi không rõ';

  @override
  String get tcpReliable => 'TCP (Đáng tin cậy)';

  @override
  String get udpFast => 'UDP (Nhanh)';

  @override
  String get createDateFoldersDescription => 'Sắp xếp theo ngày (YYYY-MM-DD)';

  @override
  String get createSenderFoldersDescription => 'Sắp xếp theo tên hiển thị người gửi';

  @override
  String get maxConcurrentTasks => 'Tác vụ đồng thời tối đa';

  @override
  String get defaultLabel => 'Mặc định';

  @override
  String get customDisplayName => 'Tên hiển thị tùy chỉnh';

  @override
  String get deviceName => 'Tên thiết bị';

  @override
  String get general => 'Chung';

  @override
  String get performance => 'Hiệu suất';

  @override
  String get advanced => 'Nâng cao';

  @override
  String get discard => 'Hủy bỏ';

  @override
  String get hasUnsavedChanges => 'Bạn có thay đổi chưa lưu. Bạn có muốn hủy bỏ chúng không?';

  @override
  String get selectFolder => 'Chọn thư mục';

  @override
  String get permissionRequired => 'Cần quyền';

  @override
  String get grantStoragePermission => 'Cấp quyền lưu trữ để chọn thư mục tải về';

  @override
  String get openSettings => 'Mở Cài đặt';

  @override
  String get notificationPermissionInfo => 'Quyền thông báo cho phép bạn nhận cập nhật về truyền file và trạng thái kết nối.';

  @override
  String get secondsLabel => 'giây';

  @override
  String get secondsPlural => 'giây';

  @override
  String get networkInfoTitle => 'Thông Tin Mạng';

  @override
  String get deviceSections => 'Phần Thiết Bị';

  @override
  String get onlineDevices => 'Thiết Bị Trực Tuyến';

  @override
  String get newDevices => 'Thiết Bị Mới';

  @override
  String get addTrust => 'Thêm tin tưởng';

  @override
  String get emptyDevicesStateTitle => 'Không Tìm Thấy Thiết Bị';

  @override
  String get viewDeviceInfo => 'Xem thông tin thiết bị';

  @override
  String get trustUser => 'Tin cậy người dùng';

  @override
  String get menuSendFiles => 'Gửi File';

  @override
  String get menuViewInfo => 'Xem Thông Tin';

  @override
  String get menuPair => 'Ghép Nối';

  @override
  String get menuTrust => 'Tin Cậy';

  @override
  String get menuUntrust => 'Xóa Tin Cậy';

  @override
  String get menuUnpair => 'Hủy Ghép Nối';

  @override
  String get deviceActions => 'Hành Động Thiết Bị';

  @override
  String get p2pTemporarilyDisabled => 'P2P tạm thời bị vô hiệu hóa - đang chờ kết nối internet';

  @override
  String get fileOrgNoneDescription => 'File đi thẳng vào thư mục tải về';

  @override
  String get fileOrgDateDescription => 'Sắp xếp theo ngày (YYYY-MM-DD)';

  @override
  String get fileOrgSenderDescription => 'Sắp xếp theo tên hiển thị người gửi';

  @override
  String get basic => 'Basic';

  @override
  String get summary => 'Summary';

  @override
  String get p2lanTransferSettingsTitle => 'P2Lan Transfer Settings';

  @override
  String get settingsTabGeneric => 'Generic';

  @override
  String get settingsTabStorage => 'Storage';

  @override
  String get settingsTabNetwork => 'Network';

  @override
  String get displayName => 'Tên hiển thị';

  @override
  String get displayNameDescription => 'Tùy chỉnh cách thiết bị của bạn xuất hiện với người dùng khác';

  @override
  String get deviceDisplayNameLabel => 'Tên hiển thị thiết bị';

  @override
  String get deviceDisplayNameHint => 'Nhập tên hiển thị tùy chỉnh...';

  @override
  String defaultDisplayName(String name) {
    return 'Mặc định: $name';
  }

  @override
  String get notifications => 'Thông báo';

  @override
  String get notSupportedOnWindows => 'Không hỗ trợ trên Windows';

  @override
  String get uiPerformance => 'Hiệu suất giao diện';

  @override
  String get uiRefreshRateDescription => 'Chọn tần suất cập nhật tiến trình truyền file trong giao diện. Tần suất cao hơn hoạt động tốt hơn trên thiết bị mạnh.';

  @override
  String savedDevicesCount(int count) {
    return 'Thiết bị đã lưu ($count)';
  }

  @override
  String get previouslyPairedOffline => 'Thiết bị đã ghép nối (ngoại tuyến)';

  @override
  String get statusSaved => 'Đã lưu';

  @override
  String get statusTrusted => 'Trusted';

  @override
  String get thisDeviceCardTitle => 'This Device';

  @override
  String get appInstallationId => 'ID phiên cài ứng dụng';

  @override
  String get ipAddress => 'Địa chỉ IP';

  @override
  String get port => 'Cổng';

  @override
  String get statusOffline => 'Ngoại tuyến';

  @override
  String get selectDownloadFolder => 'Select download folder...';

  @override
  String get maxFileSizePerFile => 'Kích thước file tối đa (mỗi file)';

  @override
  String get transferProtocol => 'Giao thức truyền';

  @override
  String get concurrentTransfers => 'Tác vụ đồng thời';

  @override
  String get transferChunkSize => 'Kích thước khối truyền';

  @override
  String get defaultValue => 'Mặc định';

  @override
  String get androidStorageAccessDescription => 'For security, it\'s recommended to use the app-specific folder. You can select other folders, but this may require additional permissions.';

  @override
  String get storageInfo => 'Storage Information';

  @override
  String get noDownloadPathSetDescription => 'Please select a download folder in the Storage tab to see storage information.';

  @override
  String get enableNotificationsDescription => 'Get notified about transfer events';

  @override
  String get maxFileSizePerFileDescription => 'File lớn hơn sẽ bị từ chối tự động';

  @override
  String get maxTotalSizeDescription => 'Giới hạn tổng kích thước cho tất cả file trong một yêu cầu truyền';

  @override
  String get concurrentTransfersSubtitle => 'Nhiều luồng truyền hơn = tổng thể nhanh hơn nhưng sử dụng CPU cao hơn';

  @override
  String get transferChunkSizeSubtitle => 'Kích thước lớn hơn = truyền nhanh hơn nhưng sử dụng nhiều bộ nhớ hơn';

  @override
  String get protocolTcpReliable => 'TCP (Tin cậy)';

  @override
  String get protocolTcpDescription => 'Đáng tin cậy hơn, tốt hơn cho các tệp quan trọng';

  @override
  String get protocolUdpFast => 'UDP (Nhanh)';

  @override
  String get fileOrgNone => 'Không có';

  @override
  String get fileOrgDate => 'Theo ngày';

  @override
  String get fileOrgSender => 'Theo tên người gửi';

  @override
  String get transferSettingsUpdatedSuccessfully => 'Cập nhật cài đặt truyền file thành công';

  @override
  String get selectOperation => 'Chọn thao tác';

  @override
  String get filterAndSort => 'Lọc và Sắp xếp';

  @override
  String get tapToSelectAgain => 'Nhấn để chọn lại thư mục';

  @override
  String get notSelected => 'Chưa chọn';

  @override
  String get selectDestinationFolder => 'Chọn thư mục đích';

  @override
  String get openInApp => 'Mở trong ứng dụng';

  @override
  String get copyTo => 'Sao chép vào';

  @override
  String get moveTo => 'Di chuyển vào';

  @override
  String get moveOrCopyAndRename => 'Di chuyển hoặc sao chép và đổi tên';

  @override
  String get share => 'Chia sẻ';

  @override
  String get confirmDelete => 'Bạn có chắc muốn xóa file';

  @override
  String get removeSelected => 'Xóa nội dung đã chọn';

  @override
  String get noFilesFound => 'Không tìm thấy file nào khớp';

  @override
  String get emptyFolder => 'Thư mục trống';

  @override
  String get file => 'tệp';

  @override
  String get quickAccess => 'Truy cập nhanh';

  @override
  String get colorFormat => 'Định dạng màu';
}
