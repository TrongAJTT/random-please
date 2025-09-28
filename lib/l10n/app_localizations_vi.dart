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
  String get helpAndGuides => 'Trợ giúp & Hướng dẫn';

  @override
  String get pressBackAgainToExit => 'Nhấn quay lại lần nữa để thoát';

  @override
  String get appVersion => 'Phiên bản Ứng dụng';

  @override
  String get versionType => 'Loại Phiên bản';

  @override
  String get versionTypeDev => 'Phát triển';

  @override
  String get versionTypeBeta => 'Beta';

  @override
  String get versionTypeRelease => 'Phát hành';

  @override
  String get versionTypeDevDisplay => 'Phiên bản phát triển';

  @override
  String get versionTypeBetaDisplay => 'Phiên bản Beta';

  @override
  String get versionTypeReleaseDisplay => 'Phiên bản phát hành';

  @override
  String get githubRepo => 'Kho lưu trữ GitHub';

  @override
  String get githubRepoDesc => 'Xem mã nguồn của ứng dụng trên GitHub';

  @override
  String get creditAck => 'Ghi công tác giả';

  @override
  String get creditAckDesc =>
      'Danh sách các thư viện, công cụ và nguồn tài nguyên đã sử dụng trong ứng dụng này.';

  @override
  String get supportDesc =>
      'Random Please giúp bạn tạo dữ liệu ngẫu nhiên một cách dễ dàng, thuận tiện và miễn phí. Nếu bạn thấy ứng dụng hữu ích, hãy cân nhắc hỗ trợ mình để giúp mình duy trì và phát triển ứng dụng này. Cảm ơn bạn rất nhiều!';

  @override
  String get supportOnGitHub => 'Hỗ trợ trên GitHub';

  @override
  String get donate => 'Ủng hộ';

  @override
  String get donateDesc => 'Hỗ trợ tôi nếu bạn thấy ứng dụng này hữu ích';

  @override
  String get oneTimeDonation => 'Ủng hộ một lần';

  @override
  String get settings => 'Cài đặt';

  @override
  String get theme => 'Chủ đề';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get userInterface => 'Giao diện người dùng';

  @override
  String get userInterfaceDesc =>
      'Cài đặt chủ đề và ngôn ngữ và phong cách hiển thị';

  @override
  String get randomTools => 'Công cụ ngẫu nhiên';

  @override
  String get randomToolsDesc =>
      'Lịch sử, trạng thái, vị trí sắp xếp công vụ và bảo vệ dữ liệu';

  @override
  String get dataManager => 'Quản lý dữ liệu';

  @override
  String get dataManagerDesc => 'Xóa toàn bộ dữ liệu';

  @override
  String get autoCleanupHistoryLimit => 'Tự động xóa bản ghi lịch sử cũ';

  @override
  String get autoCleanupHistoryLimitDesc =>
      'Tự động xóa bản ghi cũ nhất (không ghim) khi vượt ngưỡng';

  @override
  String historyLimitRecords(int count) {
    return '$count bản ghi';
  }

  @override
  String get noLimit => 'Không giới hạn';

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
  String get cacheSize => 'Kích thước bộ nhớ đệm';

  @override
  String get clearAllCache => 'Xóa tất cả bộ nhớ đệm';

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
  String get historyManager => 'Quản lý lịch sử';

  @override
  String get logRetentionDescDetail =>
      'Nhật ký sẽ được lưu trữ trong bộ nhớ đệm và có thể được xóa tự động sau một khoảng thời gian nhất định. Bạn có thể đặt thời gian lưu giữ nhật ký từ 5 đến 30 ngày (bước nhảy 5 ngày) hoặc chọn lưu vĩnh viễn.';

  @override
  String get dataAndStorage => 'Dữ liệu & Lưu trữ';

  @override
  String get confirmClearAllCache =>
      'Bạn có chắc chắn muốn xóa TẤT CẢ dữ liệu trong bộ nhớ đệm không? Thao tác này sẽ xóa tất cả bản lịch sử đã lưu trong toàn bộ công cụ nhưng vẫn giữ lại cài đặt của bạn.';

  @override
  String get cannotClearFollowingCaches =>
      'Không thể xóa các bộ nhớ đệm sau vì chúng đang được sử dụng:';

  @override
  String get allCacheCleared => 'Đã xóa tất cả bộ nhớ đệm thành công';

  @override
  String get close => 'Đóng';

  @override
  String get options => 'Tùy chọn';

  @override
  String get about => 'Giới thiệu';

  @override
  String get add => 'Thêm';

  @override
  String get copy => 'Sao chép';

  @override
  String get cancel => 'Hủy';

  @override
  String get history => 'Lịch sử';

  @override
  String get random => 'Trình tạo ngẫu nhiên';

  @override
  String get randomDesc =>
      'Tạo mật khẩu, số, ngày và nhiều thứ ngẫu nhiên khác';

  @override
  String get textTemplateGen => 'Tạo văn bản theo mẫu';

  @override
  String get textTemplateGenDesc =>
      'Tạo văn bản theo biểu mẫu có sẵn. Bạn có thể tạo các mẫu văn bản với các trường thông tin cần điền như văn bản, số, ngày tháng để sử dụng lại nhiều lần.';

  @override
  String get holdToDeleteInstruction =>
      'Nhấn giữ nút xóa trong 5 giây để xác nhận';

  @override
  String get holdToDelete => 'Nhấn giữ để xóa...';

  @override
  String get deleting => 'Đang xóa...';

  @override
  String get holdToClearCache => 'Nhấn giữ để xóa...';

  @override
  String get clearingCache => 'Đang xóa cache...';

  @override
  String get batchDelete => 'Delete Selected';

  @override
  String get passwordGenerator => 'Tạo mật khẩu';

  @override
  String get passwordGeneratorDesc => 'Tạo mật khẩu ngẫu nhiên an toàn';

  @override
  String get numCharacters => 'Số ký tự';

  @override
  String get includeLowercase => 'Chữ thường';

  @override
  String get includeLowercaseDesc => 'a-z';

  @override
  String get includeUppercase => 'Chữ hoa';

  @override
  String get includeUppercaseDesc => 'A-Z';

  @override
  String get includeNumbers => 'Số';

  @override
  String get includeNumbersDesc => '0-9';

  @override
  String get includeSpecial => 'Ký tự đặc biệt';

  @override
  String get includeSpecialDesc => 'ví dụ: !@#\$%^&*';

  @override
  String get generate => 'Tạo';

  @override
  String generatedAtTime(String time) {
    return 'Tạo vào $time';
  }

  @override
  String get generatedPassword => 'Mật khẩu đã tạo';

  @override
  String get copyToClipboard => 'Sao chép';

  @override
  String get copied => 'Đã sao chép!';

  @override
  String get startDate => 'Ngày bắt đầu';

  @override
  String get endDate => 'Ngày kết thúc';

  @override
  String get year => 'Year';

  @override
  String get month => 'Month';

  @override
  String get first => 'First';

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
  String get noHistoryYet => 'Chưa có lịch sử';

  @override
  String get confirmClearHistory => 'Bạn có chắc chắn muốn xóa lịch sử không?';

  @override
  String get confirmClearHistoryMessage =>
      'Điều này sẽ xóa tất cả các mục lịch sử đã lưu. Hành động này không thể hoàn tác.\nHãy chắc chắn rằng bạn đã lưu bất kỳ kết quả quan trọng nào trước khi tiếp tục.';

  @override
  String get historyCleared => 'Đã xóa lịch sử tính toán';

  @override
  String get pinnedHistoryCleared => 'Đã xóa lịch sử ghim';

  @override
  String get unpinnedHistoryCleared => 'Đã xóa lịch sử chưa ghim';

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
  String get allowDuplicatesDesc => 'Cho phép chọn cùng một mục nhiều lần';

  @override
  String get includeSeconds => 'Hiển thị số giây';

  @override
  String get generatedNumbers => 'Số đã tạo';

  @override
  String get yesNo => 'Có hay Không?';

  @override
  String get yesNoDesc => 'Quyết định Có hoặc Không ngẫu nhiên';

  @override
  String get flipCoin => 'Tung đồng xu';

  @override
  String get flipCoinDesc => 'Kết quả tung đồng xu ngẫu nhiên';

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
  String get generatedColor => 'Màu đã tạo';

  @override
  String get latinLetters => 'Chữ cái Latin';

  @override
  String get latinLettersDesc => 'Tạo chữ cái alphabet ngẫu nhiên';

  @override
  String get letterCount => 'Số lượng chữ cái';

  @override
  String get letters => 'chữ cái';

  @override
  String get playingCards => 'Bài tây';

  @override
  String get playingCardsDesc => 'Rút thẻ bài ngẫu nhiên';

  @override
  String get includeJokers => 'Có lá Joker';

  @override
  String get includeJokersDesc => 'Bao gồm lá bài Joker trong bộ bài';

  @override
  String get cardCount => 'Số lượng lá bài';

  @override
  String get from => 'Từ';

  @override
  String get actions => 'Hành động';

  @override
  String get delete => 'Xóa';

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
  String get startTime => 'Thời điểm bắt đầu';

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
  String get skipAnimation => 'Bỏ qua hoạt ảnh';

  @override
  String get skipAnimationDesc => 'Tắt hoạt ảnh để có kết quả nhanh hơn';

  @override
  String latinLetterGenerationError(int count, int max) {
    return 'Không thể tạo $count chữ cái. Tối đa có thể tạo là $max chữ cái. Vui lòng giảm số lượng hoặc cho phép trùng lặp.';
  }

  @override
  String get saveGenerationHistory => 'Ghi nhớ lịch sử tạo';

  @override
  String get saveGenerationHistoryDesc =>
      'Ghi nhớ và hiển thị lịch sử các mục đã tạo';

  @override
  String get generationHistory => 'Lịch sử tạo';

  @override
  String get generatedAt => 'Tạo lúc';

  @override
  String get noHistoryMessage => 'Lịch sử tạo của bạn sẽ xuất hiện ở đây';

  @override
  String get clearHistory => 'Xóa lịch sử';

  @override
  String get clearAllItems => 'Xóa Tất Cả Lịch Sử';

  @override
  String get confirmClearAllHistory =>
      'Bạn có chắc chắn muốn xóa TẤT CẢ lịch sử không? Điều này sẽ xóa tất cả lịch sử của công cụ này ngay cả các mục đã ghim của bạn.\nHãy chắc chắn rằng bạn đã lưu bất kỳ kết quả quan trọng nào trước khi tiếp tục.';

  @override
  String get clearPinnedItems => 'Xóa Các Mục Đã Ghim';

  @override
  String get clearPinnedItemsDesc =>
      'Xóa tất cả các mục đã ghim khỏi lịch sử? Điều này sẽ không ảnh hưởng đến các mục chưa ghim.\nHãy chắc chắn rằng bạn đã lưu bất kỳ kết quả quan trọng nào trước khi tiếp tục.';

  @override
  String get clearUnpinnedItems => 'Xóa Các Mục Chưa Ghim';

  @override
  String get clearUnpinnedItemsDesc =>
      'Xóa tất cả các mục chưa ghim khỏi lịch sử? Điều này sẽ không ảnh hưởng đến các mục đã ghim.\nHãy chắc chắn rằng bạn đã lưu bất kỳ kết quả quan trọng nào trước khi tiếp tục.';

  @override
  String get typeConfirmToProceed => 'Nhập \"confirm\" để tiếp tục:';

  @override
  String get clearAll => 'Xóa tất cả';

  @override
  String get converterTools => 'Công cụ chuyển đổi';

  @override
  String get converterToolsDesc =>
      'Chuyển đổi giữa các đơn vị và hệ thống khác nhau';

  @override
  String get calculatorTools => 'Công cụ tính toán';

  @override
  String get calculatorToolsDesc =>
      'Các máy tính chuyên dụng cho sức khỏe, tài chính và hơn thế nữa';

  @override
  String get value => 'Giá trị';

  @override
  String get success => 'Thành công';

  @override
  String get calculate => 'Tính toán';

  @override
  String get calculating => 'Đang tính toán...';

  @override
  String get unknown => 'Không rõ';

  @override
  String get logsAvailable => 'Log khả dụng';

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
  String get largeFileDetected =>
      'Phát hiện file lớn. Đang sử dụng tải tối ưu...';

  @override
  String get focusModeEnabled => 'Chế độ tập trung';

  @override
  String get saveRandomToolsState => 'Lưu trạng thái Random Tools';

  @override
  String get saveRandomToolsStateDesc =>
      'Tự động lưu cài đặt công cụ khi tạo kết quả';

  @override
  String get aspectRatio => 'Tỉ lệ khung hình';

  @override
  String get reset => 'Đặt lại';

  @override
  String get info => 'Thông tin';

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
  String get p2pDataTransfer => 'Truyền Dữ Liệu P2P';

  @override
  String get p2pDataTransferDesc =>
      'Truyền tệp giữa các thiết bị trong cùng mạng cục bộ.';

  @override
  String get clear => 'Xóa';

  @override
  String get debug => 'Gỡ lỗi';

  @override
  String get remove => 'Xóa';

  @override
  String get none => 'Không';

  @override
  String get storage => 'Lưu trữ';

  @override
  String get moveTo => 'Di chuyển vào';

  @override
  String get share => 'Chia sẻ';

  @override
  String get quickAccess => 'Truy cập nhanh';

  @override
  String get colorFormat => 'Định dạng màu';

  @override
  String get aboutToOpenUrlOutsideApp =>
      'Bạn sắp mở một URL bên ngoài ứng dụng. Bạn có muốn tiếp tục không?';

  @override
  String get ccontinue => 'Tiếp tục';

  @override
  String get errorOpeningUrl => 'Lỗi khi mở URL';

  @override
  String get canNotOpenUrl => 'Không thể mở URL';

  @override
  String get linkCopiedToClipboard => 'Liên kết đã được sao chép vào clipboard';

  @override
  String get refresh => 'Làm mới';

  @override
  String get loading => 'Đang tải...';

  @override
  String get retry => 'Thử lại';

  @override
  String get supporterS => 'Người ủng hộ';

  @override
  String get thanksLibAuthor => 'Cảm ơn bạn, Tác giả Thư viện!';

  @override
  String get thanksLibAuthorDesc =>
      'Ứng dụng này sử dụng một số thư viện mã nguồn mở giúp cho nó trở nên khả thi. Chúng tôi rất biết ơn tất cả các tác giả vì những nỗ lực và sự cống hiến của họ.';

  @override
  String get thanksDonors => 'Cảm ơn những người ủng hộ!';

  @override
  String get thanksDonorsDesc =>
      'Đặc biệt cảm ơn những người ủng hộ đã hỗ trợ phát triển ứng dụng này. Những đóng góp của bạn giúp chúng tôi tiếp tục cải thiện và duy trì dự án.';

  @override
  String get thanksForUrSupport => 'Cảm ơn sự hỗ trợ của bạn!';

  @override
  String get checkingForUpdates => 'Đang kiểm tra cập nhật...';

  @override
  String get minimum => 'Tối thiểu';

  @override
  String get maximum => 'Tối đa';

  @override
  String get average => 'Trung bình';

  @override
  String get total => 'Tổng';

  @override
  String get leastFrequent => 'Ít nhất';

  @override
  String get mostFrequent => 'Nhiều nhất';

  @override
  String get leastFrequentRank => 'Lá số ít nhất';

  @override
  String get mostFrequentRank => 'Lá số nhiều nhất';

  @override
  String get leastFrequentSuit => 'Chất ít nhất';

  @override
  String get mostFrequentSuit => 'Chất nhiều nhất';

  @override
  String get minGap => 'Khoảng cách nhỏ';

  @override
  String get maxGap => 'Khoảng cách lớn';

  @override
  String get statistics => 'Thống kê';

  @override
  String get expandStatistics => 'Mở rộng thống kê';

  @override
  String get collapseStatistics => 'Thu gọn thống kê';

  @override
  String get autoScrollToResults => 'Tự động cuộn xuống kết quả';

  @override
  String get autoScrollToResultsDesc =>
      'Tự động cuộn xuống để hiển thị kết quả sau khi tạo';

  @override
  String get earliest => 'Sớm nhất';

  @override
  String get latest => 'Mới nhất';

  @override
  String get shortestGap => 'Khoảng cách ngắn nhất';

  @override
  String get longestGap => 'Khoảng cách xa nhất';

  @override
  String get characters => 'Ký tự';

  @override
  String get dice => 'Xúc xắc';

  @override
  String get passwordStrength => 'Độ mạnh mật khẩu';

  @override
  String get strengthWeak => 'Yếu';

  @override
  String get strengthFair => 'Trung bình';

  @override
  String get strengthGood => 'Tốt';

  @override
  String get strengthStrong => 'Mạnh';

  @override
  String get strengthVeryStrong => 'Rất mạnh';

  @override
  String get clickToCopy => 'Nhấn để sao chép';

  @override
  String get noNewUpdates => 'Không có cập nhật mới';

  @override
  String updateCheckError(String errorMessage) {
    return 'Lỗi khi kiểm tra cập nhật: $errorMessage';
  }

  @override
  String get usingLatestVersion => 'Bạn đang sử dụng phiên bản mới nhất';

  @override
  String get newVersionAvailable => 'Phiên bản mới có sẵn';

  @override
  String currentVersion(String version) {
    return 'Hiện tại: $version';
  }

  @override
  String publishDate(String publishDate) {
    return 'Ngày phát hành: $publishDate';
  }

  @override
  String get releaseNotes => 'Ghi chú phiên bản';

  @override
  String get noReleaseNotes => 'Không có ghi chú phiên bản';

  @override
  String get alreadyLatestVersion => 'Đã là phiên bản mới nhất';

  @override
  String get download => 'Tải về';

  @override
  String get selectVersionToDownload => 'Chọn phiên bản để tải';

  @override
  String get selectPlatform => 'Chọn nền tảng';

  @override
  String downloadPlatform(String platform) {
    return 'Tải xuống cho $platform';
  }

  @override
  String get noDownloadsAvailable => 'Không có tải xuống nào khả dụng';

  @override
  String get downloadApp => 'Tải ứng dụng';

  @override
  String get downloadAppDesc =>
      'Tải ứng dụng để sử dụng ngoại tuyến khi không có kết nối internet';

  @override
  String filteredForPlatform(String getPlatformName) {
    return 'Đã lọc cho $getPlatformName';
  }

  @override
  String sizeInMB(String sizeInMB) {
    return 'Kích thước: $sizeInMB';
  }

  @override
  String uploadDate(String updatedAt) {
    return 'Ngày tải lên: $updatedAt';
  }

  @override
  String get confirmDelete => 'Xác nhận xóa';

  @override
  String get confirmDownload => 'Xác nhận tải xuống';

  @override
  String confirmDownloadMessage(String name, String sizeInMB) {
    return 'Bạn có chắc chắn muốn tải phiên bản này xuống?\n\nTên tệp: $name\nKích thước: $sizeInMB';
  }

  @override
  String get currentPlatform => 'Nền tảng hiện tại';

  @override
  String get eerror => 'Lỗi';

  @override
  String get termsOfUse => 'Điều khoản sử dụng';

  @override
  String get termsOfUseView => 'Xem Điều khoản sử dụng của ứng dụng này';

  @override
  String get versionInfo => 'Thông tin phiên bản';

  @override
  String get checkForNewVersion => 'Kiểm tra phiên bản mới';

  @override
  String get checkForNewVersionDesc =>
      'Kiểm tra xem có phiên bản mới của ứng dụng không và tải về bản mới nhất nếu có';

  @override
  String get platform => 'Nền tảng';

  @override
  String get fileS => 'Tệp tin';

  @override
  String get alsoViewAuthorOtherProducts =>
      'Cũng xem các sản phẩm khác của tác giả';

  @override
  String get authorProducts => 'Sản phẩm khác';

  @override
  String get authorProductsDesc =>
      'Xem các sản phẩm khác của tác giả, có thể bạn sẽ quan tâm!';

  @override
  String get authorProductsMessage =>
      'Chào bạn! Đây là một số sản phẩm khác của tôi. Nếu bạn quan tâm, đừng ngần ngại xem qua nhé! Tôi hy vọng bạn sẽ tìm thấy điều gì đó hữu ích trong số này. Cảm ơn bạn đã ghé thăm!';

  @override
  String get noOtherProducts => 'Không có sản phẩm nào khác';

  @override
  String get loadingProducts => 'Đang tải sản phẩm...';

  @override
  String get failedToLoadProducts => 'Không thể tải sản phẩm';

  @override
  String get retryLoadProducts => 'Thử tải lại sản phẩm';

  @override
  String get visitProduct => 'Xem sản phẩm';

  @override
  String productCount(int count) {
    return '$count sản phẩm';
  }

  @override
  String get deleteHistoryItem => 'Xóa mục';

  @override
  String get tapDeleteAgainToConfirm => 'Nhấn xóa lần nữa để xác nhận';

  @override
  String get historyItemDeleted => 'Mục lịch sử đã bị xóa';

  @override
  String get pinHistoryItem => 'Ghim mục';

  @override
  String get unpinHistoryItem => 'Bỏ ghim mục';

  @override
  String get historyItemPinned => 'Mục đã được ghim';

  @override
  String get historyItemUnpinned => 'Mục đã bỏ ghim';

  @override
  String get securitySetupTitle => 'Thiết lập bảo mật ứng dụng';

  @override
  String get securitySetupMessage =>
      'Bạn có muốn thiết lập mật khẩu chính để bảo vệ dữ liệu không?\nĐiều này sẽ bảo vệ lịch sử khỏi truy cập trái phép và chống đánh cắp dữ liệu.';

  @override
  String get setMasterPassword => 'Đặt mật khẩu chính';

  @override
  String get skipSecurity => 'Bỏ qua (Sử dụng không cần mật khẩu)';

  @override
  String get createMasterPasswordTitle => 'Tạo mật khẩu chính';

  @override
  String get createMasterPasswordMessage =>
      'Vui lòng tạo một mật khẩu chính mạnh.\nHãy nhớ kỹ mật khẩu này.\nnếu quên, toàn bộ dữ liệu sẽ bị mất.';

  @override
  String get enterPassword => 'Nhập mật khẩu';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get passwordMismatch => 'Mật khẩu không khớp';

  @override
  String get passwordTooShort => 'Mật khẩu phải có ít nhất 6 ký tự';

  @override
  String get showPassword => 'Hiện mật khẩu';

  @override
  String get hidePassword => 'Ẩn mật khẩu';

  @override
  String get enterMasterPasswordTitle => 'Nhập mật khẩu chính';

  @override
  String get enterMasterPasswordMessage =>
      'Vui lòng nhập mật khẩu chính để truy cập ứng dụng.';

  @override
  String get wrongPassword => 'Sai mật khẩu. Vui lòng thử lại.';

  @override
  String get forgotPasswordButton =>
      'Tôi đã quên mật khẩu và chấp nhận mất dữ liệu';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get confirmDataLossTitle => 'Xác nhận mất dữ liệu';

  @override
  String get confirmDataLossMessage =>
      'Bạn sẽ có thể tiếp tục sử dụng ứng dụng mà không cần nhập mật khẩu, nhưng toàn bộ dữ liệu lịch sử sẽ bị xóa vĩnh viễn.\nHành động này không thể hoàn tác.';

  @override
  String get holdToConfirm => 'Giữ để xác nhận';

  @override
  String get dataProtectionSettings => 'Cài đặt bảo vệ dữ liệu';

  @override
  String get enableDataProtection => 'Bật bảo vệ dữ liệu';

  @override
  String get disableDataProtection => 'Tắt bảo vệ dữ liệu';

  @override
  String get dataProtectionEnabled => 'Bảo vệ dữ liệu hiện đang được bật';

  @override
  String get dataProtectionDisabled => 'Bảo vệ dữ liệu hiện đang được tắt';

  @override
  String get enterCurrentPassword => 'Nhập mật khẩu hiện tại để tắt bảo vệ';

  @override
  String get securityEnabled => 'Bảo mật đã được bật thành công';

  @override
  String get securityDisabled => 'Bảo mật đã được tắt thành công';

  @override
  String get migrationInProgress => 'Đang di chuyển dữ liệu...';

  @override
  String get migrationCompleted => 'Hoàn tất di chuyển dữ liệu';

  @override
  String get migrationFailed => 'Di chuyển dữ liệu thất bại';

  @override
  String get solid => 'Đặc';

  @override
  String get includeAlpha => 'Bao gồm dãy màu Alpha';

  @override
  String totalANumber(int total) {
    return 'Tổng: $total';
  }

  @override
  String get numberType => 'Loại số';

  @override
  String get yes => 'Có';

  @override
  String get no => 'Không';

  @override
  String get dateErrStartEndConflict =>
      'Ngày bắt đầu không thể sau ngày kết thúc';

  @override
  String get arrangeTools => 'Sắp xếp công cụ';

  @override
  String get arrangeToolsDesc => 'Tùy chỉnh thứ tự các công cụ trong giao diện';

  @override
  String get howToArrangeTools => 'Cách sắp xếp công cụ';

  @override
  String get dragAndDropToReorder =>
      'Kéo và thả để sắp xếp lại các công cụ theo ý muốn';

  @override
  String get defaultOrder => 'Thứ tự mặc định';

  @override
  String get save => 'Lưu';

  @override
  String get reloadTools => 'Tải lại công cụ';

  @override
  String get compactTabLayout => 'Bố cục tab thu gọn';

  @override
  String get compactTabLayoutDesc =>
      'Ẩn biểu tượng trong tab để có giao diện gọn hơn';

  @override
  String get letterCountRange => 'Khoảng số lượng chữ cái';

  @override
  String numberRangeFromTo(String from, String to) {
    return 'Khoảng giá trị: Từ $from đến $to';
  }

  @override
  String get loremIpsumGenerator => 'Tạo văn bản giả';

  @override
  String get loremIpsumGeneratorDesc => 'Lorem Ipsum';

  @override
  String get generationType => 'Loại tạo văn bản';

  @override
  String get words => 'Từ';

  @override
  String get sentences => 'Câu';

  @override
  String get paragraphs => 'Đoạn văn';

  @override
  String get wordCount => 'Số lượng từ';

  @override
  String get numberOfWordsToGenerate => 'Số lượng từ cần tạo';

  @override
  String get sentenceCount => 'Số lượng câu';

  @override
  String get numberOfSentencesToGenerate => 'Số lượng câu cần tạo';

  @override
  String get paragraphCount => 'Số lượng đoạn văn';

  @override
  String get numberOfParagraphsToGenerate => 'Số lượng đoạn văn cần tạo';

  @override
  String get startWithLorem => 'Bắt đầu bằng Lorem';

  @override
  String get startWithLoremDesc =>
      'Bắt đầu bằng câu kinh điển \'Lorem ipsum dolor sit amet...\'';

  @override
  String get listPicker => 'Chọn từ danh sách';

  @override
  String get listPickerDesc => 'Chọn từ các danh sách tùy chỉnh';

  @override
  String get selectList => 'Chọn danh sách';

  @override
  String get createNewList => 'Tạo danh sách mới';

  @override
  String get noListsAvailable => 'Không có danh sách nào';

  @override
  String get selectOrCreateList => 'Chọn hoặc tạo danh sách để bắt đầu chọn';

  @override
  String get manageList => 'Quản lý danh sách';

  @override
  String get addItem => 'Thêm mục';

  @override
  String get items => 'Items';

  @override
  String get generatorOptions => 'Tùy chọn trình tạo';

  @override
  String get results => 'Kết quả';

  @override
  String get generateRandom => 'Chọn ngẫu nhiên';

  @override
  String get listName => 'Tên danh sách';

  @override
  String get create => 'Tạo';

  @override
  String get listPickerMode => 'Chế độ';

  @override
  String get modeRandom => 'Ngẫu nhiên';

  @override
  String get modeRandomDesc => 'Chọn các mục ngẫu nhiên từ danh sách';

  @override
  String get modeShuffle => 'Xáo trộn';

  @override
  String get modeShuffleDesc => 'Xáo trộn và chọn các mục theo thứ tự';

  @override
  String get modeTeam => 'Chia đội';

  @override
  String get modeTeamDesc => 'Chia các mục thành các đội';

  @override
  String get team => 'Đội';

  @override
  String get createListDialog => 'Tạo danh sách mới';

  @override
  String get enterListName => 'Nhập tên danh sách (tối đa 30 ký tự)';

  @override
  String get listNameRequired => 'Tên danh sách là bắt buộc';

  @override
  String get listNameTooLong => 'Tên danh sách quá dài (tối đa 30 ký tự)';

  @override
  String get listNameExists => 'Đã tồn tại danh sách với tên này';

  @override
  String get teams => 'Đội';

  @override
  String get itemsPerTeam => 'Số mục mỗi đội';

  @override
  String get addSingleItem => 'Thêm một mục';

  @override
  String get addMultipleItems => 'Thêm nhiều mục';

  @override
  String get addBatchItems => 'Thêm nhiều mục';

  @override
  String get enterItemsOneLine => 'Nhập các mục, mỗi dòng một mục:';

  @override
  String get batchItemsPlaceholder => 'Mục 1\nMục 2\nMục 3\n...';

  @override
  String previewItems(int count) {
    return 'Xem trước: $count mục';
  }

  @override
  String get addItems => 'Thêm mục';

  @override
  String get confirmAddItems => 'Xác nhận thêm mục';

  @override
  String confirmAddItemsMessage(int count, String listName) {
    return 'Thêm $count mục vào \"$listName\"?';
  }

  @override
  String addedItemsSuccessfully(int count) {
    return 'Đã thêm $count mục thành công';
  }

  @override
  String get enterAtLeastOneItem => 'Vui lòng nhập ít nhất một mục';

  @override
  String get maximumItemsAllowed => 'Tối đa 100 mục được phép';

  @override
  String get itemName => 'Item name';

  @override
  String get itemNameRequired => 'Item name is required';

  @override
  String get itemNameTooLong => 'Item name is too long (max 30 characters)';

  @override
  String get deleteList => 'Xóa danh sách';

  @override
  String deleteListConfirm(String listName) {
    return 'Bạn có chắc chắn muốn xóa \"$listName\"? Hành động này không thể hoàn tác.';
  }

  @override
  String get expand => 'Mở rộng';

  @override
  String get collapse => 'Thu gọn';

  @override
  String get minimize => 'Thu nhỏ';

  @override
  String get collapseToLimitedView => 'Thu gọn để xem giới hạn';

  @override
  String get minimizeToHeaderOnly => 'Thu nhỏ chỉ hiện tiêu đề';

  @override
  String get expandToFullView => 'Mở rộng để xem đầy đủ';

  @override
  String get viewDetails => 'Xem chi tiết';

  @override
  String get renameList => 'Đổi tên danh sách';

  @override
  String get renameItem => 'Đổi tên mục';

  @override
  String get renameListDialog => 'Đổi tên danh sách';

  @override
  String get renameItemDialog => 'Đổi tên mục';

  @override
  String get enterNewListName => 'Nhập tên danh sách mới (tối đa 30 ký tự)';

  @override
  String get enterNewItemName => 'Nhập tên mục mới (tối đa 30 ký tự)';

  @override
  String get rename => 'Đổi tên';

  @override
  String get newNameRequired => 'Tên mới là bắt buộc';

  @override
  String get newNameTooLong => 'Tên mới quá dài (tối đa 30 ký tự)';

  @override
  String get template => 'Mẫu';

  @override
  String get templates => 'Các mẫu';

  @override
  String get cloudTemplates => 'Mẫu trên đám mây';

  @override
  String get noInternetConnection => 'Không có kết nối internet';

  @override
  String get pleaseConnectAndTryAgain => 'Vui lòng kết nối internet và thử lại';

  @override
  String get languageCode => 'Ngôn ngữ';

  @override
  String itemsCount(int count) {
    return '$count mục';
  }

  @override
  String get import => 'Nhập';

  @override
  String get languageNotMatch => 'Không khớp ngôn ngữ';

  @override
  String get templateNotDesignedForLanguage =>
      'Mẫu này không được thiết kế cho ngôn ngữ của bạn.\nBạn có muốn tiếp tục không?';

  @override
  String get fetchingTemplates => 'Đang lấy các mẫu...';

  @override
  String get noTemplatesAvailable => 'Không có mẫu nào';

  @override
  String get selectTemplate => 'Chọn một mẫu để nhập';

  @override
  String get templateImported => 'Nhập mẫu thành công';

  @override
  String get continueButton => 'Tiếp tục';

  @override
  String get importingTemplate => 'Đang nhập mẫu...';

  @override
  String get errorImportingTemplate => 'Lỗi khi nhập mẫu';

  @override
  String get remoteListTemplateTitle => 'Nguồn mẫu danh sách từ xa';

  @override
  String get fetchAll => 'Lấy tất cả';

  @override
  String get fetchLatestDefaults => 'Lấy mặc định mới nhất';

  @override
  String get defaultSourcesUpdated => 'Đã cập nhật nguồn mặc định thành công';

  @override
  String get addCustomSource => 'Thêm nguồn tùy chỉnh';

  @override
  String get whatIsThis => 'Đây là gì?';

  @override
  String get defaultSources => 'Nguồn mặc định';

  @override
  String get customSources => 'Nguồn tùy chỉnh';

  @override
  String get allSources => 'Tất cả nguồn';

  @override
  String get noSourcesToDisplay => 'Không có nguồn nào để hiển thị';

  @override
  String get errorSavingData => 'Lỗi lưu dữ liệu';

  @override
  String get cannotOpenUrl => 'Không thể mở URL';

  @override
  String get viewSourceUrl => 'Xem URL nguồn';

  @override
  String get disable => 'Tắt';

  @override
  String get enable => 'Bật';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get fetch => 'Lấy';

  @override
  String get lastFetch => 'Lần lấy cuối';

  @override
  String get fetchTemplate => 'Lấy mẫu dữ liệu';

  @override
  String get cannotOpenHelpPage => 'Không thể mở trang trợ giúp';

  @override
  String get errorLoadingSources => 'Lỗi tải nguồn';

  @override
  String get name => 'Tên';

  @override
  String get myCustomSource => 'Nguồn tùy chỉnh của tôi';

  @override
  String get pleaseEnterName => 'Vui lòng nhập tên';

  @override
  String get url => 'URL';

  @override
  String get pleaseEnterUrl => 'Vui lòng nhập URL';

  @override
  String get pleaseEnterValidUrl => 'Vui lòng nhập URL hợp lệ';

  @override
  String get editSource => 'Chỉnh sửa nguồn';

  @override
  String get errorUpdatingDefaults => 'Lỗi cập nhật nguồn mặc định';

  @override
  String get urlHintText => 'https://example.com/list.json';

  @override
  String get fetchListTemplates => 'Lấy mẫu danh sách';

  @override
  String get fetchingData => 'Đang lấy dữ liệu...';

  @override
  String get preparing => 'Đang chuẩn bị...';

  @override
  String get inAppBrowser => 'Trình duyệt tích hợp';

  @override
  String get loadUrlError => 'Lỗi tải URL';

  @override
  String get copyUrl => 'Sao chép URL';

  @override
  String get goBack => 'Quay lại';

  @override
  String get goForward => 'Tiến về phía trước';

  @override
  String get noSourceSelected => 'Chưa chọn nguồn nào';

  @override
  String get failedToFetchData => 'Lỗi lấy dữ liệu';

  @override
  String get unknownError => 'Lỗi không xác định';

  @override
  String templatesCount(int count) {
    return 'Mẫu ($count)';
  }

  @override
  String andMoreItems(int count) {
    return '... và $count mục khác';
  }

  @override
  String get enter => 'Nhập';

  @override
  String get increase => 'Tăng';

  @override
  String get decrease => 'Giảm';

  @override
  String get range => 'Phạm vi';

  @override
  String get between => 'Giữa';

  @override
  String get and => 'và';

  @override
  String get browseLink => 'Duyệt liên kết';

  @override
  String get copyLink => 'Sao chép liên kết';

  @override
  String get openInBrowser => 'Mở trong trình duyệt';

  @override
  String get failedToLoadWebpage => 'Lỗi tải trang web';

  @override
  String get urlOptions => 'Tùy chọn URL';

  @override
  String get currentUrl => 'URL hiện tại:';

  @override
  String get urlCopied => 'Đã sao chép URL vào clipboard';

  @override
  String get importTemplate => 'Import Template';

  @override
  String get customizeData => 'Tùy chỉnh dữ liệu';

  @override
  String get fetchTemplatesFirst => 'Tải template từ nguồn trước';

  @override
  String get templateItems => 'Các phần tử Template';

  @override
  String get back => 'Quay lại';

  @override
  String get importedList => 'Danh sách đã import';

  @override
  String get imported => 'Đã import';

  @override
  String get error => 'Lỗi';

  @override
  String get continueText => 'Tiếp tục';

  @override
  String get setListName => 'Đặt tên danh sách';

  @override
  String get preview => 'Xem trước';

  @override
  String get importing => 'Đang import';

  @override
  String get pleaseWait => 'Vui lòng chờ';

  @override
  String get importFromFile => 'Import từ File';

  @override
  String get selectFileToImport => 'Chọn file để import';

  @override
  String get supportedFormat =>
      'Định dạng hỗ trợ: file .txt với mỗi dòng là một mục';

  @override
  String get selectFile => 'Chọn File';

  @override
  String get previewData => 'Xem Trước Dữ Liệu';

  @override
  String get readyToImport => 'Sẵn Sàng Import';

  @override
  String get importConfirmation =>
      'Nhấn Import để thêm dữ liệu này vào danh sách của bạn';

  @override
  String get importData => 'Import Dữ Liệu';

  @override
  String get next => 'Tiếp Theo';

  @override
  String get itemCount => 'Số Lượng Mục';

  @override
  String get importEmptyFileError =>
      'File được chọn trống hoặc không chứa mục nào hợp lệ';

  @override
  String get importFileError => 'Không thể đọc file';

  @override
  String get importError => 'Import thất bại';

  @override
  String get importSuccess => 'Import dữ liệu thành công';

  @override
  String get dragDropHint => 'Hoặc kéo thả file vào đây';

  @override
  String get enterManually => 'Nhập thủ công';

  @override
  String get useElementAsName => 'Dùng một phần tử làm tên';

  @override
  String get elementNumber => 'Số thứ tự phần tử';

  @override
  String get removeElementFromList => 'Xóa phần tử này khỏi danh sách';

  @override
  String get removeElementDescription =>
      'Phần tử được chọn sẽ không có trong danh sách cuối cùng';

  @override
  String get listPreview => 'Xem Trước Danh Sách';

  @override
  String get noNameSet => 'Chưa đặt tên';

  @override
  String get listNamingOptions => 'Tùy Chọn Đặt Tên Danh Sách';

  @override
  String get processingFile => 'Đang xử lý file...';

  @override
  String get largeFileWarning => 'Cảnh Báo File Lớn';

  @override
  String largeFileWarningMessage(int count) {
    return 'File này chứa $count dòng. Xử lý lượng dữ liệu lớn có thể gây chậm hoặc crash trên các máy cấu hình thấp. Bạn có muốn tiếp tục?';
  }

  @override
  String get remoteListTemplateSource => 'Nguồn mẫu danh sách từ xa';

  @override
  String get remoteListTemplateSourceDesc =>
      'Quản lý các nguồn mẫu đám mây cho Chọn từ danh sách';

  @override
  String get yesNoGenerator => 'Máy tạo Có/Không';

  @override
  String get yesNoGeneratorDesc => 'Tạo câu trả lời Có hoặc Không ngẫu nhiên';

  @override
  String get counterMode => 'Chế độ bộ đếm';

  @override
  String get counterModeDesc => 'Theo dõi thống kê kết quả Có/Không';

  @override
  String get batchCount => 'Số lượng hàng loạt';

  @override
  String get batchCountDesc => 'Số lượng kết quả tạo cùng lúc';

  @override
  String get counterStatistics => 'Thống kê bộ đếm';

  @override
  String get totalGenerations => 'Tổng số lần tạo';

  @override
  String get yesCount => 'Số lần Có';

  @override
  String get noCount => 'Số lần Không';

  @override
  String get yesPercentage => 'Tỷ lệ Có';

  @override
  String get noPercentage => 'Tỷ lệ Không';

  @override
  String get headsCount => 'Số lần Ngửa';

  @override
  String get headsPercentage => 'Tỷ lệ Ngửa';

  @override
  String get tailsCount => 'Số lần Sấp';

  @override
  String get tailsPercentage => 'Tỷ lệ Sấp';
}
